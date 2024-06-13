from app.models.Usuario import Usuario
from app.models.Curso import Curso
from google.cloud import firestore
from google.cloud.firestore_v1.base_query import FieldFilter

# Hacer un servicio para traer datos del usuario incluyendo cursos en los que esta matriculado si el campo esprofesor es falso, los datos seran buscados con el id del documento de usuario dado
# hazlo aqui
def get_user_data(db, id_usuario):
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
            return {'success': False, 'message': 'Solo los estudiantes pueden ver sus cursos matriculados.'}
        
        # Obtener todos los cursos
        cursos_ref = db.collection('curso').stream()

        # Filtrar los cursos en los que el usuario está matriculado
        cursos_matriculados_ids = []
        for curso in cursos_ref:
            matriculados_ref = curso.reference.collection('matriculados').where('id_usuario', '==', id_usuario).stream()
            if len(list(matriculados_ref)) > 0:
                cursos_matriculados_ids.append(curso.id)
            else:
                return {'success': False, 'message': 'No se encontraron cursos matriculados.'}
        return {'success': True, 'message': 'Cursos matriculados obtenidos exitosamente.', 'cursos': cursos_matriculados_ids}
    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo los cursos matriculados: {e}'}