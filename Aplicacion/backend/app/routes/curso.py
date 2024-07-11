from flask import Blueprint, request, jsonify, current_app
from app.models.Usuario import Usuario
from app.models.Curso import Curso
from datetime import datetime, date

from app.services.curso_service import create_course_service, register_student_service,get_matriculados_por_curso,unregister_student_service,get_course_info_service,edit_course_service,delete_course_service, registrar_asistencia

curso_bp = Blueprint('curso', __name__)

@curso_bp.route('/create', methods=['POST'])
def create():
    data = request.json
    db = current_app.config['db']

    # Convertir los enteros a horas y minutos
    hora_inicio = divmod(int(data['hora_inicio']), 100)
    hora_fin = divmod(int(data['hora_fin']), 100)

    # Calcular la cantidad de horas
    cantidad_horas = (hora_fin[0] + hora_fin[1] / 60) - (hora_inicio[0] + hora_inicio[1] / 60)
   
    curso = Curso(
        nombre=data['nombre'],
        hora_fin=data['hora_fin'],
        hora_inicio=data['hora_inicio'],
        dia=data['dia'],
        ciclo=data['ciclo'],
        id_profesor = data['id_profesor'],
        seccion=data['seccion'],
        duracion=cantidad_horas
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
    
@curso_bp.route('/unregister', methods=['POST'])
def unregister():
    data = request.json
    db = current_app.config['db']
    
    id_usuario = data['id_usuario']
    id_curso = data['id_curso']
    
    result = unregister_student_service(db, id_usuario, id_curso)
    
    if result['success']:
        return jsonify({"message": "Estudiante desmatriculado exitosamente"}), 200
    else:
        return jsonify({"message": result['message']}), 400


@curso_bp.route('/alumnosMatriculados', methods=['POST'])
def get_alumnos_matriculados():
    data = request.json
    db = current_app.config['db']
    
    if 'id_curso' not in data:
        return jsonify({
            "message": "El campo 'id_curso' es necesario."
        }), 400

    id_curso = data['id_curso']

    # Obtener la lista de alumnos matriculados en el curso
    alumnos_matriculados_result = get_matriculados_por_curso(db, id_curso)
        
    if alumnos_matriculados_result['success']:
        return jsonify({
            "message": "Lista de alumnos matriculados obtenida exitosamente",
            "alumnos_matriculados": alumnos_matriculados_result['data']
        }), 200
    else:
        return jsonify({
            "message": "No se pudo obtener la lista de alumnos matriculados",
            "error": alumnos_matriculados_result['message']
        }), 500

@curso_bp.route('/getinfo', methods=['POST'])
def get_course_info():
    data = request.json
    db = current_app.config['db']
    
    id_curso = data.get('id_curso')
    
    if not id_curso:
        return jsonify({"message": "El id_curso es requerido"}), 400
    
    result = get_course_info_service(db, id_curso)
    
    if result['success']:
        return jsonify({"message": "Curso obtenido exitosamente", "data": result['data']}), 200
    else:
        return jsonify({"message": result['message']}), 400

@curso_bp.route('/edit', methods=['POST'])
def edit_course():
    data = request.json
    db = current_app.config['db']
    
    id_curso = data['id_curso']
    new_data = data['new_data']  # Diccionario con los nuevos datos del curso
    
    result = edit_course_service(db, id_curso, new_data)
    
    if result['success']:
        return jsonify({"message": "Curso actualizado exitosamente"}), 200
    else:
        return jsonify({"message": result['message']}), 400

@curso_bp.route('/delete', methods=['POST'])
def delete_course():
    data = request.json
    db = current_app.config['db']
    
    id_curso = data['id_curso']
    
    result = delete_course_service(db, id_curso)
    
    if result['success']:
        return jsonify({"message": "Curso eliminado exitosamente"}), 200
    else:
        return jsonify({"message": result['message']}), 400

@curso_bp.route('/registrar_asistencia', methods=['POST'])
def endpoint_registrar_asistencia():
    data = request.json
    db = current_app.config['db']
    id_asistencia = data.get('id_asistencia')
    id_curso = data.get('id_curso')
    alumnos_estado = data.get('alumnos_estado')

    resultado = registrar_asistencia(db,id_asistencia, id_curso, alumnos_estado)
    if resultado['success']:
        return jsonify({"success": True, "message": "Asistencia registrada correctamente"}), 200
    else:
        return jsonify({"success": False, "message": resultado['message']}), 400