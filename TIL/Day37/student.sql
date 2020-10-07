CREATE TABLE Student
(
	hakbun     CHAR(7)			PRIMARY KEY,
	name		VARCHAR2(20)		NOT NULL,
	kor		NUMBER(3,0)		NOT NULL,
	eng		NUMBER(3,0)		NOT NULL,
	mat		NUMBER(3,0)		NOT NULL,
	tot		NUMBER(3,0),
	avg		NUMBER(5,2),
	grade		CHAR(1)
);