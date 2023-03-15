import time

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS, cross_origin

from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

import mimetypes

time.clock = time.time

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

mimetypes.add_type('application/javascript', '.js')
mimetypes.add_type('text/css', '.css')

CHATBOT = ChatBot(
    "Chatpot",
    logic_adapters=[
        "chatterbot.logic.MathematicalEvaluation",
        "chatterbot.logic.BestMatch"
    ],
    trainer='chatterbot.trainers.ChatterBotCorpusTrainer'
    )

TRAINER = ListTrainer(CHATBOT)

@app.route('/', methods=['GET'])
def root():
    return render_template('index.html') # Return index.html 

@app.route('/query',  methods = ['POST'])
@cross_origin()
def query_chatbot():
    data = request.json['query']
    result = CHATBOT.get_response(data).serialize()
    return jsonify({'message': result['text']})

@app.route('/train',  methods = ['POST'])
@cross_origin()
def train_chatbot():
    data = request.json['data']
    TRAINER.train(data)
    return jsonify({
        'message': "trained", 
        'data': data
    })
