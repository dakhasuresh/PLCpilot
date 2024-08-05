/**
 * PLCpilot – Node-RED Function Node
 * Generates simulated machine metrics for 10 machines
 * Outputs: [InfluxDB messages, MQTT messages]
 */

let out = [];
let mqtt = [];

for (let i = 1; i <= 10; i++) {
    let machine = `M${i}`;
    let tags = {
        temperature:  Math.random() * 100,
        vibration:    Math.random() * 10,
        speed:        Math.random() * 1500,
        load:         Math.random() * 100,
        status:       Math.random() > 0.5 ? "running" : "stopped",
        pressure:     Math.random() * 200,
        current:      Math.random() * 50,
        voltage:      220 + Math.random() * 10,
        humidity:     Math.random() * 100,
        energy:       Math.random() * 1000,
        utilization:  Math.random() * 100,
        downtime:     Math.random() > 0.95 ? Math.random() * 5 : 0
    };

    for (let tag in tags) {
        let value = tags[tag];

        // InfluxDB message
        out.push({
            payload: {
                measurement: "machine_metrics",
                tags:   { machine: machine, tag: tag },
                fields: { value: typeof value === "number" ? value : value.toString() },
                timestamp: new Date()
            }
        });

        // MQTT message
        mqtt.push({
            topic:   `factory/line1/${machine}/${tag}`,
            payload: typeof value === "number" ? value.toFixed(2) : value
        });
    }
}

return [out, mqtt];
