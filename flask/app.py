from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return "Hello, World!"

if __name__ == '__main__':
    app.run(debug=True)

@app.route('/upload', methods=['POST'])
    def upload():
    try:
        imagefile = flask.request.files.get('imagefile', '')
        file.save(os.path.join(app.config['./Unknown_pictures'], imagefile))
    except Exception as err:
        print("lol fail")

def check_known()
    return face_recognition --cpus 4 ./known_people/ ./Unknown_pictures/ cut -d ',' -f2
    
if __name__ == '__main__':
    app.run(debug=True)
