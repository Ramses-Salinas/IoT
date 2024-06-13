def init_routes(app, db):
    from .auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    from .curso import curso_bp
    app.register_blueprint(curso_bp, url_prefix='/curso')

    from .usuario_info import usuario_bp
    app.register_blueprint(usuario_bp, url_prefix='/usuario_info')
