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
WHERE deptno = 10;
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 20;
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 30;
