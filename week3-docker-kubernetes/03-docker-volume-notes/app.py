from flask import Flask, request, jsonify
from pathlib import Path
import os

app = Flask(__name__)
DATA_DIR = Path(os.getenv("DATA_DIR", "/data"))
NOTES_FILE = DATA_DIR / "notes.txt"

DATA_DIR.mkdir(parents=True, exist_ok=True)

@app.route("/")
def home():
    return {
        "message": "Docker volume notes API is running",
        "data_dir": str(DATA_DIR),
        "notes_file": str(NOTES_FILE)
    }

@app.route("/notes", methods=["GET"])
def get_notes():
    if not NOTES_FILE.exists():
        return {"notes": []}
    notes = NOTES_FILE.read_text().splitlines()
    return {"notes": notes}

@app.route("/notes", methods=["POST"])
def add_note():
    payload = request.get_json(silent=True) or {}
    note = payload.get("note")
    if not note:
        return {"error": "note is required"}, 400
    with NOTES_FILE.open("a") as f:
        f.write(note + "\n")
    return {"message": "note saved", "note": note}, 201

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)