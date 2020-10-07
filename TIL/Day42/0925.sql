--DAY42, 0925
--P.394 �������� ����
--Q1. DEPT_CONST ���̺�� EMP_CONST ���̺��� ������ ���� Ư�� �� ���� ������ �����Ͽ� ����� ���ÿ�
CREATE TABLE DEPT_CONST(
    deptno  NUMBER(2)    CONSTRAINT deptconst_deptno_PK PRIMARY KEY,
    dname   VARCHAR2(14) CONSTRAINT deptconst_dname_UK UNIQUE,
    loc     VARCHAR2(13) CONSTRAINT deptconst_loc_NN NOT NULL
);
--EMPCONST�� ERD�� ������
--������ �������� �ο�
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_CONST';
--�� �� ���� �� �������� ����
ALTER TABLE DEPT_CONST
DROP CONSTRAINT SYS_C007702;
--������ �������� �ο�
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'EMP_CONST';
--�� �� ���� �� �������� ����
ALTER TABLE EMP_CONST
DROP CONSTRAINT SYS_C007705;
ALTER TABLE EMP_CONST
DROP CONSTRAINT SYS_C007706;
ALTER TABLE EMP_CONST
DROP CONSTRAINT FK_DEPT_CONST_TO_EMP_CONST;
ALTER TABLE EMP_CONST
DROP CONSTRAINT DEPTCONST_TEL_UNQ;
--���ο� ���� ���� �ο�
ALTER TABLE EMP_CONST
MODIFY ENAME CONSTRAINT EMPCONST_ENAME_NN NOT NULL; --COLUMN-LEVEL CONSTARINTL: NOT NULL�� ���̺� ���� �������� �Ұ�

ALTER TABLE EMP_CONST
ADD CONSTRAINT EMPCONST_TEL_UNQ UNIQUE(TEL); --TABLE-LEVEL CONSTARINT

ALTER TABLE EMP_CONST
ADD CONSTRAINT EMPCONST_SAL_CHK CHECK(SAL BETWEEN 1000 AND 9999);
--����  FOREIGN �ݵ�� Ȯ��
ALTER TABLE EMP_CONST
MODIFY DEPTNO CONSTRAINT EMPCONST_DEPTNO_FK REFERENCES DEPT_CONST(DEPTNO);

ALTER TABLE EMP_CONST
ADD CONSTRAINT EMPCONST_DEPTNO_FK FOREIGN KEY(deptno)
REFERENCES DEPT_CONST(DEPTNO);
-- �������� Ȯ��
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, table_name
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP_CONST','DEPT_CONST');
--�������� �̸� ����
ALTER TABLE DEPT_CONST
RENAME CONSTRAINT DEPTCONST_DEPTNO_PK TO PK_DEPT_CONST;
ALTER TABLE DEPT_CONST
RENAME CONSTRAINT PK_DEPT_CONST TO DEPTCONST_DEPTNO_PK;

--SEQUENCE
-- �����۾�
DROP SEQUENCE dept_deptno_seq;
-- SEQUENCE ����
CREATE SEQUENCE test_seq
    START WITH 1
    INCREMENT BY 1
    NOCYCLE
    MAXVALUE 100
    CACHE 20;
--SEQUENCE �̿�
SELECT test_seq.CURRVAL, test_seq.NEXTVAL
FROM DUAL; --MAXVALUE 100�̻� ���� -���� SEQUENCE�� ������ CYCLE�̶�� �ٽ� 0���� ���ư���.
--SEQUENCEQ ����
ALTER SEQUENCE test_seq
    INCREMENT BY 10;
DROP SEQUENCE test_seq;
-- SEQUENCE Ȱ��
CREATE TABLE dept_clone
AS
SELECT *
FROM dept
WHERE 1<0;

ALTER TABLE dept_clone
ADD CONSTRAINT dept_clone_deptno_OK PRIMARY KEY(deptno); --�⺻ Ű�� ����� �ߺ���, NULL�� ����� �Ѵ� --> SEQUENCE ���

CREATE SEQUENCE DEPT_DEPTNO_SEQ
    START WITH 10
    INCREMENT BY 10
    MAXVALUE 99 -- �μ� ���̺��� �μ� ��ȣ�� NUMBER(2)�̴ϱ� 
    CACHE 20;
    
INSERT INTO DEPT_CLONE(deptno, dname, loc)
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'������','SEOUL'); --10
    
INSERT INTO DEPT_CLONE(deptno, dname, loc)
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'�ѹ���','SEOUL'); --20
    
INSERT INTO DEPT_CLONE(deptno, dname, loc)
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'���','PUSAN'); --30

