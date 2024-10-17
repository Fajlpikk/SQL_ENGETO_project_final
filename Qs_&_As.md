# Výzkumné otázky

## 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

- Z dostupných dat bylo zjištěno, že ne ve všech odvětvích v období od roku 2006 do roku 2018 mzdy každoročně rostou — bylo nalezeno 23 případů, kdy mzdy napřesrok klesaly. Nicméně je zde důležité zmínit, že 11 z 23 zjištěných poklesů bylo v roce 2013, což měla na svědomí tzv. 'Velká recese'. 
(Zdroj: https://csu.gov.cz/2013-_ekonomika_a_kvalita_zivota)
- Dovolím si zde doplnit, že meziročních poklesů bylo v dostupných datech více, tedy přesně 30. K dalším poklesům došlo v roce 2020, kdy byl zaznamenán meziroční pokles v odvětvích **"Ubytování, stravování a pohostinství"**, **"Činnosti v oblasti nemovitostí"**, 
  a v roce 2021, kdy pokles zaznamela odvětví **"Stavebnictví"**, **"Veřejná správa a obrana, povinné sociální zabezpečení"**, **"Vzdělávání"**, **"Zemědělství, lesnictví, rybářství"** a **"Kulturní, zábavní a rekreační činnosti"**.
- Moji konečnou odpovědí je, že mzdy ve všech odvětvích od roku 2006 do roku 2018 **zřejmě rostly**, v některých odvětvích ale nerostly každým rokem.

## 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

- U této otázky se nabízí dvě různé možnosti odpovědi. Pokud nás zajímá, kolik litrů mléka a kilogramů chleba bylo možné koupit za průměrnou mzdu v roce 2006 a v roce 2018, tak je odpověď jednoduchá — V roce 2006 bylo možné koupit za průměrnou mzdu **1289 kilogramů** chleba a **1441** litrů mléka,
  zatímco v roce 2018 bychom koupili za průměrnou mzdu **1344 kilogramů** chleba a **1643 litrů** mléka.
- Pokud nás ale zajímá, kolik litrů mléka a kilogramů chleba si mohl v roce 2006 a 2018 dovolit člověk pracující v námi vybraném odvětví, tak bych si dovolil odkázat na řádek č.: 95  přiloženého SQL souboru, jelikož tabulka odpovídající na tuto otázku má 76 řádků.

## 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

- **Banány žluté** jsou kategorie, která v námi vybraném období (od roku 2006 do roku 2018) zdražuje nejpomaleji, a to s celkovým nárůstem o 7,33%, meziročním nárůstem potom 0,52%. Zde je ale důležité zmínit, že se v dostupných datech vyskytly i dvě kategorie potravin, které zaznamenaly od roku
  2006 do roku 2018 pokles, a těmi jsou **"Cukr krystalový"** s celkovým poklesem 27,19% (s meziročním poklesem potom 1,94%)  a **"Rajská jablka červená kulata"** s celkovým poklesem 23,01% (s meziročním poklesem potom 1,64%).
- Zde ale nepočítám s kategorií "Jakostní víno bílé", vzhledem k tomu, že pro ni není dostatek dat pro férové hodnocení vzhledem k ostatním kategoriím.
- (Pokud by nás u této otázky zajímal nejnižší průměrný percentuální meziroční nárůst ceny vzhledem k ceně v předchozím roku, byla by odpověď stejná, nicméně by se lišily procenta nárůstu/poklesu — viz přiložený SQL soubor řádek č.: )

## 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

- **Ne**, v dostupnýách datech neexistuje rok, ve kterém by byl meziroční nárůst cen potravin vyšší než 10% oproti meziročnímu růstu mezd.
- Nicméně stojí znovu za zmínku rok 2013, kdy byl rozdíl mezi ročním navýšením cen potravin a meziročním navýšením mezd 6,66% (kdy potraviny zdražily o 5,1% a mzdy klesly o 1,56%). 
- Naopak "nejúspěšnějším" rokem byl rok 2009, kdy mzdy vzrostly o 3,16% a ceny potravin klesly o 6,41%.

##  5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

- Nemyslím si, že by dostupná data mohla s jistotou potvrdit hypotézu.
- **Návaznost cen na výrazný růst HDP:**
       V roce 2007 vzrostl HDP o 5,57% (nejvyšší nárůst HDP ve sledovaném odvětví), ceny v tomtéž roce vzrostly o 6,77%. V následujícím roce se opět ceny zvýšily, a to o 6,21%.
       Z vývoje cen a HDP v roce 2007 a 2008 bychom tedy mohli usuzovat, že pokud výrazně vzroste HDP, promítne se to negativně na cenách potravin — tedy ceny potravin vzrostou.
       To ale vyvrací rok 2015, kdy HDP vzrostl o 5,39% (druhý nejvyšší nárůst HDP ve sledovaném odvětví), zatímco ceny klesly o 2,9% a následujícím rokem klesly ceny znovu a to o 1,18%.

- **Návaznost růstu mezd na výrazný růst HDP:**
       V roce 2007 vzrostl HDP o 5,57% (nejvyšší nárůst HDP ve sledovaném odvětví), mzdy v tomtéž roce vzrostly o 6,84%. V následujícím roce se opět mzdy zvýšily, a to o 7,87%.
       To znovu navádí k myšlence, že pokud výrazně vzroste HDP, tak bude možné sledovat i výrazný nárůst průměrných mezd.
       Což znovu částečně vyvrací rok 2015, kdy HDP vzrostl o 5,39% (druhý nejvyšší nárůst HDP ve sledovaném odvětví), ale mzdy narostly pouze o 2,51% a napřesrok o 3,65% — tudíž nárůst mezd nebyl tak výrazný.
