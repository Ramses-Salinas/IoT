class Alumno_curso():
    def __init__(self, idusuario):
        self.idusuario = idusuario

    def to_dict(self):
        return {
            'idusuario': self.idusuario
        }

    @staticmethod
    def from_dict(source):
        return Alumno_curso(
            idusuario=source.get('idusuario')
        )