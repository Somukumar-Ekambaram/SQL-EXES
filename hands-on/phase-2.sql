-- 1.  Who is the highest paid C Programmer?

SELECT
	st.name,
	p.salary
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
INNER JOIN programmer_prof_xref pp ON
	pp.programmer_id = p.id
INNER JOIN dev_in di ON
	di.id = pp.dev_in_id
WHERE
	di.name = 'C'
ORDER BY
	p.salary DESC
LIMIT 1;


-- 2.  Who is the highest paid female COBOL Programmer?

SELECT
	st.name,
	p.salary
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
INNER JOIN programmer_prof_xref pp ON
	pp.programmer_id = p.id
INNER JOIN dev_in di ON
	di.id = pp.dev_in_id
WHERE
	p.sex = 'F'
	AND di.name = 'COBOL'
ORDER BY
	p.salary DESC
LIMIT 1;



-- 3. Display the names of the highest paid programmer for each language (Prof1)

WITH ranked_prof1 AS (
    SELECT id, programmer_id, dev_in_id, 
           ROW_NUMBER() OVER (PARTITION BY programmer_id ORDER BY id) AS row_num 
    FROM programmer_prof_xref 
),
salary_ranked AS (
    SELECT rn.dev_in_id, p.id, p.stud_id, p.salary,
           RANK() OVER (PARTITION BY rn.dev_in_id ORDER BY p.salary DESC) AS salary_rank
    FROM ranked_prof1 rn
    INNER JOIN programmer p ON p.id = rn.programmer_id
    WHERE rn.row_num = 1
)
SELECT s.name, d.name, sr.salary FROM salary_ranked sr
inner join studies s on s.id = sr.stud_id
inner join dev_in d on d.id = sr.dev_in_id
WHERE salary_rank = 1
ORDER BY d.name;


-- 4. Who is the least experienced programmer?
	
SELECT
	st.name,
	TIMESTAMPDIFF(YEAR,
	p.doj,
	CURDATE()) AS least_exp
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
ORDER BY
	least_exp ASC
LIMIT 1;


-- 5. Who is the most experienced programmer?

SELECT
	st.name,
	TIMESTAMPDIFF(YEAR,
	p.doj,
	CURDATE()) AS most_exp
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
ORDER BY
	most_exp DESC
LIMIT 1;


-- 6. Which language is known by only one programmer.

SELECT
	di.name AS language
FROM
	dev_in di
INNER JOIN (
	SELECT
		pp.dev_in_id
	FROM
		programmer_prof_xref pp
	GROUP BY
		pp.dev_in_id
	HAVING
		COUNT(pp.programmer_id) = 1
) unique_languages ON
	di.id = unique_languages.dev_in_id;

-- Alter solution of above

select 
	d.name 
from 
	programmer_prof_xref px
inner join dev_in d on d.id = px.dev_in_id 
group by 
	px.dev_in_id
having 
	count(px.programmer_id) = 1;


-- 7. Who is the above programmer? 

WITH SingleDev AS (
    SELECT dev_in_id 
    FROM programmer_prof_xref
    GROUP BY dev_in_id
    HAVING COUNT(*) = 1
)
SELECT s.name FROM programmer_prof_xref px
INNER JOIN SingleDev sd ON px.dev_in_id = sd.dev_in_id
INNER JOIN programmer p ON p.id = px.programmer_id 
INNER JOIN studies s ON s.id = p.stud_id;


-- 8. Who is the youngest programmer knowing dBase?

SELECT
	st.id, st.name, 
	MIN(TIMESTAMPDIFF(YEAR, p.dob, CURDATE())) AS age
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
INNER JOIN programmer_prof_xref pp ON
	pp.programmer_id = p.id
INNER JOIN dev_in di ON
	di.id = pp.dev_in_id
WHERE
	di.name = 'dBase'
GROUP BY
	st.id, st.name
ORDER BY
	age ASC
LIMIT 1;


-- 9. Which female programmer earns more than 3000/- but does not know C, C++, Oracle or Dbase?

