SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD'), 
      TO_CHAR(NEXT_DAY(ADD_MONTHS(hiredate, 3), '월요일'), 'YYYY-MM-DD') AS "R_Job",
      NVL(TO_CHAR(COMM), 'N/A') AS "COMM" --COMM이 숫자형이기 때문에 대치할 문자는 숫자형이어야 한다. 따라서 두 타입을 일치해야 한다.
FROM emp;

--그룹함수, 다중행함수
--그룹함수, 다중행함수는 여러행을 단일 행 결과로 보여준다.
--그룹함수, 다중행함수는 여러행을 결과로 보여주는 함수와 같이 사용할 수 없다. 즉
SELECT empno, SUM(sal)
FROM emp;
--는 오류가 난다.
--그룹함수, 다중행함수는 NULL값을 무시한다.
SELECT AVG(comm), AVG(NVL(comm,0))
FROM emp;
-- AVG(comm)는 NULL을 제외하기 때문에  AVG(NVL(comm,0))와 분모가 달라진다.
--단 COUNT(*)은 NULL을 포함한다.
--COUNT(*)에 NULL을 제외하려면 WHERE절에 조건을 포함하면 된다.
SELECT COUNT(DISTINCT comm)
FROM emp
WHERE comm IS NOT NULL;

--
SELECT MAX(hiredate)
FROM emp
WHERE deptno = 20;

-- 다중행 함수의 예
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 10
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 30;

-- GROUP BY: 내용은 0915.md를 볼 것
SELECT deptno, SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;

SELECT deptno,job ,TRUNC(AVG(sal)),MIN(sal), MAX(sal), COUNT(*)
FROM emp
GROUP BY deptno, job -- 부서별 그룹화
ORDER BY deptno, job;

SELECT department_id,job_id,COUNT(salary), TRUNC(AVG(salary))
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;

--단일행 함수와 다중행함수는 함께 사용할 수 없지만 GROUP BY 기준은 사용할 수 있다.
SELECT deptno, SUM(sal) --ename은 GROUP BY의 기준이 아닌 단일행이므로 SELECT절에서 사용할 수 없다.
FROM emp
GROUP BY deptno;

--HAVING
--HAVING: GROUP BY로 그룹화한 데이터에 대한 조건문이다.
SELECT deptno,job, TRUNC(AVG(sal))
FROM emp
WHERE deptno IN (10, 20)
GROUP BY deptno, job
HAVING job = UPPER('manager');

SELECT deptno, TRUNC(AVG(sal))
FROM emp
GROUP BY deptno
HAVING TRUNC(AVG(sal)) >= 2000;

--HAVING을 사용하는 이유
SELECT deptno, COUNT(*), SUM(sal)
FROM emp
--WHERE COUNT(*) >= 4 _WHERE절에서는 그룹함수를 사용할 수 없다.
GROUP BY deptno; 
HAVING COUNT(*) >= 4 --따라서 HAVING에 그룹함수를 사용

--예
--사원테이블에서 업ㅂ무별 급여의 평균이 3000불 이상인 업무에 대해, 업무명, 평균급여, 급여의 합을 구하시오
SELECT job, AVG(sal), SUM(sal)
FROM emp
GROUP BY job
HAVING AVG(sal) >= 3000;
--사원테이블에서 전체 월급이 5000불을 초과하는 각 업무에 대해 업무이름과 월 급여의
--합계를 출력하라. 단, 판매원은 제외하고 월급여 합계의 내림차순으로 출력하라.
SELECT job, SUM(sal)
FROM emp
WHERE job NOT LIKE 'SA%'
GROUP BY job
HAVING SUM(sal) > 5000
ORDER BY SUM(sal) DESC;

--ROLLUP, CUBE
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;
--위 SQL의 SUM(sal)은 job을 모두 합친 sal이나온다. 하지만 ROLLUP을 사용하면
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY ROLLUP(deptno, job)
ORDER BY deptno, job;
-- ROLLUP은 부분합을 계산해준다. 결과를 확인하자

SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;
--위 SQL의 SUM(sal)은 job을 모두 합친 sal이나온다. 하지만 ROLLUP을 사용하면
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY CUBE(deptno, job)
ORDER BY deptno, job;

--P.212~213 문제
--1. 사원테이블을 이용해서 부서번호, 평균 급여, 최고 급여, 최저 급여, 시원수를 출력
--3. 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력하시오
SELECT TO_CHAR(hiredate, 'YYYY') AS "HIRE_DATE", deptno, COUNT(*) AS "CNT"
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY'), deptno;

--아래의 결과와 왜 다른지 질문하기
--SELECT TO_CHAR(hiredate, 'YYYY'), deptno, COUNT(*)
--FROM emp
--GROUP BY hiredate, deptno;
--4. 추가수당을 받는 사원의 수와 받지 않는 사원의 수를 출력하시오
SELECT NVL2(comm,'O', 'X') AS "EXIST _COMM", COUNT(*)
FROM emp
GROUP BY NVL2(comm,'O', 'X'); --NVL2는 데이터형이 일치하지 않아도 된다.
--5. 각 부서의 입사 연도별 사원 수, 최고 급여, 급여 합, 평균 급여를 출력하고 각 부서별 소계와 총계를 출력하시오
SELECT deptno, hiredate, SUM(sal), ROUND(AVG(sal),1)
FROM emp
GROUP BY ROLLUP(deptno,hiredate);

-- 5-1 .GROUP FUNCTION 실습.pdf
--5. emp table에 등록되어 있는 인원수, 보너스가 NULL이 아닌 인원수, 보너스의
--전체평균, 등록되어 있는 부서의 수를 구하여 출력하시오.
SELECT COUNT(*), COUNT(comm), AVG(comm),ROUND(AVG(NVL(comm,0))), ROUND(SUM(comm)/14), ROUND(SUM(comm)/4), COUNT(deptno) 
--COUNT()를 제외한 나머지 그룹함수는 NULL을 제외: 분모가 달라짐을 유의
FROM emp;
--8. 각 부서별 같은 업무를 하는 사람의 인원수를 구하여 부서번호, 업무명, 인원수를
--출력하시오. 같은 업무를 하는 == 업무별
SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY deptno, job;

SELECT parameter, value
FROM NLS_SESSION_PARAMETERS;

--조인
-- 1. 교차조인, CROSS JOIN, Cartesian Product, 데카르트 곱
-- 비표준 교차 조인
SELECT empno, ename, sal, dname, loc, emp.deptno
FROM emp, dept;
-- 표준 교차 조인
SELECT empno, ename, sal, dname, loc, emp.deptno
FROM emp CROSS JOIN dept;

--조인에서 별칭 사용
SELECT empno, ename, sal, dname, loc, e.deptno
FROM emp e, dept d;

--2. 등가조인, Equi Join, 내부조인, 단순조인
-- 스미스는 어느 위치에 있는 어느 부서에서 일하는가?
-- 어느 부서?
SELECT ename, deptno
FROM emp
WHERE ename = 'SMITH';
-- 어느 위치?
SELECT deptno, loc
FROM dept
WHERE deptno = 20;
-- 즉 어느 부서 = emp 테이블, 그 부서의 위치 = dept 테이블
-- 위 두개의 결과를 하나의 SELECT문으로 표현하기 위해서 등가조인을 사용
-- 비표준 등가조인
SELECT empno, ename, sal, dname, loc, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.ename = 'SMITH'; -- 조건에서 =을 사용했다고 해서 등가조인이다. 즉 =을 안쓰면 비등가조인
--*표준 등가 조인: 조인의 조건을 FROM절에서 사용한다.
SELECT empno, ename, sal, dname, loc, d.deptno
FROM emp NATURAL JOIN dept
WHERE e.ename = 'SMITH'; -- 이 조건은 조인의 조건이 아니다.



SELECT e.empno,e.deptno
FROM dept d CROSS JOIN emp e;














