from werkzeug.security import generate_password_hash, check_password_hash # para hashear la contraseña
from app.models.Usuario import Usuario
import re

EMAIL_REGEX = r'^[^\s@]+@[^\s@]+\.[^\s@]+$'
PASSWORD_REGEX = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'
UNMSM_DOMAIN = 'unmsm.edu.pe'

def create_user(db, usuario):
    try:
        # Validar el formato del correo y la contraseña con regex
        if not re.match(EMAIL_REGEX, usuario.correo):
            print("Error: El formato del correo o la contraseña es inválido.")
            return {'success': False, 'message': 'Error: El formato del correo'}
            #return False
        
        if not re.match(PASSWORD_REGEX, usuario.password):
            print("Error: La contraseña es inválida.")
            return {'success': False, 'message': 'La contraseña debe de tener 8 caracteres, al menos un numero y una letra'}
            #return False
        
        campos = [usuario.correo, usuario.password, usuario.nombres, usuario.apellidos, usuario.escuela, usuario.facultad]

        if not all(campo or campo is False for campo in campos):
            print("Error: Los campos no pueden ser vacíos, nulos o una cadena vacía.")
            return {'success': False, 'message': 'Error: Los campos no pueden ser vacíos, nulos o una cadena vacía.'}
            #return False

        # Validar que el campo codigo este lleno cuando el campo esProfesor sea false
        if not usuario.esProfesor:
            if not usuario.codigo or len(str(usuario.codigo)) != 8 or not str(usuario.codigo).isdigit():
                print("Error: El campo código es obligatorio para los estudiantes, debe tener 8 dígitos y ser un número entero.")
                return {'success': False, 'message': 'Error: El campo código es obligatorio para los estudiantes, debe tener 8 dígitos y ser un número entero.'}
                #return False
        
        # Verificar si ya existe un usuario con el mismo código
        existing_user_ref = db.collection('usuario').where('codigo', '==', usuario.codigo).limit(1).stream()
        for doc in existing_user_ref:
            print("Error: Ya existe un usuario con el mismo código.")
            return {'success': False, 'message': 'Error:  Ya existe un usuario con el mismo código.'}
            #return False
        
        # Verificar si ya existe un usuario con el mismo correo
        existing_user_ref = db.collection('usuario').where('correo', '==', usuario.correo).limit(1).stream()
        for doc in existing_user_ref:
            print("Error: Ya existe un usuario con el mismo correo.")
            return {'success': False, 'message': 'Error:  Ya existe un usuario con el mismo correo.'}
            #return False

        # Añadir usuario a la colección y obtener su ID generado automáticamente
        doc_ref = db.collection('usuario').add(usuario.to_dict())

        # Obten el id generado automaticamente del usuario en firestore
        usuario_id = doc_ref[1].id

        # imprimir todos los campos creados del usuario incluyendo el id asignado de firestore
        print(f"Usuario creado con ID: {doc_ref[1].id}")


        usuario_id = doc_ref[1].id  # Acceder al ID del documento en la tupla devuelta por add()
        usuario.id = usuario_id
        return {'success': True, "id": usuario.id,'message': 'Usuario creado correctamente'}
    except Exception as e:
        print(f"Error creating user: {e}")
        return {'success': False, 'message': 'Error creating user: {e}'}
        #return False

def authenticate_user(db, correo, password):
    try:

        # Validar el formato del correo electrónico
        if not re.match(EMAIL_REGEX, correo):
            print("Formato de correo electrónico inválido")
            return {"success": False, "message": "Formato de correo electrónico inválido"}
            #return None
        
        # Validar que el dominio del correo electrónico sea unmsm.edu.pe
        if not correo.endswith(f"@{UNMSM_DOMAIN}"):
            print("El correo electrónico no pertenece a unmsm.edu.pe")
            return {"success": False, "message": "El correo electrónico no pertenece a unmsm.edu.pe"}
            #return None
        
        user_ref = db.collection('usuario').where('correo', '==', correo).limit(1).stream()
        for doc in user_ref:
            user = Usuario.from_dict(doc.to_dict())
            if user.password == password:
                return {"success": True, "id": doc.id, "esprofesor": user.esProfesor}
        return {"success": False, "message": "Credenciales incorrectas"}
    except Exception as e:
        print(f"Error authenticating user: {e}")
        return {"success": False, "message": f"Error authenticating user: {e}"}
       #return None
