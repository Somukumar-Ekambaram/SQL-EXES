-- 1. Display the details of those who are drawing the same salary.

WITH SalaryDuplicates AS (
SELECT
	salary
FROM
	programmer
GROUP BY
	salary
HAVING
	COUNT(*) > 1
)
SELECT
	s.name,
	p.salary
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
JOIN SalaryDuplicates sd ON
	p.salary = sd.salary
ORDER BY
	p.salary;


-- 2. Display the details of the software developed by the male programmers earning more than 3000.

SELECT
	s.title
FROM
	software s
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN programmer p ON
	p.stud_id = s.stud_id
WHERE
	p.sex = 'M'
	AND p.salary > 3000;

-- 3. Display the details of packages developed in PASCAL by female programmers.

SELECT
	s.title,
	sd.name
FROM
	software s
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
INNER JOIN programmer p ON
	p.stud_id = s.stud_id
WHERE
	p.sex = 'F'
	AND di.name = 'Pascal';

-- 4. Display the details of these programmers who joined before 1990.

SELECT
	s.name,
	p.doj
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	YEAR(p.doj) < 1990;


-- 5.  Display the details of Software developed in C by female programmers of PRAGATHI

SELECT
	*
FROM
	software s
INNER JOIN programmer p ON
	p.stud_id = s.stud_id
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
WHERE
	p.sex = 'F'
	AND di.name = 'C'
	AND pl.name = 'Pragathi';

-- 6. Display the number of packages, number of copies sold and sales value of each programmer institute-wise.

SELECT
	sd.name,
	pl.name,
	COUNT(s.id) AS num_packages,
	SUM(s.sold_qty) AS total_sold_qty,
	SUM(s.sold_qty * s.selling_cost) AS total_sales_value
FROM
	programmer p
INNER JOIN software s ON
	p.stud_id = s.stud_id
INNER JOIN studies sd ON
	sd.id = p.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
GROUP BY
	sd.name,
	pl.name
ORDER BY
	pl.name,
	sd.name;


-- 7. Display the details of software developed in DBase by male programmers who belong to the institute in which the most number of programmers studied.
WITH mostpopularinstitute AS (
SELECT
	pl.name
FROM
	programmer p
INNER JOIN studies sd ON
	sd.id = p.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
GROUP BY
	pl.name
ORDER BY
	COUNT(*) DESC
LIMIT 1
),
softwaredetails AS (
SELECT
	s.title,
	s.dev_cost,
	s.selling_cost,
	s.sold_qty,
	sd.name AS programmer_name,
	p.sex,
	pl.name
FROM
	software s
INNER JOIN programmer p ON
	s.stud_id = p.stud_id
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
INNER JOIN dev_in d ON
	s.dev_in_id = d.id
WHERE
	d.name = 'Dbase'
	AND p.sex = 'M'
	AND pl.name = (
	SELECT
		name
	FROM
		mostpopularinstitute)
)
SELECT
	*
FROM
	softwaredetails;

-- 8. Display the details of software that was developed by male programmers born before 1965 and female programmers born after 1975.

WITH SelectedProgrammers AS (
SELECT
	*
FROM
	programmer p1
WHERE
	YEAR(p1.dob) < 1965
	AND p1.sex = 'M'
UNION
SELECT
	*
FROM
	programmer p2
WHERE
	YEAR(p2.dob) > 1975
	AND p2.sex = 'F'
)
SELECT
	s.title,
	sd.name,
	p.sex
FROM
	programmer p
INNER JOIN software s ON
	s.id = p.stud_id
INNER JOIN SelectedProgrammers sp ON
	sp.stud_id = p.stud_id
INNER JOIN studies sd ON
	sd.id = s.stud_id;

-- 9. Display the details of the software developed by male students of Sabhari

SELECT
	s.title,
	sd.name,
	pl.name
FROM
	software s
INNER JOIN programmer p ON
	p.stud_id = s.stud_id
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
WHERE
	sex = 'M'
	AND pl.name = 'Sabhari';

-- 10. Display the names of programmers who have not developed any package.

SELECT
	st.name
FROM
	studies st
LEFT JOIN software s ON
	st.id = s.stud_id
WHERE
	s.stud_id IS NULL;

-- 11. What is the total cost of the software developed by the programmers of APPLE.

SELECT
	SUM(s.dev_cost) AS total_cost
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
WHERE
	pl.name = 'Apple';


-- 12. Who are the programmers who joined in the same day.

WITH same_day_programmers AS (
SELECT
	p1.stud_id AS stud_id1,
	p2.stud_id AS stud_id2,
	p1.doj
FROM
	programmer p1
JOIN programmer p2 ON
	p1.doj = p2.doj
	AND p1.stud_id <> p2.stud_id
)
SELECT
	s1.name AS programmer1,
	s2.name AS programmer2,
	same_day_programmers.doj
FROM
	same_day_programmers
JOIN studies s1 ON
	same_day_programmers.stud_id1 = s1.id
JOIN studies s2 ON
	same_day_programmers.stud_id2 = s2.id
ORDER BY
	same_day_programmers.doj,
	programmer1,
	programmer2;

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

