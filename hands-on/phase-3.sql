-- 1. Display the details of those who are drawing the same salary.

with SalaryDuplicates as (
    select salary
    from programmer
    group by salary
    having count(*) > 1
)
select s.name, p.salary from programmer p
	inner join studies s on s.stud_id = p.stud_id
	join SalaryDuplicates sd on p.salary = sd.salary
order by p.salary;

-- 2. Display the details of the software developed by the male programmers earning more than 3000.

select s.title from software s
	inner join studies sd on sd.stud_id = s.stud_id 
	inner join programmer p on p.stud_id = s.stud_id
where p.sex = 'M' and p.salary > 3000;


-- 3. Display the details of packages developed in PASCAL by female programmers.

select s.title, sd.name from software s
	inner join studies sd on sd.stud_id = s.stud_id 
	inner join dev_in di on di.dev_in_id = s.dev_in_id 
	inner join programmer p on p.stud_id = s.stud_id
where p.sex = 'F' and di.name = 'Pascal';


-- 4. Display the details of these programmers who joined before 1990.

select s.name, p.doj from programmer p
	inner join studies s on s.stud_id = p.stud_id	
where year(p.doj) < 1990;


-- 5.  Display the details of Software developed in C by female programmers of PRAGATHI

select * from software s
	inner join programmer p on p.stud_id = s.stud_id
	inner join studies sd on sd.stud_id = s.stud_id 
	inner join place pl on pl.place_id = sd.place_id
	inner join dev_in di on di.dev_in_id = s.dev_in_id
where p.sex = 'F' and di.name = 'C' and pl.place_name = 'Pragathi'; 


-- 6. Display the number of packages, number of copies sold and sales value of each programmer institute-wise.

select sd.name, pl.place_name, 
       count(s.soft_id) as num_packages,
       sum(s.sold_qty) as total_sold_qty,
       sum(s.sold_qty * s.selling_cost) as total_sales_value
from programmer p
	inner join software s on p.stud_id = s.stud_id
	inner join studies sd on sd.stud_id = p.stud_id
	inner join place pl on pl.place_id = sd.place_id
group by sd.name, pl.place_name
order by pl.place_name, sd.name;

-- 7. Display the details of software developed in DBase by male programmers who belong to the institute in which the most number of programmers studied.

with mostpopularinstitute as (
    select pl.place_name
    from programmer p
    	inner join studies sd on sd.stud_id = p.stud_id
    	inner join place pl on pl.place_id = sd.place_id
    group by pl.place_name
    order by count(*) desc
    limit 1
),
softwaredetails as (
    select s.title, s.dev_cost, s.selling_cost, s.sold_qty, sd.name as programmer_name, p.sex, pl.place_name
    from software s
    inner join programmer p on s.stud_id = p.stud_id
    inner join studies sd on sd.stud_id = s.stud_id
    inner join place pl on pl.place_id = sd.place_id
    inner join dev_in d on s.dev_in_id = d.dev_in_id
    where d.name = 'Dbase'
    and p.sex = 'M'
    and pl.place_name = (select place_name from mostpopularinstitute)
)
select *
from softwaredetails;


-- 8. Display the details of software that was developed by male programmers born before 1965 and female programmers born after 1975.

with SelectedProgrammers as (
    select * from programmer p1 where year(p1.dob) < 1965 and p1.sex = 'M'
    union
    select * from programmer p2 where year(p2.dob) > 1975 and p2.sex = 'F'
)
select s.title, sd.name, p.sex from  programmer p
	inner join software s on s.soft_id = p.stud_id 
	inner join SelectedProgrammers sp on sp.stud_id = p.stud_id
	inner join studies sd on sd.stud_id = s.stud_id;


-- 9. Display the details of the software developed by male students of Sabhari

select s.title, sd.name, pl.place_name from software s
	inner join programmer p on p.stud_id = s.stud_id
	inner join studies sd on sd.stud_id = s.stud_id 
	inner join place pl on pl.place_id = sd.place_id
where sex = 'M' and pl.place_name = 'Sabhari';


-- 10. Display the names of programmers who have not developed any package.

select st.name from studies st
	left join software s on st.stud_id = s.stud_id
where s.stud_id is null;

-- 11. What is the total cost of the software developed by the programmers of APPLE.

select sum(s.dev_cost) as total_cost from software s
	inner join dev_in di on di.dev_in_id = s.dev_in_id
	inner join studies sd on sd.stud_id = s.stud_id
	inner join place pl on pl.place_id = sd.place_id
where pl.place_name = 'Apple';


-- 12. Who are the programmers who joined in the same day.

with same_day_programmers as (
    select p1.stud_id as stud_id1, p2.stud_id as stud_id2, p1.doj
    from programmer p1
    join programmer p2 on p1.doj = p2.doj and p1.stud_id <> p2.stud_id
)
select 
	s1.name as programmer1, 
	s2.name as programmer2, 
	same_day_programmers.doj
from same_day_programmers
	join studies s1 on same_day_programmers.stud_id1 = s1.stud_id
	join studies s2 on same_day_programmers.stud_id2 = s2.stud_id
