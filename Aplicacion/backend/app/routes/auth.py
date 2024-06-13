from flask import Blueprint, request, jsonify, current_app
from app.models.Usuario import Usuario
from app.services.auth_service import create_user, authenticate_user

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.json
    db = current_app.config['db']
    

    usuario = Usuario(
        nombres=data['nombres'],
        apellidos=data['apellidos'],
        codigo=data['codigo'],
        correo=data['correo'],
        esProfesor=data['esProfesor'],
        escuela=data['escuela'],
        facultad=data['facultad'],
        password=data['password']
    )

    result = create_user(db, usuario)
    
    if result:
        return jsonify({"message": "Usuario registrado!"}), 201
    else:
        return jsonify({"error": "Fallo en el registro"}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.json
    db = current_app.config['db']
    
    correo = data['correo']
    password = data['password']
    
    user = authenticate_user(db, correo, password)
    
    if user:
        return jsonify({"esProfesor": user.esProfesor, "acceso": "Acceso exitoso"}), 200
    else:
        return jsonify({"error": "Credenciales inválidas"}), 401
