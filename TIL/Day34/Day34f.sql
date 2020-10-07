SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD'), 
      TO_CHAR(NEXT_DAY(ADD_MONTHS(hiredate, 3), '������'), 'YYYY-MM-DD') AS "R_Job",
      NVL(TO_CHAR(COMM), 'N/A') AS "COMM" --COMM�� �������̱� ������ ��ġ�� ���ڴ� �������̾�� �Ѵ�. ���� �� Ÿ���� ��ġ�ؾ� �Ѵ�.
FROM emp;

--�׷��Լ�, �������Լ�
--�׷��Լ�, �������Լ��� �������� ���� �� ����� �����ش�.
--�׷��Լ�, �������Լ��� �������� ����� �����ִ� �Լ��� ���� ����� �� ����. ��
SELECT empno, SUM(sal)
FROM emp;
--�� ������ ����.
--�׷��Լ�, �������Լ��� NULL���� �����Ѵ�.
SELECT AVG(comm), AVG(NVL(comm,0))
FROM emp;
-- AVG(comm)�� NULL�� �����ϱ� ������  AVG(NVL(comm,0))�� �и� �޶�����.
--�� COUNT(*)�� NULL�� �����Ѵ�.
--COUNT(*)�� NULL�� �����Ϸ��� WHERE���� ������ �����ϸ� �ȴ�.
SELECT COUNT(DISTINCT comm)
FROM emp
WHERE comm IS NOT NULL;

--
SELECT MAX(hiredate)
FROM emp
WHERE deptno = 20;

-- ������ �Լ��� ��
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

-- GROUP BY: ������ 0915.md�� �� ��
SELECT deptno, SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;

SELECT deptno,job ,TRUNC(AVG(sal)),MIN(sal), MAX(sal), COUNT(*)
FROM emp
GROUP BY deptno, job -- �μ��� �׷�ȭ
ORDER BY deptno, job;

SELECT department_id,job_id,COUNT(salary), TRUNC(AVG(salary))
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;

--������ �Լ��� �������Լ��� �Բ� ����� �� ������ GROUP BY ������ ����� �� �ִ�.
SELECT deptno, SUM(sal) --ename�� GROUP BY�� ������ �ƴ� �������̹Ƿ� SELECT������ ����� �� ����.
FROM emp
GROUP BY deptno;

--HAVING
--HAVING: GROUP BY�� �׷�ȭ�� �����Ϳ� ���� ���ǹ��̴�.
SELECT deptno,job, TRUNC(AVG(sal))
FROM emp
WHERE deptno IN (10, 20)
GROUP BY deptno, job
HAVING job = UPPER('manager');

SELECT deptno, TRUNC(AVG(sal))
FROM emp
GROUP BY deptno
HAVING TRUNC(AVG(sal)) >= 2000;

--HAVING�� ����ϴ� ����
SELECT deptno, COUNT(*), SUM(sal)
FROM emp
--WHERE COUNT(*) >= 4 _WHERE�������� �׷��Լ��� ����� �� ����.
GROUP BY deptno; 
HAVING COUNT(*) >= 4 --���� HAVING�� �׷��Լ��� ���

--��
--������̺��� �������� �޿��� ����� 3000�� �̻��� ������ ����, ������, ��ձ޿�, �޿��� ���� ���Ͻÿ�
SELECT job, AVG(sal), SUM(sal)
FROM emp
GROUP BY job
HAVING AVG(sal) >= 3000;
--������̺��� ��ü ������ 5000���� �ʰ��ϴ� �� ������ ���� �����̸��� �� �޿���
--�հ踦 ����϶�. ��, �Ǹſ��� �����ϰ� ���޿� �հ��� ������������ ����϶�.
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
--�� SQL�� SUM(sal)�� job�� ��� ��ģ sal�̳��´�. ������ ROLLUP�� ����ϸ�
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY ROLLUP(deptno, job)
ORDER BY deptno, job;
-- ROLLUP�� �κ����� ������ش�. ����� Ȯ������

SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;
--�� SQL�� SUM(sal)�� job�� ��� ��ģ sal�̳��´�. ������ ROLLUP�� ����ϸ�
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY CUBE(deptno, job)
ORDER BY deptno, job;

