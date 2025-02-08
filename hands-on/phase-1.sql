-- 1. Find out the selling cost average for packages developed in Pascal.

SELECT
	ROUND(AVG(software.selling_cost)) AS average_of_selling_cost
FROM
	software
INNER JOIN dev_in ON
	dev_in.id = software.dev_in_id
WHERE
	dev_in.name = 'Pascal';

-- 2. Display the names and ages of all programmers

SELECT
	studies.name,
	TIMESTAMPDIFF(YEAR, programmer.dob, CURDATE()) AS age
FROM
	programmer
INNER JOIN studies ON
	studies.id = programmer.stud_id;

-- 3.  Display the names of those who have done the DAP course 

SELECT
	studies.name
FROM
	studies
INNER JOIN stud_course_xref ON
	studies.id = stud_course_xref.stud_id
INNER JOIN course ON
	course.id = stud_course_xref.course_id
WHERE
	course.name = 'DAP';

-- 4. What is the highest number of copies sold by a package?

SELECT MAX(sold_qty) FROM software;

-- 5. Display the names and date of birth of all programmers born in January.

SELECT
	studies.name
FROM
	programmer
INNER JOIN studies ON
	studies.id = programmer.stud_id
WHERE
	MONTH(programmer.dob) = 1;

-- 6. Display the lowest course fee.

SELECT MIN(course_fee) FROM studies;

-- 7. How many programmers have done the PGDCA Course?

SELECT
	COUNT(studies.name)
FROM
	studies
INNER JOIN stud_course_xref ON
	studies.id = stud_course_xref.stud_id
INNER JOIN course ON
	course.id = stud_course_xref.course_id
WHERE
	course.name = 'PGDCA';

-- 8. How much revenue has been earned through the sales of packages developed in C?

SELECT
	SUM(selling_cost) - SUM(dev_cost) as total_revenue
FROM
	software
INNER JOIN dev_in ON
	dev_in.id = software.dev_in_id
WHERE
	dev_in.name = 'C';

-- 9. Display the details of software developed by Ramesh.

SELECT
	software.title
FROM
	software
INNER JOIN studies ON
	studies.id = software.stud_id
WHERE
	studies.name = 'Ramesh';

-- 10. How many programmers studied at SABHARI?

SELECT
	COUNT(studies.name)
FROM
	studies
INNER JOIN place ON
	place.id = studies.place_id
WHERE
	place.name = 'Sabhari';

-- 11. Display the details of packages whose sales crossed the 2000 mark.

SELECT
	studies.name,
	software.title
FROM
	software
INNER JOIN studies ON
	studies.id = software.stud_id
WHERE
	software.selling_cost >= 2000;

-- 12. Find out the number of qty which should be sold to recover the development cost of each package.

SELECT
	title,
	ROUND(SUM(dev_cost / selling_cost)) AS required_qty
FROM
	software
GROUP BY
	title;

-- 13. Display the details of packages for which development cost has been recovered?

SELECT
	title,
	selling_cost,
	dev_cost,
	sold_qty,
	SUM(ROUND(selling_cost * sold_qty)) AS total_cost
FROM
	software
GROUP BY
	title,
	selling_cost,
	dev_cost,
	sold_qty
HAVING
	SUM(selling_cost * sold_qty) >= dev_cost;

-- 14. What is the price of costliest software developed in BASIC?

SELECT
	MAX(software.dev_cost) AS costliest_basic_software
FROM
	software
INNER JOIN dev_in ON
	dev_in.id = software.dev_in_id
WHERE
	dev_in.name = 'Basic';

-- 15. How many packages were developed IN Dbase

SELECT
	COUNT(software.dev_in_id) AS COUNT_of_dbase
FROM
	software
INNER JOIN dev_in ON
	dev_in.id = software.dev_in_id
WHERE
	dev_in.name = 'Dbase';

-- 16. How many programmers studied at PRAGATHI? 

SELECT
	COUNT(studies.place_id) AS studied_at_pragathi
FROM
	studies
INNER JOIN place ON
	place.id = studies.place_id
WHERE
	place.name = 'Pragathi';

