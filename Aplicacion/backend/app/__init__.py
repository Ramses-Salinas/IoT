from flask import Flask
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, firestore
import os
#from dotenv import load_dotenv

#load_dotenv()  # Cargar variables de entorno desde el archivo .env

print("Initializing Flask app and Firestore connection")  # Línea de depuración

def create_app():
    app = Flask(__name__)
    
    # Configurar CORS
    CORS(app, origins="*", supports_credentials=True, methods=["GET", "POST", "PUT", "DELETE"], allow_headers=["Content-Type", "Authorization"])
    
    # Inicializar Firebase
    cred = credentials.Certificate(r'C:\Users\Milena\Desktop\Proyectos\Kunan\backend\token\kunan-5396a-firebase-adminsdk-pf2qb-0ec058fb36.json')
    firebase_admin.initialize_app(cred)
    
    db = firestore.client()
    app.config['db'] = db
    # Registrar rutas
    with app.app_context():
        from .routes import init_routes
        init_routes(app, db)

    
    return app
