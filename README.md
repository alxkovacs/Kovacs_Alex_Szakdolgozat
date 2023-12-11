# Szakdolgozat

## Címe
- **magyarul**: Multiplatform Mobilalkalmazás Fejlesztése Közösségi Árkövetést Támogató Adatbázissal
- **angolul**: Development of a Multiplatform Mobile Application with Community Price Tracking Database

## Mappaszerkezet

Ez a projekt az MVVM (Model-View-ViewModel) architektúrát használja. Az alábbiakban bemutatom a projekt szerkezetét és annak főbb részeit.

- [`lib/`](application/lib/)
  - [`model/`](application/lib/model/) - Az alkalmazás adatmodelljeit tartalmazó mappa.
  - [`view/`](application/lib/view/) - A felhasználói felület különböző oldalait tartalmazó mappa.
    - [`screens/`](application/lib/view/screens/)
    - [`widgets/`](application/lib/view/widgets/)
  - [`view_model/`](application/lib/view_model/) - Az üzleti logikát kezelő osztályokat tartalmazó mappa.
  - [`service/`](application/lib/service/) - Szolgáltatások, mint az API hozzáférés vagy hitelesítés.
  - [`utils/`](application/lib/utils/) - Segédfunkciók és konstansok.
    - [`styles/`](application/lib/utils/styles/)


## Adatbázis tervek
- [`database/`](./database/) - Az adatbázis terveket tartalmazó mappa.
  - [`Kovacs_Alex_Szakdolgozat_Adatbazis_Oldal.pdf`](./database/Kovacs_Alex_Szakdolgozat_Oldal.png) - Elkészült EK diagram.


## Képernyőtervek
- Moodboard: [`moodboard/`](./moodboard/)
- Prototípus-Képernyőtervek: [`prototype/Szakdolgozat-html_03`](./prototype/Szakdolgozat-html_03/)


## Hogyan kezdjük el?

1. Telepítsd a Flutter SDK-t.
2. Klónozd le a repót: `git clone [repo_url]`.
3. Futtasd a `flutter pub get` parancsot a projekt gyökérkönyvtárában.
4. Indítsd el a projektet a `flutter run` parancs segítségével.