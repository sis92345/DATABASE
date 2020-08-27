-- 0827: Day31
REM DATE: 2020�� 8�� 27��
REM Author: AN 
REM Objective: Basic SQL�� Oracle �Լ� �н��ϱ�
REM Environment: Windows 10, Oracle SQL Developer, Oracle DataBase 19c Enterorise Ed.

--�������� 
--������̺��� �޿��� 1000���̻��̰�, �μ���ȣ�� 30���� ����� �����ȣ, ����, ��پ���, �޿�, �μ���ȣ ���
SELECT empno AS "�����ȣ", ename AS "����", job AS "������", sal AS "�޿�", deptno AS "�μ���ȣ"
FROM emp
WHERE deptno = 30 AND sal >= 1000;
--����� 7788�� ����� �̸��� �޿��� ����Ͻÿ�.
SELECT name. sal
FROM emp 
WHERE empno = 7788;
--�޿��� 3000�� �Ѵ� ������ �����Ͻÿ�.
SELECT DISTINCT job
FROM emp
WHERE sal >= 3000;
--PRESEDENT�� ������ ������� �̸��� ����
SELECT ename AS "�̸�", sal AS "�޿�"
FROM   emp
WHERE  job != 'PRESIDENT';
--BOSTON ������ �ִ� �μ��� ��ȣ�� �̸��� ���
SELECT deptno AS "�μ���ȣ", dname AS "�μ��̸�"
FROM   dept
WHERE  loc = 'BOSTON';

-- SQL ������
-- 1. IN
-- IN�� ������� ���� SQL��
SELECT ename, job
FROM emp
WHERE job = 'CLERK' OR job = 'MAMAGER' OR job = 'ANALYST';
-- IN ���
SELECT ename, job
FROM emp
WHERE job IN ('CLERK', 'MANAGER', 'ANALYST');

SELECT empno, ename, sal, mgr
FROM emp
WHERE mgr IN (7902, 7566, 7788);

SELECT dname
FROM   dept
WHERE  deptno IN (10, 20);

-- 2. BETWEEN A AND B
-- BETWEEN A AND B �� �� ���
SELECT ename, job, sal
FROM emp
WHERE sal >= 1300 AND sal<=1500;

-- BETWEEN A AND B �� ���
SELECT ename, job, sal
FROM emp
WHERE sal BETWEEN 1300 AND 1500;

-- 3. ��¥ ���� �ٷ��
-- DATE ������ �׻� NLS_DATE_FORMAT ���Ŀ� ���߾�� �Ѵ�.
SELECT parameter, value 
FROM NLS_SESSION_PARAMETERS; 
--
ALTER SESSION
SET NLS_DATE_FORMAT = 'YYYY-MM-DD';  

SELECT hiredate
FROM emp
WHERE deptno = 10;

--==================
-- 1981�⿡ �Ի��� ����� ���, �̸�, �Ի糯¥�� ����ϴ� ��� 5����
-- 1. ����
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '1987-01-01' AND hiredate <= '1987-12-31';
-- 2. BETWEEN ���
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate BETWEEN '1987-01-31' AND '1987-12-31';
-- 3. LIKE ������, WildCard: %, _
--�̷�
SELECT ename
FROM emp
WHERE ename LIKE 'S____'; -- ���ϵ�ī�带 ����� ���� �ݵ�� LIKE ���

SELECT ename, job
FROM emp
WHERE job LIKE '%S_'; --%�� ��ġ�� �����Ӱ� ���� ����
-- ���� ������ ���� �ϸ� �ȴ�. (3)
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate LIKE '1987%';

SELECT COUNT(*)
FROM ZIPCODE;

DESC zipcode;
-- ���ϵ�ī�� ����
SELECT *
FROM ZIPCODE
WHERE dong LIKE '����%' AND SIDO = '����';
--���ϵ�ī���� ESCAPSE: �����Ϳ� _ �� %�� ���ٸ� EACAPE Ȱ��
SELECT ename
FROM emp
WHERE ename LIKE '$_T%' ESCAPE '$';

--�츮ȸ�翡�� ���ʽ��� ���� �ʴ� ��� ������ ��ȸ�Ͻÿ�
SELECT *
FROM emp
WHERE comm IS NULL;
--�츮ȸ�翡�� �޴����� ���� ����� ��ȸ�Ͻÿ�.
SELECT ename, job
FROM emp
WHERE mgr IS NULL;

-- ================
--  ����
SELECT *    
FROM emp
ORDER BY comm DESC;

--���� ������

--���̺� ����: ���տ����� ������
CREATE TABLE emp10
AS 
SELECT * FROM emp
WHERE deptno = 10; 

CREATE TABLE emp20
AS 
SELECT * FROM emp
WHERE deptno = 20; 

SELECT *  FROM emp10;
SELECT *  FROM emp20;

-- UNION
SELECT empno, ename, deptno
FROM emp10
UNION
SELECT empno, ename, deptno
FROM emp20;
-- ����: emp_clerk(������ clerk), emp_manager(������ manager)
CREATE TABLE emp_clerk
AS
SELECT *
FROM emp
WHERE job = 'CLERK';

CREATE TABLE emp_manager
AS
SELECT *
FROM emp
WHERE job = 'MANAGER';
-- ����2: UNION�� Ȱ���� emp_tf ���̺� ����, �� ����� ���, �̸�, ���������� ������ �ΰ��� ���̺��� ���Ķ�
CREATE TABLE emp_tf
AS
SELECT  empno, ename, job
FROM emp
WHERE job = 'CLERK'
UNION
SELECT empno, ename, job
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM emp_tf;

--MINUS
SELECT ename, job
FROM emp       --14��
MINUS
SELECT ename, job
FROM emp_clerk; --4��

--INTERSECT
SELECT ename, job
FROM emp       --14��
INTERSECT
SELECT ename, job
FROM emp_clerk; --4��

-- ������ ���� ���̺� ���� ����

--P.125 ����
--1
SELECT *
FROM emp
WHERE ename LIKE '%S';
--2
SELECT empno, ename, job, deptno
FROM emp
WHERE deptno = 30 AND job = 'SALESMAN';
--3
--3-1 ���տ����� X
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno IN (20, 30) AND sal > 2000;
--3-2 ���տ����� ���:
SELECT empno, ename, sal, deptno
FROM emp 
WHERE sal > 2000
MINUS
SELECT  empno, ename, sal, deptno
FROM emp 
WHERE deptno NOT IN (20, 30);
--4
SELECT *
FROM emp
WHERE NOT(sal >= 2000 AND sal <= 3000);
--5
SELECT ename, empno, sal, deptno
FROM emp
WHERE (sal NOT BETWEEN  1000 AND 2000) AND ename LIKE '%E%';
--6
SELECT *
FROM emp
WHERE comm is null AND job IN ('MANAGER', 'CLERK') AND mgr IS NOT NULL AND NOT ename = '_L%';
--6-1 ������ ���� ��������
SELECT *
FROM emp
WHERE comm is null
INTERSECT
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK')
INTERSECT
SELECT *
FROM emp
WHERE mgr IS NOT NULL
INTERSECT
SELECT *
FROM emp
WHERE NOT ename = '_L%';
/




