--Day39, 0922
--DDL
--CREATE
--환자관리 프로그램의 테이블
--번호, 진료코드, 입원일수, 나이, 진찰부서, 진찰비, 입원비, 진료비
CREATE TABLE Patient(
    bunho      NUMBER(1), --1, 2,
    code       CHAR(2), -- MI
    days        NUMBER(3),
    age        NUMBER(3),   
    department VARCHAR(20),
    jinchalfee NUMBER(4),
    ipwonfee,  NUMBER(7),
    total      NUMBER(7)
);
--급여관리 프로그램
-- 사번, 급, 호, 수당, 지급액, 세금, 차인지급액
CREATE TABLE Employee(
    empno   NUMBER(4),
    grade   NUMBER(2),
    ho      NUMBER(2),
    sudang  NUMBER(4),
    money   NUMBER(7),
    tax     NUMBER(3,2), --0.13, 1.05    
    sal     NUMBER(7)
);

-- 챕터 10용 테이블 삭제
DROP TABLE chap10hw_dept;
DROP TABLE chap10hw_emp;
DROP TABLE chap10hw_salgrade;
DROP TABLE emp_copy;
DROP TABLE Student1;
DROP TABLE member;
--기존 테이블 열 구조와 데이터를 복사하여 새 테이블을 생성
CREATE TABLE emp_copy
AS 
SELECT * FROM emp; -- emp table의 구조와 데이터를 그대로 복사한다. 단, 제약조건은 복사되지 않는다.
DESC emp_copy; --기본 emp 테이블의 NUT NULL은 나오지 않는다. 
DESC emp;
--기존 테이블의 열 구조와 일부 데이터만 복사하여 새 테이블 생성
--10번 부서만 들어있는 테이블을 생성
CREATE TABLE emp10
AS
SELECT * 
FROM emp
WHERE deptno = 10;
--직무가 SALESMAN인 사람들만 들어있는 테이블 생성하되, 사번, 이름, 직무, 봉급, 입사날짜만 생성
CREATE TABLE emp_salsman
AS
SELECT empno, ename, job, sal, hiredate
FROM emp
WHERE job = 'SALESMAN';
SELECT *
FROM emp_salsman;
--예제: 테이블을 생성하되, 사번, 이름, 부서이름, 위치, 부서번호를 포함하는 테이블을 생성하되, 단 부서번호가 10번과 20번만
CREATE TABLE emp_dept
AS
SELECT empno, ename, dname, loc, deptno
FROM emp e INNER JOIN dept d USING(deptno)
WHERE deptno IN (10,20)
ORDER BY deptno ASC;
SELECT * FROM emp_dept;
--기존열 테이블의 열 구조만 복사하여 새 테이블 생성
--조건이 언제나 false이도록 작성하면 된다.
CREATE TABLE emp_empty
AS
SELECT * FROM emp
WHERE 1 = 0; --구조만 복사
SELECT * FROM emp_empty;
--예제
--테이블을 복사해서 생성하되, 데이터는 복사하지 말고, 구조만 복사하라, 사번, 이름, 직무, 부서이름, 부서위치, 부서번호로 생성
CREATE TABLE emp_dept1
AS
SELECT empno, ename, job, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE 1 < 0;

--RENAME 
--RENAME oldname TO newname
SELECT * FROM emp_copy;
RENAME emp_copy TO emp_boksa;
SELECT * FROM emp_boksa;

--TRUCATE
TRUNCATE TABLE emp_boksa;

--DROP
DROP TABLE emp_boksa;
--주의점: 외래 키에의해 참조되는 고유/기본 키가 테이블에 있으면 삭제할 수 없다.
--즉 자식 테이블이 참조하고 있으면 삭제가 안된다.
--따라서 다음의 명령어는 삭제가 불가능하다.
DROP TABLE dept;

--COMMENT
COMMENT ON TABLE emp_boksa IS '이 테이블은 EMP 테이블을 복사한 테이블입니다.';
--COMMENT 확인
DESC USER_tab_comments;
--반드시 주석을 달았다면 Dictionary에서 확인하자
SELECT table_name, table_type, comments
FROM user_tab_comments
WHERE table_name = upper('emp_boksa');

