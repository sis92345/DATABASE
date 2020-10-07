--0917, Day36
-- 복습 문제 6-1. JOIN 실습.pdf
--3. DEPT Table에 있는 모든 부서를 출력하고, EMP Table에 있는 DATA와 JOIN하여 모든
--사원의 이름, 부서번호, 부서명, 급여를 출력하라. OUTER JOIN을 사용해야 완벽한 답
--비표준
SELECT e.ename, e.deptno, d.dname, e.sal
FROM emp e,dept d
WHERE e.deptno = d.deptno;
--표준
SELECT ename, deptno, dname, sal
FROM emp NATURAL JOIN dept;

SELECT e.ename, deptno, d.dname, e.sal
FROM emp e INNER JOIN dept d USING (deptno);

SELECT ename, d.deptno, dname, sal
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno;

--5. ‘ALLEN:의 직무와 같은 사람의 이름, 부서명, 급여, 회사위치, 직무를 출력하라.
--서브쿼리를 사용하는 문제지만 여기서는 SELECT를 두번 이상 했다고 가정
SELECT job
FROM emp
WHERE ename = 'ALLEN';
--비표준
SELECT ename, dname, sal, loc, job
FROM emp e, dept d
WHERE e.deptno = d.deptno AND job = 'SALESMAN';
--표준
SELECT ename, dname, sal, loc, job
FROM emp NATURAL JOIN dept
WHERE job = 'SALESMAN';

SELECT ename, dname, sal, loc, job
FROM emp INNER JOIN dept USING (deptno)
WHERE job = 'SALESMAN';

SELECT ename, dname, sal, loc, job
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno
WHERE job = 'SALESMAN';

--6. ‘JAMES’가 속해있는 부서의 모든 사람의 사원번호, 이름, 입사일, 급여를 출력하라.
SELECT dname
FROM emp NATURAL JOIN dept
WHERE ename = 'JAMES';
--표준
SELECT empno, ename, hiredate, sal
FROM emp e, dept d
WHERE e.deptno = d.deptno AND dname = 'SALES';
--비표준
SELECT empno, ename, hiredate, sal
FROM emp NATURAL JOIN dept
WHERE dname = 'SALES';

--9. 10번 부서 중에서 30번 부서에는 없는 업무를 하는 사원의 사원번호, 이름, 부서명,
--입사일, 지역을 출력하라.
SELECT job
FROM emp
WHERE deptno = 10;
--비표준
SELECT empno, ename, dname, hiredate, loc
FROM emp e, dept d
WHERE e.deptno = d.deptno AND job NOT IN ('MANAGER', 'PRESISDENT', 'CLERK');
--표준
SELECT empno, ename, dname, hiredate, loc
FROM emp INNER JOIN dept USING (deptno)
WHERE job NOT IN ('MANAGER', 'PRESISDENT', 'CLERK');

--hr계정 사용
SELECT *
FROM employees;

SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id;

SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees  NATURAL JOIN departments ;

SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees  INNER JOIN departments USING (department_id);

--3개 이상의 테이블을 조인하는 방법: 위 SQL문에 위치명을 추가해보자: EMPLOYEES + DEPARTMENTS +LOCATIONS
--비표준: 옆으로 계속 붙인다.
SELECT employee_id, first_name, hire_date, department_name, lo.location_id, lo.city, c.country_name
FROM  employees e, departments d, locations lo, countries c
--ER 다이어그램을 보면 department 테이블은 Location 테이블의 자식이며 employees는 department의 자식이다. 관계를 유의하자
--ER 다이어그램에서 부모-자식관계를 알려면 외래키(FK)를 보자
WHERE e.department_id = d.department_id AND d.location_id = lo.location_id AND lo.country_id = c.country_id AND
e.department_id IN (10, 20, 30, 40); -- 조인 조건을 두 번 쓰자!
--표준: 식별자를 사용할 수 없음을 유의
SELECT employee_id, first_name, hire_date, department_name, location_id, city, country_name
FROM employees  e NATURAL JOIN departments  d NATURAL JOIN locations lo NATURAL JOIN countries c
WHERE department_id IN (10, 20, 30, 40, 50);

SELECT employee_id, first_name, hire_date, department_name, department_id, location_id, city, country_name
FROM employees  e INNER JOIN departments  d USING (department_id, manager_id) 
                  INNER JOIN locations lo USING (location_id) 
                  INNER JOIN countries c USING (country_id) 
WHERE department_id IN (10, 20, 30, 40);
-- JOIN ~ ON
SELECT employee_id, first_name, hire_date, department_name, e.department_id, lo.location_id, city, state_province, c.country_name
FROM employees  e INNER JOIN departments  d ON  e.department_id = d.department_id
                  INNER JOIN locations lo ON d.location_id = lo.location_id 
                  INNER JOIN countries c ON lo.country_id = c.country_id 
WHERE e.department_id IN (10, 20, 30, 40);

