from flask import Flask
import functions


app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"