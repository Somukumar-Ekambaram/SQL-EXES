-- CREATE DATABASE --
CREATE DATABASE `sql-exs`;

-- TABLES DDL --
-- `sql-exs`.course definition -- 
CREATE TABLE `course` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.dev_in definition -- 
CREATE TABLE `dev_in` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.place definition --
CREATE TABLE `place` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.programmer definition --
CREATE TABLE `programmer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stud_id` int DEFAULT NULL,
  `dob` date NOT NULL,
  `doj` date NOT NULL,
  `sex` char(1) NOT NULL,
  `salary` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stud_id` (`stud_id`),
  CONSTRAINT `programmer_ibfk_1` FOREIGN KEY (`stud_id`) REFERENCES `studies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.programmer_prof_xref definition --
CREATE TABLE `programmer_prof_xref` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programmer_id` int NOT NULL,
  `dev_in_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `programmer_id` (`programmer_id`),
  KEY `programmer_prof_xref_dev_in_FK` (`dev_in_id`),
  CONSTRAINT `programmer_prof_xref_dev_in_FK` FOREIGN KEY (`dev_in_id`) REFERENCES `dev_in` (`id`),
  CONSTRAINT `programmer_prof_xref_ibfk_3` FOREIGN KEY (`programmer_id`) REFERENCES `programmer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.software definition --
CREATE TABLE `software` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stud_id` int DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `dev_in_id` int DEFAULT NULL,
  `selling_cost` float NOT NULL,
  `dev_cost` float NOT NULL,
  `sold_qty` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stud_id` (`stud_id`),
  KEY `dev_in_id` (`dev_in_id`),
  CONSTRAINT `software_ibfk_1` FOREIGN KEY (`stud_id`) REFERENCES `studies` (`id`),
  CONSTRAINT `software_ibfk_2` FOREIGN KEY (`dev_in_id`) REFERENCES `dev_in` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.stud_course_xref definition --
CREATE TABLE `stud_course_xref` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `stud_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stud_course_xref_course_FK` (`course_id`),
  KEY `stud_course_xref_studies_FK` (`stud_id`),
  CONSTRAINT `stud_course_xref_course_FK` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  CONSTRAINT `stud_course_xref_studies_FK` FOREIGN KEY (`stud_id`) REFERENCES `studies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `sql-exs`.studies definition --
CREATE TABLE `studies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `place_id` int DEFAULT NULL,
  `course_fee` float NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `place_id` (`place_id`),
  CONSTRAINT `studies_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `place` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- TABLE's DML --
-- COURSE --
INSERT INTO `sql-exs`.course (name) VALUES
	 ('PGDCA'),
	 ('DCA'),
	 ('MCA'),
	 ('DCP'),
	 ('DAP'),
	 ('DCAP'),
	 ('HDCP'),
	 ('DCAnP'),
	 ('DCS');

-- DEV_IN --
INSERT INTO `sql-exs`.dev_in (name) VALUES
	 ('ASSEMBLY'),
	 ('BASIC'),
	 ('C'),
	 ('C++'),
	 ('CLIPPER'),
	 ('COBOL'),
	 ('DBASE'),
	 ('FOXPRO'),
	 ('ORACLE'),
	 ('PASCAL');

-- PLACE --
INSERT INTO `sql-exs`.place (name) VALUES
	 ('Sabhari'),
	 ('COLT'),
	 ('Pragathi'),
	 ('BITS'),
	 ('Apple'),
	 ('Brilliant'),
	 ('BDPS');

-- PROGRAMMER --
INSERT INTO `sql-exs`.programmer (stud_id,dob,doj,sex,salary) VALUES
	 (1,'1966-04-21','1992-04-21','M',3200),
	 (2,'1964-07-02','1990-11-13','M',2800),
	 (3,'1968-01-31','1990-04-21','F',3000),
	 (4,'1968-10-30','1992-01-02','F',2900),
	 (5,'1970-06-24','1991-02-01','F',4500),
	 (6,'1965-09-11','1989-10-11','M',2500),
	 (7,'1965-11-10','1990-04-21','M',2800),
	 (8,'1965-08-31','1990-04-21','M',3000),
	 (9,'1967-05-03','1991-02-28','M',3200),
	 (10,'1967-01-01','1990-12-01','F',2500);
