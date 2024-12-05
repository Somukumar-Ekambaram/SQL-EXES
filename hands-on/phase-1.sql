-- 1. Find out the selling cost average for packages developed in Pascal.

 -- select avg(software.selling_cost) as average_of_selling_cost from software inner join dev_in on dev_in.dev_in_id = software.dev_in_id where dev_in.name='Pascal';

SELECT AVG(software.selling_cost) AS average_of_selling_cost 
FROM software 
INNER JOIN dev_in ON dev_in.id = software.dev_in_id 
WHERE dev_in.name = 'Pascal';

-- 2. Display the names and ages of all programmers

-- select name, timestampdiff(year, dob, doj) as age from programmer p inner join studies s on s.stud_id = p.stud_id;
SELECT studies.name, TIMESTAMPDIFF(YEAR, programmer.dob, programmer.doj) AS age 
FROM programmer 
INNER JOIN studies ON studies.id = programmer.stud_id;

-- 3.  Display the names of those who have done the DAP course 

-- select s.name from studies s inner join course c on c.course_id = s.course_id where c.course_name='DAP';
SELECT studies.name 
FROM studies 
INNER JOIN stud_course_xref ON studies.id = stud_course_xref.stud_id
INNER JOIN course ON course.id = stud_course_xref.course_id
WHERE course.name = 'DAP';

-- 4. What is the highest number of copies sold by a package?

-- select max(sold_qty) from software;

SELECT MAX(sold_qty) FROM software;

-- 5. Display the names and date of birth of all programmers born in January.

-- select s.name from programmer p inner join studies s on s.stud_id = p.stud_id where month(p.dob) = 01;

SELECT studies.name 
FROM programmer 
INNER JOIN studies ON studies.id = programmer.stud_id 
WHERE MONTH(programmer.dob) = 1;

-- 6. Display the lowest course fee.

-- select min(course_fee) from studies;

SELECT MIN(course_fee) FROM studies;

-- 7. How many programmers have done the PGDCA Course?

-- select count(s.name) from studies s inner join course c on c.course_id = s.course_id where c.course_name='PGDCA';

SELECT COUNT(studies.name) 
FROM studies 
INNER JOIN stud_course_xref ON studies.id = stud_course_xref.stud_id
INNER JOIN course ON course.id = stud_course_xref.course_id
WHERE course.name = 'PGDCA';

-- 8. How much revenue has been earned through the sales of packages developed in C?

-- select sum(s.selling_cost - s.dev_cost) as revenue from software s inner join dev_in d on d.dev_in_id = s.dev_in_id where d.name='C';

SELECT SUM(software.selling_cost - software.dev_cost) AS revenue 
FROM software 
INNER JOIN dev_in ON dev_in.id = software.dev_in_id 
WHERE dev_in.name = 'C';

-- 9. Display the details of software developed by Ramesh.

-- select s.title from software s  inner join studies ss on ss.stud_id = s.stud_id where ss.name = 'Ramesh';

SELECT software.title 
FROM software 
INNER JOIN studies ON studies.id = software.stud_id 
WHERE studies.name = 'Ramesh';

-- 10. How many programmers studied at SABHARI?

-- select count(s.name) from studies s inner join place p on p.place_id = s.place_id  where p.place_name = 'Sabhari';

SELECT COUNT(studies.name) 
FROM studies 
INNER JOIN place ON place.id = studies.place_id 
WHERE place.name = 'Sabhari';

-- 11. Display the details of packages whose sales crossed the 2000 mark.

-- select ss.name, s.title from software s inner join studies ss on ss.stud_id = s.stud_id where s.selling_cost >= 2000;

SELECT studies.name, software.title 
FROM software 
INNER JOIN studies ON studies.id = software.stud_id 
WHERE software.selling_cost >= 2000;

-- 12. Find out the number of qty which should be sold to recover the development cost of each package.

-- select title, sum(dev_cost / selling_cost) as required_qty from software group by title;

SELECT title, SUM(dev_cost / selling_cost) AS required_qty 
FROM software 
GROUP BY title;

-- 13. Display the details of packages for which development cost has been recovered?

-- select title, selling_cost, dev_cost, sold_qty, sum(round(selling_cost * sold_qty)) as total_cost from software group by title, selling_cost, dev_cost, sold_qty having sum(selling_cost * sold_qty) >= dev_cost;

SELECT title, selling_cost, dev_cost, sold_qty, 
       SUM(ROUND(selling_cost * sold_qty)) AS total_cost
FROM software 
GROUP BY title, selling_cost, dev_cost, sold_qty
HAVING SUM(selling_cost * sold_qty) >= dev_cost;

-- 14. What is the price of costliest software developed in BASIC?

-- select max(s.dev_cost) as costliest_basic_software from software s inner join dev_in d on d.dev_in_id = s.dev_in_id where d.name='Basic';

SELECT MAX(software.dev_cost) AS costliest_basic_software 
FROM software 
INNER JOIN dev_in ON dev_in.id = software.dev_in_id 
WHERE dev_in.name = 'Basic';

