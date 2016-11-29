# ETL
Projekt zaliczeniowy - Hurtownie Danych - wersja iOS
ETL to aplikacja stworzona jako projekt zaliczeniowy z przedmiotu Hurtownie Danych na kierunku Informatyka Stosowana na Uniwersytecie Ekonomicznym w Krakowie. Głównym celem aplikacji jest przeprowadzenie procesu ETL (Extract, Trasform, Load) na danych pobranych z serwisu Ceneo.pl.

## Aplikacji w wersji iOS NIE MOŻNA pobrać ani zainstalować na innym urządzeniu niż urządzenie twórcy - wynika to z kwestii certyfikacyjnych firmy Apple
Oczywiście byłoby to możliwe gdyby twórca miał prywatne opłacone konto developerskie, lecz dla jednej aplikacji ciężko wydać 100$

## Wykorzystane technologie
- aplikacja została napisana na system operacyjny iOS - minimalna wersja systemu to 8.0
- aplikacja została napisana w języku Swift wersja 2.2
- do przetwarzania plików html z danymi o produktach wykorzystana została biblioteka [HTMLReader](https://github.com/nolanw/HTMLReader) w wersji 0.9
- do przechowywania danych lokalnie wykorzystane zostało rozwiązanie [realm.io](https://realm.io/products/swift/) w wersji w najnowszej wersji dla języka Swift 2.2
- do zarządzania połączeniem z serwerem ceneo wykorzystano bibliotekę Alamofire w wersji 3.5.0 (wersja zgodna z Swift 2.2) [Alamofire](https://github.com/Alamofire/Alamofire)
- do uzyskania menu typu dropdown wykorzystano bibliotekę AZDropdownMenu w obecnie najnowszej wersji (wersje nie są oznaczone)[AZDropdownMenu](https://github.com/realm/jazzy)
- do wygenerowania dokumentacji posłużyła biblioteka jazzy 

## Dokumentacja techniczna
[Link do dokumentacji](http://kartwal.ayz.pl/docs/index.html)

## Projekt bazy danych
Ponieważ technologia użyta do przechowywania danych jest obiektowa istnieją dwie klasy reprezentujące obiekty w bazie danych:
- [Product](http://kartwal.ayz.pl/docs/Classes/Product.html) - klasa reprezentująca produkty
- [Review](http://kartwal.ayz.pl/docs/Classes/Review.html) - klasa reprezentująca opinie o produktach
Każdy produkt posiada listę z obiektami typu Review - co odpowiada relacji 1 - &#8734; w relacyjnych bazach danych 

## Instrukcja użytkownika
<!--[Link do instrukcji](https://docs.google.com/presentation/d/1HMFL0xjRb8wYqnbS5GlmsSTnOxsO483PdHdGJ8sx2bM/edit#slide=id.p)-->
