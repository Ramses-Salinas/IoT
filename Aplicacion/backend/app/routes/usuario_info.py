from flask import Blueprint, request, jsonify, current_app
from app.services.usuario_service import get_info_courses, get_info_user,get_all_users,update_user_info,delete_user

usuario_bp = Blueprint('usuario_bp', __name__)

@usuario_bp.route('/user/<id_usuario>', methods=['GET'])
def get_courses(id_usuario):
    db = current_app.config['db']
    result = get_info_courses(db, id_usuario)
    if result['success']:
        return jsonify(result), 200
    else:
        return jsonify(result), 400

@usuario_bp.route('/info/<id_usuario>', methods=['GET'])
def usuario_info(id_usuario):
    db = current_app.config['db']
    result = get_info_user(db, id_usuario)
    if result['success']:
        return jsonify(result['usuario']), 200
    else:
        return jsonify({"error": result['message']}), 400
        
@usuario_bp.route('/all', methods=['GET'])
def all_users_info():
    db = current_app.config['db']
    result = get_all_users(db)
    if result['success']:
        return jsonify(result['usuarios']), 200
    else:
        return jsonify({"error": result['message']}), 400

@usuario_bp.route('/edit/<id_usuario>', methods=['PUT'])
def update_usuario_info(id_usuario):
    db = current_app.config['db']
    update_data = request.get_json()  # Obtiene los datos del cuerpo de la solicitud
    
    # Validar si los datos son válidos (opcional)
    if not update_data:
        return jsonify({"error": "No se proporcionaron datos para actualizar."}), 400
    
    result = update_user_info(db, id_usuario, update_data)
    if result['success']:
        return jsonify({"message": result['message']}), 200
    else:
        return jsonify({"error": result['message']}), 400

@usuario_bp.route('/delte/<id_usuario>', methods=['DELETE'])
def delete_usuario(id_usuario):
    db = current_app.config['db']
    result = delete_user(db, id_usuario)
    if result['success']:
        return jsonify({"message": result['message']}), 200
    else:
        return jsonify({"error": result['message']}), 400
