from flask import Blueprint, request, jsonify, current_app
from app.models.Usuario import Usuario
from app.models.Curso import Curso

from app.services.curso_service import create_course_service, register_student_service

curso_bp = Blueprint('curso', __name__)

@curso_bp.route('/create', methods=['POST'])
def create():
    data = request.json
    db = current_app.config['db']

    curso = Curso(
        nombre=data['nombre'],
        hora_fin=data['hora_fin'],
        hora_inicio=data['hora_inicio'],
        dia=data['dia'],
        ciclo=data['ciclo'],
        id_profesor = data['id_profesor'],
        seccion=data['seccion']
    )

    result = create_course_service(db, curso)

    if result['success']:
        # que retorne el result['message']
        return jsonify({"message": result['message']}), 201
    else:
        return jsonify({"message": result['message']}), 400
    
@curso_bp.route('/register', methods=['POST'])
def register():
    data = request.json
    db = current_app.config['db']
    
    id_usuario = data['id_usuario']
    id_curso = data['id_curso']
    
    result = register_student_service(db, id_usuario, id_curso)
    
    if result['success']:
        return jsonify({"message": "Estudiante registrado exitosamente"}), 201
    else:
        return jsonify({"message": result['message']}), 400