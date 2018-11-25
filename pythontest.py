import face_recognition
import os
from os.path import isfile, join
j=0
mypath = "Known_faces"
mypath2 = "Unknown_faces"
onlyfiles = [f for f in os.listdir(mypath) if isfile(join(mypath, f))]
for i in onlyfiles:
    if(i.endswith('.jpg')):
        picture_of_me = face_recognition.load_image_file(mypath +"/" +i)
        my_face_encoding = face_recognition.face_encodings(picture_of_me)[0]

        unknown_picture = face_recognition.load_image_file(mypath2 +"/Unknown.jpg")
        unknown_face_encoding = face_recognition.face_encodings(unknown_picture)[0]
        results = face_recognition.compare_faces([my_face_encoding], unknown_face_encoding)
        if results[0] == True:
            print("It's a picture of " +os.path.splitext(i)[0])
            j=1


if(j==0):
    print("Unknown Person")
# Now we can see the two face encodings are of the same person with `compare_faces`!



