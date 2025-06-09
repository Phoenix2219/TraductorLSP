import mysql.connector
from flask import Flask

def init_db(app: Flask):
    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = ''
    app.config['MYSQL_DB'] = 'traductorlsp_db'
    
    # Conecta a la base de datos con mysql.connector
    db_connection = mysql.connector.connect(
        host=app.config['MYSQL_HOST'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD'],
        database=app.config['MYSQL_DB'],
        use_pure=True  # Desactiva el uso de SSL
    )
    return db_connection


