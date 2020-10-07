--Day44, 0929
--DML
--CREATE USER
ALTER SESSION SET "_ORACLE_SCRIPT"=True; --Oracle 12c 이상은 세션을 시작할 때 마다 반드시 해야 한다
--일반 유저는 사용자를 생성할 권리가 없다.
CREATE USER Jimin
IDENTIFIED BY Jimin;

--시스템 권한 확인
DESC DBA_SYS_PRIVS;
SELECT GRANTEE, PRIVILEGE, ADMIN_OPTION
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'JIMIN';

--객체 권한 :scott
SHOW USER;

GRANT SELECT --SELECT권한 부여
ON scott.emp --scott계정의 emp을
TO jimin; --jimin에게 

GRANT DELETE, UPDATE, INSERT, SELECT
ON scott.emp_clerk
TO jimin;

REVOKE SELECT ON emp FROM jimin;

--객체 권한 확인
SELECT * FROM USER_TAB_PRIvS_MADE; --권한을 부여한 사람 기준

--ROLE
--1. level1이라는 Roll생성
CREATE ROLE level1;

--2. level1에 권한 생성
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO level1;

--3. test1/tiger, test2/tiger 계정 생성
CREATE USER test1
IDENTIFIED BY tiger
DEFAULT tablespace users
temporary tablespace temp;

CREATE USER test2
IDENTIFIED BY tiger
DEFAULT tablespace users
temporary tablespace temp;

--4. 사용자 test1/2에게 level1을 부여
GRANT level1 TO test1;

GRANT level1 TO test2;

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE IN ('LEVEL1');

--5. 권한 회수
REVOKE level1 FROM test1;
REVOKE level1 FROM test2;

--6. ROLE 삭제
DROP ROLE level1;

--DML 문제
--Q1. 다음 조건을 만족하는 SQL문을 작성하시오
CREATE USER PREV_HW
IDENTIFIED BY ORCL
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE temp;

GRANT CONNECT TO PREV_HW;

--Q2. SCOTT 계정으로 접속하여 위에서 생성한 PREV_HW 계정에 SCOTT 소유의 EMP, DEPT, SALGRADE테이블에 SELECT 권한을 부여하는 SQL문을 작성
GRANT SELECT
ON scott.emp
TO PREV_HW;
GRANT SELECT
ON scott.dept
TO PREV_HW;
GRANT SELECT
ON scott.salgrade
TO PREV_HW;
--
GRANT SELECT 
ON scott.emp, scott.dept, scott.salgrade
TO PREV_HW;

--Q3. SCOTT 계정으로 접속하여 PREV_HW 계정에 SALGRADE 테이블의 SELECT 권한을 취소하는 SQL문을 작성하라, 확인되면 SALGRADE 테이블의 조회 여부를 확인
REVOKE SELECT
ON scott.salgrade
FROM PREV_HW;


--SYNONYM
CREATE SYNONYM mySynonym
FOR scott.emp; --일반 유저는 SYNONYM을 생성할 수 있는 권한이 없다.
--사용
SELECT *
FROM emp;
SELECT *
FROM mySynonym;
--권한 부여
GRANT CREATE SYNONYM TO SCOTT; -- 비공개 Synonym 생성 권한 부여
GRANT CREATE PUBLIC SYNONYM TO SCOTT; -- 공개 Synonym 생성 권한 부여

--JIMIN계정에 시노님으로 SELECT권한 부여 --> 보안성 증가
GRANT SELECT
on scott.mySynonym
to jimin;

--PUBLIC SYNONYM: 예도 SELECT권한 필요
--일반 SYNONYM과 다르게 다른 계정에서 사용할 때 소유자를 적지 않아도된다.
CREATE PUBLIC SYNONYM department
FOR dept;

GRANT SELECT
ON department
TO jimin;

