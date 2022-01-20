![App Icon](https://user-images.githubusercontent.com/23143311/150419106-b00026aa-9f7f-46e3-979f-712cad95f564.png)

# Współlokator

🇵🇱

Studencki projekt aplikacji na iOS służącej do wyszukiwania współlokatorów. Oprócz wersji mobilnej, niezależne zespoły tworzyły wersję webową oraz architekturę backendową.

Aplikacja na iOS ma architekturę MVVM. Interfejsy użytkownika przygotowano w SwiftUI, a komunikacja z serwerem (HTTP, JSON) odbywa się poprzez URLSession. Inne wykorzystane technologie: Core Location, Keychain Services, MapKit, PhotosUI, UIKit, UserDefaults.

🇬🇧

A student project of an iOS app for finding roommates. Apart from the mobile version, independent teams were working on a web version of the app and its backend architecture.

The iOS app has an MVVM architecture. User interfaces were created with SwiftUI and communication with the server (HTTP, JSON) was established using URLSession. Other used technologies are: Core Location, Keychain Services, MapKit, PhotosUI, UIKit, UserDefaults.

# Funkcjonalności | Features

## Rejestracja i logowanie | Sign up & Log in

🇵🇱

Aby korzystać z aplikacji, należy założyć konto i się zalogować.

🇬🇧

To begin using the app, a user has to create their account and log in.

![Screenshots 1](https://user-images.githubusercontent.com/23143311/150369650-db2505ec-2ca0-4cf8-9b7b-aa7838812e47.png)

## Mój profil i Ustawienia | My profile & Settings

🇵🇱

W karcie _Mój profil_ użytkownik może ustalać swoje preferencje: punkt na mapie i odległość od tego punktu wyznaczające obszar miasta, w którym szuka współlokatorów, a także swój stosunek (negatywny, neutralny lub pozytywny) do kwestii takich jak osoby palące czy zwierzęta domowe. Ustawianie punktu odbywa się poprzez upuszczenie pinezki na mapie, albo w dowolnym miejscu (ręcznie), albo w bieżącej lokalizacji użytkownika (przyciskiem na dole ekranu). Zanim użytkownik udostępni swój profil w wynikach wyszukiwania przy użyciu głównego przełącznika, warto by przeszedł do ekranu _Ustawienia_ i zmienił opis widoczny w profilu oraz ustawił swój awatar. W tym samym ekranie może też zmienić swoje dane oraz się wylogować. Karta _Mój profil_ zawiera również średnią ocenę i opinie wystawione użytkownikowi przez innych użytkowników.

🇬🇧

In the _My profile_ tab the user can set their preferences: a point on the map and a distance from the point defining a region of the city, in which they are looking for roommates, as well as their attitude (negative, neutral or positive) to matters such as smoking people or pets. Setting the point is done by dropping a pin on the map, either in any place (manually), or in the user's current location (with a button at the bottom of the screen). Before user shares their profile in search results using the master switch, it is recommended to go to the _Settings_ view and set description and avatar visible in the profile. The same view allows user to change their information and log out. The _My profile_ tab also contains an average score and ratings about the user written by other users.

![Screenshots 2](https://user-images.githubusercontent.com/23143311/150391083-d1206ed3-b688-4470-801b-262f2d870d81.png)

## Wyszukiwanie | Search

🇵🇱

Najważniejszą funkcją aplikacji jest wyszukiwanie współlokatorów, dostępne w karcie _Szukaj_. Wyniki wyszukiwania są przedstawiane w formie listy lub punktów na mapie. Wyszukiwani są tacy użytkownicy, których obszar zainteresowania znajduje się w odległości nie większej niż limit ustalony w filtrach od punktu bieżącego użytkownika oraz których preferencje pasują do preferencji ustalonych w filtrach. Kryteria wyszukiwania można jednym przyciskiem ustawić na takie same jak pożądana odległość od punktu oraz preferencje w profilu bieżącego użytkownika.

🇬🇧

The most important feature of the app is searching for roommates, available in the _Search_ tab. Search results are presented as a list or as points on the map. The app searches for users whose region of interest is not farther than the limit specified in filters from the current user's point of interest and whose preferences match the ones specified in filters. The search criteria can be matched to the current user's target distance from their point and their preferences with a tap of a button.

![Screenshots 3](https://user-images.githubusercontent.com/23143311/150392191-3cc22701-afc4-4909-9c58-cfbb00d7abcc.png)

## Profil użytkownika i opinie | User Profile & Ratings

🇵🇱

Po stuknięciu w użytkownika przechodzimy do jego profilu, gdzie oprócz informacji o nim znajdziemy średnią ocenę oraz opinie, a także przycisk kierujący do konwersacji z tym użytkownikiem.

🇬🇧

By tapping a user, we go to their profile, where apart from some information about them we can find an average score and ratings, as well as a button redirecting us to a conversation with the user.

![Screenshots 4](https://user-images.githubusercontent.com/23143311/150410496-293b391c-a6d7-4f99-905e-7c0f33cb6c9c.png)

## Wiadomości | Messages

🇵🇱

Karta _Wiadomości_ zawiera listę konwersacji, w których uczestniczy bieżący użytkownik. Wspierane są konwersacje zarówno z jedną osobą, jak i grupowe. Można utworzyć konwersację, wybierając osobę lub osoby spośród zapisanych użytkowników.

🇬🇧

The _Messages_ tab contains a list of conversations, in which the current user participates. Both conversations with one user and group conversations are supported. A new conversation can be created by choosing one or more users from the saved ones.

![Screenshots 5](https://user-images.githubusercontent.com/23143311/150415478-5c439ec5-5aa4-4d23-ab57-58ba5a0df264.png)

## Lista zapisanych | Saved Users

🇵🇱

Jeśli jakiś użytkownik jest dobrym kandydatem na współlokatora, możemy go zapisać na specjalnej liście osób zapisanych (karta _Zapisane_).

🇬🇧

If a user seems to be a good candidate for a roommate, we can add them to the special saved users list (the _Saved_ tab).

![Screenshots 6](https://user-images.githubusercontent.com/23143311/150417343-850b0bb0-4ad9-45d5-bace-5a4f31cd9f54.png)

# Demo

🇵🇱

Gałąź główna zawiera pełną wersję aplikacji, łączącą się z serwerem. Z czasem serwer przestanie być aktywny, dlatego przygotowano również demonstracyjną wersję offline z przykładowymi danymi. Jest ona dostępna jako gałąź [offline-demo](https://github.com/Oplaner/Wspollokator/tree/offline-demo).

Jest 5 przykładowych użytkowników:
* John Appleseed
* Anna Brown
* Mark Williams
* Amy Smith
* Carol Johnson

Login: imię.nazwisko@apple.com
Hasło: dowolny niepusty ciąg

🇬🇧

The main branch contains a full version of the app, the one which connects with the server. The server is going to become inactive, however. For that reason, an offline demo version with sample data was prepared. It is available as the [offline-demo](https://github.com/Oplaner/Wspollokator/tree/offline-demo) branch.

There are 5 sample users:
* John Appleseed
* Anna Brown
* Mark Williams
* Amy Smith
* Carol Johnson

Login: name.surname@apple.com
Hasło: any non-empty string

# Autorzy | Authors

* [Oplaner](https://github.com/Oplaner)
* [szytambsky](https://github.com/szytambsky)
* [Piotr Czajkowski](https://github.com/piotrczajkowski1)
