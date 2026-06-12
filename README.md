# Ampelsteuerung (SPS / Structured Text)

Eine Ampelsteuerung als Zustandsautomat, programmiert in Structured Text (IEC 61131-3) mit dem OpenPLC Editor.

Aktuelle Version: **Kreuzung mit zwei verriegelten Fahrtrichtungen** (Nord-Süd und Ost-West). Die einfache Erstversion (eine Richtung) bleibt in der Git-Historie erhalten.

## Funktion

Eine gemeinsame Zustandsmaschine schaltet beide Richtungen durch acht Phasen. Grün tritt je Richtung nur in genau einer Phase auf — daher sind nie beide gleichzeitig grün (Verriegelung). Zwischen den Richtungswechseln liegt je eine kurze Alles-Rot-Phase.

| Schritt | Nord-Süd | Ost-West | Dauer |
|--------:|----------|----------|:-----:|
| 0 | Rot-Gelb | Rot      | 2 s |
| 1 | Grün     | Rot      | 5 s |
| 2 | Gelb     | Rot      | 3 s |
| 3 | Rot      | Rot      | 1 s |
| 4 | Rot      | Rot-Gelb | 2 s |
| 5 | Rot      | Grün     | 5 s |
| 6 | Rot      | Gelb     | 3 s |
| 7 | Rot      | Rot      | 1 s |

## Technik

- Zustandsautomat über `CASE Schritt OF ... END_CASE`
- Ein einziger `TON`-Timer für alle Phasen, mit Selbstreset über `IN := NOT T1.Q`
- Grundstellung „alles Rot" je Zyklus, danach nur die Abweichungen setzen (sicherer Default)
- Sicherheitsverriegelung: falls je beide Richtungen grün wären, werden beide sofort abgeschaltet

## Ausführen

1. Projekt im OpenPLC Editor öffnen
2. Simulation starten
3. Variablen `Schritt`, `NS_*`, `OW_*` in den Debugger holen (ein Umlauf: 22 s)

## Geplante Erweiterungen

- Fußgänger-Anforderungstaster
- Nachtblinken (gelb blinkend)

## Hintergrund

Übungsprojekt im Rahmen meiner Vorbereitung auf die industrielle Automatisierung. Das Muster (Zustandsautomat + Timer + Verriegelung) ist IEC-61131-3-Standard und direkt auf Siemens TIA Portal / SCL übertragbar.