SELECT *
FROM DEPT_CLONE;
--VIEW
--�Ϲ� ������ VIEW�� ����� �� ����.
CREATE VIEW test_view
AS
SELECT * FROM emp;
--VIEW ���� ���� �ο�: SQLPLUS����
GRANT CREATE VIEW TO SCOTT;
--FORCE: VIEW���� ����, �⺻���� NO FORCE
CREATE FORCE VIEW test1_view
AS
SELECT * FROM aaa; --���̺��� ������ VIEW�� ��������� �ʴ´�:NO FORCE, ���̺��� ��� VIEW ����: FORCE
-- VIEW�� ����
DROP VIEW test1_view; --VIEW�� �����ص� ��� ���̺��� ���� ������ ����.

--VIEW�� ����: emp ���̺��� 10�� �μ��� �ٶ󺸴� VIEW
CREATE OR REPLACE VIEW emp_dept10_view
AS
SELECT empno, ename, dname, loc, sal, deptno
FROM emp NATURAL JOIN dept
WHERE deptno = 10;

--VIEW�� �̿�
SELECT * FROM emp_dept10_view
ORDER BY sal DESC; --ORDER BY�� �̶� ����Ѵ�

SELECT * FROM emp_dept10_view
WHERE sal > 2000; --VIEW�� ������ ����� �� �ִ�.
--VIEW�� ����: OR REPLACE ���
--OR REPALEC�� ���� �̸��� �䰡 ������ ��� ���� ������ ��� ��ü�Ͽ� �����Ѵ�.
CREATE OR REPLACE VIEW emp_dept10_view
AS
SELECT empno, ename, dname, loc, sal, deptno
FROM emp NATURAL JOIN dept
WHERE deptno = 10;

--
CREATE OR REPLACE NOFORCE VIEW EMP1982_VIEW(EMPOLYEE_ID,EMPOLYEE_NAME, HIRE_DATE, DEPARTMENT_NAME, LOCATION, DEPARTMENT_ID)
AS
SELECT empno, ename, hiredate, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE TO_CHAR(hiredate, 'YYYY') = '1981';

SELECT *
FROM  EMP1982_VIEW;
--�ܼ���(Simple View)�� DML�� �����ϰ�, ���պ�� DML�� �Ұ����ϴ�.
INSERT INTO EMP1982_VIEW(EMPOLYEE_ID,EMPOLYEE_NAME)
VALUES(8888, '������'); --VIEW�� ������ �ƴ� ���̺� �����Ѵ�,
ROLLBACK;

CREATE OR REPLACE NOFORCE VIEW EMP1982_VIEW(EMPOLYEE_ID,EMPOLYEE_NAME, HIRE_DATE, DEPARTMENT_NAME, LOCATION, DEPARTMENT_ID)
AS
SELECT empno, ename, hiredate, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE TO_CHAR(hiredate, 'YYYY') = '1981'
WITH READ ONLY; --DML�� ������ �� �ִ�. 

--WITH READ ONLY: ��ü ������ ������ ����(��ü�� ������� READ ONLY ����)
--WITH CHECK OPTION: �������� �ִ� ������ �����Ҷ���
CREATE OR REPLACE VIEW test_view
AS 
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 20
WITH CHECK OPTION; --������ ������ ������ DML�� ����, VIEW�� ���鶧 ����� WHERE���� ���ǰ� ��ġ���� ������ ���� �ź�
COMMIT; --12:25��
ROLLBACK;
INSERT INTO test_view(empno,ename,sal,deptno)
VALUES(9999, '������',2000,20);

--TOP-N QUERY: 
--�Ʒ��� ���� ���� ������ 3���� �����͸� sal �������� ����
SELECT ROWNUM, ename, sal
FROM emp
WHERE ROWNUM <=3
ORDER BY sal DESC;

CREATE OR REPLACE view emp_sal_dec_view
AS
SELECT ename, sal
FROM emp
ORDER BY sal DESC;
--���θ��� ���� ���θ��� ROWNUM�̹Ƿ� ������ ������������ ���� --> ROWNUM ���� 3�� ��� == ���� ���� ���� 3��� ��� 
SELECT ROWNUM, ename, sal FROM emp_sal_dec_view
WHERE ROWNUM<=3;

--�μ����� �μ���, �ּ� �޿�, �ִ� �޿�, �μ��� ��� �޿��� �����ϴ� DEPT_SUM VIEW ����
CREATE OR REPLACE VIEW DEPT_SUM(deptno, dname, min_sal, max_sal, avg_sal)
AS
SELECT  emp.deptno, dept.dname, MAX(sal),MIN(sal), TRUNC(AVG(sal))
FROM emp INNER JOIN dept ON (emp.deptno = dept.deptno)
GROUP BY emp.deptno, dept.dname;

DESC dept_sum;
SELECT * FROM dept_sum;

