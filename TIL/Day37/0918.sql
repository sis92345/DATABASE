--0918. DAY37
--emp 테이블을 복사
CREATE TABLE emp_copy 
AS 
SELECT *
FROM emp; --14rows, 8colums
-- 스키마 구조만 복사
CREATE TABLE emp_copy
AS
SELECT *
FROM emp
WHERE 0 > 1; --WHERE이 거짓이되면 이 조건에 맞는 데이터가 없기에 스키마만 카피

SELECT * 
FROM emp_copy;

--DML
--INSERT

INSERT INTO emp_copy(empno, ename, mgr, hiredate)
VALUES (8001,'CHULSU', 7369, SYSDATE);

INSERT INTO emp_copy(empno, ename, job, sal)
VALUES(8002, 'YOUNGHEE', 'DESIGNER', 1500);

DROP TABLE emp_copy;

INSERT INTO emp_copy(empno, ename, sal, comm, deptno)
VALUES (1111, 'CHULSU', 800, 100, 40);

INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (2222, 'HANJIMIN', 'DEVELOPER', SYSDATE);

--개수가 일치하지 않는 경우 오류
--INSERT INTO emp_copy(empno, ename, job, hiredate)
--VALUES (2222, 'HANJIMIN', SYSDATE);

--empno는 NUMBER지만 문자열 입력해도 자동형변환이 되어 입력된다.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES ('2223', 'HANJIMIN', 'MARKETTER',SYSDATE);


--empno는 NUMBER지만 문자열 입력해도 자동형변환이 되어 입력된다. --단 데이터 타입이 아예 다른 경우는 자동형변환이 안된다.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES ('hale', 'HANJIMIN', 'MARKETTER',SYSDATE);

-- 데이터에 들어갈 수 있는 사이즈를 유의하자
SELECT LENGTH(ename), LENGTHB('안녕')
FROM emp_copy;

INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (4444, '이데이터는사이즈를초과합니다', 'MARKETTER',SYSDATE);

--NULL 처리
--암시적인 방법
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (4444, 'HOJUNE', 'MARKETTER',SYSDATE); -- 나머지 4개 열은 자동으로 NULL 처리
--명시적인 방법
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (5555, UPPER('girlsday'), NULL ,NULL); -- empno와 null을 제와한 나머지는 전부 NULL

--INSERT 날자형 데이터 입력
INSERT INTO emp_copy(empno, ename, hiredate)
VALUES (6666, 'BTS', TO_DATE('01-02-2019', 'MM-DD-YYYY')); -- '2019-01-02'? '01-02-2019'? --> 날짜형 데이터에는 NLS_DATE_FORMET을 알아야 한다.
--일 두번 하지 않으려면 TO_DATE를 사용

--Foreign Key에 유의해야 한다.
SELECT deptno FROM dept;

INSERT INTO emp(empno, ename, deptno)
VALUES (8888, 'JIMIN', 77); -- deptno는 Foreign Key,deptno에는 77번이 없다.

DROP TABLE emp_copy;


----UPDATE
SELECT *
FROM emp_copy;

--UPDATE 형식
--WHERE절을 사용하지 않으면 테이블 내 지정된 모든 열의 데이터가 수정된다.
UPDATE emp_copy
SET deptno = 10; -- 모든 행의 deptno가 10으로 수정된다.

--조건을 사용해서 일부 행만 수정하기
UPDATE emp_copy 
SET sal = 1000
WHERE empno <= 3000;

UPDATE emp_copy
SET sal = 2000
WHERE ename = 'JIMIN';

--일부 열을 수정하기
UPDATE emp_copy 
SET job = 'DESIGNER', mgr = 3333, sal = 3000, deptno = 20 -- 순서는 상관 없다.
WHERE empno = 4444;

--1. 수정하려는 열의 갯수 파악(전체, 일부, 단 하나) --> WHERE 조건절에 따라 결정
--2. 수정하려는 컬럼의 갯수 파악(전체 칼럼 변경은 없다. 단 한개의 컬럼, 일부 컬럼을 변경할 것인가?) --> 쉼표(,)를 사용할 것인가?

