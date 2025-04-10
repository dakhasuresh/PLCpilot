# PLCpilot Architecture Notes

## Modbus Address Mapping (OpenPLC)

| PLC Variable | Modbus Type | Address | Node-RED Register |
|---|---|---|---|
| %MW0 | Holding Register | 1024 | HR 1024 |
| %MW1 | Holding Register | 1025 | HR 1025 |
| %QX0.0 | Coil | 0 | Coil 0 |
| %QX0.1 | Coil | 1 | Coil 1 |
| %IX0.0 | Discrete Input | 0 | DI 0 |

## OpenPLC Compilation Notes

When compiling `.st` files in OpenPLC:
- Ensure `CONFIGURATION` block matches `PROGRAM` name exactly
- `INTERVAL := T#100ms` is standard for most control tasks
- Use `%MW` for integer sensor inputs (temperature, position)
- Use `%QX` for boolean outputs (fans, alarms, motors)
- Use `%IX` for boolean inputs (push buttons, pulse sensors)

## Node-RED Modbus Setup

- Server: `127.0.0.1:502` (OpenPLC default Modbus port)
- Use `modbus-write` node → Data Type: `Holding Register` → Address: `1024`
- Use `modbus-read` node → Data Type: `Coil` → Address: `0`, Quantity: `2`
- Poll interval: 1000ms recommended for testing

## MQTT Topics (Flask Simulator)

| Topic | Payload | Description |
|---|---|---|
| `{machine}/{tag}/{phase}` | `machine1/temperature/phase1` | Flask simulator output |
| `factory/line1/{M}/{tag}` | `factory/line1/M1/temperature` | Node-RED function output |

**Flask simulator** publishes 10 machines × 5 tags × 3 phases = **150 topics/second**

Tags: `temperature`, `vibration`, `pressure`, `speed`, `load`

**Node-RED function** outputs to InfluxDB + MQTT for 10 machines × 12 tags = **120 data points**

Tags: `temperature`, `vibration`, `speed`, `load`, `status`, `pressure`, `current`, `voltage`, `humidity`, `energy`, `utilization`, `downtime`
