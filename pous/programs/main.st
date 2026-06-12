PROGRAM main
  VAR
    Schritt : INT;
    NS_Rot : BOOL;
    NS_Gelb : BOOL;
    NS_Gruen : BOOL;
    OW_Rot : BOOL;
    OW_Gelb : BOOL;
    OW_Gruen : BOOL;
    T_Zeit : TIME;
    T1 : TON;
  END_VAR

(* Kreuzung: zwei Richtungen NS und OW, nie beide gruen *)

(* 1) Grundstellung: alles Rot. Danach pro Phase nur die Abweichung setzten *)
NS_Rot := TRUE; NS_Gelb := FALSE; NS_Gruen := FALSE;
OW_Rot := TRUE; OW_Gelb := FALSE; OW_Gruen := FALSE;

(* 2) Phasenfolge *)
CASE Schritt OF
    0: (* NS Rot-Gleb *)
    NS_Gelb := TRUE;
    T_Zeit := T#2s;
    IF T1.Q THEN Schritt := 1; END_IF;

    1: (* NS Gruen *)
    NS_Rot := TRUE; NS_Gruen := TRUE;
    T_Zeit := T#5s;
    IF T1.Q THEN Schritt := 2; END_IF;

    2: (* NS Gelb *)
    NS_Rot := FALSE; NS_Gelb := TRUE;
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 3; END_IF;

    3: (* Alles Rot *)
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 4; END_IF;  

    4: (* OW Rot-Gelb *)
    OW_Gelb := TRUE;
    T_Zeit := T#2s;
    IF T1.Q THEN Schritt := 5; END_IF;

    5: (* OW Gruen *)
    OW_Rot := FALSE; OW_Gruen := TRUE;
    T_Zeit := T#5s;
    IF T1.Q THEN SChritt := 6; END_IF;

    6: (* OW Gelb *)
    OW_Rot := FALSE; OW_Gelb := TRUE;
    T_Zeit := T#3s;
    IF T1.Q THEN SChritt := 7; END_IF;

    7: (* Alles Rot *)
    T_Zeit := T#1s;
    IF T1.Q THEN Schritt := 0; END_IF;
END_CASE;

(* 3) Sicherheitsverriegelung: falls je beide gruen waeren, sofort abschalten *)
IF NS_Gruen AND OW_Gruen then   
    NS_Gruen := FALSE;
    OW_Gruen := FALSE;
END_IF;

(* 4) Timer mit Selbstreset *)
T1(IN := NOT T1.Q, PT := T_Zeit);


END_PROGRAM