order by same_day_programmers.doj, programmer1, programmer2;

-- 13. Who are the programmers who have the same prof2.

with same_prof2_programmers as (
    select p1.stud_id as stud_id1, p2.stud_id as stud_id2, p1.prof2
    from programmer p1
    join programmer p2 on p1.prof2 = p2.prof2 and p1.programmer_id <> p2.programmer_id
)
select s1.name as programmer1, s2.name as programmer2, same_prof2_programmers.prof2
from same_prof2_programmers
	join studies s1 on same_prof2_programmers.stud_id1 = s1.stud_id
	join studies s2 on same_prof2_programmers.stud_id2 = s2.stud_id
order by same_prof2_programmers.prof2, programmer1, programmer2;

-- 14. Display the total sales value of software, institute-wise.

select pl.place_name, sum(s.selling_cost) from software s
	inner join studies sd on sd.stud_id = s.stud_id 
	inner join place pl on pl.place_id = sd.place_id
group by pl.place_name;

-- 15. In which institute did the person who developed the costliest package study.

select pl.place_name from place pl
join (
	select s.stud_id, p.place_id from software s 
		inner join studies sd on sd.stud_id = s.stud_id
		inner join place p on p.place_id = sd.place_id 
	order by s.dev_cost desc limit 1
) as top_package on pl.place_id = top_package.place_id;

-- 16. Which language listed in Prof1 and Prof2 has not been used to develop any package.

with all_languages as (
    select distinct prof1 as language from programmer
    union
    select distinct prof2 as language from programmer
),
used_languages as (
    select distinct prof1 as language from programmer p
    join software s on p.stud_id = s.stud_id
    union
    select distinct prof2 as language from programmer p
    join software s on p.stud_id = s.stud_id
)
select di.name from all_languages al
	inner join dev_in di on di.dev_in_id = al.language
where language not in (select language from used_languages);


-- 17. How much does the person who developed the highest selling package earn, and what course did he/she undergo.

with highest_selling_package as (
    select stud_id
    from software
    order by selling_cost * sold_qty desc
    limit 1
)
select s.name, c.course_name, s.course_fee from highest_selling_package hsp
	inner join studies s on s.stud_id = hsp.stud_id
	inner join course c on c.course_id = s.course_id

-- 18. How many months will it take for each programmer to recover the cost of the course underwent.?
	
select
    s.stud_id,
    s.name,
    s.course_fee,
    p.salary as annual_earnings,
    round(s.course_fee / (p.salary / 12), 2) as recovery_time_months
from
    studies s
inner join programmer p on s.stud_id = p.stud_id;

-- 19. Which is the costliest package developed by a person with under 3-year experience.

with programmer_experience as (
    select 
        stud_id,
        doj,
        timestampdiff(year, doj, curdate()) as experience_years
    from programmer
),
less_than_3_years_experience as (
    select stud_id
    from programmer_experience
    where experience_years < 3
),
costliest_package as (
    select s.*
    from software s
    join less_than_3_years_experience l on s.stud_id = l.stud_id
    order by s.selling_cost desc
    limit 1
)
select p.name as programmer_name, cp.title as package_title, cp.selling_cost
from costliest_package cp
join studies p on cp.stud_id = p.stud_id;

-- 20. What is the average salary for those whose software’s sales value is more than 50,000.

select avg(p.salary) from software s
	inner join programmer p on p.stud_id = s.stud_id
where s.selling_cost > 50000;

-- 21. How many packages were developed by the students who studied in institute that charge the lowest course fee.

with lowest_fee_institute as (
    select p.place_id
    from studies s
    	inner join place p on p.place_id = s.place_id
    order by s.course_fee
    limit 1
),
students_in_lowest_fee_institute as (
    select stud_id
    from studies s
    	inner join place p on p.place_id = s.place_id
    where s.place_id in (select place_id from lowest_fee_institute)
),
packages_count as (
    select count(*) as num_packages
    from software
    where stud_id in (select stud_id from students_in_lowest_fee_institute)
)
select num_packages
from packages_count;


-- 22. How many packages were developed by the person who developed the cheapest package. Where did he/she study.

with cheapest_package_developer as (
    select stud_id
    from software
    order by selling_cost
    limit 1
),
developer_institute as (
    select s.stud_id, p.place_name from cheapest_package_developer cpd
    	join studies s on cpd.stud_id = s.stud_id
    	join place p on s.place_id = p.place_id
),
packages_count as (
    select count(*) as num_packages
    from software
    where stud_id in (select stud_id from cheapest_package_developer)
)
select di.place_name, pc.num_packages
from developer_institute di
cross join packages_count pc;

-- 23. How many packages were developed by female programmers earning more than highest paid male programmer.

with highest_male_earnings as (
    select max(salary) as max_earnings
    from programmer
    where sex = 'M'
),
packages_count as (
    select count(*) as num_packages
    from software s
    	join programmer p on s.stud_id = p.stud_id
    	where p.sex = 'F' and p.salary > (select max_earnings from highest_male_earnings)
)
select num_packages from packages_count;