--2. emp table���� �����ȣ, �̸�, ������ �����ϴ� emp_view VIEW�� �����Ͻÿ�
CREATE OR REPLACE VIEW EMP_VIEW
AS
SELECT empno, ename, job
FROM emp;
--3. �� 2������ ������ VIEW�� �̿��Ͽ� 10�� �μ��� �ڷḸ ��ȸ�Ͻÿ�
SELECT *
FROM emp_view
WHERE deptno = 10;
--4. �� 2������ ������ VIEW�� Data Dictionary���� ��ȸ�Ͻÿ�
DESC USER_VIEWS;
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS
WHERE VIEW_NAME = UPPER('EMP_VIEW');
--5. �̸�, ����, �޿�, �μ���, ��ġ�� �����ϴ� emp_dept_name �̶�� VIEW�� �����Ͻÿ�
CREATE OR REPLACE VIEW EMP_DEPT_NAME("�̸�", "����", "�޿�", "�μ���", "��ġ")
AS
SELECT ename, job, sal, dname, loc
FROM emp e INNER JOIN dept d ON(e.deptno = d.deptno);

SELECT * FROM EMP_DEPT_NAME;

--6. 1987�⿡ �Ի��� ����� �� �� �ִ� ��
CREATE OR REPLACE VIEW emp1987_view 
AS
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate BETWEEN '87/01/01' AND '87/12/31';
-- WHERE hiredate >= 87/01/01 AND hiredate <= '87/12/31';
-- WHERE SUBSTR(hiredate,1,2) = '87';
-- WHERE hiredate LIKE '87%';
-- WHERE TO_CHAR(hiredate,'YYYY') = '1987';

--1. DEPT TABLE�� �⺻ Ű ���� ����� �������� ���� ���ǿ� �°� �����Ͻÿ�
-- ������ ���� 60���� �����ؼ� 10�� �����ϸ� �ִ� 200���� �����ϵ��� �Ѵ�
-- ������ �̸��� dept_deptno_seq�̴�.
CREATE SEQUENCE  dept_deptno_seq
    START WITH 60
    INCREMENT BY 10
    MAXVALUE 200;
DROP SEQUENCE dept_deptno_seq;
--2. �� 1���� ���� �������� �̸�, �ִ밪, ������, ������ ��ȣ�� ������ �Ʒ��� ���� ��µǵ��� Data_Dictionary���� ��ȸ
SELECT SEQUENCE_NAME, MAX_VALUE, INCREMENT_BY, LAST_NUMBER
FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'DEPT_DEPTNO_SEQ';

--3. �� 1���� ���� �������� �̿��Ͽ� �μ��̸��� education, �μ� ��ġ�� seoul�� �� ���� dept ���̺� �߰��ϰ� �Ʒ��� ���� ��ȸ
COMMIT;
INSERT INTO dept
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL , 'EDUCATION','SEOUL');

--INDEX
--UNIQUE INDEX: ���� �ߺ����� �������� �ʾƾ� �Ѵ�.
DESC USER_INDEXES;
SELECT INDEX_NAME, INDEX_TYPE, TABLE_NAME
FROM USER_INDEXS;

--P.357
--Q1
--1-1 EMP ���̺�� ���� ������ �����͸� �����ϴ� EMPIDX���̺��� ����� ������
CREATE TABLE EMPIDX
AS
SELECT *
FROM emp
WHERE 1<0;
--1-2 ������ EMPIDX ���̺��� EMPNO���� IDX_EMPID_EMPNO �ε����� ����� ������
CREATE INDEX IDX_EMPID_EMPNO ON EMPIDX(EMPNO ASC);
--1-3 ���������� �ε����� �� �����Ǿ����� ������ ���� �並 ���� Ȯ���Ͻÿ�
SELECT INDEX_NAME, INDEX_TYPE, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'EMPIDX';

--Q2. 
CREATE OR REPLACE VIEW EMPIDX_OVER15K(EMPNO, ENAME, JOB, DEPTNO, SAL, COMM)
AS
SELECT empno, ename, job, deptno, sal, NVL2(comm, 'O','X')
FROM  emp
WHERE sal >1500;

SELECT *
FROM EMPIDX_OVER15K;

--Q3
CREATE SEQUENCE DEPTSEQ
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 99
    MINVALUE 1
    NOCYCLE
    NOCACHE;
INSERT INTO dept
VALUES(DEPTSEQ.NEXTVAL, 'DATABASE', 'SEOUL');
INSERT INTO dept
VALUES(DEPTSEQ.NEXTVAL, 'WEB', 'BUSAN');
INSERT INTO dept
VALUES(DEPTSEQ.NEXTVAL, 'MOBILE', 'ILSAN');