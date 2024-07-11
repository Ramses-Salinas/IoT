from decouple import config
from src.utils.errors.CustomException import CustomException
import firebase_admin
from firebase_admin import firestore


def get_connection():
    try:
        firebase_admin.get_app()
        db = firestore.client()
        return db
    except CustomException as ex:
        raise CustomException(ex)