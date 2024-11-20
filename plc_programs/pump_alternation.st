PROGRAM PumpAlternate
VAR
    PumpA         AT %QX0.0 : BOOL;
    PumpB         AT %QX0.1 : BOOL;
    Timer12H      : TON;
    ActivePump    : BOOL := FALSE;
END_VAR

Timer12H(IN := TRUE, PT := T#43200s);

IF Timer12H.Q THEN
    ActivePump := NOT ActivePump;
    Timer12H(IN := FALSE, PT := T#43200s);
    Timer12H(IN := TRUE, PT := T#43200s);
END_IF;

PumpA := NOT ActivePump;
PumpB := ActivePump;
END_PROGRAM

CONFIGURATION Config0
    RESOURCE Res0 ON PLC
        TASK MainTask(INTERVAL := T#100ms, PRIORITY := 1);
        PROGRAM PumpInst WITH MainTask : PumpAlternate;
    END_RESOURCE
END_CONFIGURATION
