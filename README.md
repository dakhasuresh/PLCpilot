# ⚙️ PLCpilot — Self-Evolving PLC Automation at the Edge

> **GenAI-powered industrial automation that detects anomalies, generates PLC logic, and deploys updates autonomously — with human-in-the-loop oversight.**

---

## 🚀 Overview

PLCpilot is an AI-driven edge automation platform that bridges the gap between **natural language intent** and **deployable PLC code**. It uses a 7-agent pipeline to:

1. Detect sensor anomalies in real time
2. Identify root causes automatically
3. Generate OpenPLC-compatible Structured Text (ST) code via LLaMA3 (Ollama)
4. Deploy updates to OpenPLC without manual intervention
5. Notify human operators and learn from outcomes

---

## 🏗️ Architecture

```
Sensor Data (Node-RED/MQTT)
         |
         v
+---------------------+
|  Anomaly Detection  |  <-- Detects drift, out-of-range, missing pulses
+---------------------+
         |
         v
+---------------------+
|  Root Cause Agent   |  <-- Maps anomaly to cause category
+---------------------+
         |
         v
+---------------------+
|  Prompt Generation  |  <-- Converts cause to GenAI prompt
+---------------------+
         |
         v
+---------------------+
|  GenAI Code Agent   |  <-- Ollama LLaMA3 -> Structured Text (.st)
+---------------------+
         |
         v
+---------------------+
|  Deployment Agent   |  <-- Pushes to OpenPLC, monitors compile
+---------------------+
         |
         v
+---------------------+
|  Human Notification |  <-- Email/MQTT alert, approval request
+---------------------+
         |
         v
+---------------------+
|   Learning Agent    |  <-- Logs outcomes, improves future prompts
+---------------------+
```

---

## 📁 Repository Structure

```
plcpilot/
├── app/
│   ├── app.py                       # Flask app: starts/stops MQTT simulation via web UI
│   ├── streamlit_app.py             # Streamlit GenAI PLC code generator
│   └── templates/
│       └── index.html               # Simulator control UI (Start/Stop buttons)
├── plc_programs/
│   ├── temp_fan_control.st          # Temperature-based fan/alarm control
│   ├── watchdog_press.st            # Press machine watchdog timer (10s)
│   ├── pump_alternation.st          # Pump A/B 12-hour alternation
│   └── sensor_drift_robotic_arm.st  # Robotic arm drift detection
├── nodered_flows/
│   ├── plcpilot_flow.json          # Node-RED Modbus simulation flow
│   └── nodered_function.js          # Function node: 10 machines × 12 tags → InfluxDB + MQTT
├── agents/
│   └── pipeline.py                  # 7-agent pipeline description & runner
├── mosquitto/
│   └── config/
│       └── mosquitto.conf           # MQTT broker config (port 1883, persistence enabled)
├── docs/
│   └── ARCHITECTURE.md              # Modbus mapping & Node-RED setup reference
├── Dockerfile                       # Flask simulator container (python:3.11-slim)
├── docker-compose.yml               # Full stack: Mosquitto + Flask on iot_net
├── requirements.txt                 # Python dependencies
└── .gitignore
```

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| PLC Runtime | OpenPLC (open-source) |
| PLC Language | Structured Text (IEC 61131-3) |
| GenAI Engine | Ollama + LLaMA3 (local inference) |
| Web UI | Streamlit |
| Sensor Simulator | Flask + Paho MQTT |
| Message Broker | Eclipse Mosquitto |
| Field Bus | Modbus TCP |
| Flow Automation | Node-RED |
| Containers | Docker + Docker Compose |

---

## ⚡ Quick Start

### Prerequisites
- Docker & Docker Compose
- [OpenPLC Runtime](https://openplcproject.com/) installed locally
- [Ollama](https://ollama.ai/) with LLaMA3 pulled: `ollama pull llama3`
- Node-RED with `node-red-contrib-modbus` installed

### 1. Clone and start services
```bash
git clone https://github.com/YOUR_USERNAME/plcpilot.git
cd plcpilot
docker-compose up -d
```

### 2. Run the Streamlit code generator
```bash
pip install -r requirements.txt
streamlit run app/streamlit_app.py
```

### 3. Import Node-RED flow
- Open Node-RED at `http://localhost:1880`
- Import `nodered_flows/plcpilot_flow.json`
- Deploy the flow

### 4. Deploy a PLC program
- Open OpenPLC at `http://localhost:8080`
- Upload any `.st` file from `plc_programs/`
- Start the runtime

### 5. Test
- Node-RED injects temperature values via Modbus to `%MW0` (register 1024)
- OpenPLC evaluates the logic and sets coil outputs
- Read coils 0 and 1 in Node-RED to observe fan/alarm state

---

## 🧪 Demo Use Cases

| Use Case | File | Modbus Register |
|----------|------|-----------------|
| Temperature Fan Control | `temp_fan_control.st` | Write to HR 1024 (%MW0) |
| Press Machine Watchdog | `watchdog_press.st` | Toggle Coil 0 (%IX0.0) |
| Pump A/B Alternation | `pump_alternation.st` | Read Coils 0,1 |
| Robotic Arm Drift | `sensor_drift_robotic_arm.st` | Write HR 1024, 1025 |

---

## 🤖 AI Agent Pipeline

See [`agents/pipeline.py`](agents/pipeline.py) for the full 7-agent description.

The agents are designed to be modular — each can be swapped for a production service (e.g., replace the notification agent with PagerDuty, replace Ollama with a cloud LLM API).

---

## 🙋 Human-in-the-Loop

PLCpilot is designed with **human oversight** at every critical step:

- The **Human Notification Agent** sends alerts before deployment
- Operators can **approve or reject** generated code
- The **Learning Agent** flags repeated failures for human review
- All generated code is logged with timestamps for auditability

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Suresh Dakha**
Senior Solution Architect — Physical AI, Edge AI & OT Cybersecurity

Passionate about making industrial automation intelligent, accessible, and secure —
bringing GenAI to the factory floor for manufacturers of every size.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-suresh--dakha-blue?logo=linkedin)](https://linkedin.com/in/suresh-dakha)
[![GitHub](https://img.shields.io/badge/GitHub-dakhasuresh-black?logo=github)](https://github.com/dakhasuresh)

---

## 🔗 More Projects

Explore my other repositories covering OT Security, Edge AI and Physical AI:

[![OT Asset Classifier](https://img.shields.io/badge/Repo-OT--Asset--Classifier-orange?logo=github)](https://github.com/dakhasuresh/ot-asset-classifier)
[![GitHub Profile](https://img.shields.io/badge/All%20Repos-dakhasuresh-black?logo=github)](https://github.com/dakhasuresh?tab=repositories)
