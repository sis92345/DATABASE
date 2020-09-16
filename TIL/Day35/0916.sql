--0916, Day35
SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY deptno, job
ORDER BY deptno;
--교차조인, CROSS JOIN, Cartesian Product
--비표준 조인
SELECT empno, ename, job, dname, loc, dept, deptno
FROM emp, dept, salgrade; -- 280개 
--표준 조인
SELECT empno
FROM emp CROSS JOIN dept CROSS JOIN salgrade CROSS JOIN bonus ;

-- 등가조인(Equi Join), Inner Join, Simple JOin, Natural Join, Join ~ on, Join Using
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
-- 위 두개의 결과를 하나의 SELECT문으로 표현하기 위해서 등가조인을 사용: 스미스는 어느 위치에 있는 어느 부서에서 일하는가?
SELECT ename, emp.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'SMITH';
-- 사원번호, 이름, 급여 ,근무 부서를 함께 출력하되 급여가 3000 이상인 데이터만 출력하시오.
SELECT empno AS "사번", ename AS "이름", sal AS "급여", d.dname AS "부서" -- SELECT절의 구문
FROM emp e, dept d -- 조인 시 별칭 사용 가능
WHERE e.deptno = d.deptno AND sal >= 3000; -- 비표준인 등가조인은 = 연산자를 사용한다. 비표준은 조건을 WHERE에 사용
--표준--
--NATURAL JOIN: 조인한 테이블을 검색해서 공통된 컬럼을 감지, 연결함 --> =을 사용할 필요가 없다.
SELECT empno AS "사번", ename AS "이름", sal AS "급여", d.dname AS "부서"
FROM emp e NATURAL JOIN dept d -- 표준은 조건을 FROM절에 작성
WHERE e.sal >= 3000;

--문제
--사원이름 KING 의 부서이름과 근무지를 출력하시오.
--비표준
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'KING';
--표준
SELECT ename, dname, loc
FROM emp NATURAL JOIN dept
WHERE ename = 'KING';

-- JOIN ~ USING
-- 예: 사원번호, 이름, 급여 ,근무 부서를 함께 출력하되 급여가 3000 이상인 데이터만 출력하시오.
SELECT empno AS "사번", ename AS "이름", sal AS "급여", d.dname AS "부서" 
FROM emp e JOIN dept d USING (deptno)
WHERE sal >= 3000;

-- JOIN ~ ON
--기존 비표준 등가 조인
SELECT empno, ename, job, sal, dname, loc, dept.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
-- 표준 NATURAL JOIN 이용
SELECT empno, ename, job, sal, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
-- 표준 JOIN ~ USING이용
SELECT empno, ename, job, sal, dname, loc, deptno
FROM emp INNER JOIN dept USING (deptno)
WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
-- 표준: JOIN ~ ON 이용
SELECT empno, ename, job, sal, dname, loc, dept.deptno
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno -- ON 조건
WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');

--JOIN 문제 6-1. Join 실습.pdf
--1. 모든 사원의 이름, 부서 번호, 부서 이름을 표시하는 질의를 작성하시오.
--비표준
SELECT ename, d.deptno, dname -- 비표준시 공통된 칼럼은 테이블 명 명시
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--표준 NATURAL JOIN
SELECT ename, deptno, dname -- 표준 NATURAL JOIN의 경우 공통된 칼럼에 식별자 사용 불가
FROM emp e NATURAL JOIN dept d;
-- 표준 JOIN ~ USING
SELECT ename, deptno, dname -- 표준 NATURAL JOIN의 경우 공통된 칼럼에 식별자 사용 불가
FROM emp INNER JOIN dept USING (deptno);

--2. comm을 받는 모든 사원의 이름, 부서 이름 및 위치를 표시하는 질의를 작성하시오.
--비표준
SELECT ename, comm, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND REPLACE(COMM, 0, null) IS NOT NULL; --comm이 0인 사람을 null로 처리할 경우
--표준 NATURAL JOIN
SELECT ename, comm, dname, loc
FROM emp NATURAL JOIN dept
WHERE COMM IS NOT NULL; --모두 포함
--표준 JOIN ~ USING
SELECT ename, comm, dname, loc
FROM emp INNER JOIN dept USING (deptno)
WHERE COMM IS NOT NULL;

--4. DALLAS에 근무하는 모든 사원의 이름, 직무, 부서 번호 및 부서 이름을 표시하는 질의를 작성하시오.
--비표준
SELECT ename, job, dept.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND loc = UPPER('DALLAS');
--표준 NATURAL JOIN
SELECT ename, job, deptno, dname, loc
FROM emp NATURAL JOIN dept
WHERE loc = UPPER('DALLAS');
--표준 JOIN ~ USING
SELECT ename, job, deptno, dname, loc
FROM emp INNER JOIN dept USING (deptno)
WHERE loc = UPPER('DALLAS');
--6. 이름이 ‘ALLEN’인 사원의 부서명을 출력하라.
--비표준
SELECT ename, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'ALLEN';
--표준 NATURAL JOIN
SELECT ename, dname
FROM emp NATURAL JOIN dept
WHERE ename = 'ALLEN';
--표준 JOIN ~ USING
SELECT ename, dname
FROM emp INNER JOIN dept USING (deptno)
WHERE ename = 'ALLEN';
--표준 JOIN ~ ON
SELECT ename, dname
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno
WHERE ename = 'ALLEN';
--5. EMP와 DEPT Table을 JOIN하여 부서번호, 부서명, 이름, 급여를 출력하라.
--비표준
SELECT d.deptno, dname, ename, sal
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--표준 NATURAL JOIN
SELECT deptno, dname, ename, sal
FROM emp NATURAL JOIN dept;
--표준 JOIN ~ USING
SELECT deptno, dname, ename, sal
FROM emp INNER JOIN dept USING (deptno);
--표준 JOIN ~ ON
SELECT deptno, dname, ename, sal
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno;

