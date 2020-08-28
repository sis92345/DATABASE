--Day32:0828
-- 복습 문제: 23번(2-1 pdf)
SELECT ename, sal, TRUNC((sal/12)/5,1) AS"시간당 급여" -- ROUND((sal/12)/5, 0)과 같은 코드이다.
FROM emp
WHERE deptno = 20;
--1. 숫자함수
--1.1 ROUND()
SELECT ROUND(45.925,2), ROUND(45.925, 0), ROUND(45.925, -1)
FROM dual;
--1.2 TRUNC()
SELECT TRUNC(45.925,2), TRUNC(45.925, 0), TRUNC(45.925, -1)
FROM dual;
--1.3 CEIL(), FLOOR()
SELECT TRUNC(45.925,2), CEIL(45.925), FLOOR(45.925)
FROM dual;
--1.4.MOD()
SELECT 15 / 6 ,MOD(15,6)
FROM dual;
--1.5. NVL2()
SELECT deptno, comm, NVL(comm,0), NVL2(comm, comm *1*1,0), NULLIF(comm, NULL)
FROM emp
WHERE deptno IN (10, 30)
ORDER BY deptno;
--1.6.NULLIF()
SELECT NULLIF(sal, 800)
FROM emp
WHERE ename = UPPER('smith');
--1.7.COALESCE
SELECT comm, sal, NVL(comm, 0), NVL2(comm, comm * 1.1, 0), COALESCE(comm, sal) --comm이 null이면 sal을 찍고, null이 아니면 comm을 찍는다.
FROM emp
WHERE deptno IN (10, 30);

SELECT deptno, comm,COALESCE(comm, 100)
FROM emp
WHERE deptno IN (10,30)
ORDER BY deptno ASC;

--1.8. DECODE
SELECT deptno, sal, DECODE(deptno, 10, sal * 1.1, 20, sal * 1.5, sal) AS "보너스"
FROM emp
ORDER BY deptno ASC;

SELECT job, sal, DECODE(job, 'ANALYST', sal * 0.1, 'CLERK', sal * 0.2, 'MANAGER', sal * 0.3, sal ) AS "보너스"
FROM emp
ORDER BY job;
--문제: 입사한 년도를 기준으로 87년에 입사한 사원은 사원, 82년도는 과장 81년도는 부장, 80년도는 이사로 직급을 지정하라. 사원명, 입사년도, 직급을 출력하라
SElECT ename, hiredate, CONCAT('19', TO_CHAR(hiredate, 'RR')) AS "입사년도", DECODE(TO_CHAR(hiredate, 'RR'), '87', '사원', 
                                                                                                            '82', '과장', 
                                                                                                            '81', '부장', 
                                                                                                                  '이사') AS "직급"
FROM emp
ORDER BY "입사년도";
--1.9. CASE
--DECODE를 
SELECT deptno, sal, DECODE(deptno, 10, sal * 1.1, 20, sal * 1.5, 0) AS "보너스"
FROM emp
ORDER BY deptno ASC;
--아래의 CASE문으로 바꾸면
SELECT deptno, sal, 
       CASE
            WHEN deptno = 10 THEN sal *  1.1
            WHEN deptno = 20 THEN sal *  1.2
            ELSE sal -- WHEN 경우 의외의 경우
       END AS "보너스" -- CASE ~ END 까지 실행

FROM emp
ORDER BY deptno ASC;

SELECT job, sal, DECODE(job, 'ANALYST', sal * 0.1, 'CLERK', sal * 0.2, 'MANAGER', sal * 0.3, sal ) AS "보너스"
FROM emp
ORDER BY job;
-- 위 문제를 CASE로
SELECT job, sal,
       CASE
            WHEN job = 'ANALYST' THEN sal * 0.1
            WHEN job = 'CLERK' THEN sal * 0.2
            WHEN job = 'MANAGER' THEN sal * 0.3
            ELSE 0
       END AS "보너스"
FROM emp
ORDER BY job; 

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
SELECT ename,  TO_CHAR(hiredate, 'YYYY')AS "입사년도",
       CASE
            WHEN  TO_CHAR(hiredate, 'YYYY') = '1980' THEN '이사'
            WHEN  TO_CHAR(hiredate, 'YYYY') = '1981' THEN '부장'
            WHEN  TO_CHAR(hiredate, 'YYYY') = '1982' THEN '과장'
            ELSE '사원'
       END AS "직급"
FROM emp
ORDER BY "입사년도";

-- 2. 날짜 함수
--2.1 SYSDATE
SELECT ename, TRUNC((sysdate - hiredate)/365 ) || '년째 근무 중' AS "근로연수" 
FROM emp
WHERE deptno = 10;

SELECT SYSDATE + 5 -- 날짜도 연산이 가능하다.
FROM dual;

--2.2MONTHS_BETWEEN()
SELECT ename, hiredate, TRUNC((sysdate - hiredate)/365 ) || '년째 근무 중' AS "근로연수", TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) || '개월째 근무'
FROM emp
WHERE deptno = 10;
--2.3ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 5) 
FROM dual; 
--2.4NEXT_DAY()
SELECT NEXT_DAY(SYSDATE, '금요일')
FROM dual;

SELECT NEXT_DAY(NEXT_DAY(SYSDATE, '월요일'), '월요일')
FROM dual;
--2.5LAS_DAY() 자바에서는 겟 엑츄얼 멕시멈 쓰면 주어진 값을 뽑는데 
SELECT LAST_DAY(SYSDATE)
FROM dual;

SELECT LAST_DAY(ADD_MONTHS(SYSDATE,1)) --다다음달의 마지막 날
FROM dual;
--2.6날짜 함수에서 ROUND()
SELECT ROUND(sysdate, 'YEAR')
FROM dual;

SELECT ROUND(ADD_MONTHS(sysdate, -3), 'YEAR')
FROM dual;

--2.6날짜 함수에서 TRUNC()

SELECT TRUNC(ADD_MONTHS(sysdate, -3), 'MONTH')
FROM dual;





