--COLUMN COMMENTS
COMMENT ON COLUMN emp_boksa.hiredate IS '입사날짜를 저장하는 칼럼';
--컬럼 주석 확인
DESC USER_COL_COMMENTS;
SELECT table_name, column_name, comments
FROM user_col_comments
WHERE table_name = upper('emp_boksa');


--ALTER TABLE: table remodeling
--사전작업
DROP TABLE emp_boksa;
DROP TABLE emp_dept;
DROP TABLE emp_empty;
DROP TABLE emp_salsman;
DROP TABLE emp_copy;
SELECT * FROM emp_copy10;
CREATE TABLE emp_copy10
AS
SELECT empno, ename
FROM emp
WHERE deptno = 10;
--add
DESC emp_copy10;
--Job Column을 추가
ALTER TABLE emp_copy10
ADD (job VARCHAR2(9));
--열을 새로 추가하면 기존 데이터의 새로 추가한 열의 값은 NULL값이다.
--입사날짜 추가
ALTER TABLE emp_copy10
ADD (hiredate DATE);
--월급 추가
ALTER TABLE emp_copy10
ADD (sal NUMBER(7,2));

--RENAME
ALTER TABLE emp_copy10 
RENAME COLUMN sal TO salary;

--MODIFY
DESC emp_copy10;
--ename VARCHAR(10)의 길이를 변경
ALTER TABLE emp_copy10
MODIFY ename VARCHAR(20);
--job VARCHAR(10)의 길이를 변경
ALTER TABLE emp_copy10
MODIFY job VARCHAR(10);

ALTER TABLE emp_copy10
MODIFY empno NUMBER(5,0);
--기본의 데이터 길이를 줄일 경우: 제한 --확인
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES(55555, '한지민', '배우배우배우', SYSDATE); --이미 더 긴 행이 있으므로 값을 변경할 수 없다.
ALTER TABLE emp_copy10
MODIFY job VARCHAR(10);

--CHAR와 VARCHAR2 간은 변환이 가능하다
ALTER TABLE emp_copy10
MODIFY job CHAR(30);

--DROP
ALTER TABLE emp_copy10
DROP COLUMN job;

--DDL 문제
--Q1. 다음의 열 구조를 가지는 EMP_HW 테이블을 만드시오
CREATE TABLE EMPHW(
    empno       NUMBER(4),
    ename       VARCHAR2(10),
    job         VARCHAR2(10),
    mgr         NUMBER(4),
    hiredate    DATE,
    sal         NUMBER(7,2),
    comm        NUMBER(7,2),
    deptno      NUMBER(2)
);
SELECT TABLE_NAME FROM USER_TABLES
WHERE TABLE_NAME = 'EMPHW';

--Q2. EMP_HW 테이블에 BIGO열을 추가하라.BIGO 열의 자료형은 가변형 문자열이고 길이는 20이다.
ALTER TABLE EMPHW
ADD (BIGO VARCHAR2(20));

--Q3. EMPHW테이블의 BIGO열 크기를 30으로 변경하라
ALTER TABLE EMPHW
MODIFY BIGO VARCHAR(30);
DESC EMPHW;

--Q4. EMPHW테이블의 BIGO 열 이름은 RWMARK로 변경하라
ALTER TABLE EMPHW
RENAME COLUMN BIGO TO REMARK;

--Q5. EMPHW 테이블에 EMP 테이블의 데이터를 모두 저장하라 단 REMARK 열은 NULL로 처리하라
--서브쿼리 + INSERT
--VALUES대신 서브쿼리 사용 가능
--암시적인 방법
INSERT INTO EMPHW(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp;
--명시적인 방법
INSERT INTO EMPHW(empno, ename, job, mgr, hiredate, sal, comm, deptno, remark)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno, NULL
FROM emp;

--Q5. EMPHW 테이블을 삭제하시오
DROP TABLE EMPHW;

SELECT *
FROM Student
WHERE hakbun = '2020-01';