--P.212~213 ����
--1. ������̺��� �̿��ؼ� �μ���ȣ, ��� �޿�, �ְ� �޿�, ���� �޿�, �ÿ����� ���
--3. ������� �Ի� ������ �������� �μ����� �� ���� �Ի��ߴ��� ����Ͻÿ�
SELECT TO_CHAR(hiredate, 'YYYY') AS "HIRE_DATE", deptno, COUNT(*) AS "CNT"
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY'), deptno;

--�Ʒ��� ����� �� �ٸ��� �����ϱ�
--SELECT TO_CHAR(hiredate, 'YYYY'), deptno, COUNT(*)
--FROM emp
--GROUP BY hiredate, deptno;
--4. �߰������� �޴� ����� ���� ���� �ʴ� ����� ���� ����Ͻÿ�
SELECT NVL2(comm,'O', 'X') AS "EXIST _COMM", COUNT(*)
FROM emp
GROUP BY NVL2(comm,'O', 'X'); --NVL2�� ���������� ��ġ���� �ʾƵ� �ȴ�.
--5. �� �μ��� �Ի� ������ ��� ��, �ְ� �޿�, �޿� ��, ��� �޿��� ����ϰ� �� �μ��� �Ұ�� �Ѱ踦 ����Ͻÿ�
SELECT deptno, hiredate, SUM(sal), ROUND(AVG(sal),1)
FROM emp
GROUP BY ROLLUP(deptno,hiredate);

-- 5-1 .GROUP FUNCTION �ǽ�.pdf
--5. emp table�� ��ϵǾ� �ִ� �ο���, ���ʽ��� NULL�� �ƴ� �ο���, ���ʽ���
--��ü���, ��ϵǾ� �ִ� �μ��� ���� ���Ͽ� ����Ͻÿ�.
SELECT COUNT(*), COUNT(comm), AVG(comm),ROUND(AVG(NVL(comm,0))), ROUND(SUM(comm)/14), ROUND(SUM(comm)/4), COUNT(deptno) 
--COUNT()�� ������ ������ �׷��Լ��� NULL�� ����: �и� �޶����� ����
FROM emp;
--8. �� �μ��� ���� ������ �ϴ� ����� �ο����� ���Ͽ� �μ���ȣ, ������, �ο�����
--����Ͻÿ�. ���� ������ �ϴ� == ������
SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY deptno, job;

SELECT parameter, value
FROM NLS_SESSION_PARAMETERS;

--����
-- 1. ��������, CROSS JOIN, Cartesian Product, ��ī��Ʈ ��
-- ��ǥ�� ���� ����
SELECT empno, ename, sal, dname, loc, emp.deptno
FROM emp, dept;
-- ǥ�� ���� ����
SELECT empno, ename, sal, dname, loc, emp.deptno
FROM emp CROSS JOIN dept;

--���ο��� ��Ī ���
SELECT empno, ename, sal, dname, loc, e.deptno
FROM emp e, dept d;

--2. �����, Equi Join, ��������, �ܼ�����
-- ���̽��� ��� ��ġ�� �ִ� ��� �μ����� ���ϴ°�?
-- ��� �μ�?
SELECT ename, deptno
FROM emp
WHERE ename = 'SMITH';
-- ��� ��ġ?
SELECT deptno, loc
FROM dept
WHERE deptno = 20;
-- �� ��� �μ� = emp ���̺�, �� �μ��� ��ġ = dept ���̺�
-- �� �ΰ��� ����� �ϳ��� SELECT������ ǥ���ϱ� ���ؼ� ������� ���
-- ��ǥ�� �����
SELECT empno, ename, sal, dname, loc, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.ename = 'SMITH'; -- ���ǿ��� =�� ����ߴٰ� �ؼ� ������̴�. �� =�� �Ⱦ��� ������
--*ǥ�� � ����: ������ ������ FROM������ ����Ѵ�.
SELECT empno, ename, sal, dname, loc, d.deptno
FROM emp NATURAL JOIN dept
WHERE e.ename = 'SMITH'; -- �� ������ ������ ������ �ƴϴ�.



SELECT e.empno,e.deptno
FROM dept d CROSS JOIN emp e;














