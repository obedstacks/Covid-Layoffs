-- exploratory data, working with the laid off section more than the percentage

select * from layoffs_stagging2;

select max(total_laid_off), max(percentage_laid_off) from layoffs_stagging2;

select * from layoffs_stagging2
where percentage_laid_off = 1 -- the total workplace was laid off
order by funds_raised_millions desc;

select company, sum(total_laid_off) from layoffs_stagging2
group by company
order by 2 desc;

-- when did the laying off star?

select min(`date`), max(`date`) from layoffs_stagging2;

-- what industry got hit the most? and which coutry or year was also hit hard

select industry, sum(total_laid_off) from layoffs_stagging2
group by industry
order by 2 desc;

select country, sum(total_laid_off) from layoffs_stagging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off) from layoffs_stagging2
group by year(`date`)
order by 1 desc;

-- rolling total of layoffs by month

select substring(`date`, 1, 7) as `MONTH`, sum(total_laid_off) -- this takes the month from the date 1th position in the date and then takes 7 values from that position
from layoffs_stagging2
where substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 asc; 

-- doing the rolling sum

select * from layoffs_stagging2;

with rolling_total as (

select substring(`date`, 1, 7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_stagging2
where substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 asc 
)

select `MONTH`, total_off, sum(total_off) over(order by `MONTH`) as Rolling 
from rolling_total; 
 
-- looking now at companies to determine how much they were laying off per year

select company,year(`date`), sum(total_laid_off) from layoffs_stagging2
group by company, year(`date`) 
order by 3 desc ; 

with company_year  (companies, years, total_laid_off) as (

select company, year(`date`), sum(total_laid_off) 
from layoffs_stagging2
group by company, year(`date`) 

),

company_year_rank as (

select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
 from company_year 
 where years is not null 
 order by ranking
 -- what the code above does is it ranks based on the years the total laid off by heighest to lowest doing individual max laid offs 
 )
 
 select * from company_year_rank
 where ranking <= 5; -- it only shows the top 5 rankings















