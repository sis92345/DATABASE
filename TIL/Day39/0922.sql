--Day39, 0922
--DDL
--CREATE
--ȯ�ڰ��� ���α׷��� ���̺�
--��ȣ, �����ڵ�, �Կ��ϼ�, ����, �����μ�, ������, �Կ���, �����
CREATE TABLE Patient(
    bunho      NUMBER(1), --1, 2,
    code       CHAR(2), -- MI
    days        NUMBER(3),
    age        NUMBER(3),   
    department VARCHAR(20),
    jinchalfee NUMBER(4),
    ipwonfee,  NUMBER(7),
    total      NUMBER(7)
);
--�޿����� ���α׷�
-- ���, ��, ȣ, ����, ���޾�, ����, �������޾�
CREATE TABLE Employee(
    empno   NUMBER(4),
    grade   NUMBER(2),
    ho      NUMBER(2),
    sudang  NUMBER(4),
    money   NUMBER(7),
    tax     NUMBER(3,2), --0.13, 1.05    
    sal     NUMBER(7)
);

-- é�� 10�� ���̺� ����
DROP TABLE chap10hw_dept;
DROP TABLE chap10hw_emp;
DROP TABLE chap10hw_salgrade;
DROP TABLE emp_copy;
DROP TABLE Student1;
DROP TABLE member;
--���� ���̺� �� ������ �����͸� �����Ͽ� �� ���̺��� ����
CREATE TABLE emp_copy
AS 
SELECT * FROM emp; -- emp table�� ������ �����͸� �״�� �����Ѵ�. ��, ���������� ������� �ʴ´�.
DESC emp_copy; --�⺻ emp ���̺��� NUT NULL�� ������ �ʴ´�. 
DESC emp;
--���� ���̺��� �� ������ �Ϻ� �����͸� �����Ͽ� �� ���̺� ����
--10�� �μ��� ����ִ� ���̺��� ����
CREATE TABLE emp10
AS
SELECT * 
FROM emp
WHERE deptno = 10;
--������ SALESMAN�� ����鸸 ����ִ� ���̺� �����ϵ�, ���, �̸�, ����, ����, �Ի糯¥�� ����
CREATE TABLE emp_salsman
AS
SELECT empno, ename, job, sal, hiredate
FROM emp
WHERE job = 'SALESMAN';
SELECT *
FROM emp_salsman;
--����: ���̺��� �����ϵ�, ���, �̸�, �μ��̸�, ��ġ, �μ���ȣ�� �����ϴ� ���̺��� �����ϵ�, �� �μ���ȣ�� 10���� 20����
CREATE TABLE emp_dept
AS
SELECT empno, ename, dname, loc, deptno
FROM emp e INNER JOIN dept d USING(deptno)
WHERE deptno IN (10,20)
ORDER BY deptno ASC;
SELECT * FROM emp_dept;
--������ ���̺��� �� ������ �����Ͽ� �� ���̺� ����
--������ ������ false�̵��� �ۼ��ϸ� �ȴ�.
CREATE TABLE emp_empty
AS
SELECT * FROM emp
WHERE 1 = 0; --������ ����
SELECT * FROM emp_empty;
--����
--���̺��� �����ؼ� �����ϵ�, �����ʹ� �������� ����, ������ �����϶�, ���, �̸�, ����, �μ��̸�, �μ���ġ, �μ���ȣ�� ����
CREATE TABLE emp_dept1
AS
SELECT empno, ename, job, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE 1 < 0;

--RENAME 
--RENAME oldname TO newname
SELECT * FROM emp_copy;
RENAME emp_copy TO emp_boksa;
SELECT * FROM emp_boksa;

--TRUCATE
TRUNCATE TABLE emp_boksa;

--DROP
DROP TABLE emp_boksa;
--������: �ܷ� Ű������ �����Ǵ� ����/�⺻ Ű�� ���̺� ������ ������ �� ����.
--�� �ڽ� ���̺��� �����ϰ� ������ ������ �ȵȴ�.
--���� ������ ��ɾ�� ������ �Ұ����ϴ�.
DROP TABLE dept;