INSERT INTO `sql-exs`.programmer (stud_id,dob,doj,sex,salary) VALUES
	 (11,'1970-04-19','1993-04-20','F',3600),
	 (12,'1969-12-02','1992-01-02','F',3700),
	 (13,'1965-12-14','1992-05-02','F',3500);

-- PROGRAMMER_PROF_XREF --
INSERT INTO `sql-exs`.programmer_prof_xref (programmer_id,dev_in_id) VALUES
	 (1,3),
	 (1,4),
	 (2,5),
	 (2,6),
	 (3,6),
	 (3,7),
	 (4,2),
	 (4,7),
	 (5,8),
	 (5,9);
INSERT INTO `sql-exs`.programmer_prof_xref (programmer_id,dev_in_id) VALUES
	 (6,7),
	 (6,6),
	 (7,3),
	 (7,5),
	 (8,10),
	 (8,2),
	 (9,7),
	 (9,3),
	 (10,4),
	 (10,6);
INSERT INTO `sql-exs`.programmer_prof_xref (programmer_id,dev_in_id) VALUES
	 (11,10),
	 (11,2),
	 (12,3),
	 (12,4),
	 (13,1),
	 (13,2);

-- SOFTWARE --
INSERT INTO `sql-exs`.software (stud_id,title,dev_in_id,selling_cost,dev_cost,sold_qty) VALUES
	 (1,'Parachutes',4,399.95,6000.0,43.0),
	 (1,'Video Titling pack',3,7500.0,16000.0,9.0),
	 (1,'System Software',2,400.0,24000.0,10.0),
	 (3,'Inventory control',6,3000.0,3500.0,0.0),
	 (4,'Payroll package',7,9000.0,20000.0,7.0),
	 (5,'Financial Acc S/W',9,18000.0,85000.0,4.0),
	 (5,'Code Generator',2,4500.0,20000.0,23.0),
	 (7,'Read Me',8,300.0,1200.0,84.0),
	 (8,'Bombs Away',10,750.0,5000.0,11.0),
	 (8,'Vaccines',2,1900.0,3400.0,21.0);
INSERT INTO `sql-exs`.software (stud_id,title,dev_in_id,selling_cost,dev_cost,sold_qty) VALUES
	 (9,'Hotel Management',7,12000.0,35000.0,4.0),
	 (9,'Dead Lee',3,599.95,4500.0,73.0),
	 (11,'PC Utilities',2,725.0,5000.0,51.0),
	 (11,'TSR Help Package',10,2500.0,6000.0,6.0),
	 (12,'Hotel Management',3,1100.0,75000.0,2.0),
	 (12,'Quiz Master',4,3200.0,2100.0,15.0),
	 (13,'ISK Editor',2,900.0,700.0,6.0);

-- STUD_COURSE_XREF --
INSERT INTO `sql-exs`.stud_course_xref (course_id,stud_id) VALUES
	 (1,1),
	 (2,2),
	 (3,3),
	 (4,4),
	 (1,5),
	 (5,6),
	 (6,7),
	 (7,8),
	 (1,9),
	 (8,10);
INSERT INTO `sql-exs`.stud_course_xref (course_id,stud_id) VALUES
	 (9,11),
	 (5,12),
	 (2,13);

-- STUDIES -- 
INSERT INTO `sql-exs`.studies (name,place_id,course_fee) VALUES
	 ('Anand',1,4500.0),
	 ('Altaf',2,7200.0),
	 ('Juliana',4,22000.0),
	 ('Kamala',3,5000.0),
	 ('Mary',1,4500.0),
	 ('Nelson',3,6200.0),
	 ('Partick',3,5200.0),
	 ('Qadir',5,4500.0),
	 ('Ramesh',1,4500.0),
	 ('Rebecca',6,11000.0);
INSERT INTO `sql-exs`.studies (name,place_id,course_fee) VALUES
	 ('Remitha',7,6000.0),
	 ('Revathi',1,5000.0),
	 ('Vijaya',7,48000.0);