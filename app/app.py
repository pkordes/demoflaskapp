from flask import Flask, flash, redirect, render_template, request, session, abort
import os
 
app = Flask(__name__)
 
@app.route("/")
def index():
    return render_template('index.html',name=os.uname()[1])
 
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

