![App Icon](https://user-images.githubusercontent.com/23143311/150419106-b00026aa-9f7f-46e3-979f-712cad95f564.png)

# Wsp贸艂lokator

馃嚨馃嚤

Studencki projekt aplikacji na iOS s艂u偶膮cej do wyszukiwania wsp贸艂lokator贸w. Opr贸cz wersji mobilnej, niezale偶ne zespo艂y tworzy艂y wersj臋 webow膮 oraz architektur臋 backendow膮.

Aplikacja na iOS ma architektur臋 MVVM. Interfejsy u偶ytkownika przygotowano w SwiftUI, a komunikacja z serwerem (HTTP, JSON) odbywa si臋聽poprzez URLSession. Inne wykorzystane technologie: Core Location, Keychain Services, MapKit, PhotosUI, UIKit, UserDefaults.

馃嚞馃嚙

A student project of an iOS app for finding roommates. Apart from the mobile version, independent teams were working on a web version of the app and its backend architecture.

The iOS app has an MVVM architecture. User interfaces were created with SwiftUI and communication with the server (HTTP, JSON) was established using URLSession. Other used technologies are: Core Location, Keychain Services, MapKit, PhotosUI, UIKit, UserDefaults.

# Funkcjonalno艣ci | Features

## Rejestracja i logowanie | Sign up & Log in

馃嚨馃嚤

Aby korzysta膰 z aplikacji, nale偶y za艂o偶y膰 konto i si臋 zalogowa膰.

馃嚞馃嚙

To begin using the app, a user has to create their account and log in.

![Screenshots 1](https://user-images.githubusercontent.com/23143311/150369650-db2505ec-2ca0-4cf8-9b7b-aa7838812e47.png)

## M贸j profil i Ustawienia | My profile & Settings

馃嚨馃嚤

W karcie _M贸j profil_ u偶ytkownik mo偶e ustala膰 swoje preferencje: punkt na mapie i odleg艂o艣膰 od tego punktu wyznaczaj膮ce obszar miasta, w kt贸rym szuka wsp贸艂lokator贸w, a tak偶e sw贸j stosunek (negatywny, neutralny lub pozytywny) do kwestii takich jak osoby pal膮ce czy zwierz臋ta domowe. Ustawianie punktu odbywa si臋 poprzez upuszczenie pinezki na mapie, albo w dowolnym miejscu (r臋cznie), albo w bie偶膮cej lokalizacji u偶ytkownika (przyciskiem na dole ekranu). Zanim u偶ytkownik udost臋pni sw贸j profil w wynikach wyszukiwania przy u偶yciu g艂贸wnego prze艂膮cznika, warto by przeszed艂 do ekranu _Ustawienia_ i zmieni艂 opis widoczny w profilu oraz ustawi艂 sw贸j awatar. W tym samym ekranie mo偶e te偶 zmieni膰 swoje dane oraz si臋 wylogowa膰. Karta _M贸j profil_ zawiera r贸wnie偶 艣redni膮 ocen臋 i opinie wystawione u偶ytkownikowi przez innych u偶ytkownik贸w.

馃嚞馃嚙

In the _My profile_ tab the user can set their preferences: a point on the map and a distance from the point defining a region of the city, in which they are looking for roommates, as well as their attitude (negative, neutral or positive) to matters such as smoking people or pets. Setting the point is done by dropping a pin on the map, either in any place (manually), or in the user's current location (with a button at the bottom of the screen). Before user shares their profile in search results using the master switch, it is recommended to go to the _Settings_ view and set description and avatar visible in the profile. The same view allows user to change their information and log out. The _My profile_ tab also contains an average score and ratings about the user written by other users.

![Screenshots 2](https://user-images.githubusercontent.com/23143311/150391083-d1206ed3-b688-4470-801b-262f2d870d81.png)

## Wyszukiwanie | Search

馃嚨馃嚤

Najwa偶niejsz膮 funkcj膮 aplikacji jest wyszukiwanie wsp贸艂lokator贸w, dost臋pne w karcie _Szukaj_. Wyniki wyszukiwania s膮聽przedstawiane w formie listy lub punkt贸w na mapie. Wyszukiwani s膮 tacy u偶ytkownicy, kt贸rych obszar zainteresowania znajduje si臋 w odleg艂o艣ci nie wi臋kszej ni偶 limit ustalony w filtrach od punktu bie偶膮cego u偶ytkownika oraz kt贸rych preferencje pasuj膮 do preferencji ustalonych w filtrach. Kryteria wyszukiwania mo偶na jednym przyciskiem ustawi膰 na takie same jak po偶膮dana odleg艂o艣膰 od punktu oraz preferencje w profilu bie偶膮cego u偶ytkownika.

馃嚞馃嚙

The most important feature of the app is searching for roommates, available in the _Search_ tab. Search results are presented as a list or as points on the map. The app searches for users whose region of interest is not farther than the limit specified in filters from the current user's point of interest and whose preferences match the ones specified in filters. The search criteria can be matched to the current user's target distance from their point and their preferences with a tap of a button.

![Screenshots 3](https://user-images.githubusercontent.com/23143311/150392191-3cc22701-afc4-4909-9c58-cfbb00d7abcc.png)

## Profil u偶ytkownika i opinie | User Profile & Ratings

馃嚨馃嚤

Po stukni臋ciu w u偶ytkownika przechodzimy do jego profilu, gdzie opr贸cz informacji o nim znajdziemy 艣redni膮 ocen臋 oraz opinie, a tak偶e przycisk kieruj膮cy do konwersacji z tym u偶ytkownikiem.

馃嚞馃嚙

By tapping a user, we go to their profile, where apart from some information about them we can find an average score and ratings, as well as a button redirecting us to a conversation with the user.

![Screenshots 4](https://user-images.githubusercontent.com/23143311/150410496-293b391c-a6d7-4f99-905e-7c0f33cb6c9c.png)

## Wiadomo艣ci | Messages

馃嚨馃嚤

Karta _Wiadomo艣ci_ zawiera list臋 konwersacji, w kt贸rych uczestniczy bie偶膮cy u偶ytkownik. Wspierane s膮聽konwersacje zar贸wno z jedn膮 osob膮, jak i grupowe. Mo偶na utworzy膰 konwersacj臋, wybieraj膮c osob臋 lub osoby spo艣r贸d zapisanych u偶ytkownik贸w.

馃嚞馃嚙

The _Messages_ tab contains a list of conversations, in which the current user participates. Both conversations with one user and group conversations are supported. A new conversation can be created by choosing one or more users from the saved ones.

![Screenshots 5](https://user-images.githubusercontent.com/23143311/150415478-5c439ec5-5aa4-4d23-ab57-58ba5a0df264.png)

## Lista zapisanych | Saved Users

馃嚨馃嚤

Je艣li jaki艣 u偶ytkownik jest dobrym kandydatem na wsp贸艂lokatora, mo偶emy go zapisa膰 na specjalnej li艣cie os贸b zapisanych (karta _Zapisane_).

馃嚞馃嚙

If a user seems to be a good candidate for a roommate, we can add them to the special saved users list (the _Saved_ tab).

![Screenshots 6](https://user-images.githubusercontent.com/23143311/150417343-850b0bb0-4ad9-45d5-bace-5a4f31cd9f54.png)

# Demo

馃嚨馃嚤

Ga艂膮藕 g艂贸wna zawiera pe艂n膮 wersj臋 aplikacji, 艂膮cz膮c膮 si臋 z serwerem. Z czasem serwer przestanie by膰 aktywny, dlatego przygotowano r贸wnie偶 demonstracyjn膮 wersj臋聽offline z przyk艂adowymi danymi. Jest ona dost臋pna jako ga艂膮藕 [offline-demo](https://github.com/Oplaner/Wspollokator/tree/offline-demo).

Jest 5 przyk艂adowych u偶ytkownik贸w:
* John Appleseed
* Anna Brown
* Mark Williams
* Amy Smith
* Carol Johnson

Dane do logowania:

```
Login: imi臋.nazwisko@apple.com
Has艂o: dowolny niepusty ci膮g
```

馃嚞馃嚙

The main branch contains a full version of the app, the one which connects with the server. The server is going to become inactive, however. For that reason, an offline demo version with sample data was prepared. It is available as the [offline-demo](https://github.com/Oplaner/Wspollokator/tree/offline-demo) branch.

There are 5 sample users:
* John Appleseed
* Anna Brown
* Mark Williams
* Amy Smith
* Carol Johnson

Log in information:

```
Login: name.surname@apple.com
Password: any non-empty string
```

# Autorzy | Authors

馃嚨馃嚤

Tw贸rcy aplikacji:
* [Kamil Chmielewski](https://github.com/Oplaner)
* [Szymon Tamborski](https://github.com/szytambsky)
* [Piotr Czajkowski](https://github.com/piotrczajkowski1)

Oryginalna ikona aplikacji: [Javier Cabezas](https://thenounproject.com/Xavi%20Caps/)

Redesign ikony i dob贸r kolor贸w: [Adrian Kut](https://github.com/AdrianKut), [Jerzy Chrupek](https://github.com/jerzychrupek)

馃嚞馃嚙

App makers:
* [Kamil Chmielewski](https://github.com/Oplaner)
* [Szymon Tamborski](https://github.com/szytambsky)
* [Piotr Czajkowski](https://github.com/piotrczajkowski1)

Original app icon: [Javier Cabezas](https://thenounproject.com/Xavi%20Caps/)

Icon redesign and color selection: [Adrian Kut](https://github.com/AdrianKut), [Jerzy Chrupek](https://github.com/jerzychrupek)