-- 17. How many programmers paid 5000 to 10000 for their course? 

SELECT
	COUNT(studies.name) AS paid_range_bw_5000_to_10000
FROM
	studies
INNER JOIN stud_course_xref ON
	studies.id = stud_course_xref.stud_id
WHERE
	studies.course_fee BETWEEN 5000 AND 10000;

-- 18. What is the average course fee?

SELECT AVG(course_fee) AS average_course_fee FROM studies;

-- 19. Display the details of programmers knowing C?

SELECT
	studies.name,
	programmer.sex
FROM
	programmer
INNER JOIN studies ON
	studies.id = programmer.stud_id
INNER JOIN programmer_prof_xref prof ON
	programmer.id = prof.programmer_id
WHERE
	prof.dev_in_id = (
	SELECT
		id
	FROM
		dev_in
	WHERE
		name = 'C');

-- 20. How many programmers know either COBOL or Pascal?
	
SELECT
	COUNT(studies.id)
FROM
	studies
INNER JOIN programmer ON
	programmer.stud_id = studies.id
INNER JOIN programmer_prof_xref prof ON
	programmer.id = prof.programmer_id
WHERE
	prof.dev_in_id IN (
	SELECT
		id
	FROM
		dev_in
	WHERE
		name IN ('COBOL', 'Pascal'));

-- 21. How many programmers don’t know Pascal and C?

SELECT
	COUNT(DISTINCT p.id) AS programmers_without_pascal_and_c
FROM
	programmer p
WHERE
	p.id NOT IN (
	SELECT
		DISTINCT pp.programmer_id
	FROM
		programmer_prof_xref pp
	WHERE
		pp.dev_in_id IN (2, 3)
);

-- 22.  How old is the oldest male programmer?

SELECT
	timestampdiff(YEAR,
	dob,
	doj) AS age
FROM
	programmer
WHERE
	sex = 'M'
	AND YEAR(dob) = (
	SELECT
		MIN(YEAR(dob))
	FROM
		programmer);


-- 23. What is the average age of female programmers?

SELECT
	AVG(timestampdiff(YEAR, dob, doj))
FROM
	programmer
WHERE
	sex = 'F';


-- 24.Calculate the experience in years for each programmer and display alONg with their names in descendINg order.

SELECT
	s.name,
	timestampdiff(YEAR,
	p.doj,
	NOW()) AS experience
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
ORDER BY
	experience DESC;


-- 25. Who are the programmers who celebrate their birthdays durINg current mONth?

SELECT
	s.name
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	MONTH(p.dob) = MONTH(NOW());


-- 26. How many female programmers are there?

SELECT
	COUNT(s.name)
FROM
	programmer p
INNER JOIN studies s ON
	s.id = p.stud_id
WHERE
	p.sex = 'F';


-- 27.  What are the languages known by the male programmers?

SELECT DISTINCT
	di.name
FROM
	programmer_prof_xref p1
INNER JOIN programmer p ON
	p.id = p1.programmer_id
INNER JOIN dev_in di ON
	di.id = p1.dev_in_id
WHERE
	p.sex = 'M';


-- 28. What is the average salary?

SELECT AVG(salary) FROM programmer;

-- 29. How many people draw 2000 to 4000?

SELECT
	COUNT(salary)
FROM
	programmer
WHERE
	salary BETWEEN 2000 AND 4000;


-- 30. Display the details of those who dON’t know CLIPPER, COBOL or Pascal.

SELECT
	st.name, di.name
FROM
	programmer p
INNER JOIN programmer_prof_xref p1 ON
	p.id = p1.programmer_id
INNER JOIN dev_in di ON
	di.id = p1.dev_in_id
INNER JOIN studies st ON
	st.id  = p.stud_id
WHERE
	di.name NOT IN ('CLIPPER', 'COBOL', 'Pascal');


-- 31. Display the cost of the package developed by each programmer.

SELECT
	st.name,
	SUM(so.dev_cost) AS cost
FROM
	software so
INNER JOIN studies st ON
	st.id = so.stud_id
GROUP BY
	st.name;

-- 32. Display the sales values of packages developed by each programmer.