--UPDATE에서 무결성 제약 조건
UPDATE emp
SET deptno = 98949
WHERE ename = 'SMITH';

UPDATE emp_copy
SET mgr = 3333, sal = 1500, comm = 100
WHERE empno = 5555;

COMMIT;
--DELETE
--모든 데이터 삭제
DELETE FROM emp_copy;

ROLLBACK;

DELETE FROM emp_copy 
WHERE empno = 2222;

--10장 문제
-- 
CREATE TABLE CHAP10HW_EMP AS SELECT * FROM emp;
CREATE TABLE CHAP10HW_DEPT AS SELECT * FROM dept;
CREATE TABLE CHAP10HW_SALGRADE AS SELECT * FROM salgrade;
DROP TABLE CHAP10HW_SALGRADE;
--Q1 CHAP10HW_DEPT테이블에 50,60,70,80번 부서를 등록
INSERT INTO CHAP10HW_DEPT 
VALUES(50, 'ORACLE', 'BUSAN');

INSERT INTO CHAP10HW_DEPT 
VALUES(60, 'SQL', 'ILSAN');

INSERT INTO CHAP10HW_DEPT 
VALUES(70, 'SELECT', 'INCHEON');

INSERT INTO CHAP10HW_DEPT 
VALUES(80, 'DML', 'BUNDANG');

SELECT * FROM CHAP10HW_DEPT;

--Q2 CHAP10HW_EMP 테이블에 2명의 사원을 입력하시오
--명시적 NULL처리
INSERT INTO CHAP10HW_EMP
VALUES(7201, 'TEST_USER1', 'MANAGER', 7788, TO_DATE('2016-01-02','YYYY-MM-DD'), 4500, NULL, 50);
--암시적 NULL처리
INSERT INTO CHAP10HW_EMP(empno, ename, job, mgr, hiredate, sal, deptno)
VALUES(7202, 'TEST_USER2', 'CLERK', 7201, TO_DATE('2016-02-21','YYYY-MM-DD'), 1800, 50);

SELECT * FROM CHAP10HW_EMP;
--Q3 CHAP10HW_EMP에 속한 사원 중 50번 부서에서 근무하는 사원들의 평균 급여보다 많은 급여를 받고있는 사원들을 70번 부서로 옮기는 SQL문 작성
--서브쿼리 미사용으로 할 것
SELECT AVG(sal)
FROM CHAP10HW_EMP
WHERE deptno = 50;

UPDATE CHAP10HW_EMP
SET deptno = 70
WHERE sal > 3150;

ROLLBACK;

--Q4.(수정) 20번 부서의 사원 중 입사일이 가장 늦은 사원보다 더 늦게 입사한 사원의 급여를 10% 인상하고 80번 부서로 옮겨라
UPDATE CHAP10HW_EMP
SET sal = sal * 1.1, deptno = 80
WHERE hiredate > (SELECT MAX(hiredate)FROM CHAP10HW_EMP WHERE deptno = 20);

--Q5. CHAP10HW_EMP에 속한 사원 중, 급여 등급이 5인 사원을 삭제하는 SQL문 작성
DELETE FROM CHAP10HW_EMP
WHERE empno IN (SELECT e.empno FROM CHAP10HW_SALGRADE INNER JOIN CHAP10HW_EMP e ON e.sal BETWEEN losal AND hisal  WHERE grade = 5); 

SELECT ename, grade 
FROM CHAP10HW_SALGRADE INNER JOIN CHAP10HW_EMP e ON e.sal BETWEEN losal AND hisal  
WHERE grade = 5;

SELECT *
FROM CHAP10HW_EMP;


--student 테이블 입력용
INSERT INTO student
VALUES('2020-01', '한지민', 100, 100, 100, 300, 100.00, 'A');
commit; --COMMIT 해야함 --> 그래야 JDBC 이용 가능