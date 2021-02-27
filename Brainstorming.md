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

Subnetting av etasjene?

Generelt
* Heisene bør ha tilgang til sin egen kø
* Kan ha hybrid-greie, heisen tenker selv 

Heisen er: lokale aktører som kan lese lokale inputs og få tilsendt inputs. Kan anta at førstnevnte fungerer og at sistnevnte kan slutte å fungere whenever

Antagelser:
* Antar hall call-knappene fungerer som en vanlig heis, dvs. at hall call-knappene deles mellom alle heisene.
* Antar at server alltid fungerer.
* Lager heis for et realistisk system.

Håndtering av hall-ordre:
* PtP: Alle heisene må snakke sammen og bli enige om hvem som skal ta ordren. Antall meldinger har kompleksistet n!
* Server: Server må tildele ordrer. Antall meldinger har kompleksistet

Nyttige ressurser:
* https://elixir-lang.org/blog/2013/08/08/elixir-design-goals/
* https://elixir-lang.org/getting-started/introduction.html
* https://github.com/TTK4145/Project-resources
* https://github.com/TTK4145/Simulator-v2

Går for server-approach.
Heis' state:
* Hvor den er
* Hva retning den kjører
* Current target (top of queue)
* Kø med etasjer

Costfunction
* Heiser som ikke gjør noe bør vektes lavere enn heiser som har lang kø
* Heiser skal ikke trenge å snu før det er absolutt nødvendig (tar bare ordre som er i samme retning som vi beveger oss i)

State til elevator:
* Hvilken retning den beveger seg i
* Hvilken etasje den var i sist 
*   Disse to sammen gir plassering
* Lokal Kø
