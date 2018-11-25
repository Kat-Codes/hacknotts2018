import face_recognition
from flask import Flask, render_template, request
import os
from pathlib import Path
import PIL.Image
import numpy as np
from io import BytesIO
import binascii


from os import listdir
from os.path import isfile, join

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
        imagefile.save('Unknown_pictures/face.jpg')
        #imagefile.save(os.path.join(app.config['Unknown_pictures'], imagefile.filename))
        
        return "success"
    except Exception as err:
        print(err)
        return "fail"

@app.route('/check', methods=['GET'])
def check_known():
    j=0
    mypath = "Known_people"
    mypath2 = "Unknown_pictures"
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    for i in onlyfiles:
        if(i.endswith('.jpg')):
            picture_of_me = face_recognition.load_image_file(mypath +"/" +i)
            my_face_encoding = face_recognition.face_encodings(picture_of_me)[0]
            if(os.path.isfile(mypath2 +"/face.jpg")):
                print("File exists")
            else:
                print("FIle does not exist")
            openface = open(mypath2 +"/face.jpg", "rb").read()
            pilimg = PIL.Image.open(BytesIO(openface))
            pilimgarray = np.array(pilimg)
            print (pilimgarray)
            unknown_picture = pilimgarray #face_recognition.load_image_file(mypath2 +"/face.jpg")
            unknown_face_encodings = face_recognition.face_encodings(unknown_picture)
            print(unknown_face_encodings)
            unknown_face_encoding = unknown_face_encodings[0]
            results = face_recognition.compare_faces([my_face_encoding], unknown_face_encoding)
            if results[0] == True:
                return os.path.splitext(i)[0]
                j=1


    if(j==0):
        return ''
    # Now we can see the two face encodings are of the same person with `compare_faces`!


