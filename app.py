from flask import Flask, render_template, request

import os

app = Flask(__name__)


@app.route('/')
def index():
    return "Hello, World!"

if __name__ == '__app__':
    app.run(debug=True)

@app.route('/')
def form():
    return render_template('index.html')

@app.route('/uploadToContacts', methods=['POST'])
def upload():
    imagefile = flask.request.files.get('imagefile', '')
    imagefile.save(os.path.join(app.config['./known_people'], imagefile))

@app.route('/uploadForCheck', methods=['POST'])
def check():
    try:
        imagefile = request.files['file']
        imagefile.save(os.path.join('./Unknown_pictures', imagefile.filename))
        # check_known()
        os.remove('./Unknown_pictures/' +imagefile.filename)
        return "success"
    except Exception as err:
        print(err)
        return "fail"

# def check_known():
#     os.system(face_recognition ./known_people/ ./Unknown_pictures/ cut -d ',' -f2)
#     return