--Day43,0928
--서브쿼리
--서브쿼리의 장점: SELECT문을 2번 안해도 된다.
SELECT sal
FROM emp
WHERE ename = 'JONES';

SELECT *
FROM emp
WHERE sal > 2975;
--
SELECT *
FROM emp
WHERE sal > (SELECT sal FROM emp WHERE ename = 'JONES');


----단일행 서브쿼리: MAX, MIN, AVG같이 서브쿼리의 결과가 하나의 행으로 반환
SELECT *
FROM emp
WHERE hiredate < (SELECT  hiredate FROM emp WHERE ename = 'MILLER'); --결과가 하나로 반환

SELECT empno, ename, job, deptno, dname, loc
FROM emp NATURAL JOIN dept --NATURAL JOIN, JOIN ~ USING을 사용하면 식별자 사용 불가
WHERE deptno = 20 AND sal > (SELECT AVG(sal) FROM emp);

----다중행 서브쿼리: 서브 쿼리의 결과가 여러 행으로 반환, 예를 들어 서브쿼리의 조건이 10번 부서의 봉급이라면 여러 행으로 반환
--1.서브쿼리의 SELECT문의 결과 행 수는 함께 사용하는 메인쿼리의 연산자 종류와 호환 가능해야 한다.
--IN, ANY, SOME, ALL, EXISTS
--예:  IN (2975,3000,2000),, ALL (2975,3000,2000)

--ANY, SOME: 메인 쿼리 조건식을 만족하는 서브 쿼리의 결과가 하나 이상이면TRUE
--즉 ANY는 sal > ANY (2075, 3000, 2100)에서 sal이 2100이상이라면 true, 그런데 IN은 2101이라면 FALSE 
-- < ANY: 최대값보다 작은
-- = ANY: IN과 동일
-- > ANY: 최대값보다 큰
--sal >   (SELECT MIN(sal) 오류, 다중행 서브쿼리인데 메인 쿼리에 단일행 연산자 사용
  --  FROM emp
 --   GROUP BY deptno); --결과가 3개행이므로 다중행 서브쿼리
SELECT *
FROM emp
WHERE sal IN (SELECT MIN(sal) FROM emp GROUP BY deptno); -- 각 부서 최소 월급
SELECT *
FROM emp
WHERE sal = ANY (SELECT MIN(sal) FROM emp GROUP BY deptno); --IN과 동일
SELECT *
FROM emp
WHERE sal > ANY (SELECT MIN(sal) FROM emp GROUP BY deptno); -- 월급이 850보다 많은 사람

--ALL: 메인쿼리의 조건식을 서브쿼리의 결과가 모두 만족하면 TRUE
SELECT empno, ename, job, sal
FROM emp
WHERE sal > ALL (SELECT sal FROM emp WHERE job = 'CLERK'); --월급이 1300보다 많은 사람
SELECT empno, ename, job, sal
FROM emp
WHERE sal < ALL (SELECT sal FROM emp WHERE job = 'CLERK'); --월급이 800보다 많은 사람

--EXISTS: 서브쿼리에 결과값이 하나 이상 존재하면 TRUE
--자주 사용하지은 않는다.

--서브쿼리의 주의점
--1.서브쿼리의 SELECT문의 결과 행 수는 함께 사용하는 메인쿼리의 연산자 종류와 호환 가능해야 한다!!!!!!
--예를 들어 WHERE절에 사용한 서브쿼리 SELECT의 결과가 한개로 나오는데 메인쿼리 WHERE절에 IN을 사용한다면 오류
--따라서 복수행 서브쿼리는 다중행 연산자를 사용해야 한다: --IN, ANY, SOME, ALL, EXISTS

--2.대부분의 서브쿼리에서는 ORDER BY절을 사용할 수 없다.

