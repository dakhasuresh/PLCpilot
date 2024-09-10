import streamlit as st
import subprocess
import datetime

st.set_page_config(page_title="PLCpilot – PLC Logic Generator", layout="centered")
st.title("⚙️ PLCpilot – GenAI PLC Logic Generator")
st.subheader("Describe your manufacturing control logic in plain language")

USE_CASES = {
    "Custom (enter your own)": "",
    "Temperature Fan Control": (
        "Create a PLC program that turns on a cooling fan and an alarm when a machine's "
        "temperature exceeds 75C. The fan and alarm should stay on until the temperature "
        "drops below 70C. Use Structured Text. Include OpenPLC-compatible I/O mappings."
    ),
    "Watchdog Timer – Press Machine": (
        "Include a watchdog timer that stops the press machine if no sensor pulse is "
        "received within 10 seconds, due to missed part detection anomalies."
    ),
    "Pump A/B Alternation": (
        "Add logic to alternate between pump A and B every 12 hours due to uneven wear."
    ),
    "Sensor Drift – Robotic Arm": (
        "Detect sensor drift in a robotic arm position sensor. If drift between actual "
        "and expected position exceeds 50 units, trigger alarm and safety stop."
    ),
}

selected = st.selectbox("Select a use case:", list(USE_CASES.keys()))
prompt = st.text_area("Your logic description:", value=USE_CASES[selected], height=150)

if st.button("Generate PLC Code"):
    if not prompt.strip():
        st.warning("Please enter a prompt.")
    else:
        with st.spinner("Generating via Ollama..."):
            system_prompt = (
                "You are an expert PLC programmer. Generate ONLY OpenPLC-compatible "
                "Structured Text (ST) code. Always include PROGRAM, VAR blocks with "
                "%MW/%QX/%IX mappings, logic, END_PROGRAM, and CONFIGURATION block."
            )
            try:
                result = subprocess.run(
                    ["ollama", "run", "llama3"],
                    input=f"{system_prompt}\n\nRequest: {prompt}",
                    capture_output=True, text=True, timeout=120
                )
                plc_code = result.stdout.strip()
                if not plc_code:
                    raise ValueError("Empty response")
            except Exception:
                plc_code = "# Ollama unavailable. Paste prompt into OpenPLC manually."

        st.code(plc_code, language="pascal")
        st.success("PLC code generated!")
        ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        fname = f"plc_generated_{ts}.st"
        with open(fname, "w") as f:
            f.write(plc_code)
        with open(fname, "rb") as f:
            st.download_button("Download .st File", f, file_name=fname)
