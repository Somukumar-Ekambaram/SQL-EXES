-- 1.  Who is the highest paid C Programmer?

select st.name, p.salary from programmer p
	inner join studies st on st.stud_id = p.stud_id
	inner join dev_in di1 on di1.dev_in_id = p.prof1
	inner join dev_in di2 on di2.dev_in_id = p.prof2 
where (di2.name  = 'C' or di1.name = 'C')
order by p.salary desc limit 1;

-- 2.  Who is the highest paid female COBOL Programmer?

select st.name, p.salary from programmer p
	inner join studies st on st.stud_id = p.stud_id
	inner join dev_in di1 on di1.dev_in_id = p.prof1
	inner join dev_in di2 on di2.dev_in_id = p.prof2
where p.sex = 'F' and (di2.name  = 'COBOL' or di1.name = 'COBOL')
order by p.salary desc limit 1;


-- 3. Display the names of the highest paid programmer for each language (Prof1)

with max_salaries as (
	select p.prof1  as prof1, max(salary) as max_salary from programmer p
	group by p.prof1
) 
select 
	di1.name AS language, 
    st.name AS programmer_name, 
    ms.max_salary
from max_salaries ms
	inner join programmer p on p.prof1 = ms.prof1 and ms.max_salary = p.salary
	inner join dev_in di1 on di1.dev_in_id  = p.prof1
	inner join studies st on st.stud_id = p.stud_id

-- 4. Who is the least experienced programmer?
	
select st.name ,min(timestampdiff(year, p.doj, now())) as least_exp 
	from programmer p
	inner join studies st on st.stud_id = p.stud_id
group by st.name 
order by least_exp 
limit 1;

-- 5. Who is the most experienced programmer?

select st.name ,max(timestampdiff(year, p.doj, now())) as most_exp 
	from programmer p
	inner join studies st on st.stud_id = p.stud_id
group by st.name 
order by most_exp desc
limit 1;

-- 6. Which language is known by only one programmer.

select di.name as language
from dev_in di
inner join (
    select prof1 as dev_in_id from programmer
    union all
    select prof2 as dev_in_id from programmer
) as combined on di.dev_in_id = combined.dev_in_id
group by di.name
having count(combined.dev_in_id) = 1;


-- 7. Who is the above programmer? 
select st.name, max(timestampdiff(year, p.dob, now())) as age from programmer p
	inner join studies st on st.stud_id = p.stud_id
group by st.name
order by age desc 
limit 1;



-- 8. Who is the youngest programmer knowing dBase?
select st.name, min(timestampdiff(year, p.dob, now())) as age from programmer p
	inner join studies st on st.stud_id = p.stud_id
	where p.prof1 in (select dev_in_id from dev_in where name = 'Dbase') or p.prof2 in (select dev_in_id from dev_in where name = 'Dbase')
group by st.name
order by age 
limit 1;

-- 9. Which female programmer earns more than 3000/- but does not know C, C++, Oracle   or Dbase?

select 
	st.name, 
	p.salary, 
	(select name from dev_in where dev_in_id = p.prof1) as prof1, 
	(select name from dev_in where dev_in_id = p.prof2) as prof2 
from programmer p
	inner join studies st on st.stud_id = p.stud_id 
where p.salary >= 3000 and p.sex = 'F' and 
(p.prof1 not in (select dev_in_id from dev_in where name in ('C', 'C++', 'Oracle', 'Dbase')))
and (p.prof2 not in (select dev_in_id from dev_in where name in ('C', 'C++', 'Oracle', 'Dbase')));


-- 10. Which institute has the greatest number of students?

select p.place_name, count(s.name) as greatest from studies s
	inner join place p on p.place_id = s.place_id
group by p.place_name order by greatest desc limit 1;

-- 11. Which course has been done by most of the students?

select c.course_name, count(s.name) as most from studies s
	inner join course c on c.course_id = s.course_id 
group by c.course_name order by most desc limit 1;

-- 12. Display the name of the institute and course which has course fee below average.

select p.place_name, c.course_name, avg(s.course_fee) as avg_course_fee from studies s
	inner join course c on c.course_id = s.course_id 
	inner join place p on p.place_id = s.place_id
