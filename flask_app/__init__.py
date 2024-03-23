from flask import Flask, request, make_response, jsonify
from flask_cors import CORS, cross_origin
from dotenv import load_dotenv, dotenv_values

import os

__version__ = "0.dev1"

app = Flask(__name__)
cors = CORS(app,
            origins = ["http://127.0.0.1:8080", "https://example.com"],
            methods = ['GET'])

if (os.getenv("API_ENVFILE")):
    app.config.from_mapping(dotenv_values(os.getenv("API_ENVFILE")))
    load_dotenv(os.environ["API_ENVFILE"])

app.config['CORS_HEADERS'] = 'Content-Type'

from .app import *