-- 24. How many packages were developed by the most experienced programmers from BDPS?

with most_experienced_bdps_programmers as (
    select p.stud_id from programmer p
	    join studies s on p.stud_id = s.stud_id
		join place pl on s.place_id = pl.place_id
    where pl.place_name = 'BDPS'
    order by timestampdiff(year, p.doj, curdate()) desc
    limit 1
),
packages_count as (
    select count(*) as num_packages
    from software s
    where s.stud_id in (select stud_id from most_experienced_bdps_programmers)
)
select num_packages from packages_count;

-- 25. List the programmers (from the software table) and the institutes they studied, including those who did not develop any package.

select p.stud_id, s.name as programmer_name, pl.place_name, count(so.soft_id) as num_packages
from studies s
left join programmer p on s.stud_id = p.stud_id
left join software so on s.stud_id = so.stud_id
left join place pl on s.place_id = pl.place_id
group by p.stud_id, s.name, pl.place_name
order by p.stud_id;

-- 26. List the programmer names (from the programmer table) and the number of packages each developed.

select st.name, count(s.title) from programmer p
	inner join studies st on st.stud_id = p.stud_id
	inner join software s on s.stud_id = p.stud_id
group by st.name;

-- 27. Display the details of those who will be completing 2 years of service this year.

select s.name from programmer p
	inner join studies s on s.stud_id = p.stud_id 
where year(curdate()) - year(doj) = 2 and month(curdate()) >= month(doj)
	and day(curdate()) >= day(doj);

-- 28. Calculate the amount to be recovered for those packages whose development cost has not been recovered.

select title, dev_cost, (selling_cost* sold_qty) as revenue,
	(dev_cost - (selling_cost * sold_qty)) as amount_to_be_recovered
from software 
	where (selling_cost * sold_qty) < dev_cost;

-- 29. List the packages which have not been sold so far.

select title, sold_qty from software where sold_qty = 0;

-- 30. Find out the cost of the software developed by Mary.

select st.name, sum(s.dev_cost) as total_dev_cost from software s
	inner join studies st on st.stud_id = s.stud_id
where st.name = 'Mary';

-- 31. Display the institutes from the studies table without duplicates.

select p.place_name from studies s
	join place p on p.place_id = s.place_id
group by p.place_name
having count(s.place_id) = 1;

-- 32. How many different courses are mentioned in the studies table.

select count(distinct course_id) as different_courses_count from studies;

-- 33. Display the names of programmers whose names contain 2 occurences of the letter A. 

select name from studies where length(name) - length(replace(lower(name), 'a', '')) = 2;

-- 34. Display the names of the programmers whose names contain upto 5 characters.

select name from studies where length(name) <= 5;

-- 35. How many female programmers knowing COBOL have more than 2 years of experience.

select count(*) as female_cobol_programmers from programmer p
	inner join dev_in di1 on di1.dev_in_id = p.prof1 
	inner join dev_in di2 on di2.dev_in_id = p.prof2 
where p.sex = 'F' and (di1.name = 'COBOL' or di2.name = 'COBOL') and datediff(curdate(), p.doj) > 730;

-- 36. What is the length of the shortest name in the programmer table.

select min(length(name)) AS shortest_name_length from studies;

-- 37. What is the average development cost of a package developed in COBOL?

select avg(dev_cost) from software s
	inner join dev_in di on di.dev_in_id = s.dev_in_id
where di.name = 'COBOL';

-- 38. Display the name, sex, DOB, (dd/mm/yy), DOJ for all the programmers without using the conversion function.

select s.name, p.sex, date_format(p.dob, '%d/%m/%y') as dob, date_format(p.doj, '%d/%m/%y') as doj from programmer p
	inner join studies s on s.stud_id = p.stud_id;

-- 39. Who are the programmers who were born on the last day of the month.

select s.name, p.dob from programmer p
	inner join studies s on s.stud_id = p.stud_id 
where day(p.dob) = day(last_day(dob));

-- 40. What is the amount paid in salaries of the male programmers who do not know COBOL

select sum(p.salary) as total_salary_paid
from programmer p
left join dev_in d1 on p.prof1 = d1.dev_in_id and d1.name = 'COBOL'
left join dev_in d2 on p.prof2 = d2.dev_in_id and d2.name = 'COBOL'
where p.sex = 'M'
  and d1.dev_in_id is null
  and d2.dev_in_id is null;

-- 41. Display the title, selling_cost, dev_cost and difference between selling_cost and dev_cost in descending order of difference.

select title, selling_cost, dev_cost, (selling_cost - dev_cost) as difference from software order by difference desc;

-- 42. Display the names of the packages whose names contain more than one word.

select title from software where instr(title, ' ') > 0;

-- 43. Display the name, job, DOB, DOJ of those, month of birth and month of joining are the same.

select s.name, p.dob, p.doj from programmer p 
	inner join studies s on s.stud_id = p.stud_id 
where month(p.dob) = month(p.doj);