group by p.place_name, c.course_name;


-- 13. Which is the costliest course?

select s.name, c.course_name, s.course_fee from studies s
	inner join course c on c.course_id = s.course_id
order by s.course_fee desc limit 1;

-- 14. Which institute conducts the costliest course?

select p.place_name, c.course_name, s.course_fee from studies s
	inner join course c on c.course_id = s.course_id
	inner join place p on p.place_id = s.place_id
order by s.course_fee desc limit 1;

-- 15. Which course has below average number of students?

with coursestudentcounts as (
    select c.course_id, c.course_name as course_name, count(s.stud_id) as num_students
    from course c
    left join studies s on s.course_id = c.course_id
    group by c.course_id, c.course_name
),
averagestudentcount as (
    select avg(num_students) as avg_num_students
    from coursestudentcounts
)
select c.course_name
from coursestudentcounts c
cross join averagestudentcount avg
where c.num_students < avg.avg_num_students;

-- 16.  Which institute conducts the above course? // Same as 14th

select p.place_name, c.course_name, s.course_fee from studies s
	inner join course c on c.course_id = s.course_id
	inner join place p on p.place_id = s.place_id
order by s.course_fee desc limit 1;

-- 17. Display the names of the course whose fees are within 1000 (+ or -) of the average fee.

with AvgFee as (
	select avg(course_fee) as avg_fee from studies
)
select c.course_name, s.course_fee from studies s
	inner join course c on c.course_id = s.course_id 
cross join AvgFee af
where s.course_fee between avg_fee - 1000 and avg_fee + 1000;


-- 18. Which package has the highest development cost?

select title, dev_cost from software where dev_cost = (select max(dev_cost) from software);

-- 19. Which package has the lowest selling cost?

select title, dev_cost from software where dev_cost = (select min(dev_cost) from software);

-- 20. Who developed the package which has sold the least number of copies?

select st.name, s.title, s.sold_qty from software s
	inner join studies st on st.stud_id = s.stud_id 
where s.sold_qty = (select min(sold_qty) from software);
	

-- 21. Which language was used to develop the package which has the highest sales amount?

select di.name, s.title, s.selling_cost from software s
	inner join dev_in di on di.dev_in_id = s.dev_in_id 
where s.selling_cost = (select max(selling_cost) from software);


-- 22.  How many copies of the package that has the least difference between development and selling cost were sold?

with packagecostdifference as (
    select soft_id, abs(dev_cost - selling_cost) as cost_difference
    from software
    order by cost_difference asc
    limit 1
)
select *
from software
where soft_id = (select soft_id from packagecostdifference);

-- 23.  Which is the costliest package developed in Pascal?

with PascalDevPackage as (
	select s.title, di.name, s.dev_cost from software s
		inner join dev_in di on di.dev_in_id = s.dev_in_id 
	where di.name = 'Pascal'
)
select * from PascalDevPackage where dev_cost = (select max(dev_cost) from PascalDevPackage);


-- 24. Which language was used to develop the most number of packages?

select di.name, count(s.title) as package_count from software s
	inner join dev_in di on di.dev_in_id = s.dev_in_id
group by di.name order by package_count desc limit 1;

-- 25.  Which Programmer has developed the highest number of packages?

select st.name, count(s.title) as package_count from software s
	inner join studies st on st.stud_id = s.stud_id
group by st.name order by package_count desc limit 1;

-- 26.  Who is the author of the costliest package?

select st.name, s.title as package_count from software s
	inner join studies st on st.stud_id = s.stud_id
where dev_cost = (select max(dev_cost) from software);

-- 27.  Display the names of packages which have been sold less than the average number of packages.

with average_sold_qty as (
    select avg(sold_qty) as avg_sold_qty
    from software
)
select title
from software
where sold_qty < (select avg_sold_qty from average_sold_qty);

-- 28.  Who are the authors of packages which have recovered more than double the development cost?

select distinct st.name, s.title from software s
	inner join studies st on st.stud_id = s.stud_id 
where s.selling_cost > (s.dev_cost * 2);


-- 29.  Display the programmer names and the cheapest package developed by them in each language?

