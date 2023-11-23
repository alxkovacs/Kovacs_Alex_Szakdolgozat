# Szakdolgozat

## Címe
- **magyarul**: Multiplatform Mobilalkalmazás Fejlesztése Közösségi Árkövetést Támogató Adatbázissal
- **angolul**: Development of a Multiplatform Mobile Application with Community Price Tracking Database

## Mappaszerkezet

Ez a projekt az MVVM (Model-View-ViewModel) architektúrát használja. Az alábbiakban bemutatom a projekt szerkezetét és annak főbb részeit.

- [`lib/`](./lib/)
  - [`models/`](./lib/models/) - Az alkalmazás adatmodelljeit tartalmazó mappa.
    - [`user.dart`](./lib/models/user.dart)
    - [`post.dart`](./lib/models/post.dart)
    - ... (további modellek)
  - [`views/`](./lib/views/) - A felhasználói felület különböző oldalait tartalmazó mappa.
    - [`login_page.dart`](./lib/views/login_page.dart)
    - [`home_page.dart`](./lib/views/home_page.dart)
    - ... (további nézetek)
  - [`viewmodels/`](./lib/viewmodels/) - Az üzleti logikát kezelő osztályokat tartalmazó mappa.
    - [`login_viewmodel.dart`](./lib/viewmodels/login_viewmodel.dart)
    - [`home_viewmodel.dart`](./lib/viewmodels/home_viewmodel.dart)
    - ... (további viewmodellek)
  - [`services/`](./lib/services/) - Szolgáltatások, mint az API hozzáférés vagy hitelesítés.
    - [`api_service.dart`](./lib/services/api_service.dart)
    - ... (további szolgáltatások)
  - [`utils/`](./lib/utils/) - Segédfunkciók és konstansok.
    - [`constants.dart`](./lib/utils/constants.dart)
    - ... (további eszközök)


## Adatbázis tervek
- [`database/`](./database/) - Az adatbázis terveket tartalmazó mappa.
  - [`Kovacs_Alex_Szakdolgozat_Adatbazis_Dokumentacio.pdf`](./database/Kovacs_Alex_Szakdolgozat_Adatbazis_Dokumentacio.pdf) - Teljes adatbázis dokumentáció(EK diagram, Leképezés adatbázissémákra, Normalizálás(1NF, 2NF, 3NF), Tábla tervek).
  - [`Kovacs_Alex_Szakdolgozat_Adatbazis_Oldal.pdf`](./database/Kovacs_Alex_Szakdolgozat_Oldal.png) - Elkészült EK diagram.


## Képernyőtervek
- Moodboard: [`moodboard/`](./moodboard/)
- Prototípus-Képernyőtervek: [`prototype/Szakdolgozat-html_03`](./prototype/Szakdolgozat-html_03/)


## Hogyan kezdjük el?

1. Telepítsd a Flutter SDK-t.
2. Klónozd le a repót: `git clone [repo_url]`.
3. Futtasd a `flutter pub get` parancsot a projekt gyökérkönyvtárában.
4. Indítsd el a projektet a `flutter run` parancs segítségével.