--COMMENT
COMMENT ON TABLE emp_boksa IS '�� ���̺��� EMP ���̺��� ������ ���̺��Դϴ�.';
--COMMENT Ȯ��
DESC USER_tab_comments;
--�ݵ�� �ּ��� �޾Ҵٸ� Dictionary���� Ȯ������
SELECT table_name, table_type, comments
FROM user_tab_comments
WHERE table_name = upper('emp_boksa');

--COLUMN COMMENTS
COMMENT ON COLUMN emp_boksa.hiredate IS '�Ի糯¥�� �����ϴ� Į��';
--�÷� �ּ� Ȯ��
DESC USER_COL_COMMENTS;
SELECT table_name, column_name, comments
FROM user_col_comments
WHERE table_name = upper('emp_boksa');


--ALTER TABLE: table remodeling
--�����۾�
DROP TABLE emp_boksa;
DROP TABLE emp_dept;
DROP TABLE emp_empty;
DROP TABLE emp_salsman;
DROP TABLE emp_copy;
SELECT * FROM emp_copy10;
CREATE TABLE emp_copy10
AS
SELECT empno, ename
FROM emp
WHERE deptno = 10;
--add
DESC emp_copy10;
--Job Column�� �߰�
ALTER TABLE emp_copy10
ADD (job VARCHAR2(9));
--���� ���� �߰��ϸ� ���� �������� ���� �߰��� ���� ���� NULL���̴�.
--�Ի糯¥ �߰�
ALTER TABLE emp_copy10
ADD (hiredate DATE);
--���� �߰�
ALTER TABLE emp_copy10
ADD (sal NUMBER(7,2));

--RENAME
ALTER TABLE emp_copy10 
RENAME COLUMN sal TO salary;

--MODIFY
DESC emp_copy10;
--ename VARCHAR(10)�� ���̸� ����
ALTER TABLE emp_copy10
MODIFY ename VARCHAR(20);
--job VARCHAR(10)�� ���̸� ����
ALTER TABLE emp_copy10
MODIFY job VARCHAR(10);

ALTER TABLE emp_copy10
MODIFY empno NUMBER(5,0);
--�⺻�� ������ ���̸� ���� ���: ���� --Ȯ��
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES(55555, '������', '�������', SYSDATE); --�̹� �� �� ���� �����Ƿ� ���� ������ �� ����.
ALTER TABLE emp_copy10
MODIFY job VARCHAR(10);

--CHAR�� VARCHAR2 ���� ��ȯ�� �����ϴ�
ALTER TABLE emp_copy10
MODIFY job CHAR(30);

--DROP
ALTER TABLE emp_copy10
DROP COLUMN job;

--DDL ����
--Q1. ������ �� ������ ������ EMP_HW ���̺��� ����ÿ�
CREATE TABLE EMPHW(
    empno       NUMBER(4),
    ename       VARCHAR2(10),
    job         VARCHAR2(10),
    mgr         NUMBER(4),
    hiredate    DATE,
    sal         NUMBER(7,2),
    comm        NUMBER(7,2),
    deptno      NUMBER(2)
);
SELECT TABLE_NAME FROM USER_TABLES
WHERE TABLE_NAME = 'EMPHW';

--Q2. EMP_HW ���̺� BIGO���� �߰��϶�.BIGO ���� �ڷ����� ������ ���ڿ��̰� ���̴� 20�̴�.
ALTER TABLE EMPHW
ADD (BIGO VARCHAR2(20));

--Q3. EMPHW���̺��� BIGO�� ũ�⸦ 30���� �����϶�
ALTER TABLE EMPHW
MODIFY BIGO VARCHAR(30);
DESC EMPHW;

--Q4. EMPHW���̺��� BIGO �� �̸��� RWMARK�� �����϶�
ALTER TABLE EMPHW
RENAME COLUMN BIGO TO REMARK;

--Q5. EMPHW ���̺� EMP ���̺��� �����͸� ��� �����϶� �� REMARK ���� NULL�� ó���϶�
--�������� + INSERT
--VALUES��� �������� ��� ����
--�Ͻ����� ���
INSERT INTO EMPHW(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp;
--������� ���
INSERT INTO EMPHW(empno, ename, job, mgr, hiredate, sal, comm, deptno, remark)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno, NULL
FROM emp;

--Q5. EMPHW ���̺��� �����Ͻÿ�
DROP TABLE EMPHW;

SELECT *
FROM Student
WHERE hakbun = '2020-01';