SELECT
	pl.name,
	SUM(s.selling_cost)
FROM
	software s
INNER JOIN studies sd ON
	sd.id = s.stud_id
INNER JOIN place pl ON
	pl.id = sd.place_id
GROUP BY
	pl.name;

-- 15. In which institute did the person who developed the costliest package study.

SELECT
	pl.name
FROM
	place pl
JOIN (
	SELECT
		s.stud_id,
		p.id
	FROM
		software s
	INNER JOIN studies sd ON
		sd.id = s.stud_id
	INNER JOIN place p ON
		p.id = sd.place_id
	ORDER BY
		s.dev_cost DESC
	LIMIT 1
) AS top_package ON
	pl.id = top_package.id;

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

WITH highest_selling_package AS (
SELECT
	stud_id
FROM
	software
ORDER BY
	selling_cost * sold_qty DESC
LIMIT 1
)
SELECT
	s.name AS student_name,
	c.name AS course_name,
	s.course_fee
FROM
	highest_selling_package hsp
INNER JOIN studies s ON
	s.id = hsp.stud_id
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id
INNER JOIN course c ON
	c.id = sx.course_id;

-- 18. How many months will it take for each programmer to recover the cost of the course underwent.?
	
SELECT
	s.id,
	s.name,
	s.course_fee,
	p.salary AS annual_earnings,
	ROUND(s.course_fee / (p.salary / 12), 2) AS recovery_time_months
FROM
	studies s
INNER JOIN programmer p ON
	s.id = p.stud_id;

-- 19. Which is the costliest package developed by a person with under 3-year experience.

WITH programmer_experience AS (
SELECT
	stud_id,
	doj,
	TIMESTAMPDIFF(YEAR,
	doj,
	CURDATE()) AS experience_years
FROM
	programmer
),
less_than_3_years_experience AS (
SELECT
	stud_id
FROM
	programmer_experience
WHERE
	experience_years < 3
),
costliest_package AS (
SELECT
	s.*
FROM
	software s
JOIN less_than_3_years_experience l ON
	s.stud_id = l.stud_id
ORDER BY
	s.selling_cost DESC
LIMIT 1
)
SELECT
	p.name AS programmer_name,
	cp.title AS package_title,
	cp.selling_cost
FROM
	costliest_package cp
JOIN studies p ON
	cp.stud_id = p.id;

-- 20. What is the average salary for those whose software’s sales value is more than 50,000.

SELECT
	AVG(p.salary)
FROM
	software s
INNER JOIN programmer p ON
	p.stud_id = s.stud_id
WHERE
	s.selling_cost > 50000;

-- 21. How many packages were developed by the students who studied in institute that charge the lowest course fee.

with lowest_fee_institute as (
    select p.id
    from studies s
    	inner join place p on p.id = s.place_id
    order by s.course_fee
    limit 1
),
students_in_lowest_fee_institute as (
    select id
    from studies s
    	inner join place p on p.id = s.place_id
    where s.place_id in (select id from lowest_fee_institute)
),
packages_count as (
    select count(*) as num_packages
    from software
    where stud_id in (select id from students_in_lowest_fee_institute)
)
select num_packages
from packages_count;


-- 22. How many packages were developed by the person who developed the cheapest package. Where did he/she study.

WITH cheapest_package_developer AS (
SELECT
	stud_id
FROM
	software
ORDER BY
	selling_cost
LIMIT 1
),
developer_institute AS (
SELECT
	s.id,
	p.name
FROM
	cheapest_package_developer cpd
JOIN studies s ON
	cpd.stud_id = s.id
JOIN place p ON
	s.place_id = p.id
),
packages_count AS (
SELECT
	COUNT(*) AS num_packages
FROM
	software
WHERE
	stud_id IN (
	SELECT
		stud_id
	FROM
		cheapest_package_developer)
)
SELECT
	di.name,
	pc.num_packages
FROM
	developer_institute di
CROSS JOIN packages_count pc;

-- 23. How many packages were developed by female programmers earning more than highest paid male programmer.

WITH highest_male_earnings AS (
SELECT
	MAX(salary) AS max_earnings
FROM
	programmer
WHERE
	sex = 'M'
),
packages_count AS (
SELECT
	COUNT(*) AS num_packages
FROM
	software s
JOIN programmer p ON
	s.stud_id = p.stud_id
WHERE
	p.sex = 'F'
	AND p.salary > (
	SELECT
		max_earnings
	FROM
		highest_male_earnings)
)
SELECT
	num_packages
FROM
	packages_count;


-- 24. How many packages were developed by the most experienced programmers from BDPS?

WITH most_experienced_bdps_programmers AS (
SELECT
	p.stud_id
FROM
	programmer p
JOIN studies s ON
	p.stud_id = s.id
JOIN place pl ON
	s.place_id = pl.id
WHERE
	pl.name = 'BDPS'
ORDER BY
	TIMESTAMPDIFF(YEAR,
	p.doj,
	CURDATE()) DESC
LIMIT 1
),
packages_count AS (
SELECT
	COUNT(*) AS num_packages
FROM
	software s
WHERE
	s.stud_id IN (
	SELECT
		stud_id
	FROM
		most_experienced_bdps_programmers)
)
SELECT
	num_packages