-- 비등가 조인. Non - Equi Join
-- 조인 조건이'='이 아닌 경우이다.
-- 비표준
SELECT empno, ename, sal, grade 
FROM emp , salgrade 
--WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
WHERE sal >= losal AND sal <= hisal;
--표준: JOIN ~ ON 사용
SELECT empno, ename, sal, grade 
FROM emp JOIN salgrade ON sal BETWEEN losal AND hisal;

-- 외부조인 OUTER JOIN
-- 두 테이블간 조인 수행에서 조인 기준 열의 어느 한쪽이 NULL이어도 강제로 출력하는 방식을 외부조인이라고 한다. 
--비표준
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno; --40번 부서에 소속된 사원은 없다.
--WHERE emp.deptno = dept.deptno(+); -모든 사원은 부서에 소속되어 있다. --> null값을 가져오지 않는다.
-- 부서는 10, 20, 30, 40인데 40번 부서는 사원이 없으므로 등가 조인의 경우는 40번 부서를 가져 오지 않는다.
-- 즉 사원테이블의 정보가 부족하다.
-- 정보가 부족한 쪽에 +를 붙여주는게 외부조인이다.
-- 비표준 OUTER JOIN 종류
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno; -- RIGHT OUTER JOIN

SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno = dept.deptno(+); --LEFT OUTER JOIN,부족한 정보가 없으므로 결과는 등가 조인과 동일

--SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
--FROM emp, dept
--WHERE emp.deptno(+) = dept.deptno(+); --FULL OUTER JOIN은 비표준 외부조인에서 지원하지 않는다.
-- 비표준에서 FULL OUTER JOIN을 사용하는 방법: UNION을 사용
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno -- RIGHT OUTER JOIN
UNION
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno = dept.deptno(+); -- RIGHT OUTER JOIN

--표준 OUTER JOIN
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp RIGHT OUTER JOIN dept ON emp.deptno = dept.deptno;
--표준 외부 조인은 FULL OUTER JOIN을 사용할 수 있다.
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp FULL OUTER JOIN dept ON emp.deptno = dept.deptno;

--hr
--표준
SELECT empolyee_id, first_name, e.department_id, d.department_id, departmoent_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id; -- 표준 RIGHT OUTER JOIN
-- 비표준
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id;

--사원 중 소속 부서가 없는 사원이 있는가?
--표준
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+); -- 표준 LEFT OUTER JOIN
-- 비표준
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id;

-- FULL 포괄조인: 소속이 없는 사원 + 사원이 없는 부서
--표준
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id -- 표준 LEFT OUTER JOIN
UNION
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+); -- 표준 RIGHT OUTER JOIN
--비표준
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e FULL OUTER JOIN departments d ON e.department_id = d.department_id;


--자체 조인, SELF JOIN
--비표준
SELECT 부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
FROM emp 부하, emp 상사 --자체조인은 반드시 별칭을 사용해야 한다.
WHERE 상사.empno = 부하.mgr; --부하의 메니저가 상사의 사원번호와 일치한다면 

SELECT 부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
FROM emp 부하, emp 상사 --자체조인은 반드시 별칭을 사용해야 한다.
WHERE 상사.empno(+) = 부하.mgr; --LEFT OUTER JOIN
--표준
SELECT 부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
FROM emp 부하 INNER JOIN emp 상사 ON 부하.mgr = 상사.empno; --자체조인은 반드시 별칭을 사용해야 한다.

-- 자체조인 문제
--비표준
--4. EMP Table에 있는 EMPNO와 MGR을 이용하여 서로의 관계를 다음과 같이 출력하라.‘SMTH의 매니저는 FORD이다’
SELECT 부하.ename || '의 메니저는 ' || NVL(상사.ename,'미정') || '이다.'
FROM emp 부하, emp 상사
WHERE 부하.mgr = 상사.empno(+);
--표준
SELECT 부하.ename || '의 메니저는 ' || 상사.ename || '이다.'
FROM emp 부하 INNER JOIN emp 상사 ON 부하.mgr = 상사.empno;

--조인 문제 P.239 
--Q1 급여가 2000초과인 사원들의 부서, 정보, 사원 정보를 출력
-- 비표준
SELECT dept.deptno, dname, empno, ename, sal
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal > 2000;
-- 표준
SELECT dept.deptno, dname, empno, ename, sal
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno
WHERE sal > 2000;

--Q2. 각 부서별 평균 급여, 최대 급여, 최소 급여, 사원수를 출력
- 비표준
SELECT d.deptno, dname ,TRUNC(AVG(sal)) AS "AVG_SAL", MAX(sal) AS "MAX_SAL",MIN(sal) AS "MIN_SAL", COUNT(*) AS "CNT"
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- GROUP BY 주의점: 위의 SELECT절에 집계함수와 여러 행을 결과로 반환하는 컬럼을 같이 사용하면 오류
-- 단 GROUP BY에 사용된 기준열을 SELECT절의 첫번째 파라미터에 들어오면 에러가 안난다. ★
-- dname은 이때 문제가 되는데 아래와 같이 GROUP BY절을 입력할 경우
-- GROUP BY d.deptno
-- 위 GROUP BY절에 dname이 없으므로 dname은 여러개의 결과를 반환하는 컬럼으로 간주되어 오류
-- 따라서 dname을 GROUP BY기준 열로 사용하면 해결된다.
GROUP BY d.deptno, dname 
ORDER BY d.deptno;
--표준
SELECT d.deptno, dname ,ROUND(AVG(sal)) AS "AVG_SAL", ROUND(MAX(sal)) AS "MAX_SAL", ROUND(MIN(sal)) AS "MIN_SAL", ROUND(COUNT(*)) AS "CNT"
FROM emp e INNER JOIN dept d ON  e.deptno = d.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno;

