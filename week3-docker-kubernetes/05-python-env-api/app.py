from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    app_name = os.getenv("APP_NAME", "Default API")
    environment = os.getenv("APP_ENV", "dev")

    return {
        "message": "API is running",
        "app_name": app_name,
        "environment": environment
    }

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)