SELECT
	st.name,
	p.salary
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
WHERE
	p.salary > 3000
	AND p.sex = 'F'
	AND NOT EXISTS (
	SELECT
		1
	FROM
		programmer_prof_xref pp
	INNER JOIN dev_in di ON
		di.id = pp.dev_in_id
	WHERE
		pp.programmer_id = p.id
		AND di.name IN ('C', 'C++', 'Oracle', 'dBase')
  );
		
-- Rewritten without subquery for above
 
select p.id, s.name, p.salary from programmer p 
	inner join studies s on s.id = p.stud_id
	left join programmer_prof_xref px on  px.programmer_id = p.id
	left join dev_in d on d.id = px.dev_in_id and d.name in ('C', 'C++', 'Oracle', 'Dbase')
where p.sex = 'F' and salary > 3000 group by p.id, s.name, p.salary
having count(d.id) = 0;


-- 10. Which institute has the greatest number of students?

SELECT
	pl.id, pl.name AS institute_name,
	COUNT(st.id) AS student_count
FROM
	studies st
INNER JOIN place pl ON
	pl.id = st.place_id
GROUP BY
	pl.id, pl.name
ORDER BY
	student_count DESC
LIMIT 1;


-- 11. Which course has been done by most of the students?

SELECT
	c.id, c.name AS course_name,
	COUNT(s.id) AS student_count
FROM
	studies s
INNER JOIN course c ON
	c.id = s.id
GROUP BY
	c.id, c.name
ORDER BY
	student_count DESC
LIMIT 1;


-- 12. Display the name of the institute and course which has course fee below average.

WITH avg_course_fee AS (
    SELECT ROUND(AVG(course_fee)) AS avg_cf FROM studies
)
SELECT 
	p.name, 
	c.name, 
	s.name, 
	s.course_fee,
	avg_course_fee.avg_cf
FROM studies s
	INNER JOIN place p ON s.place_id = p.id
	INNER JOIN stud_course_xref scx ON scx.stud_id = s.id
	INNER JOIN course c ON c.id = scx.course_id
	JOIN avg_course_fee ON 1=1
WHERE s.course_fee < avg_course_fee.avg_cf;



-- 13. Which is the costliest course?

SELECT
	s.name,
	c.name,
	s.course_fee
FROM
	studies s
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id
INNER JOIN course c ON
	c.id = sx.course_id
order by
	s.course_fee DESC
LIMIT 1;


-- 14. Which institute conducts the costliest course?

SELECT
	p.name,
	c.name,
	s.course_fee
FROM
	studies s
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id
INNER JOIN course c ON
	c.id = sx.course_id
INNER JOIN place p ON
	p.id = s.place_id
ORDER BY
	s.course_fee DESC
LIMIT 1;

-- 15. Which course has below average number of students?

WITH coursestudentcounts AS (
SELECT
	c.id,
	c.name AS course_name,
	count(s.id) AS num_students
FROM
	course c
INNER JOIN stud_course_xref sx ON
	sx.course_id = c.id
LEFT JOIN studies s on
	s.id = sx.stud_id
GROUP BY
	c.id,
	c.name
),
averagestudentcount AS (
SELECT
	AVG(num_students) AS avg_num_students
FROM
	coursestudentcounts
)
SELECT
	c.course_name
FROM
	coursestudentcounts c
CROSS JOIN averagestudentcount AVG
WHERE
	c.num_students < AVG.avg_num_students;

-- 16.  Which institute conducts the above course? // Same as 14th

SELECT
	p.name,
	c.name,
	s.course_fee
FROM
	studies s
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id
INNER JOIN course c ON
	c.id = sx.course_id
INNER JOIN place p ON
	p.id = s.place_id
ORDER BY
	s.course_fee DESC
LIMIT 1;

-- 17. Display the names of the course whose fees are within 1000 (+ or -) of the average fee.

WITH AvgFee AS (
SELECT
	AVG(course_fee) AS avg_fee
FROM
	studies
)
SELECT
	c.name,
	s.course_fee
FROM
	studies s
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id
INNER JOIN course c ON
	c.id = sx.course_id
CROSS JOIN AvgFee af
WHERE
	s.course_fee BETWEEN avg_fee - 1000 AND avg_fee + 1000;


-- 18. Which package has the highest development cost?

SELECT
	title,
	dev_cost
FROM
	software
