PROGRAM WatchdogPress
VAR
    SensorPulse   AT %IX0.0 : BOOL;
    MachineRun    AT %QX0.0 : BOOL;
    WatchdogTimer : TON;
    LastPulse     : BOOL;
END_VAR

WatchdogTimer(IN := NOT SensorPulse, PT := T#10s);

IF WatchdogTimer.Q THEN
    MachineRun := FALSE;
END_IF;

IF SensorPulse AND NOT LastPulse THEN
    MachineRun := TRUE;
    WatchdogTimer(IN := FALSE, PT := T#10s);
END_IF;

LastPulse := SensorPulse;
END_PROGRAM

CONFIGURATION Config0
    RESOURCE Res0 ON PLC
        TASK MainTask(INTERVAL := T#100ms, PRIORITY := 1);
        PROGRAM WatchdogInst WITH MainTask : WatchdogPress;
    END_RESOURCE
END_CONFIGURATION