SELECT
	st.name,
	SUM(so.selling_cost) as sale_cost
FROM
	software so
INNER JOIN studies st ON
	st.id = so.stud_id
group by
	st.name;

-- 33. Display the number of packages sold by each programmer.

SELECT
	st.name,
	COUNT(di.name) as COUNTOfDevIN
FROM
	software so
INNER JOIN studies st ON
	st.id = so.stud_id
INNER JOIN dev_in di ON
	di.id = so.dev_in_id
GROUP BY
	st.name;

-- 34. Display the sales cost of the packages developed by each programmer language-wise.

SELECT
	st.name,
	di.name as languages,
	SUM(so.selling_cost) AS sale_cost
FROM
	software so
INNER JOIN studies st ON
	st.id = so.stud_id
INNER JOIN dev_in di ON
	di.id = so.dev_in_id
GROUP BY
	di.name,
	st.name;

-- 35.  Display each language name with average development cost, average sellINg cost AND average price per copy. 

SELECT
	di.name as language_p,
	AVG(so.dev_cost),
	AVG(so.selling_cost),
	AVG(so.selling_cost / so.sold_qty)
FROM
	software so
INNER JOIN dev_in di ON
	di.id = so.dev_in_id
GROUP BY
	di.name;

-- 36. Display each programmer’s name, costliest AND cheapest package developed?

SELECT
	std.name,
	MAX(so.dev_cost) as costliest,
	MIN(so.dev_cost) as cheapest
FROM
	software so
INNER JOIN studies std ON
	std.id = so.stud_id
INNER JOIN dev_in di ON
	di.id = so.dev_in_id
GROUP BY
	std.name;

-- 37. Display each INstitute name with number of course AND course fee average.

SELECT
	p.name,
	COUNT(cr.name),
	AVG(s.course_fee)
FROM
	studies s
INNER JOIN stud_course_xref sx ON
	sx.stud_id = s.id
INNER JOIN course cr ON
	cr.id = sx.course_id
INNER JOIN place p ON
	p.id = s.place_id
GROUP BY
	p.name;

-- 38. Display each INstitute name with number of students.

SELECT
	p.name,
	COUNT(*) AS students
FROM
	studies s
INNER JOIN place p ON
	p.id = s.place_id
GROUP BY
	p.name;

-- 39. Display the names of male AND female programmers.

SELECT
	st.name,
	p.sex
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
ORDER BY
	sex DESC;

-- 40. Display the programmers name AND their packages.

SELECT
	st.name,
	SUM(p.salary)
FROM
	programmer p
INNER JOIN studies st ON
	st.id = p.stud_id
GROUP BY
	st.name;

-- 41. Display the number of packages IN each language except C AND C++

SELECT
	s.title,
	di.name,
	COUNT(title)
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
WHERE
	di.name NOT IN ('C', 'C++')
GROUP BY
	s.title,
	di.name;

-- 42.  Display the number of packages IN each language for which development cost is less than 1000

SELECT
	di.name,
	s.title,
	COUNT(s.title)
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
WHERE
	s.dev_cost < 1000
GROUP BY
	di.name,
	s.title;

-- 43.  Display the average difference BETWEEN selling_cost AND dev_cost for each language.

SELECT
	di.name,
	AVG(s.dev_cost - s.selling_cost)
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
GROUP BY
	di.name;

-- 44. Display the total selling_cost, dev_cost AND the amount to be recovered for each programmer

SELECT
	st.name,
	SUM(s.selling_cost) as total_selling_cost,
	SUM(s.dev_cost) as total_dev_cost,
	SUM(s.dev_cost - s.selling_cost) as amount_to_be_recovered
FROM
	software s
INNER JOIN dev_in di ON
	di.id = s.dev_in_id
INNER JOIN programmer p ON
	p.stud_id = s.stud_id
INNER JOIN studies st ON
	st.id = s.stud_id
GROUP BY
	st.name;

-- 45.  Display the highest, lowest AND average salaries for those earnINg more than 2000

SELECT
	MAX(salary),
	MIN(salary),
	AVG(salary)
FROM
	programmer
WHERE
	salary > 2000;