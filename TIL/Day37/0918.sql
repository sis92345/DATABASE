--0918. DAY37
--emp ���̺��� ����
CREATE TABLE emp_copy 
AS 
SELECT *
FROM emp; --14rows, 8colums
-- ��Ű�� ������ ����
CREATE TABLE emp_copy
AS
SELECT *
FROM emp
WHERE 0 > 1; --WHERE�� �����̵Ǹ� �� ���ǿ� �´� �����Ͱ� ���⿡ ��Ű���� ī��

SELECT * 
FROM emp_copy;

--DML
--INSERT

INSERT INTO emp_copy(empno, ename, mgr, hiredate)
VALUES (8001,'CHULSU', 7369, SYSDATE);

INSERT INTO emp_copy(empno, ename, job, sal)
VALUES(8002, 'YOUNGHEE', 'DESIGNER', 1500);

DROP TABLE emp_copy;

INSERT INTO emp_copy(empno, ename, sal, comm, deptno)
VALUES (1111, 'CHULSU', 800, 100, 40);

INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (2222, 'HANJIMIN', 'DEVELOPER', SYSDATE);

--������ ��ġ���� �ʴ� ��� ����
--INSERT INTO emp_copy(empno, ename, job, hiredate)
--VALUES (2222, 'HANJIMIN', SYSDATE);

--empno�� NUMBER���� ���ڿ� �Է��ص� �ڵ�����ȯ�� �Ǿ� �Էµȴ�.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES ('2223', 'HANJIMIN', 'MARKETTER',SYSDATE);


--empno�� NUMBER���� ���ڿ� �Է��ص� �ڵ�����ȯ�� �Ǿ� �Էµȴ�. --�� ������ Ÿ���� �ƿ� �ٸ� ���� �ڵ�����ȯ�� �ȵȴ�.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES ('hale', 'HANJIMIN', 'MARKETTER',SYSDATE);

-- �����Ϳ� �� �� �ִ� ����� ��������
SELECT LENGTH(ename), LENGTHB('�ȳ�')
FROM emp_copy;

INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (4444, '�̵����ʹ»�����ʰ��մϴ�', 'MARKETTER',SYSDATE);

--NULL ó��
--�Ͻ����� ���
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (4444, 'HOJUNE', 'MARKETTER',SYSDATE); -- ������ 4�� ���� �ڵ����� NULL ó��
--������� ���
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (5555, UPPER('girlsday'), NULL ,NULL); -- empno�� null�� ������ �������� ���� NULL

--INSERT ������ ������ �Է�
INSERT INTO emp_copy(empno, ename, hiredate)
VALUES (6666, 'BTS', TO_DATE('01-02-2019', 'MM-DD-YYYY')); -- '2019-01-02'? '01-02-2019'? --> ��¥�� �����Ϳ��� NLS_DATE_FORMET�� �˾ƾ� �Ѵ�.
--�� �ι� ���� �������� TO_DATE�� ���

--Foreign Key�� �����ؾ� �Ѵ�.
SELECT deptno FROM dept;

INSERT INTO emp(empno, ename, deptno)
VALUES (8888, 'JIMIN', 77); -- deptno�� Foreign Key,deptno���� 77���� ����.

DROP TABLE emp_copy;


----UPDATE
SELECT *
FROM emp_copy;

--UPDATE ����
--WHERE���� ������� ������ ���̺� �� ������ ��� ���� �����Ͱ� �����ȴ�.
UPDATE emp_copy
SET deptno = 10; -- ��� ���� deptno�� 10���� �����ȴ�.

--������ ����ؼ� �Ϻ� �ุ �����ϱ�
UPDATE emp_copy 
SET sal = 1000
WHERE empno <= 3000;

UPDATE emp_copy
SET sal = 2000
WHERE ename = 'JIMIN';

--�Ϻ� ���� �����ϱ�
UPDATE emp_copy 
SET job = 'DESIGNER', mgr = 3333, sal = 3000, deptno = 20 -- ������ ��� ����.
WHERE empno = 4444;

