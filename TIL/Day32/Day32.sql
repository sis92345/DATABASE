--Day32:0828
-- ���� ����: 23��(2-1 pdf)
SELECT ename, sal, TRUNC((sal/12)/5,1) AS"�ð��� �޿�" -- ROUND((sal/12)/5, 0)�� ���� �ڵ��̴�.
FROM emp
WHERE deptno = 20;
--1. �����Լ�
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
SELECT comm, sal, NVL(comm, 0), NVL2(comm, comm * 1.1, 0), COALESCE(comm, sal) --comm�� null�̸� sal�� ���, null�� �ƴϸ� comm�� ��´�.
FROM emp
WHERE deptno IN (10, 30);

SELECT deptno, comm,COALESCE(comm, 100)
FROM emp
WHERE deptno IN (10,30)
ORDER BY deptno ASC;

--1.8. DECODE
SELECT deptno, sal, DECODE(deptno, 10, sal * 1.1, 20, sal * 1.5, sal) AS "���ʽ�"
FROM emp
ORDER BY deptno ASC;

SELECT job, sal, DECODE(job, 'ANALYST', sal * 0.1, 'CLERK', sal * 0.2, 'MANAGER', sal * 0.3, sal ) AS "���ʽ�"
FROM emp
ORDER BY job;
--����: �Ի��� �⵵�� �������� 87�⿡ �Ի��� ����� ���, 82�⵵�� ���� 81�⵵�� ����, 80�⵵�� �̻�� ������ �����϶�. �����, �Ի�⵵, ������ ����϶�
SElECT ename, hiredate, CONCAT('19', TO_CHAR(hiredate, 'RR')) AS "�Ի�⵵", DECODE(TO_CHAR(hiredate, 'RR'), '87', '���', 
                                                                                                            '82', '����', 
                                                                                                            '81', '����', 
                                                                                                                  '�̻�') AS "����"
FROM emp
ORDER BY "�Ի�⵵";
--1.9. CASE
--DECODE�� 
SELECT deptno, sal, DECODE(deptno, 10, sal * 1.1, 20, sal * 1.5, 0) AS "���ʽ�"
FROM emp
ORDER BY deptno ASC;
--�Ʒ��� CASE������ �ٲٸ�
SELECT deptno, sal, 
       CASE
            WHEN deptno = 10 THEN sal *  1.1
            WHEN deptno = 20 THEN sal *  1.2
            ELSE sal -- WHEN ��� �ǿ��� ���
       END AS "���ʽ�" -- CASE ~ END ���� ����

FROM emp
ORDER BY deptno ASC;

SELECT job, sal, DECODE(job, 'ANALYST', sal * 0.1, 'CLERK', sal * 0.2, 'MANAGER', sal * 0.3, sal ) AS "���ʽ�"
FROM emp
ORDER BY job;
-- �� ������ CASE��
SELECT job, sal,
       CASE
            WHEN job = 'ANALYST' THEN sal * 0.1
            WHEN job = 'CLERK' THEN sal * 0.2
            WHEN job = 'MANAGER' THEN sal * 0.3
            ELSE 0
       END AS "���ʽ�"
FROM emp
ORDER BY job; 

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
SELECT ename,  TO_CHAR(hiredate, 'YYYY')AS "�Ի�⵵",
       CASE
            WHEN  TO_CHAR(hiredate, 'YYYY') = '1980' THEN '�̻�'
            WHEN  TO_CHAR(hiredate, 'YYYY') = '1981' THEN '����'
            WHEN  TO_CHAR(hiredate, 'YYYY') = '1982' THEN '����'
            ELSE '���'
       END AS "����"
FROM emp
ORDER BY "�Ի�⵵";

-- 2. ��¥ �Լ�
--2.1 SYSDATE
SELECT ename, TRUNC((sysdate - hiredate)/365 ) || '��° �ٹ� ��' AS "�ٷο���" 
FROM emp
WHERE deptno = 10;

SELECT SYSDATE + 5 -- ��¥�� ������ �����ϴ�.
FROM dual;

--2.2MONTHS_BETWEEN()
SELECT ename, hiredate, TRUNC((sysdate - hiredate)/365 ) || '��° �ٹ� ��' AS "�ٷο���", TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) || '����° �ٹ�'
FROM emp
WHERE deptno = 10;
--2.3ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 5) 
FROM dual; 
--2.4NEXT_DAY()
SELECT NEXT_DAY(SYSDATE, '�ݿ���')
FROM dual;

SELECT NEXT_DAY(NEXT_DAY(SYSDATE, '������'), '������')
FROM dual;
--2.5LAS_DAY() �ڹٿ����� �� ����� �߽ø� ���� �־��� ���� �̴µ� 
SELECT LAST_DAY(SYSDATE)
FROM dual;

SELECT LAST_DAY(ADD_MONTHS(SYSDATE,1)) --�ٴ������� ������ ��
FROM dual;
--2.6��¥ �Լ����� ROUND()
SELECT ROUND(sysdate, 'YEAR')
FROM dual;

SELECT ROUND(ADD_MONTHS(sysdate, -3), 'YEAR')
FROM dual;

--2.6��¥ �Լ����� TRUNC()

SELECT TRUNC(ADD_MONTHS(sysdate, -3), 'MONTH')
FROM dual;





























