--Day44, 0929
--DML
--CREATE USER
ALTER SESSION SET "_ORACLE_SCRIPT"=True; --Oracle 12c �̻��� ������ ������ �� ���� �ݵ�� �ؾ� �Ѵ�
--�Ϲ� ������ ����ڸ� ������ �Ǹ��� ����.
CREATE USER Jimin
IDENTIFIED BY Jimin;

--�ý��� ���� Ȯ��
DESC DBA_SYS_PRIVS;
SELECT GRANTEE, PRIVILEGE, ADMIN_OPTION
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'JIMIN';

--��ü ���� :scott
SHOW USER;

GRANT SELECT --SELECT���� �ο�
ON scott.emp --scott������ emp��
TO jimin; --jimin���� 

GRANT DELETE, UPDATE, INSERT, SELECT
ON scott.emp_clerk
TO jimin;

REVOKE SELECT ON emp FROM jimin;

--��ü ���� Ȯ��
SELECT * FROM USER_TAB_PRIvS_MADE; --������ �ο��� ��� ����

--ROLE
--1. level1�̶�� Roll����
CREATE ROLE level1;

--2. level1�� ���� ����
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO level1;

--3. test1/tiger, test2/tiger ���� ����
CREATE USER test1
IDENTIFIED BY tiger
DEFAULT tablespace users
temporary tablespace temp;

CREATE USER test2
IDENTIFIED BY tiger
DEFAULT tablespace users
temporary tablespace temp;

--4. ����� test1/2���� level1�� �ο�
GRANT level1 TO test1;

GRANT level1 TO test2;

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE IN ('LEVEL1');

--5. ���� ȸ��
REVOKE level1 FROM test1;
REVOKE level1 FROM test2;

--6. ROLE ����
DROP ROLE level1;

--DML ����
--Q1. ���� ������ �����ϴ� SQL���� �ۼ��Ͻÿ�
CREATE USER PREV_HW
IDENTIFIED BY ORCL
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE temp;

GRANT CONNECT TO PREV_HW;

--Q2. SCOTT �������� �����Ͽ� ������ ������ PREV_HW ������ SCOTT ������ EMP, DEPT, SALGRADE���̺� SELECT ������ �ο��ϴ� SQL���� �ۼ�
GRANT SELECT
ON scott.emp
TO PREV_HW;
GRANT SELECT
ON scott.dept
TO PREV_HW;
GRANT SELECT
ON scott.salgrade
TO PREV_HW;
--
GRANT SELECT 
ON scott.emp, scott.dept, scott.salgrade
TO PREV_HW;

--Q3. SCOTT �������� �����Ͽ� PREV_HW ������ SALGRADE ���̺��� SELECT ������ ����ϴ� SQL���� �ۼ��϶�, Ȯ�εǸ� SALGRADE ���̺��� ��ȸ ���θ� Ȯ��
REVOKE SELECT
ON scott.salgrade
FROM PREV_HW;


--SYNONYM
CREATE SYNONYM mySynonym
FOR scott.emp; --�Ϲ� ������ SYNONYM�� ������ �� �ִ� ������ ����.
--���
SELECT *
FROM emp;
SELECT *
FROM mySynonym;
--���� �ο�
GRANT CREATE SYNONYM TO SCOTT; -- ����� Synonym ���� ���� �ο�
GRANT CREATE PUBLIC SYNONYM TO SCOTT; -- ���� Synonym ���� ���� �ο�

--JIMIN������ �ó������ SELECT���� �ο� --> ���ȼ� ����
GRANT SELECT
on scott.mySynonym
to jimin;

--PUBLIC SYNONYM: ���� SELECT���� �ʿ�
--�Ϲ� SYNONYM�� �ٸ��� �ٸ� �������� ����� �� �����ڸ� ���� �ʾƵ��ȴ�.
CREATE PUBLIC SYNONYM department
FOR dept;

GRANT SELECT
ON department
TO jimin;

