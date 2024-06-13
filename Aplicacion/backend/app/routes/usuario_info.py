from flask import Blueprint, request, jsonify, current_app
from app.services.usuario_service import get_user_data

usuario_bp = Blueprint('usuario_bp', __name__)

@usuario_bp.route('/user/<id_usuario>', methods=['GET'])
def get_user(id_usuario):
    db = current_app.config['db']
    result = get_user_data(db, id_usuario)
    if result['success']:
        return jsonify(result), 200
    else:
        return jsonify(result), 400