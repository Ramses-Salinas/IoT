class Registro_asistencia():
    def __init__(self, hora_fin, hora_inicio, modalidad, num_asistentes):
        # crea
        self.hora_fin = hora_fin
        self.hora_inicio = hora_inicio
        self.modalidad = modalidad
        self.num_asistentes = num_asistentes


    def to_dict(self):
        return {
            'hora_fin': self.hora_fin,
            'hora_inicio': self.hora_inicio,
            'modalidad': self.modalidad,
            'num_asistentes': self.num_asistentes
        }

    @staticmethod
    def from_dict(source):
        return Registro_asistencia(
            hora_fin=source.get('hora_fin'),
            hora_inicio=source.get('hora_inicio'),
            modalidad=source.get('modalidad'),
            num_asistentes=source.get('num_asistentes')
        )