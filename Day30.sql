-- 1. 모든 row와 모든 column 조회하기
SELECT ALL *
FROM salgrade;

-- 2. 모든 row와 특정 column 조회하기
SELECT deptno, Dname
FROM dept;
--부서테이블에서 부서번호와 부서명 조회하기
--SELECT deptno, dname
--FROM dept
SELECT empno, deptno
FROM emp;

--사원테이블에서 직무를 가져오기
SELECT DISTINCT job
FROM emp;
--사원테이블에서 사원들은 몇 개의 부서에 소속되어 있는가?
SELECT DISTINCT deptno
FROM emp;

--3. 별칭 사용하기
SELECT empno EmpolyeeNumber, ename EmpolyeeName
FROM emp;

SELECT empno AS "사원 번호", ename AS "사원 이름"
FROM emp;

SELECT sal * 12 + NVL(COMM,0) AS "연봉"
FROM EMP;

-- 사원테이블에서 사번, 사원의 이름, 직무, 월급, 보너스, 연봉을 조회하시오
SELECT empno AS "사번", ename AS "사원의 이름",job  AS "직무", 
sal AS "월급", comm AS "보너스", sal * 12 + NVL(comm,0) AS "연봉"
FROM emp;

--4. 정렬하기 ORDER BY
--사원테이블에서 부서번호로 오름차순으로 정렬하고, 월급을 내림차순으로 정렬
SELECT deptno, sal
FROM emp
ORDER BY deptno ASC, sal DESC;

-- SELECT가 되고 난 후 ORDER BY를 시행하기에 테이블에 없는 컬럼으로 정렬 가능
SELECT empno AS "사번", ename AS "사원의 이름",job  AS "직무", 
sal AS "월급", comm AS "보너스", sal * 12 + NVL(comm,0) AS "연봉"
FROM emp
ORDER BY "연봉" DESC;

-- P. 92 3번
SELECT empno AS EMPLOYEE_NO, ename AS EMPLOYEE_NAME, mgr AS MANAGER, sal AS SALARY,
comm AS COMMISSION, deptno AS DEPARTMENT_NO
FROM emp
ORDER BY deptno DESC, ename;

--5. NULL 처리
--NVL()함수
--SELECT NVL(COMM, '값 없음')
SELECT NVL(COMM, 100) 
FROM emp;

SELECT DISTINCT NVL(mgr, 0)
FROM emp;

--6. 문자열 연결하기: 연결 연산자.
SELECT 'HELLO' || ', World'
FROM dual;

SELECT '사원번호 ' || empno || '는 '|| ename || '입니다.'
FROM emp;

-- 7. 조건절 WHERE
SELECT ename, job, sal
FROM emp
WHERE deptno = 10;

SELECT ename, sal * 12 + NVL(comm,0) AS "연봉"
FROM emp
WHERE empno = 7782;

--사원테이블에서 부서번호가 20번 부서에 속해있는 사원 중에 월급이 1000불 이하인 사원의 정보를 조회
SELECT *
FROM emp
WHERE deptno = 20 AND sal<=1000;

SELECT *
FROM emp 
WHERE empno = 7499 AND deptno = 30;

--사원테이블에서 부서번호가 10번이거나 월급이 3000불 ~ 5000사이인 사원의 사번, 이름, 월급, 부서번호 조회
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 10 OR (sal >= 3000 AND sal <= 5000); 

--논리부정연산자
SELECT deptno, dname, loc
FROM dept
WHERE NOT (deptno = 10 OR deptno = 20);

-- IN 연산자
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20);
--사원테이블에서 직무가 SALESMAN이거나 MANAGER이거나 PRESIDENT인 사원의 사원이름, 직무 조회
SELECT ename, job
FROM emp
WHERE job IN('SALESMAN', 'MANAGER', 'PRESIDENT');