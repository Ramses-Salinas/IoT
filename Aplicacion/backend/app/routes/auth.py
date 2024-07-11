from flask import Blueprint, redirect, request, jsonify, current_app
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
    
    if result['success']:
        #return jsonify({"message": "Usuario registrado!"}), 201
        return jsonify({"id": result['id'], "message": result['message']}), 201
    else:
        return jsonify({"message": result['message']}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.json
    db = current_app.config['db']
    
    correo = data['correo']
    password = data['password']
    
    user = authenticate_user(db, correo, password)

    print(user)
    
    if user['success']:
        return jsonify({"id": user['id'], "esProfesor": user['esprofesor'], "acceso": "Acceso exitoso"}), 200
    else:
        return jsonify({"error": user['message']}), 401

@auth_bp.route('/admin')
def admin():
    return redirect("https://pillpop.000webhostapp.com/templates/html/menu.html")