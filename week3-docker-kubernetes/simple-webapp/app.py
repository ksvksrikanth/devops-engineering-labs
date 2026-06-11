from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <h1>Welcome to Flask</h1>
    <p>Your Flask application is running successfully!</p>
    """

@app.route("/about")
def about():
    return """
    <h1>About</h1>
    <p>This is a simple Flask web application.</p>
    """

if __name__ == "__main__":
    app.run(debug=True)