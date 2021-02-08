Gruppe 45, labplass 6

Code conventions:
* Commits på engelsk og i preteritum, "Added penis mmodule"
* Følge elixir-conventions
* Feature-branching, master funker alltid

Server
* +Følger med om heisene gjør jobben sin.
* +Leser state til heisene
* -Veldig alvorlig om server dør

PtP
* +Alle heiser kjører samme software
* +Elegant
* -Kan potensielt bli minst effektivt

Subnetting av etajene

Generelt
* Heisene bør ha tilgang til sin egen kø
* Kan ha hybrid-greie, heisen tenker selv 

Heisen er: lokale aktører som kan lese lokale inputs og få tilsendt inputs. Kan anta at førstnevnte fungerer og at sistnevnte kan slutte å fungere whenever

Antagelser:
* Antar hall call-knappene fungerer som en vanlig heis, dvs. at hall call-knappene deles mellom alle heisene.

Håndtering av hall-ordre:
* PtP: Alle heisene må snakke sammen og bli enige om hvem som skal ta ordren. Antall meldinger har kompleksistet n!
* Server: Server må tildele ordrer. Antall meldinger har kompleksistet

Nyttige ressurser:
* https://elixir-lang.org/blog/2013/08/08/elixir-design-goals/
* https://elixir-lang.org/getting-started/introduction.html
* https://github.com/TTK4145/Project-resources
* https://github.com/TTK4145/Simulator-v2
