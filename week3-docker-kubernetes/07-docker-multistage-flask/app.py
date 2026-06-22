from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return {
        "message": "Multi-stage Flask API is running",
        "environment": os.getenv("APP_ENV", "local"),
        "hostname": socket.gethostname()
    }

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)