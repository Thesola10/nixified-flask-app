from flask import Flask, request, make_response, jsonify
from flask_cors import CORS, cross_origin

from . import app

@app.route('/', methods=['GET'])
@cross_origin()
def hello():
    return jsonify(who="flask-app"), 200