-- 15. How many packages were developed in Dbase

-- select count(s.dev_in_id) as count_of_dbase from software s inner join dev_in d on d.dev_in_id = s.dev_in_id where d.name = 'Dbase';

SELECT COUNT(software.dev_in_id) AS count_of_dbase 
FROM software 
INNER JOIN dev_in ON dev_in.id = software.dev_in_id 
WHERE dev_in.name = 'Dbase';

-- 16. How many programmers studied at PRAGATHI? 

-- select count(s.place_id) as studied_at_pragathi from studies s inner join place p on p.place_id = s.place_id where p.place_name = 'Pragathi';

SELECT COUNT(studies.place_id) AS studied_at_pragathi 
FROM studies 
INNER JOIN place ON place.id = studies.place_id 
WHERE place.name = 'Pragathi';

-- 17. How many programmers paid 5000 to 10000 for their course? 

-- select count(s.name) paid_range_bw_5000_to_10000 from studies s  inner join course c on c.course_id = s.course_id where s.course_fee >= 5000 and s.course_fee <= 10000;

SELECT COUNT(studies.name) AS paid_range_bw_5000_to_10000 
FROM studies 
INNER JOIN stud_course_xref ON studies.id = stud_course_xref.stud_id
WHERE studies.course_fee BETWEEN 5000 AND 10000;

-- 18. What is the average course fee?

-- select avg(course_fee) average_course_fee from studies;

SELECT AVG(course_fee) AS average_course_fee FROM studies;

-- 19. Display the details of programmers knowing C?

-- select s.name, p.sex from programmer p inner join studies s on s.stud_id = p.stud_id where p.prof1 in (select dev_in_id from dev_in where name = 'C') OR p.prof2 in (select dev_in_id from dev_in where name = 'C');

SELECT studies.name, programmer.sex 
FROM programmer 
INNER JOIN studies ON studies.id = programmer.stud_id
INNER JOIN programmer_prof_xref prof ON programmer.id = prof.programmer_id
WHERE prof.dev_in_id = (SELECT id FROM dev_in WHERE name = 'C');

-- 20. How many programmers know either COBOL or Pascal?

-- select count(s.stud_id) from studies s inner join programmer p on p.stud_id = s.stud_id where p.prof1 in (select dev_in_id from dev_in where name in ('COBOL', 'Pascal')) or p.prof2 in (select dev_in_id from dev_in where name in ('COBOL', 'Pascal'));

SELECT COUNT(studies.id) 
FROM studies 
INNER JOIN programmer ON programmer.stud_id = studies.id
INNER JOIN programmer_prof_xref prof ON programmer.id = prof.programmer_id
WHERE prof.dev_in_id IN (SELECT id FROM dev_in WHERE name IN ('COBOL', 'Pascal'));

-- 21. How many programmers don’t know Pascal and C?

-- select count(s.stud_id) from studies s inner join programmer p on p.stud_id = s.stud_id where p.prof1 not in ((select dev_in_id from dev_in where name = 'C'), (select dev_in_id from dev_in where name = 'Pascal')) and p.prof2 not in ((select dev_in_id from dev_in where name = 'C'), (select dev_in_id from dev_in where name = 'Pascal'));

SELECT COUNT(s.name), s.name FROM programmer p 
INNER JOIN programmer_prof_xref prof ON prof.programmer_id  = p.id 
INNER JOIN dev_in d ON d.id = prof.dev_in_id 
INNER JOIN studies s ON s.id = p.stud_id 
WHERE prof.dev_in_id NOT IN (SELECT id FROM dev_in WHERE name IN ('C', 'Pascal'))
GROUP BY prof.programmer_id;

-- 22.  How old is the oldest male programmer?

-- select timestampdiff(year, dob, doj) as age from programmer where sex = 'M' and year(dob) = (select min(year(dob)) from programmer);

select timestampdiff(year, dob, doj) as age 
from programmer 
where sex = 'M' 
and year(dob) = (select min(year(dob)) from programmer);


-- 23. What is the average age of female programmers?

-- select avg(timestampdiff(year, dob, doj)) from programmer where sex = 'F';

select avg(timestampdiff(year, dob, doj)) 
from programmer 
where sex = 'F';


-- 24.Calculate the experience in years for each programmer and display along with their names in descending order.

-- select s.name, (timestampdiff(year, p.doj, now())) as age from programmer p inner join studies s on s.stud_id = p.stud_id order by age desc;

select s.name, timestampdiff(year, p.doj, now()) as experience 
from programmer p 
inner join studies s on s.id = p.stud_id
order by experience desc;


-- 25. Who are the programmers who celebrate their birthdays during current month?

-- select s.name from programmer p inner join studies s on s.stud_id = p.stud_id where month(p.dob) = month(now());

select s.name 
from programmer p 
inner join studies s on s.id = p.stud_id
where month(p.dob) = month(now());


-- 26. How many female programmers are there?

-- select count(s.name) from programmer p inner join studies s on s.stud_id = p.stud_id where sex='F';

select count(s.name) 
from programmer p 
inner join studies s on s.id = p.stud_id
where p.sex = 'F';


