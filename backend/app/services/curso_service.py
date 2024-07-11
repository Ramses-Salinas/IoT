from app.models.Usuario import Usuario
from app.models.Curso import Curso
from google.cloud import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from app.services.usuario_service import get_info_user

def create_course_service(db,  curso):
    try:
        # el id del usuario se obtiene del curso
        usuario_id = curso.id_profesor

        # Obtener el usuario
        usuario_ref = db.collection('usuario').document(usuario_id)
        usuario = usuario_ref.get().to_dict()

         # Verificar si el usuario existe
        if usuario is None:
            print("Error: El usuario no existe.")
            return {'success': False, 'message': 'El usuario no existe.'}

        # Verificar si el usuario es un profesor
        if not usuario['esProfesor']:
            return {'success': False, 'message': 'Solo los profesores pueden crear cursos.'}
        
        # Verificar si ya existe un curso con el mismo nombre, sección, ciclo, id_profesor
        existing_course_ref = db.collection('curso').where('nombre', '==', curso.nombre).where('seccion', '==', curso.seccion).where('ciclo', '==', curso.ciclo).where('id_profesor', '==', curso.id_profesor).limit(1).stream()

        for __ in existing_course_ref:
            print("Error: Ya existe un curso con el mismo nombre, sección, ciclo, id_profesor")
            return {'success': False, 'message': 'Ya existe un curso con el mismo nombre, sección, ciclo, id_profesor.'}

        # Crear el curso
        curso_ref = db.collection('curso').add(curso.to_dict())

        # Crear una coleccion dentro de la coleccion de curso llamada matriculados en firestore
        

        # Imprimir el ID del curso creado
        print(f"Curso creado con ID: {curso_ref[1].id}")

        return {'success': True, 'message':f"Curso creado con ID: {curso_ref[1].id}"}
    except Exception as e:
        return {'success': False, 'message': f'Error creando el curso: {e}'} # Cambiar el mensaje de error si es necesario



def register_student_service(db, id_usuario, id_curso):
    try:
        # Obtener el curso
        curso_ref = db.collection('curso').document(id_curso)
        curso = curso_ref.get().to_dict()

        # Verificar si el curso existe
        if not curso:
            print("Error: El curso no existe.")
            return {'success': False, 'message': f'Error: El curso no existe'}
            #return False

        # Obtener el usuario
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario = usuario_ref.get().to_dict()

        # Verificar si el usuario existe
        if not usuario:
            print("Error: El usuario no existe.")
            return {'success': False, 'message': f'Error: El usuario no existe'}
            #return False

        # Verificar si el usuario es un estudiante
        if usuario['esProfesor']:
            print("Error: El usuario no es un estudiante.")
            return {'success': False, 'message': f'Error: El usuario no es un estudiante'}
            #return False

        # Verificar si el estudiante ya está matriculado en el curso
        existing_student_ref = db.collection('curso').document(id_curso).collection('matriculados').where(filter=FieldFilter('id_usuario', '==', id_usuario))

        existing_student = existing_student_ref.get()

        if len(existing_student)>0:
            # Devolver un mensaje indicando que el estudiante ya está matriculado en el curso
            for student in existing_student:
                print(f"Estudiante encontrado: {student.id}")
                return {'success': False, 'message': f'El estudiante ya está matriculado en el curso'}

        # Si el estudiante no está matriculado, agregarlo a la colección de matriculados del curso
        curso_ref.collection('matriculados').add({
            "id_usuario": id_usuario,
            # Añade otros campos del estudiante aquí si es necesario
        })
        #usuario_ref.collection('cursos').add({
            #"id_curso": id_curso,
        #})

        return {'success': True, 'message': f'Estudiante matriculado con éxito en el curso'}

    except Exception as e:
        print(f"Error registering student: {e}")
        return {'success': False, 'message': f'Error registering student: {e}'}
        #return False