with minPackages as (
    select di.name as lang, st.name as programmer, s.title as package, s.dev_cost, 
           row_number() over (partition by di.name order by s.dev_cost asc) as rn    
    from software s
    inner join studies st on s.stud_id = st.stud_id 
    inner join dev_in di on s.dev_in_id = di.dev_in_id
)
select lang, programmer, package, dev_cost
from minPackages 
where rn = 1;

-- 30. Display the language used by each programmer to develop the highest selling and lowest selling package.

with highestSelling as (
    select di.name as lang, st.name as programmer, s.title as package, s.selling_cost,
           row_number() over (partition by st.name order by s.selling_cost desc) as rn_highest
    from software s
    inner join studies st on s.stud_id = st.stud_id
    inner join dev_in di on s.dev_in_id = di.dev_in_id
),
lowestSelling as (
    select di.name as lang, st.name as programmer, s.title as package, s.selling_cost,
           row_number() over (partition by st.name order by s.selling_cost asc) as rn_lowest
    from software s
    inner join studies st on s.stud_id = st.stud_id
    inner join dev_in di on s.dev_in_id = di.dev_in_id
)
select
    hs.programmer,
    hs.lang as highest_selling_lang,
    hs.package as highest_selling_package,
    hs.selling_cost as highest_selling_cost,
    ls.lang as lowest_selling_lang,
    ls.package as lowest_selling_package,
    ls.selling_cost as lowest_selling_cost
from
    highestSelling hs
    inner join lowestSelling ls on hs.programmer = ls.programmer
where
    hs.rn_highest = 1 and ls.rn_lowest = 1
order by
    hs.programmer;

-- 31. Who is the youngest male programmer born in 1965?	

select s.name, p.dob from programmer p 
	inner join studies s on s.stud_id = p.stud_id
where year(p.dob) = 1965 and p.sex = 'M'
order by p.dob desc limit 1;


-- 32. Who is the oldest female programmer born 1n 1965?

select s.name, p.dob from programmer p 
	inner join studies s on s.stud_id = p.stud_id
where year(p.dob) = 1965 and p.sex = 'F'
order by p.dob desc limit 1;


-- 33. In which year were the most number of programmers born?

select year(p.dob) as birth_year, count(*) as num_programmers
from programmer p
group by year(p.dob)
order by num_programmers desc
limit 1;


-- 34. In which month did the most number of programmers join?

select month(p.doj) as join_month, count(*) as num_programmers
from programmer p
group by month(p.doj)
order by num_programmers desc
limit 1;

-- 35. In which language are most of the programmers proficient?

with Proficiencies as (
    select di1.name as language, count(*) as proficiency_count
    from programmer p
    	inner join dev_in di1 on di1.dev_in_id = p.prof1
    where p.prof1 is not null
    group by p.prof1
    union all
    select di2.name as language, count(*) as proficiency_count
    from programmer p
    	inner join dev_in di2 on di2.dev_in_id = p.prof2
    where p.prof2 is not null
    group by p.prof2
)
select language, sum(proficiency_count) as total_programmers
from Proficiencies
group by language
order by total_programmers desc
limit 1;

-- 36.  Who are the male programmers earning below the average salary of the female programmers?

with FemaleAvgSalary as (
    select avg(p.salary) as avg_female_salary
    from programmer p
    where p.sex = 'F'
),
MaleBelowAvgFemaleSalary as (
    select *
    from programmer p
    cross join FemaleAvgSalary fas
    where p.sex = 'M' and p.salary < fas.avg_female_salary
)
select *
from MaleBelowAvgFemaleSalary;


-- 37. Who are the female programmers earning more than the highest paid male programmer?

with highestmalesalary as (
    select max(salary) as highest_male_salary
    from programmer
    where sex = 'M'
),
femaleabovemale as (
    select *
    from programmer
    where sex = 'F'
    and salary > (select highest_male_salary from highestmalesalary)
)
select *
from femaleabovemale;

-- 38. Which language has been stated as  prof1  by most of the programmers?

select di.name, count(p.prof1) as most_prof1 from programmer p
	inner join dev_in di on di.dev_in_id = p.prof1
group by di.name 
order by most_prof1 desc
limit 1;
	


