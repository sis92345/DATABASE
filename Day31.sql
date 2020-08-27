-- 0827: Day31
REM DATE: 2020년 8월 27일
REM Author: AN 
REM Objective: Basic SQL과 Oracle 함수 학습하기
REM Environment: Windows 10, Oracle SQL Developer, Oracle DataBase 19c Enterorise Ed.

--복습문제 
--사원테이블에서 급여가 1000불이상이고, 부서번호가 30번인 사원의 사원번호, 성명, 담다업무, 급여, 부서번호 출력
SELECT empno AS "사원번호", ename AS "성명", job AS "담당업무", sal AS "급여", deptno AS "부서번호"
FROM emp
WHERE deptno = 30 AND sal >= 1000;
--사번이 7788인 사원의 이름과 급여를 출력하시오.
SELECT name. sal
FROM emp 
WHERE empno = 7788;
--급여가 3000이 넘는 직종을 선택하시오.
SELECT DISTINCT job
FROM emp
WHERE sal >= 3000;
--PRESEDENT를 제외한 사원들의 이름과 직종
SELECT ename AS "이름", sal AS "급여"
FROM   emp
WHERE  job != 'PRESIDENT';
--BOSTON 지역에 있는 부서의 번호와 이름을 출력
SELECT deptno AS "부서번호", dname AS "부서이름"
FROM   dept
WHERE  loc = 'BOSTON';

-- SQL 연산자
-- 1. IN
-- IN을 사용하지 않은 SQL문
SELECT ename, job
FROM emp
WHERE job = 'CLERK' OR job = 'MAMAGER' OR job = 'ANALYST';
-- IN 사용
SELECT ename, job
FROM emp
WHERE job IN ('CLERK', 'MANAGER', 'ANALYST');

SELECT empno, ename, sal, mgr
FROM emp
WHERE mgr IN (7902, 7566, 7788);

SELECT dname
FROM   dept
WHERE  deptno IN (10, 20);

-- 2. BETWEEN A AND B
-- BETWEEN A AND B 안 쓴 경우
SELECT ename, job, sal
FROM emp
WHERE sal >= 1300 AND sal<=1500;

-- BETWEEN A AND B 쓴 경우
SELECT ename, job, sal
FROM emp
WHERE sal BETWEEN 1300 AND 1500;

-- 3. 날짜 형식 다루기
-- DATE 형식은 항상 NLS_DATE_FORMAT 형식에 맞추어야 한다.
SELECT parameter, value 
FROM NLS_SESSION_PARAMETERS; 
--
ALTER SESSION
SET NLS_DATE_FORMAT = 'YYYY-MM-DD';  

SELECT hiredate
FROM emp
WHERE deptno = 10;

--==================
-- 1981년에 입사한 사원의 사번, 이름, 입사날짜를 출력하는 방법 5가지
-- 1. 보통
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '1987-01-01' AND hiredate <= '1987-12-31';
-- 2. BETWEEN 사용
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate BETWEEN '1987-01-31' AND '1987-12-31';
-- 3. LIKE 연산자, WildCard: %, _
--이론
SELECT ename
FROM emp
WHERE ename LIKE 'S____'; -- 와일드카드를 사용할 때는 반드시 LIKE 사용

SELECT ename, job
FROM emp
WHERE job LIKE '%S_'; --%의 위치를 자유롭게 조정 가능
-- 따라서 다음과 같이 하면 된다. (3)
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate LIKE '1987%';

SELECT COUNT(*)
FROM ZIPCODE;

DESC zipcode;
-- 와일드카드 연습
SELECT *
FROM ZIPCODE
WHERE dong LIKE '개포%' AND SIDO = '서울';
--와일드카드의 ESCAPSE: 데이터에 _ 나 %가 들어간다면 EACAPE 활용
SELECT ename
FROM emp
WHERE ename LIKE '$_T%' ESCAPE '$';

--우리회사에서 보너스를 받지 않는 사원 정보를 조회하시오
SELECT *
FROM emp
WHERE comm IS NULL;
--우리회사에서 메니저가 없는 사원을 조회하시오.
SELECT ename, job
FROM emp
WHERE mgr IS NULL;

-- ================
--  정렬
SELECT *    
FROM emp
ORDER BY comm DESC;

--집합 연산자

--테이블 생성: 집합연산자 예제용
CREATE TABLE emp10
AS 
SELECT * FROM emp
WHERE deptno = 10; 

CREATE TABLE emp20
AS 
SELECT * FROM emp
WHERE deptno = 20; 

SELECT *  FROM emp10;
SELECT *  FROM emp20;

-- UNION
SELECT empno, ename, deptno
FROM emp10
UNION
SELECT empno, ename, deptno
FROM emp20;
-- 연습: emp_clerk(직무가 clerk), emp_manager(직무가 manager)
CREATE TABLE emp_clerk
AS
SELECT *
FROM emp
WHERE job = 'CLERK';

CREATE TABLE emp_manager
AS
SELECT *
FROM emp
WHERE job = 'MANAGER';
-- 연습2: UNION을 활용한 emp_tf 테이블 생성, 각 사원의 사번, 이름, 직무만으로 구성된 두개의 테이블을 합쳐라
CREATE TABLE emp_tf
AS
SELECT  empno, ename, job
FROM emp
WHERE job = 'CLERK'
UNION
SELECT empno, ename, job
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM emp_tf;

--MINUS
SELECT ename, job
FROM emp       --14명
MINUS
SELECT ename, job
FROM emp_clerk; --4명

--INTERSECT
SELECT ename, job
FROM emp       --14명
INTERSECT
SELECT ename, job
FROM emp_clerk; --4명

-- 위에서 만든 테이블 삭제 ㄱㄱ

--P.125 문제
--1
SELECT *
FROM emp
WHERE ename LIKE '%S';
--2
SELECT empno, ename, job, deptno
FROM emp
WHERE deptno = 30 AND job = 'SALESMAN';
--3
--3-1 집합연산자 X
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno IN (20, 30) AND sal > 2000;
--3-2 집합연산자 사용:
SELECT empno, ename, sal, deptno
FROM emp 
WHERE sal > 2000
MINUS
SELECT  empno, ename, sal, deptno
FROM emp 
WHERE deptno NOT IN (20, 30);
--4
SELECT *
FROM emp
WHERE NOT(sal >= 2000 AND sal <= 3000);
--5
SELECT ename, empno, sal, deptno
FROM emp
WHERE (sal NOT BETWEEN  1000 AND 2000) AND ename LIKE '%E%';
--6
SELECT *
FROM emp
WHERE comm is null AND job IN ('MANAGER', 'CLERK') AND mgr IS NOT NULL AND NOT ename = '_L%';
--6-1 위에꺼 집합 연산으로
SELECT *
FROM emp
WHERE comm is null
INTERSECT
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK')
INTERSECT
SELECT *
FROM emp
WHERE mgr IS NOT NULL
INTERSECT
SELECT *
FROM emp
WHERE NOT ename = '_L%';
/




