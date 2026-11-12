from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, Irfan This Terraform Project is deployed and created Successfully!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)