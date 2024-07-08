PROGRAM TempControl
VAR
    TempSensor AT %MW0 : INT;
    Fan        AT %QX0.0 : BOOL;
    Alarm      AT %QX0.1 : BOOL;
END_VAR

VAR CONSTANT
    HIGH_LIMIT : INT := 75;
    LOW_LIMIT  : INT := 70;
END_VAR

IF TempSensor >= HIGH_LIMIT THEN
    Fan := TRUE;
    Alarm := TRUE;
ELSIF TempSensor <= LOW_LIMIT THEN
    Fan := FALSE;
    Alarm := FALSE;
END_IF;
END_PROGRAM

CONFIGURATION Config0
    RESOURCE Res0 ON PLC
        TASK MainTask(INTERVAL := T#100ms, PRIORITY := 1);
        PROGRAM TempInst WITH MainTask : TempControl;
    END_RESOURCE
END_CONFIGURATION
