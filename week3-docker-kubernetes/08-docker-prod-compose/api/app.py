from flask import Flask
import os
import mysql.connector

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "apppassword")

@app.route("/")
def home():
    return {
        "message": "Nginx -> Flask -> MySQL stack is running",
        "db_host": DB_HOST
    }

@app.route("/db")
def db_check():
    conn = mysql.connector.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()
    cursor.execute("SELECT message FROM greetings LIMIT 1")
    row = cursor.fetchone()
    cursor.close()
    conn.close()
    return {"database_message": row[0]}

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)