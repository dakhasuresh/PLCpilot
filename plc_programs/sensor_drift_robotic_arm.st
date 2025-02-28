PROGRAM SensorDriftDetect
VAR
    ActualPos     AT %MW0 : INT;
    ExpectedPos   AT %MW1 : INT;
    DriftAlarm    AT %QX0.0 : BOOL;
    SafetyStop    AT %QX0.1 : BOOL;
    Drift         : INT;
END_VAR

VAR CONSTANT
    DRIFT_LIMIT : INT := 50;
END_VAR

Drift := ActualPos - ExpectedPos;
IF Drift < 0 THEN
    Drift := -Drift;
END_IF;

IF Drift > DRIFT_LIMIT THEN
    DriftAlarm := TRUE;
    SafetyStop := TRUE;
ELSE
    DriftAlarm := FALSE;
    SafetyStop := FALSE;
END_IF;
END_PROGRAM

CONFIGURATION Config0
    RESOURCE Res0 ON PLC
        TASK MainTask(INTERVAL := T#100ms, PRIORITY := 1);
        PROGRAM DriftInst WITH MainTask : SensorDriftDetect;
    END_RESOURCE
END_CONFIGURATION
