-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-- ///
-- TABULKA Č.1 — VÝVOJ MEZD A CEN POTRAVIN V LETECH 2006-2018

-- create or replace view v_salary_merge as
select 	name as industry_branch,
				payroll_year,
				ROUND(avg(cp.value), 1) as salary,
				industry_branch_code
from czechia_payroll as cp 
left join czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
where value_type_code = 5958 and name is not NULL
group by payroll_year, industry_branch_code
order by name, payroll_year;

-- create or replace view v_prices_merge as
select name,
	   ROUND(avg(value), 1) as price,
	   year(date_from) as price_year
from czechia_price cp
left join czechia_price_category cpc on cp.category_code = cpc.code
where region_code is null
group by name, price_year;

-- finální tabulka
create or replace table t_filip_roudny_project_SQL_primary_final
select *
from v_prices_merge tpm 
join v_salary_merge tsm on tpm.price_year = tsm.payroll_year;

-- ///
-- TABULKA Č.2: 

create or replace table t_filip_roudny_project_SQL_secondary_final as 
select e.country,
	   e.year as economy_year,
	   gdp,
	   gini,
	   e.population
from economies e 
join countries c on e.country = c.country 
where year between 2006 and 2018
	  and continent like 'europe'
order by e.country, year;

-- //
-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

create or replace view v_salary_view as
select  industry_branch,
		payroll_year,
		salary,
		LAG(salary) over (partition by industry_branch order by payroll_year) as salary_previous_year,
		case 
			when salary > LAG(salary) over (partition by industry_branch order by payroll_year) then 'higher'
			when LAG(salary) over (partition by industry_branch order by payroll_year) is NULL then 'without_comparison'
			else 'lower'
			end as payroll_rise
from t_filip_roudny_project_sql_primary_final tfrpspf
group by industry_branch, payroll_year;

-- 
select *
from salary_view sv 
where salary_previous_year > salary; -- and payroll_year = 2013;

-- V dostupné tabulce vidíme, že ne ve všech odvětvích mzdy každoročně rostou — bylo nalezeno 23 případů, kdy mzdy napřesrok klesaly. 
-- Nicméně je zde důležité zmínit, že 11 z 23 zjištěných poklesů bylo v roce 2013, což měla na svědomí tzv. 'Velká recese'.
-- Zdroj: https://csu.gov.cz/2013-_ekonomika_a_kvalita_zivota
-- PS.: Poklesů bylo dohromady 30, nicméně v jiných letech, než ve společném porovnatelném období cen kategorie potravin a mezd v odvětvích
-- (přesněji v letech 2020 — Ubytování, stravování a pohostinství; Činnosti v oblasti nemovitostí 
--                  a 2021 — Stavebnictví; Veřejná správa a obrana, povinné sociální zabezpečení; Vzdělávání; Zemědělství, lesnictví, rybářství; Kulturní, zábavní a rekreační činnosti)

select  industry_branch,
		payroll_year,
		salary,
		LAG(salary) over (partition by industry_branch order by payroll_year) as salary_previous_year,
		case 
			when salary > LAG(salary) over (partition by industry_branch order by payroll_year) then 'higher'
			when LAG(salary) over (partition by industry_branch order by payroll_year) is NULL then 'base_salary'
			else 'lower' end as payroll_rise
from t_filip_roudny_project_sql_primary_final tfrpspf
where payroll_year in (2006, 2018)
group by industry_branch, payroll_year;

-- Doplňující tabulka znázorňující, že od roku 2006 do roku 2018 vzrostly mzdy ve všech odvětvích.

-- //
-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
select  industry_branch,
		payroll_year,
		salary,
		name,
		price,
		ROUND(salary/price, 0) as buying_power
from t_filip_roudny_project_sql_primary_final tfrpspf 
where name in ('Chléb konzumní kmínový', 'Mléko polotučné pasterované') 
	  and payroll_year in (2006, 2018)
order by name, payroll_year asc;

-- V tabulce vidíme ve sloupci 'bying_power', kolik litrů mléka a kilogramů chleba bylo možné pořídit za mzdu v daném odvětví a daném roce.
-- (z tabulky czechia_price_category víme, že mléko je v základní ceně za litr a chléb za kilogram, proto mi přišlo nadbytečné přidávat dva další sloupce na jednotky a počet jednotek)

select 	name, 
		payroll_year,
		price,
		ROUND(avg(salary), 2) as avg_salary,
		ROUND(avg(salary)/price, 0) as buying_power
from t_filip_roudny_project_sql_primary_final tfrpspf 
where name in ('Chléb konzumní kmínový', 'Mléko polotučné pasterované') 
	  and payroll_year in (2006, 2018)
group by name, payroll_year;

-- V této tabulce vidíme, kolik litrů mléka a kilogramů chleba bylo možnos pořídit v roce 2006 a 2018 za průměrnou mzdu ve všech odvětvích.

-- //
-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

select name,
	   payroll_year,
	   price,
	   LAG(price) over (partition by name order by payroll_year) as price_previous_year
from t_filip_roudny_project_sql_primary_final tfrpspf 
group by name, payroll_year
order by name;

create or replace view v_price_development as
with prices_with_previous_year as 
		(select name,
	   			payroll_year,
	  			price,
	  			LAG(price) over (partition by name order by payroll_year) as price_previous_year
from t_filip_roudny_project_sql_primary_final tfrpspf 
group by name, payroll_year
order by name)
select name,
	   payroll_year,
	   price,
	   price_previous_year,
	   ROUND((price/price_previous_year)*100-100, 2) as price_development