-- 27.  What are the languages known by the male programmers?

-- select (select name from dev_in where dev_in_id = p1.prof1) from programmer p1 where sex = 'M' union  select (select name from dev_in where dev_in_id = p2.prof2) from programmer p2 where sex = 'M';

select di.name 
from programmer_prof_xref p1
inner join programmer p on p.id = p1.programmer_id 
inner join dev_in di on di.id = p1.dev_in_id 
where p.sex = 'M'
union 
select di.name 
from programmer_prof_xref p2
inner join programmer p on p.id = p2.programmer_id
inner join dev_in di on di.id = p2.dev_in_id
where p.sex = 'M';


-- 28. What is the average salary?

-- select avg(salary) from programmer;

select avg(salary) from programmer;

-- 29. How many people draw 2000 to 4000?

-- select count(salary) from programmer where salary >= 2000 and salary <= 4000;

select count(salary) 
from programmer 
where salary between 2000 and 4000;


-- 30. Display the details of those who don’t know CLIPPER, COBOL or Pascal.

-- select * from programmer where prof1 not in ('CLIPPER', 'COBOL', 'Pascal') and prof2 not in ('CLIPPER', 'COBOL', 'Pascal');

select * 
from programmer p 
inner join programmer_prof_xref p1 on p.id = p1.programmer_id 
inner join dev_in di on di.id = p1.dev_in_id 
where di.name not in ('CLIPPER', 'COBOL', 'Pascal');


-- 31. Display the cost of the package developed by each programmer.

-- select st.name, sum(so.dev_cost) as cost from software so inner join studies st on st.stud_id = so.stud_id  group by st.name;

-- 32. Display the sales values of packages developed by each programmer.

-- select st.name, sum(so.selling_cost) as sale_cost from software so inner join studies st on st.stud_id = so.stud_id group by st.name;

-- 33. Display the number of packages sold by each programmer.

-- select st.name, count(di.name) as countOfDevIn from software so inner join studies st on st.stud_id = so.stud_id inner join dev_in di on di.dev_in_id = so.dev_in_id group by st.name;

-- 34. Display the sales cost of the packages developed by each programmer language-wise.

-- select st.name, di.name as languages, sum(so.selling_cost) as sale_cost from software so inner join studies st on st.stud_id = so.stud_id inner join dev_in di on di.dev_in_id = so.dev_in_id group by st.name, di.name;

-- 35.  Display each language name with average development cost, average selling cost and average price per copy. 

-- select di.name as language, avg(so.dev_cost), avg(so.selling_cost), avg(so.selling_cost / so.sold_qty) from software soinner join dev_in di on di.dev_in_id = so.dev_in_id group by di.name;

-- 36. Display each programmer’s name, costliest and cheapest package developed?

-- select std.name, max(so.dev_cost) as costliest, min(so.dev_cost) as cheapest from software so inner join studies std on std.stud_id  = so.stud_id inner join dev_in di on di.dev_in_id = so.dev_in_id group by std.name;

-- 37. Display each Institute name with number of course and course fee average.

-- select p.place_name, count(cr.course_name), avg(s.course_fee) from studies s inner join course cr on cr.course_id = s.course_id  inner join place p on p.place_id  = s.place_id group by p.place_name;

-- 38. Display each institute name with number of students.

-- select p.place_name, count(*) as students  from studies s inner join place p on p.place_id  = s.place_id group by p.place_name ;

-- 39. Display the names of male and female programmers.

-- select st.name, p.sex from programmer p inner join studies st on st.stud_id = p.stud_id order by sex desc;

-- 40. Display the programmers name and their packages.

-- select st.name, sum(p.salary) from programmer p inner join studies st on st.stud_id = p.stud_id group by st.name;

-- 41. Display the number of packages in each language except C and C++

-- select s.title, count(title)  from software s inner join dev_in di on di.dev_in_id = s.dev_in_id where di.name not in ('C', 'C++') group by s.title;

-- 42.  Display the number of packages in each language for which development cost is less than 1000

-- select di.name, s.title, count(s.title) from software s inner join dev_in di on di.dev_in_id = s.dev_in_id where s.dev_cost < 1000 group by di.name, s.title;

-- 43.  Display the average difference between selling_cost and dev_cost for each language.

-- select di.name, avg(s.dev_cost - s.selling_cost) from software s inner join dev_in di on di.dev_in_id = s.dev_in_id group by di.name;

-- 44. Display the total selling_cost, dev_cost and the amount to be recovered for each programmer

-- select st.name, sum(s.selling_cost) as total_selling_cost, sum(s.dev_cost) as total_dev_cost, sum(s.dev_cost - s.selling_cost) as amount_to_be_recovered from software s inner join dev_in di on di.dev_in_id = s.dev_in_id inner join programmer p on p.stud_id  = s.stud_id inner join studies st on st.stud_id  = s.stud_id group by st.name;

-- 45.  Display the highest, lowest and average salaries for those earning more than 2000

-- select max(salary), min(salary), avg(salary) from programmer where salary > 2000;