--Q3. 모든 부서 정보와 사원 정보를 부서 번호, 사원 이름순으로 정렬해서 출력하라
-- 비표준: 모든 부서 정보 이므로 외부 조인을 사용
SELECT d.deptno, dname, empno, ename, job, sal
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno --  오른쪽 외부 조인 조건식 오른쪽 열을  왼쪽 열 데이터와 상관없이 모든 데이터를 출력하는 것
ORDER BY d.deptno, ename;
-- 표준 
SELECT d.deptno, dname, empno, ename, job, sal
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno  
ORDER BY d.deptno, ename;

--Q4. 모든 부서 정보, 사원 정보, 급여 등급 정보 ,각 사원의 직속 상관의 정보를 부서 번호, 사원 번호 순으로 정렬하여 출력 ★
-- 비표준
SELECT d.deptno, dname, e.empno, e.ename, e.mgr, e.sal, b.deptno, s.losal, s.hisal, s.grade, b.empno, b.ename
FROM emp e, dept d, salgrade s, emp b
WHERE (e.deptno(+) = d.deptno)AND (e.sal BETWEEN losal(+) AND hisal(+)) AND e.mgr = b.empno(+) --  오른쪽 외부 조인 조건식 오른쪽 열을  왼쪽 열 데이터와 상관없이 모든 데이터를 출력하는 것
ORDER BY d.deptno,e.empno;
-- losal, hisal, grade도 null이 나와야 한다.
--강사님 버전 다운받아서 비교해 봐야 한다.

--표준
SELECT d.deptno, dname, e.empno, e.ename, e.mgr, b.deptno, s.losal, s.hisal, s.grade, b.empno, b.ename
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno 
     emp INNER JOIN salgrade s ON e.sal BETWEEN losal AND hisal 
     FULL OUTER JOIN emp b on  e.mgr = b.empno
ORDER BY d.deptno, e.empno;

--강사님 버전
SELECT dept.deptno, dname, 부하.empno, 부하.ename, 부하.mgr, 상사.deptno, losal, hisal, grade, 상사.empno, 상사.ename
FROM dept LEFT OUTER JOIN emp 부하 ON (부하.deptno = dept.deptno) 
     LEFT OUTER JOIN salgrade ON (부하.sal BETWEEN losal AND hisal)
    LEFT OUTER JOIN emp 상사 ON (부하.mgr = 상사.empno)    --셀프조인이면서 포괄조인
ORDER BY dept.deptno, 부하.empno;

--DML
--INSERT: 새로운 데이터 추가
--INSERT INTO 테이블명 VALUE (데이터....) 
--날짜형과 문자형은 반드시 `''`를 사용해야 한다.
--채워야 할 컬럼 개수와 순서와 literal의 사이즈, NULL, 타입를 생각해야 한다.
INSERT INTO dept 
VALUES(50, 'DEVELOPEMENT', 'SEOUL'); --채워야 할 컬럼 개수와 순서와 literal의 사이즈, NULL, 타입를 생각해야 한다.

--순서와 상관없이 삽입하기 위해서는 다음과 같이 진행한다.
INSERT INTO dept(loc, deptno, dname)
VALUES('BUSAN', 60, 'DESIGN');

INSERT INTO dept(dname, loc, deptno) -- 테이블의 순서를 다르게 하려면 반드시 명시해야 한다.
VALUES ('MARKETING', 'KWANGJUKWANGYUKSI', 70); --사이즈 고민, 원래 공간보다 데이터는 삽입할 수 없다.

--INSERT INTO dept
--VALUES (10, 20, 30); 타입을 고민하자

--INSERT INTO dept
--VALUES(80, 'JAVA'); -- NULL을 주의하자: 값의 수가 충분하지 않습니다. 라는 에러가 발생
--위에서 NULL을 암시적으로 처리하기 위한 방법
INSERT INTO dept(deptno, dname)
VALUES(70, 'SERVICE'); --암시적으로 처리
-- NULL을 명시적으로 처리하는 방법
INSERT INTO dept
VALUES(80, 'MAINTANCE', null);
--loc는 13바이트
SELECT *
FROM dept;
--dept 테이블 복구
-- 삭제는 자식 테이블부터
--scott.sql 사용
SELECT *
FROM emp;
SELECT *
FROM dept;
SELECT *
FROM salgrade;