--다중열 서브쿼리
--사원번호가 7396, 7499와 같은 상사와 부서번호를 갖는 모든 사원의 번호와 상사번호 및 부서번호를 출력, 단 7469, 7499는 제외
SELECT empno, ename, mgr, deptno
FROM emp
WHERE   (mgr, deptno)IN (SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN (7369, 7499)) AND empno NOT IN (7369, 7499);
                         
--FROM절에 사용하는 인라인 뷰
--가독성을 위해 WITH 절을 사용한다.

--서브쿼리를 이용한 INSERT
--서브쿼리를 이용하여 INSERT를 할때는 매핑을 해야하고 VALUES를 사용 안함을 주의
INSERT INTO emp_copy(empno, ename, sal, job)
SELECT empno, ename, sal, job
FROM emp 
WHERE deptno = 30;
--문제
--Q1. 전체사원 중 ALLEN과 같은 직책인 사원들의 사원 정보, 부서 정보를 출력
SELECT *
FROM emp INNER JOIN dept USING(deptno)
WHERE job = (SELECT job FROM emp WHERE ename = 'ALLEN');
--Q2. 전체 사원의 평균 급여보다 높은 급여를 받는 사원들의 사원 정보, 부서 정보, 급여 등급 정보를 출력하는 SQL문을 작성하라
--단 월급은 내림차순 정렬, 같은 월급은 사번을 오름차순 정렬
SELECT job, empno, ename, sal, deptno, dname, grade
FROM emp NATURAL JOIN dept 
     INNER JOIN salgrade ON sal BETWEEN losal AND hisal
WHERE sal > (SELECT AVG(sal) FROM emp)
ORDER BY sal DESC, empno ASC;
--Q3. 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원정보, 부서 정보를 출력
SELECT *
FROM emp NATURAL JOIN dept
WHERE deptno = 10 AND job NOT IN (SELECT job FROM emp WHERE deptno = 30);
--Q4. 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원정보, 급여 등급 정보를 다음과 같이 출력하는 SQL문 작ㄱ성
--다중행 함수 이용 X
SELECT empno, ename, sal ,grade
FROM emp INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE sal > (SELECT MAX(sal) FROM emp WHERE job = 'SALESMAN')
ORDER BY empno;
--다중행 함수
SELECT empno, ename, sal ,grade
FROM emp INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE sal > ALL (SELECT sal FROM emp WHERE job = 'SALESMAN')
ORDER BY empno;

SELECT *
FROM emp;

--트랜잭션
--ROLLBACK
--일반 ROLLBACK
COMMIT; --14:50
INSERT INTO emp(empno, ename, hiredate)
VALUES(7777, '한지민', SYSDATE);

UPDATE emp
SET sal = sal * 1.1
WHERE ename = 'SMITH';

DELETE FROM emp
WHERE ename = 'SCOTT';

ROLLBACK; --14:50 COMMIT;로 이동

--RALLBACK USING SAVEPOINT
COMMIT; --14:52
INSERT INTO emp(empno, ename, hiredate)
VALUES(7777, '한지민', SYSDATE);

UPDATE emp
SET sal = sal * 1.1
WHERE ename = 'SMITH';

SAVEPOINT b;

DELETE FROM emp
WHERE ename = 'SCOTT';

ROLLBACK TO b; -- SAVEPOINT b로 이동 --> DELETE만 취소됨

--JDBC BATCH 실습용
DESC emp_copy;
ALTER TABLE emp_copy
DROP CONSTRAINT emp_temp_hiredate_NN;
DESC emp_temp; --테이블 만들면 제약조건 날라감 
TRUNCATE TABLE emp_copy;
DROP TABLE emp_temp;
CREATE TABLE emp_temp 
AS
SELECT *
FROM emp
WHERE 1 < 0;
ALTER TABLE emp_copy
ADD CONSTRAINT emp_copy_empno_PK PRIMARY KEY(empno);
ALTER TABLE emp_copy
MODIFY hiredate DATE DEFAULT SYSDATE CONSTRAINT emp_temp_hiredate_NN NOT NULL; --NOT NULL은 컬럼레벨 제약 조건