WHERE
	dev_cost = (
	SELECT
		MAX(dev_cost)
	FROM
		software);

-- 19. Which package has the lowest selling cost?

SELECT title, dev_cost FROM software WHERE dev_cost = (SELECT MIN(dev_cost) FROM software);

-- 20. Who developed the package which has sold the least number of copies?

SELECT
	st.name,
	s.title,
	s.sold_qty
FROM
	software s
INNER JOIN studies st ON
	st.id = s.stud_id
WHERE
	s.sold_qty = (
	SELECT
		MIN(sold_qty)
	FROM
		software);
	

-- 21. Which language was used to develop the package which has the highest sales amount?

SELECT
	di.name,
	s.title,
	s.selling_cost
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
WHERE
	s.selling_cost = (
	SELECT
		max(selling_cost)
	FROM
		software);


-- 22.  How many copies of the package that has the least difference between development and selling cost were sold?

WITH packagecostdifference AS (
SELECT
	id,
	ABS(dev_cost - selling_cost) AS cost_difference
FROM
	software
ORDER BY
	cost_difference ASC
LIMIT 1
)
SELECT
	*
FROM
	software
WHERE
	id = (
	SELECT
		id
	FROM
		packagecostdifference);

-- 23.  Which is the costliest package developed in Pascal?

WITH PascalDevPackage AS (
SELECT
	s.title,
	di.name,
	s.dev_cost
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
WHERE
	di.name = 'Pascal'
)
SELECT
	*
FROM
	PascalDevPackage
WHERE
	dev_cost = (
	SELECT
		MAX(dev_cost)
	FROM
		PascalDevPackage);

-- 24. Which language was used to develop the most number of packages?

SELECT
	di.name,
	COUNT(s.title) AS package_count
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
GROUP BY
	di.name
ORDER BY
	package_count DESC
LIMIT 1;

-- 25.  Which Programmer has developed the highest number of packages?

SELECT
	st.name,
	COUNT(s.title) As package_count
FROM
	software s
INNER JOIN studies st ON
	st.id = s.stud_id
GROUP BY
	st.name
ORDER BY
	package_count DESC
LIMIT 1;

-- 26.  Who is the author of the costliest package?

SELECT
	st.name,
	s.title AS package_count
FROM
	software s
INNER JOIN studies st ON
	st.id = s.stud_id
WHERE
	dev_cost = (
	SELECT
		MAX(dev_cost)
	FROM
		software);

-- 27.  Display the names of packages which have been sold less than the average number of packages.

WITH AVERAGE_SOLD_QTY AS (
SELECT
	AVG(sold_qty) AS avg_sold_qty
FROM
	software
)
SELECT
	title
FROM
	software
WHERE
	sold_qty < (
	SELECT
		avg_sold_qty
	FROM
		AVERAGE_SOLD_QTY);


-- 28.  Who are the authors of packages which have recovered more than double the development cost?

SELECT
	DISTINCT st.name,
	s.title
FROM
	software s
INNER JOIN studies st ON
	st.id = s.stud_id
WHERE
	s.selling_cost > (s.dev_cost * 2);

-- 29.  Display the programmer names and the cheapest package developed by them in each language?

WITH minPackages AS (
SELECT
	di.name AS lang,
	st.name AS programmer,
	s.title AS package,
	s.dev_cost,
	ROW_NUMBER() OVER (PARTITION BY di.name
ORDER BY
	s.dev_cost ASC) AS rn
FROM
	software s
INNER JOIN studies st ON
	s.stud_id = st.id
INNER JOIN dev_in di ON
	s.dev_in_id = di.id
)
SELECT
	lang,
	programmer,
	package,
	dev_cost
FROM
	minPackages
WHERE
	rn = 1;


-- 30. Display the language used by each programmer to develop the highest selling and lowest selling package.