from prices_with_previous_year
where price_previous_year is not null
group by name, payroll_year;

-- 
select name,
       ROUND(AVG(price_development), 2) as avg_price_development
from v_price_development vpd 
group by name
order by avg_price_development;

-- V této tabulce vidíme, že nejnižší průměrný percentuální meziroční nárůst (nebo spíš pokles) ceny má kategorie 'Cukr krystalový'.
-- Nicméně je důležité poznamenat, že tento způsob výpočtu počítá s každým meziročním nárůstem/poklesem ceny oproti předchozímu roku,
-- neodvíjí se tedy od ceny v prvním pevném bodu (rok 2006) vzhledem k ceně v posledním pevném bodu (rok 2018).
-- Pokud by nás zajímal průměrný nárůst od 2006 do 2018 bez počítání každé meziroční ceny, byl by nejmenší procentuální nárůst(největší pokles) u kategorie 'Cukr krystalový', který klesal o 1,94% ročně 
-- ('Rajská jablka červená' by v tomto případě byla na druhém místě s klesáním o 1,64% ročně) :

create or replace view v_price_comparison_2008_2016 as
select name,
	   payroll_year,
	   price as price_2018,
	   LAG(price) over (partition by name order by payroll_year) as price_2006
from t_filip_roudny_project_sql_primary_final tfrpspf 
where payroll_year in (2006, 2018)
group by name, payroll_year
order by name;

-- 
-- create or replace view v_price_comparison_yearly as
select name,
	   price_2018,
	   price_2006,
	   CONCAT(ROUND(((price_2018/price_2006)*100 - 100), 2), ' %') as price_diff,
	   CONCAT(ROUND(((price_2018/price_2006)*100 - 100)/14, 2), ' %') as price_diff_yearly
from v_price_comparison_2008_2016 vpc 
where price_2006 is not null
order by price_diff_yearly;

-- Zde ale nepočítám s kategorií 'Jakostní víno bílé', vzhledem k tomu, že pro ni není dostatek dat pro férové hodnocení vzhledem k ostatním kategoriím.

-- //
-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

create or replace view v_salary_comparison as
select payroll_year,
	   AVG(salary),
	   AVG(salary_previous_year),
	   CONCAT(ROUND(((AVG(salary)/AVG(salary_previous_year))*100-100), 2), ' %') as salary_diff
from v_salary_view sv 
where salary_previous_year is not null
group by payroll_year;

-- 

create or replace view v_price_comparison as
select vpd.payroll_year as payroll_year_prices,
	   AVG(price) as avg_price,
	   AVG(price_previous_year) as avg_price_previous_year,
	   CONCAT(ROUND(((AVG(price)/AVG(price_previous_year))*100-100),2), ' %') as price_diff
from v_price_development vpd 
group by vpd.payroll_year;
-- 

select payroll_year,
	   price_diff,
	   salary_diff,
	   price_diff-salary_diff as price_and_salary_diff
from v_price_comparison vpc 
join v_salary_comparison vsc on vpc.payroll_year_prices = vsc.payroll_year;

-- Z tabulky lze vyčíst, že neexistuje rok, kdy by byl meziroční nárůst cen potravin výrazně vyšší (více než 10%) než nárůst mezd. Nicméně stojí znovu za zmínku rok 2013,
-- kdy byl rozdíl mezi ročním navýšením cen potravin a  meziročním navýšením mezd 6,66% (kdy potraviny zdražily o 5,1% a mzdy klesly o 1,56%). 
-- Naopak "nejúspěšnějším" rokem byl rok 2009, kdy mzdy vzrostly o 3,16% a ceny potravin klesly o 6,41%. 

-- // 
-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--    projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

create or replace view v_gdp_with_previous_year as
select economy_year,
	   country,
	   gdp,
	   LAG(gdp) over (partition by country order by economy_year) as gdp_previous_year
from t_filip_roudny_project_sql_secondary_final tfrpssf
where country like 'czech republic'
order by economy_year ;

-- 
with gdp_with_previous_year as 
		(select economy_year,
	   			country,
	  			gdp,
	   			LAG(gdp) over (partition by country order by economy_year) as gdp_previous_year
		 from t_filip_roudny_project_sql_secondary_final tfrpssf
		 where country like 'czech republic'
		 order by economy_year)
select country,
	   economy_year,
	   gdp,
	   gdp_previous_year,
	   ROUND((gdp/gdp_previous_year)*100-100, 2) as gdp_development
from gdp_with_previous_year
where gdp_previous_year is not null;

-- 
create or replace view v_gdp_development as
select country,
	   economy_year,
	   gdp,
	   gdp_previous_year,
	   ROUND((gdp/gdp_previous_year)*100-100, 2) as gdp_development
from v_gdp_with_previous_year
where gdp_previous_year is not null
      and country like 'czech republic';

-- 
select payroll_year,
	   price_diff,
	   salary_diff,
	   gdp_development,
	   price_diff-salary_diff as price_and_salary_diff
from v_price_comparison vpc 
join v_salary_comparison vsc on vpc.payroll_year_prices = vsc.payroll_year
join v_gdp_development vgd on vpc.payroll_year_prices = vgd.economy_year
where country like 'czech republic'; 

-- Z dostupných dat nelze s jistotou vyvrátit ani potvrdit hypotézu, že by měl růst HDP vliv na změny ve mzdách či mzdách ve stejném nebo následujícím roce.
-- 
