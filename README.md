EarnQuest

EarnQuest är en SwiftUI-app byggd med Firebase där ett barn kan få sysslor från en admin/förälder, markera dem som klara och följa sin statistik, streak och intjänade veckopeng.

Projektet är byggt med:

* SwiftUI
* MVVM-arkitektur
* Firebase Firestore
* UserNotifications
* Swift Charts

⸻

Funktioner

Admin

* Skapa nya sysslor
* Skicka sysslor till barnet
* Se barnets pågående sysslor
* Se barnets statistik
* Få notifieringar när barnet gjort klart sysslor

Barn

* Se pågående sysslor
* Markera sysslor som klara
* Se avklarade sysslor grupperade efter datum
* Se veckostatistik
* Se streak för utförda sysslor
* Få notifieringar när nya sysslor skickas

⸻

Arkitektur

Projektet använder MVVM.

Struktur

Models/
Views/
ViewModels/
Services/
Managers/
Resources/

Exempel

* Views ansvarar för UI
* ViewModels hanterar logik och state
* Services ansvarar för Firebase-kommunikation
* Managers används för notifieringar

⸻

Firebase

Projektet använder Firebase Firestore med följande collections:

users

Lagrar användare:

- uid
- email
- displayName
- role
- familyId

chores

Lagrar aktiva sysslor:

- title
- dailyReward

När barnet slutför en syssla tas den bort från chores.

completions

Lagrar historik över slutförda sysslor:

- choreId
- title
- dailyReward
- userId
- date

Denna collection används för:

* Statistik
* Veckopeng
* Charts
* Streak
* Avklarade sysslor

⸻

Statistik & Streak

Appen använder Swift Charts för att visa:

* Intjänad veckopeng
* Daglig aktivitet
* Streak för utförda sysslor

Streak räknas automatiskt baserat på antal dagar i rad användaren utfört minst en syssla.

⸻

Notifieringar

Projektet använder UserNotifications.

Exempel

* Barnet får notifiering när nya sysslor skickas
* Admin får notifiering när barnet gjort klart sysslor

⸻

Teknologier

* SwiftUI
* Firebase Firestore
* Firebase Authentication
* Swift Charts
* UserNotifications
* Combine

⸻

Installation

1. Klona projektet

git clone <repo-url>

2. Installera Firebase

Projektet använder Swift Package Manager.

Lägg till:

https://github.com/firebase/firebase-ios-sdk

3. Lägg till GoogleService-Info.plist

Skapa ett Firebase-projekt och lägg till din egen:

GoogleService-Info.plist

fil i projektet.

4. Kör appen

Öppna:

EarnQuest.xcodeproj

och kör projektet i simulator eller på fysisk enhet.

⸻

Framtida förbättringar

* Flera barn per familj
* Redigera sysslor
* Profilbilder
* Cloud Messaging
* Pushnotiser mellan riktiga användare
* Family relation-system
* Belöningssystem
* Månadsstatistik

⸻

Utvecklare

Skapad av Mikael Engvall som skolprojekt i SwiftUI och Firebase.