--1. �����Ϸ��� ���� ���� �ľ�(��ü, �Ϻ�, �� �ϳ�) --> WHERE �������� ���� ����
--2. �����Ϸ��� �÷��� ���� �ľ�(��ü Į�� ������ ����. �� �Ѱ��� �÷�, �Ϻ� �÷��� ������ ���ΰ�?) --> ��ǥ(,)�� ����� ���ΰ�?

--UPDATE���� ���Ἲ ���� ����
UPDATE emp
SET deptno = 98949
WHERE ename = 'SMITH';

UPDATE emp_copy
SET mgr = 3333, sal = 1500, comm = 100
WHERE empno = 5555;

COMMIT;
--DELETE
--��� ������ ����
DELETE FROM emp_copy;

ROLLBACK;

DELETE FROM emp_copy 
WHERE empno = 2222;

--10�� ����
-- 
CREATE TABLE CHAP10HW_EMP AS SELECT * FROM emp;
CREATE TABLE CHAP10HW_DEPT AS SELECT * FROM dept;
CREATE TABLE CHAP10HW_SALGRADE AS SELECT * FROM salgrade;
DROP TABLE CHAP10HW_SALGRADE;
--Q1 CHAP10HW_DEPT���̺� 50,60,70,80�� �μ��� ���
INSERT INTO CHAP10HW_DEPT 
VALUES(50, 'ORACLE', 'BUSAN');

INSERT INTO CHAP10HW_DEPT 
VALUES(60, 'SQL', 'ILSAN');

INSERT INTO CHAP10HW_DEPT 
VALUES(70, 'SELECT', 'INCHEON');

INSERT INTO CHAP10HW_DEPT 
VALUES(80, 'DML', 'BUNDANG');

SELECT * FROM CHAP10HW_DEPT;

--Q2 CHAP10HW_EMP ���̺� 2���� ����� �Է��Ͻÿ�
--����� NULLó��
INSERT INTO CHAP10HW_EMP
VALUES(7201, 'TEST_USER1', 'MANAGER', 7788, TO_DATE('2016-01-02','YYYY-MM-DD'), 4500, NULL, 50);
--�Ͻ��� NULLó��
INSERT INTO CHAP10HW_EMP(empno, ename, job, mgr, hiredate, sal, deptno)
VALUES(7202, 'TEST_USER2', 'CLERK', 7201, TO_DATE('2016-02-21','YYYY-MM-DD'), 1800, 50);

SELECT * FROM CHAP10HW_EMP;
--Q3 CHAP10HW_EMP�� ���� ��� �� 50�� �μ����� �ٹ��ϴ� ������� ��� �޿����� ���� �޿��� �ް��ִ� ������� 70�� �μ��� �ű�� SQL�� �ۼ�
--�������� �̻������ �� ��
SELECT AVG(sal)
FROM CHAP10HW_EMP
WHERE deptno = 50;

UPDATE CHAP10HW_EMP
SET deptno = 70
WHERE sal > 3150;

ROLLBACK;

--Q4.(����) 20�� �μ��� ��� �� �Ի����� ���� ���� ������� �� �ʰ� �Ի��� ����� �޿��� 10% �λ��ϰ� 80�� �μ��� �Űܶ�
UPDATE CHAP10HW_EMP
SET sal = sal * 1.1, deptno = 80
WHERE hiredate > (SELECT MAX(hiredate)FROM CHAP10HW_EMP WHERE deptno = 20);

--Q5. CHAP10HW_EMP�� ���� ��� ��, �޿� ����� 5�� ����� �����ϴ� SQL�� �ۼ�
DELETE FROM CHAP10HW_EMP
WHERE empno IN (SELECT e.empno FROM CHAP10HW_SALGRADE INNER JOIN CHAP10HW_EMP e ON e.sal BETWEEN losal AND hisal  WHERE grade = 5); 

SELECT ename, grade 
FROM CHAP10HW_SALGRADE INNER JOIN CHAP10HW_EMP e ON e.sal BETWEEN losal AND hisal  
WHERE grade = 5;

SELECT *
FROM CHAP10HW_EMP;


--student ���̺� �Է¿�
INSERT INTO student
VALUES('2020-01', '������', 100, 100, 100, 300, 100.00, 'A');
commit; --COMMIT �ؾ��� --> �׷��� JDBC �̿� ����