FROM
	packages_count;


-- 25. List the programmers (from the software table) and the institutes they studied, including those who did not develop any package.

SELECT
	p.stud_id,
	s.name AS programmer_name,
	pl.name,
	COUNT(so.id) AS num_packages
FROM
	studies s
LEFT JOIN programmer p ON
	s.id = p.stud_id
LEFT JOIN software so ON
	s.id = so.stud_id
LEFT JOIN place pl ON
	s.place_id = pl.id
GROUP BY
	p.stud_id,
	s.name,
	pl.name
ORDER BY
	p.stud_id;

-- 26. List the programmer names (from the programmer table) and the number of packages each developed.

SELECT
	st.name,
	COUNT(s.title)
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
INNER JOIN software s ON
	s.stud_id = p.stud_id
GROUP BY
	st.name;

-- 27. Display the details of those who will be completing 2 years of service this year.

SELECT
	s.name
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	YEAR(CURDATE()) - YEAR(doj) = 2
	AND MONTH(CURDATE()) >= MONTH(doj)
	AND DAY(CURDATE()) >= DAY(doj);

-- 28. Calculate the amount to be recovered for those packages whose development cost has not been recovered.

SELECT
	title,
	dev_cost,
	(selling_cost * sold_qty) AS revenue,
	(dev_cost - (selling_cost * sold_qty)) AS amount_to_be_recovered
FROM
	software
WHERE
	(selling_cost * sold_qty) < dev_cost;

-- 29. List the packages which have not been sold so far.

SELECT
	title,
	sold_qty
FROM
	software
WHERE
	sold_qty = 0;

-- 30. Find out the cost of the software developed by Mary.

SELECT
	st.name,
	SUM(s.dev_cost) AS total_dev_cost
FROM
	software s
INNER JOIN studies st ON
	st.id = s.stud_id
WHERE
	st.name = 'Mary'
GROUP BY
	st.name;

-- 31. Display the institutes from the studies table without duplicates.

SELECT
	p.name
FROM
	studies s
JOIN place p ON
	p.id = s.place_id
GROUP BY
	p.name
HAVING
	COUNT(s.place_id) = 1;

-- 32. How many different courses are mentioned in the studies table.

SELECT
	COUNT(DISTINCT sx.course_id) AS different_courses_count
FROM
	studies s
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id;

-- 33. Display the names of programmers whose names contain 2 occurences of the letter A. 

SELECT
	name
FROM
	studies
WHERE
	LENGTH(name) - LENGTH(REPLACE(LOWER(name), 'a', '')) = 2;

-- 34. Display the names of the programmers whose names contain upto 5 characters.

SELECT
	name
FROM
	studies
WHERE
	LENGTH(name) <= 5;

-- 35. How many female programmers knowing COBOL have more than 2 years of experience.

select count(*) as female_cobol_programmers from programmer p
	inner join dev_in di1 on di1.dev_in_id = p.prof1 
	inner join dev_in di2 on di2.dev_in_id = p.prof2 
where p.sex = 'F' and (di1.name = 'COBOL' or di2.name = 'COBOL') and datediff(curdate(), p.doj) > 730;

-- 36. What is the length of the shortest name in the programmer table.

SELECT
	MIN(LENGTH(name)) AS shortest_name_length
FROM
	studies;

-- 37. What is the average development cost of a package developed in COBOL?

SELECT
	AVG(dev_cost)
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
WHERE
	di.name = 'COBOL';

-- 38. Display the name, sex, DOB, (dd/mm/yy), DOJ for all the programmers without using the conversion function.

SELECT
	s.name,
	p.sex,
	DATE_FORMAT(p.dob, '%d/%m/%y') AS dob,
	DATE_FORMAT(p.doj, '%d/%m/%y') AS doj
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id;

-- 39. Who are the programmers who were born on the last day of the month.

SELECT
	s.name,
	p.dob
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	DAY(p.dob) = DAY(LAST_DAY(p.dob));

-- 40. What is the amount paid in salaries of the male programmers who do not know COBOL

SELECT
	SUM(p.salary) AS total_salary_paid
FROM
	programmer p
INNER JOIN programmer_prof_xref px ON
	px.programmer_id = p.id
LEFT JOIN dev_in d1 ON
	px.dev_in_id = d1.id
	AND d1.name = 'COBOL'
WHERE
	p.sex = 'M'
	AND d1.id IS NULL;

-- 41. Display the title, selling_cost, dev_cost and difference between selling_cost and dev_cost in descending order of difference.

SELECT
	title,
	selling_cost,
	dev_cost,
	(selling_cost - dev_cost) AS difference
FROM
	software
ORDER BY
	difference DESC;

-- 42. Display the names of the packages whose names contain more than one word.

SELECT
	title
FROM
	software
WHERE
	INSTR(title, ' ') > 0;

-- 43. Display the name, job, DOB, DOJ of those, month of birth and month of joining are the same.

SELECT
	s.name,
	p.dob,
	p.doj
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	MONTH(p.dob) = MONTH(p.doj);

