PROGRAM main
  VAR
    Schritt : INT;
    Rot : BOOL;
    Gelb : BOOL;
    Gruen : BOOL;
    T_Zeit : TIME;
    T1 : TON;
  END_VAR

(* Ampel-Steuerung als Zustandsautomat *)
CASE Schritt OF
    0: (* Rot *)
    Rot := TRUE; Gelb := FALSE; Gruen := FALSE;
    IF T1.Q THEN Schritt := 1; END_IF;

    1: (* Rot-Gelb *)
    Rot := TRUE; Gelb := TRUE; Gruen:= FALSE;
    T_Zeit := T#2s;
    IF T1.Q THEN Schritt := 2; END_IF;

    2: (* Gruen *)
    Rot := FALSE; Gelb := FALSE; Gruen := TRUE;
    T_Zeit := T#5s;
    IF T1.Q THEN Schritt := 3; END_IF;

    3: (* Gelb *)
    Rot := FALSE; Gelb := TRUE; Gruen := FALSE;
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 0; END_IF;  
END_CASE;
(* Timer laeuft mit der Zeit des aktuellen Schritts *)
(* und setzt sich beim Fertigwerden selbst zurück *)
T1(IN := NOT T1.Q, PT := T_Zeit);

END_PROGRAM