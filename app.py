import face_recognition
from flask import Flask, render_template, request
import os
import os


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
        imagefile.save('Unknown_pictures/test2.jpg')
        check_known(imagefile.filename)
        
        os.remove('./Unknown_pictures/' +imagefile.filename)
        return "success"
    except Exception as err:
        print(err)
        return "fail"

def check_known(aFILE):
    j=0
    mypath = "Known_people"
    mypath2 = "Unknown_pictures/"
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    for i in onlyfiles:
        #print(i)
        if(i.endswith('.jpg')):
            picture_of_me = face_recognition.load_image_file(mypath +"/" +i)
            my_face_encoding = face_recognition.face_encodings(picture_of_me)[0]

            #wait for image to be loaded
            unknown_picture = face_recognition.load_image_file("Unknown_pictures/test2.jpg")
            unknown_face_encoding = face_recognition.face_encodings(unknown_picture)[0]
            results = face_recognition.compare_faces([my_face_encoding], unknown_face_encoding)
            if results[0] == True:
                print(os.path.splitext(i))
                print("It's a picture of " +os.path.splitext(i)[0])
                j=1


    if(j==0):
        print("Unknown Person")
    # Now we can see the two face encodings are of the same person with `compare_faces`!

