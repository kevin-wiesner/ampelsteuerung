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

(* 1) Grundstellung: alles Rot. Danach pro Phase nur die Abweichung setzen. *)
NS_Rot := TRUE; NS_Gelb := FALSE; NS_Gruen := FALSE;
OW_Rot := TRUE; OW_Gelb := FALSE; OW_Gruen := FALSE;

(* 2) Phasenfolge *)
CASE Schritt OF
    0: (* NS Rot-Gelb *)
    NS_Gelb := TRUE;
    T_Zeit := T#2s;
    IF T1.Q THEN Schritt := 1; END_IF;

    1: (* NS Gruen *)
    NS_Rot := FALSE; NS_Gruen := TRUE;
    T_Zeit := T#5s;
    IF T1.Q THEN Schritt := 2; END_IF;

    2: (* NS Gelb *)
    NS_Rot := FALSE; NS_Gelb := TRUE;
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 3; END_IF;

    3: (* Alles Rot - Raeumzeit *)
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 4; END_IF;

    4: (* OW Rot-Gelb *)
    OW_Gelb := TRUE;
    T_Zeit := T#2s;
    IF T1.Q THEN Schritt := 5; END_IF;

    5: (* OW Gruen *)
    OW_Rot := FALSE; OW_Gruen := TRUE;
    T_Zeit := T#5s;
    IF T1.Q THEN Schritt := 6; END_IF;

    6: (* OW Gelb *)
    OW_Rot := FALSE; OW_Gelb := TRUE;
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 7; END_IF;

    7: (* Alles Rot - Raeumzeit *)
    T_Zeit := T#3s;
    IF T1.Q THEN Schritt := 0; END_IF;
END_CASE;

(* 3) Sicherheitsverriegelung
   Beide Pruefungen liegen NACH dem CASE. Was hier greift, ist ein
   Programmierfehler in der Phasenlogik - der sichere Zustand ist Rot. *)

(* 3a) Nie beide Richtungen gleichzeitig gruen *)
IF NS_Gruen AND OW_Gruen THEN
    NS_Gruen := FALSE;
    OW_Gruen := FALSE;
    NS_Rot := TRUE;
    OW_Rot := TRUE;
END_IF;

(* 3b) Nie Rot und Gruen derselben Richtung gleichzeitig.
   Diese Pruefung haette den Fehler in Schritt 1 gefunden, bei dem
   NS_Rot faelschlich TRUE blieb, waehrend NS_Gruen gesetzt wurde. *)
IF NS_Rot AND NS_Gruen THEN
    NS_Gruen := FALSE;
END_IF;
IF OW_Rot AND OW_Gruen THEN
    OW_Gruen := FALSE;
END_IF;

(* 4) Timer mit Selbstreset *)
T1(IN := NOT T1.Q, PT := T_Zeit);

END_PROGRAM
