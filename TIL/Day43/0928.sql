--Day43,0928
--��������
--���������� ����: SELECT���� 2�� ���ص� �ȴ�.
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


----������ ��������: MAX, MIN, AVG���� ���������� ����� �ϳ��� ������ ��ȯ
SELECT *
FROM emp
WHERE hiredate < (SELECT  hiredate FROM emp WHERE ename = 'MILLER'); --����� �ϳ��� ��ȯ

SELECT empno, ename, job, deptno, dname, loc
FROM emp NATURAL JOIN dept --NATURAL JOIN, JOIN ~ USING�� ����ϸ� �ĺ��� ��� �Ұ�
WHERE deptno = 20 AND sal > (SELECT AVG(sal) FROM emp);

----������ ��������: ���� ������ ����� ���� ������ ��ȯ, ���� ��� ���������� ������ 10�� �μ��� �����̶�� ���� ������ ��ȯ
--1.���������� SELECT���� ��� �� ���� �Բ� ����ϴ� ���������� ������ ������ ȣȯ �����ؾ� �Ѵ�.
--IN, ANY, SOME, ALL, EXISTS
--��:  IN (2975,3000,2000),, ALL (2975,3000,2000)

--ANY, SOME: ���� ���� ���ǽ��� �����ϴ� ���� ������ ����� �ϳ� �̻��̸�TRUE
--�� ANY�� sal > ANY (2075, 3000, 2100)���� sal�� 2100�̻��̶�� true, �׷��� IN�� 2101�̶�� FALSE 
-- < ANY: �ִ밪���� ����
-- = ANY: IN�� ����
-- > ANY: �ִ밪���� ū
--sal >   (SELECT MIN(sal) ����, ������ ���������ε� ���� ������ ������ ������ ���
  --  FROM emp
 --   GROUP BY deptno); --����� 3�����̹Ƿ� ������ ��������
SELECT *
FROM emp
WHERE sal IN (SELECT MIN(sal) FROM emp GROUP BY deptno); -- �� �μ� �ּ� ����
SELECT *
FROM emp
WHERE sal = ANY (SELECT MIN(sal) FROM emp GROUP BY deptno); --IN�� ����
SELECT *
FROM emp
WHERE sal > ANY (SELECT MIN(sal) FROM emp GROUP BY deptno); -- ������ 850���� ���� ���

--ALL: ���������� ���ǽ��� ���������� ����� ��� �����ϸ� TRUE
SELECT empno, ename, job, sal
FROM emp
WHERE sal > ALL (SELECT sal FROM emp WHERE job = 'CLERK'); --������ 1300���� ���� ���
SELECT empno, ename, job, sal
FROM emp
WHERE sal < ALL (SELECT sal FROM emp WHERE job = 'CLERK'); --������ 800���� ���� ���

--EXISTS: ���������� ������� �ϳ� �̻� �����ϸ� TRUE
--���� ��������� �ʴ´�.

--���������� ������
--1.���������� SELECT���� ��� �� ���� �Բ� ����ϴ� ���������� ������ ������ ȣȯ �����ؾ� �Ѵ�!!!!!!
--���� ��� WHERE���� ����� �������� SELECT�� ����� �Ѱ��� �����µ� �������� WHERE���� IN�� ����Ѵٸ� ����
--���� ������ ���������� ������ �����ڸ� ����ؾ� �Ѵ�: --IN, ANY, SOME, ALL, EXISTS

--2.��κ��� �������������� ORDER BY���� ����� �� ����.

--���߿� ��������
--�����ȣ�� 7396, 7499�� ���� ���� �μ���ȣ�� ���� ��� ����� ��ȣ�� ����ȣ �� �μ���ȣ�� ���, �� 7469, 7499�� ����
SELECT empno, ename, mgr, deptno
FROM emp
WHERE   (mgr, deptno)IN (SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN (7369, 7499)) AND empno NOT IN (7369, 7499);
                         
--FROM���� ����ϴ� �ζ��� ��
--�������� ���� WITH ���� ����Ѵ�.

--���������� �̿��� INSERT
--���������� �̿��Ͽ� INSERT�� �Ҷ��� ������ �ؾ��ϰ� VALUES�� ��� ������ ����
INSERT INTO emp_copy(empno, ename, sal, job)
SELECT empno, ename, sal, job
FROM emp 
WHERE deptno = 30;
--����
--Q1. ��ü��� �� ALLEN�� ���� ��å�� ������� ��� ����, �μ� ������ ���
SELECT *
FROM emp INNER JOIN dept USING(deptno)
WHERE job = (SELECT job FROM emp WHERE ename = 'ALLEN');
--Q2. ��ü ����� ��� �޿����� ���� �޿��� �޴� ������� ��� ����, �μ� ����, �޿� ��� ������ ����ϴ� SQL���� �ۼ��϶�
--�� ������ �������� ����, ���� ������ ����� �������� ����
SELECT job, empno, ename, sal, deptno, dname, grade
FROM emp NATURAL JOIN dept 
     INNER JOIN salgrade ON sal BETWEEN losal AND hisal
WHERE sal > (SELECT AVG(sal) FROM emp)
ORDER BY sal DESC, empno ASC;
--Q3. 10�� �μ��� �ٹ��ϴ� ��� �� 30�� �μ����� �������� �ʴ� ��å�� ���� ������� �������, �μ� ������ ���
SELECT *
FROM emp NATURAL JOIN dept
WHERE deptno = 10 AND job NOT IN (SELECT job FROM emp WHERE deptno = 30);
--Q4. ��å�� SALESMAN�� ������� �ְ� �޿����� ���� �޿��� �޴� ������� �������, �޿� ��� ������ ������ ���� ����ϴ� SQL�� �ۤ���
--������ �Լ� �̿� X
SELECT empno, ename, sal ,grade
FROM emp INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE sal > (SELECT MAX(sal) FROM emp WHERE job = 'SALESMAN')
ORDER BY empno;
--������ �Լ�
SELECT empno, ename, sal ,grade
FROM emp INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE sal > ALL (SELECT sal FROM emp WHERE job = 'SALESMAN')
ORDER BY empno;

SELECT *
FROM emp;

--Ʈ�����
--ROLLBACK
--�Ϲ� ROLLBACK
COMMIT; --14:50
INSERT INTO emp(empno, ename, hiredate)
VALUES(7777, '������', SYSDATE);

UPDATE emp
SET sal = sal * 1.1
WHERE ename = 'SMITH';

DELETE FROM emp
WHERE ename = 'SCOTT';

ROLLBACK; --14:50 COMMIT;�� �̵�

--RALLBACK USING SAVEPOINT
COMMIT; --14:52
INSERT INTO emp(empno, ename, hiredate)
VALUES(7777, '������', SYSDATE);

UPDATE emp
SET sal = sal * 1.1
WHERE ename = 'SMITH';

SAVEPOINT b;

DELETE FROM emp
WHERE ename = 'SCOTT';

ROLLBACK TO b; -- SAVEPOINT b�� �̵� --> DELETE�� ��ҵ�

--JDBC BATCH �ǽ���
DESC emp_copy;
ALTER TABLE emp_copy
DROP CONSTRAINT emp_temp_hiredate_NN;
DESC emp_temp; --���̺� ����� �������� ���� 
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
MODIFY hiredate DATE DEFAULT SYSDATE CONSTRAINT emp_temp_hiredate_NN NOT NULL; --NOT NULL�� �÷����� ���� ����
