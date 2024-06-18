from flask import Flask, render_template, redirect
import threading, time, random
import paho.mqtt.client as mqtt

app = Flask(__name__)
simulating = False

# MQTT Setup
client = mqtt.Client()
client.connect("mosquitto", 1883, 60)

machines = [f"machine{i}" for i in range(1, 11)]
tags = ["temperature", "vibration", "pressure", "speed", "load"]
phases = ["phase1", "phase2", "phase3"]

def simulate_data():
    global simulating
    while simulating:
        for machine in machines:
            for tag in tags:
                for phase in phases:
                    topic = f"{machine}/{tag}/{phase}"
                    value = round(random.uniform(20, 100), 2)
                    client.publish(topic, f"{value}")
        time.sleep(1)

@app.route('/')
def index():
    return render_template('index.html', simulating=simulating)

@app.route('/start', methods=['POST'])
def start():
    global simulating
    if not simulating:
        simulating = True
        threading.Thread(target=simulate_data).start()
    return redirect('/')

@app.route('/stop', methods=['POST'])
def stop():
    global simulating
    simulating = False
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
