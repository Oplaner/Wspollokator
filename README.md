![App Icon](https://user-images.githubusercontent.com/23143311/148995223-420cca42-8cfe-40d9-a2f7-70b3b4fa9654.png)

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

In the _My profile_ tab the user can set their preferences: a point on the map and a distance from the point defining a region of the city, in which they are looking for roommates, as well as their attitude (negative, neutral or positive) to matters such as smoking people or pets. Setting the point is done by dropping a pin on the map, either in any place (manually), or in the user's current location (with a button on the bottom of the screen). Before user shares their profile in search results using the master switch, it is recommended to go to the _Settings_ view and set description and avatar visible in the profile. The same view allows user to change their information and log out. The _My profile_ tab also contains an average score and ratings about the user written by other users.

![Screenshots 2](https://user-images.githubusercontent.com/23143311/150385181-80157e0a-b6fd-4a8f-bbea-069fb270811b.png)
