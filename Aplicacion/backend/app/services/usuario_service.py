from app.models.Usuario import Usuario
from app.models.Curso import Curso
from google.cloud import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


def get_info_courses(db, id_usuario):
    try:
        # Obtener el usuario
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario = usuario_ref.get().to_dict()

        # Verificar si el usuario existe
        if not usuario:
            print("Error: El usuario no existe.")
            return False

        # Verificar si el usuario es un profesor
        if usuario['esProfesor']:
            cursos_profesor_ids = filter_cursos_profesor(db, id_usuario)
            
            if len(cursos_profesor_ids) == 0:
                return {'success': False, 'message': 'No se encontraron cursos en los que el usuario sea profesor.'}
            return {'success': True, 'message': 'Cursos en los que el usuario es profesor obtenidos exitosamente.', 'cursos': cursos_profesor_ids}
        
        else:
            cursos_matriculados_ids = filter_cursos_matriculados(db, id_usuario)
            
            if len(cursos_matriculados_ids) == 0:
                return {'success': False, 'message': 'No se encontraron cursos matriculados.'}
            return {'success': True, 'message': 'Cursos matriculados obtenidos exitosamente.', 'cursos': cursos_matriculados_ids}
        
    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo los cursos: {e}'}

def filter_cursos_profesor(db, id_usuario):
    cursos_ref = db.collection('curso').stream()
    cursos_profesor = []
    for curso in cursos_ref:
        curso_dict = curso.to_dict()
        if curso_dict['id_profesor'] == id_usuario:
            cursos_profesor.append({
                'id': curso.id,
                'nombre': curso_dict['nombre'],
                'hora_inicio': curso_dict['hora_inicio'],
                'hora_fin': curso_dict['hora_fin'],
                'dia': curso_dict['dia'],
                'duracion': curso_dict['duracion'],
                'seccion':curso_dict['seccion'],
            })
    return cursos_profesor

def filter_cursos_matriculados(db, id_usuario):
    cursos_ref = db.collection('curso').stream()
    cursos_matriculados = []
    for curso in cursos_ref:
        curso_dict = curso.to_dict()
        matriculados_ref = curso.reference.collection('matriculados').where('id_usuario', '==', id_usuario).stream()
        if len(list(matriculados_ref)) > 0:
            cursos_matriculados.append({
                'id': curso.id,
                'nombre': curso_dict['nombre'],
                'hora_inicio': curso_dict['hora_inicio'],
                'hora_fin': curso_dict['hora_fin'],
                'dia': curso_dict['dia'],
                'duracion': curso_dict['duracion'],
                'seccion':curso_dict['seccion'],
            })
    return cursos_matriculados

def get_info_user(db, id_usuario):
    try:
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario = usuario_ref.get().to_dict()
        if not usuario:
            return {'success': False, 'message': 'El usuario no existe.'}
        return {'success': True, 'message': 'Usuario obtenido exitosamente.', 'usuario': usuario}
    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo el usuario: {e}'}
    
def get_all_users(db):
    try:
        usuarios_ref = db.collection('usuario')
        usuarios_docs = usuarios_ref.stream()
        usuarios = []
        for doc in usuarios_docs:
            usuario = doc.to_dict()
            usuario['id'] = doc.id  # Incluye el ID del documento en el diccionario del usuario
            usuarios.append(usuario)
        if not usuarios:
            return {'success': False, 'message': 'No hay usuarios en la base de datos.'}
        return {'success': True, 'message': 'Usuarios obtenidos exitosamente.', 'usuarios': usuarios}
    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo los usuarios: {e}'}
    
def update_user_info(db, id_usuario, update_data):
    try:
        # Verificar si el nuevo código o correo ya existe en la base de datos
        if 'codigo' in update_data or 'correo' in update_data:
            usuario_ref = db.collection('usuario')
            # Verificar el código
            if 'codigo' in update_data:
                existing_user_by_codigo = usuario_ref.where('codigo', '==', update_data['codigo']).get()
                if existing_user_by_codigo and existing_user_by_codigo[0].id != id_usuario:
                    return {'success': False, 'message': 'El código ya está en uso por otro usuario.'}
            # Verificar el correo
            if 'correo' in update_data:
                existing_user_by_correo = usuario_ref.where('correo', '==', update_data['correo']).get()
                if existing_user_by_correo and existing_user_by_correo[0].id != id_usuario:
                    return {'success': False, 'message': 'El correo ya está en uso por otro usuario.'}
        
        # Proceder con la actualización del usuario
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario_ref.update(update_data)
        return {'success': True, 'message': 'Usuario actualizado exitosamente.'}
    except Exception as e:
        return {'success': False, 'message': f'Error actualizando el usuario: {e}'}

    
def delete_user(db, id_usuario):
    try:
        # Obtener todos los cursos
        cursos_ref = db.collection('curso').stream()

        # Recorrer todos los cursos para encontrar y eliminar al usuario de la colección 'matriculados'
        for curso in cursos_ref:
            curso_id = curso.id
            matriculados_ref = db.collection('curso').document(curso_id).collection('matriculados')
            existing_student_ref = matriculados_ref.where('id_usuario', '==', id_usuario).stream()

            for student in existing_student_ref:
                matriculados_ref.document(student.id).delete()

        # Eliminar el documento del usuario
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario_ref.delete()

        return {'success': True, 'message': 'Usuario y matriculaciones eliminados exitosamente.'}
    
    except Exception as e:
        return {'success': False, 'message': f'Error eliminando el usuario: {e}'}


