# Ampelsteuerung (SPS / Structured Text)

Eine Ampelsteuerung als Zustandsautomat, programmiert in Structured Text (IEC 61131-3) mit dem OpenPLC Editor. Erste Version: eine Fahrtrichtung mit der vollständigen deutschen Ampelsequenz.

## Funktion

Die Ampel durchläuft endlos vier zeitgesteuerte Zustände:

| Schritt | Zustand  | Rot | Gelb | Gruen | Dauer |
|--------:|----------|:---:|:----:|:-----:|:-----:|
| 0       | Rot      |  X  |      |       |  5 s  |
| 1       | Rot-Gelb |  X  |  X   |       |  2 s  |
| 2       | Gruen    |     |      |   X   |  5 s  |
| 3       | Gelb     |     |  X   |       |  3 s  |

Nach Schritt 3 beginnt der Zyklus von vorn. Rot-Gelb erscheint nur beim Übergang Rot→Grün.

## Technik

- Zustandsautomat über `CASE Schritt OF ... END_CASE`
- Ein einziger `TON`-Timer für alle Zustände, mit Selbstreset über `IN := NOT T1.Q`
- Wartezeit je Zustand in einer `TIME`-Variablen

## Ausführen

1. Projekt im OpenPLC Editor öffnen
2. Simulation starten
3. Variablen `Schritt`, `Rot`, `Gelb`, `Gruen` in den Debugger holen und Ablauf beobachten

## Geplante Erweiterungen

- Kreuzung mit zwei verriegelten Fahrtrichtungen (nie beide grün)
- Fußgänger-Anforderungstaster
- Nachtblinken

## Hintergrund

Übungsprojekt im Rahmen meiner Vorbereitung auf die industrielle Automatisierung. Das Muster (Zustandsautomat + Timer) ist IEC-61131-3-Standard und direkt auf Siemens TIA Portal / SCL übertragbar.