def unregister_student_service(db, id_usuario, id_curso):
    try:
        # Obtener el curso
        curso_ref = db.collection('curso').document(id_curso)
        curso = curso_ref.get().to_dict()

        # Verificar si el curso existe
        if not curso:
            print("Error: El curso no existe.")
            return {'success': False, 'message': 'Error: El curso no existe'}

        # Verificar si el estudiante está matriculado en el curso
        existing_student_ref = db.collection('curso').document(id_curso).collection('matriculados').where(filter=FieldFilter('id_usuario', '==', id_usuario))

        existing_student = existing_student_ref.get()

        if not existing_student:
            return {'success': False, 'message': 'El estudiante no está matriculado en el curso'}

        # Eliminar al estudiante de la colección de matriculados del curso
        for student in existing_student:
            db.collection('curso').document(id_curso).collection('matriculados').document(student.id).delete()

        return {'success': True, 'message': 'Estudiante desmatriculado con éxito del curso'}

    except Exception as e:
        print(f"Error unregistering student: {e}")
        return {'success': False, 'message': f'Error unregistering student: {e}'}
    



def get_matriculados_por_curso(db, id_curso):
    try:
        # Obtener la referencia del curso
        curso_ref = db.collection('curso').document(id_curso)

        # Obtener la lista de matriculados
        matriculados_ref = curso_ref.collection('matriculados')
        matriculados = matriculados_ref.get()

        lista_matriculados = []
        for matriculado in matriculados:
            id_usuario = matriculado.to_dict().get('id_usuario')
            if id_usuario:
                user_info_result = get_info_user(db, id_usuario)
                if user_info_result['success']:
                    lista_matriculados.append(user_info_result['usuario'])
                else:
                    lista_matriculados.append({'id_usuario': id_usuario, 'error': user_info_result['message']})

        return {'success': True, 'data': lista_matriculados}

    except Exception as e:
        print(f"Error getting enrolled students: {e}")
        return {'success': False, 'message': f'Error getting enrolled students: {e}'}
    
def get_course_info_service(db, id_curso):
    try:
        curso_ref = db.collection('curso').document(id_curso)
        curso = curso_ref.get()

        if not curso.exists:
            return {'success': False, 'message': 'Curso no existe'}
        
        # Obtener los datos del curso
        curso_data = curso.to_dict()
        return {'success': True, 'data': curso_data}

    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo la información del curso: {e}'}

def edit_course_service(db, id_curso, new_data):
    try:
        curso_ref = db.collection('curso').document(id_curso)
        curso = curso_ref.get()

        if not curso.exists:
            return {'success': False, 'message': 'Curso no existe'}

        # Actualizar el curso con los nuevos datos
        curso_ref.update(new_data)
        return {'success': True, 'message': 'Curso actualizado exitosamente'}

    except Exception as e:
        return {'success': False, 'message': f'Error actualizando el curso: {e}'}

def delete_course_service(db, id_curso):
    try:
        curso_ref = db.collection('curso').document(id_curso)
        curso = curso_ref.get()

        if not curso.exists:
            return {'success': False, 'message': 'Curso no existe'}

        # Eliminar todos los estudiantes matriculados en el curso
        matriculados_ref = curso_ref.collection('matriculados').stream()
        for student in matriculados_ref:
            curso_ref.collection('matriculados').document(student.id).delete()

        # Eliminar el curso
        curso_ref.delete()
        return {'success': True, 'message': 'Curso eliminado exitosamente'}

    except Exception as e:
        return {'success': False, 'message': f'Error eliminando el curso: {e}'}
    
def registrar_asistencia(db, id_asistencia, id_curso, alumnos_estado):
    try:
        asistencia_ref = db.collection('asistencia').document(id_asistencia)
        # Verificar si el documento de asistencia existe
        if not asistencia_ref.get().exists:
            return {'success': False, 'message': 'Asistencia no encontrada'}

        for alumno in alumnos_estado:
            # Crear o actualizar el documento por cada alumno en la subcolección 'lista'
            # Asegurándose de incluir tanto el id_usuario como el estado
            asistencia_ref.collection('lista').document(alumno['id_usuario']).set({
                'id_usuario': alumno['id_usuario'],  # Asegurarse de incluir el id_usuario
                'estado': alumno['estado']
            })

        return {'success': True, 'message': 'Asistencia registrada correctamente'}
    except Exception as e:
        return {'success': False, 'message': f'Error al registrar asistencia: {e}'}