WITH highestSelling AS (
SELECT
	di.name AS lang,
	st.name AS programmer,
	s.title AS package,
	s.selling_cost,
	ROW_NUMBER() OVER (PARTITION BY st.name
ORDER BY
	s.selling_cost DESC) AS rn_highest
FROM
	software s
INNER JOIN studies st ON
	s.stud_id = st.id
INNER JOIN dev_in di ON
	s.dev_in_id = di.id
),
lowestSelling AS (
SELECT
	di.name AS lang,
	st.name AS programmer,
	s.title AS package,
	s.selling_cost,
	ROW_NUMBER() OVER (PARTITION BY st.name
ORDER BY
	s.selling_cost ASC) AS rn_lowest
FROM
	software s
INNER JOIN studies st ON
	s.stud_id = st.id
INNER JOIN dev_in di ON
	s.dev_in_id = di.id
)
SELECT
	hs.programmer,
	hs.lang AS highest_selling_lang,
	hs.package AS highest_selling_package,
	hs.selling_cost AS highest_selling_cost,
	ls.lang AS lowest_selling_lang,
	ls.package AS lowest_selling_package,
	ls.selling_cost AS lowest_selling_cost
FROM
	highestSelling hs
INNER JOIN lowestSelling ls ON
	hs.programmer = ls.programmer
WHERE
	hs.rn_highest = 1
	AND ls.rn_lowest = 1
ORDER BY
	hs.programmer;

-- 31. Who is the youngest male programmer born in 1965?	

SELECT
	s.name,
	p.dob
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	YEAR(p.dob) = 1965
	AND p.sex = 'M'
ORDER BY
	p.dob DESC
LIMIT 1;

-- 32. Who is the oldest female programmer born 1n 1965?

SELECT
	s.name,
	p.dob
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	YEAR(p.dob) = 1965
	AND p.sex = 'F'
ORDER BY
	p.dob DESC
LIMIT 1;


-- 33. In which year were the most number of programmers born?

SELECT
	YEAR(p.dob) AS birth_year,
	COUNT(*) AS num_programmers
FROM
	programmer p
GROUP BY
	YEAR(p.dob)
ORDER BY
	num_programmers DESC
LIMIT 1;

-- 34. In which month did the most number of programmers join?

SELECT
	MONTH(p.doj) AS join_month,
	COUNT(*) AS num_programmers
FROM
	programmer p
GROUP BY
	MONTH(p.doj)
ORDER BY
	num_programmers DESC
LIMIT 1;

-- 35. In which language are most of the programmers proficient?

WITH Proficiencies AS (
SELECT
	di1.name AS language,
	COUNT(*) AS proficiency_count
FROM
	programmer p
INNER JOIN programmer_prof_xref px ON
	px.programmer_id = p.id
INNER JOIN dev_in di1 ON
	di1.id = px.dev_in_id
WHERE
	px.dev_in_id IS NOT NULL
GROUP BY
	px.dev_in_id
)
SELECT
	language,
	SUM(proficiency_count) AS total_programmers
FROM
	Proficiencies
GROUP BY
	language
ORDER BY
	total_programmers DESC
LIMIT 1;

-- 36.  Who are the male programmers earning below the average salary of the female programmers?

WITH FemaleAvgSalary AS (
SELECT
	AVG(p.salary) AS avg_female_salary
FROM
	programmer p
WHERE
	p.sex = 'F'
),
MaleBelowAvgFemaleSalary AS (
SELECT
	*
FROM
	programmer p
CROSS JOIN FemaleAvgSalary fas
WHERE
	p.sex = 'M'
	AND p.salary < fas.avg_female_salary
)
SELECT
	*
FROM
	MaleBelowAvgFemaleSalary;


-- 37. Who are the female programmers earning more than the highest paid male programmer?

WITH highestmalesalary AS (
SELECT
	MAX(salary) AS highest_male_salary
FROM
	programmer
WHERE
	sex = 'M'
),
femaleabovemale AS (
SELECT
	*
FROM
	programmer
WHERE
	sex = 'F'
	AND salary > (
	SELECT
		highest_male_salary
	FROM
		highestmalesalary)
)
SELECT
	*
FROM
	femaleabovemale;


-- 38. Which language has been stated as  prof1  by most of the programmers?

SELECT
    di.name,
    COUNT(px.dev_in_id) AS most_prof1
FROM
    programmer p
INNER JOIN programmer_prof_xref px ON 
    px.programmer_id = p.id
INNER JOIN dev_in di ON
    di.id = px.dev_in_id
GROUP BY
    di.name
ORDER BY
    most_prof1 DESC
LIMIT 1;

	


