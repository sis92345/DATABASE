--DAY40, 0923
--DEFAULT option
--INSERT �� �� �Ͻ������� NULL�� ���� �ڵ������� ��ü�� ���� ������ �� ���
--�����۾�
DROP TABLE emp_copy10;
DROP TABLE TESTTABLE;

-- ���ڸ� �Է� �� �� ��� ���� ��¥�� �⺻������ ����, 
CREATE TABLE emp_copy10(
    empno       NUMBER(4),
    ename       VARCHAR2(200),
    hiredate    DATE            DEFAULT SYSDATE, --����Ʈ�� �� �����ʹ� �ش� �÷��� ������ Ÿ�԰� ��ġ�ؾ� �Ѵ�.
    job         VARCHAR2(50)    DEFAULT 'DEVELOPER',
    sal         NUMBER(7)       DEFAULT 800000
);
--emp_copy10�� �Ͻ������� NULL�� ���� ��� �⺻���� �ְԵȴ�.
INSERT INTO emp_copy10(empno, ename)
VALUES(1111, '������');

INSERT INTO emp_copy10(empno, ename, job)
VALUES(2222, '������', 'SALESMAN');

--��������� NULL�� ���� ��� DEFAULT Ű���带 ����ؾ� DEFAULT option�� ����.
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES(3333, '������', NULL, NULL);

INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES(3333, '������', DEFAULT, DEFAULT);


SELECT * FROM emp_copy10; --�⺻���� �߰��Ǿ� �ִ�.

-- DEFAULT option��
CREATE TABLE member -- ���̺��� �����ؼ� �����ϸ� ��� ���������� �����ȴ�.
AS 
SELECT  empno, ename
FROM emp
WHERE 1 = 0; -- ��Ű���� �����´�.

DESC member;
-- �÷� �߰�
ALTER TABLE member
ADD (gender NUMBER(1));
--�߰��� �÷� ����
ALTER TABLE member
MODIFY (gender VARCHAR(7) DEFAULT '����');

INSERT INTO member(empno, ename)
VALUES (1111, '������');

SELECT * FROM member;
--PRIMARY KEY
--�����غ�
DROP TABLE emp_copy10;
DROP TABLE member;
--1. Column-level ������������ �����ϱ�
CREATE TABLE Member(
    userid  CHAR(14)        PRIMARY KEY, -- Column-level ��������: ��� ���� ������ �÷��� ���� ���
    passwd  VARCHAR2(20),
    name    VARCHAR2(20),
    age     NUMBER(2),
    city    VARCHAR2(20)    DEFAULT 'SEOUL'
);
--1-1. Column-level �������ǿ� �̸� �ο��ؼ� ����
-- �Ϲ����� ����: ���̺��̸�_�÷��̸�_PK | UK | NN | FK | CK
CREATE TABLE Member(
    userid  CHAR(14)       CONSTRAINT member_userid_PK PRIMARY KEY, 
    passwd  VARCHAR2(20),
    name    VARCHAR2(20),
    age     NUMBER(2),
    city    VARCHAR2(20)    DEFAULT 'SEOUL'
);
--2. Table-level ������������ �����ϱ�
CREATE TABLE Member(
    userid  CHAR(14),
    passwd  VARCHAR2(20),
    name    VARCHAR2(20),
    age     NUMBER(2),
    city    VARCHAR2(20) DEFAULT 'SEOUL',
    -- Table-level�� ���⼭���� ���������� �ο��Ѵ�.
    CONSTRAINT member_userid_pk PRIMARY KEY(userid)
);

INSERT INTO Member(userid, passwd)
VALUES(1111, '12345');
INSERT INTO Member(userid, passwd)
VALUES(1111, '12345'); --userid�� �����̸Ӹ�Ű�̹Ƿ� �ߺ����� ������ �� ����.
INSERT INTO Member(userid, passwd)
VALUES(NULL, '12345'); -- userid�� �����̸Ӹ�Ű�̹Ƿ� NULL���� ������� �ʴ´�.
--PRIMARY KEY Ȯ��
SELECT table_name
FROM USER_TABLES;

DESC USER_CONSTRAINTS;
SELECT OWNER, Constraint_name, constraint_type, table_name
FROM USER_constraints
WHERE table_name = 'MEMBER';

DROP TABLE member;
--�������ǿ� �̸� �ο��ϱ�
-- �Ϲ����� ����: ���̺��̸�_�÷��̸�_PK | UK | NN | FK | CK


--ProductMgmt.exerd�� ���̺� ����
CREATE TABLE Product(
    productid   CHAR(7),
    name        VARCHAR2(20),
    price       NUMBER(8),
    pdate       DATE DEFAULT SYSDATE,
    maker       VARCHAR(20),
    -- ���̺��� ��������
    CONSTRAINT product_product_id PRIMARY KEY(productid)
);
--���̺� �����ؼ� ���̺� ������ ��, ���� ������ ���̺��� ���������� ���������ϱ� ���� ���������� �߰��ϴ� ���
--���̺� �����ؼ� ����
CREATE TABLE emp_copy10
AS 
SELECT empno, ename, job, hiredate
FROM emp
WHERE deptno = 10;
--������ ���̺��� ���������� �����Ǿ����Ƿ� �ٽ� ���������� �ο�
ALTER TABLE emp_copy10
ADD CONSTRAINT emp_copy10_empno_PK PRIMARY KEY(empno); --ADD CONSTRAINT�� ���� ���� �߰�
--Ȯ��
DESC USER_CONSTRAINTS;
SELECT OWNER, Constraint_name, constraint_type, table_name
FROM USER_constraints
WHERE table_name = 'MEMBER';

INSERT INTO emp_copy10(empno, ename)
VALUES (7782, '������'); -- �⺻Ű ���������� �����Ǿ� �����Ƿ� ������ �� ����.

--�������� ���� ALTER�� DROP�� �̿�
ALTER TABLE emp_copy10
DROP CONSTRAINT emp_copy10_empno_PK;


--NOT NULL
--NOT NULL���� ���� �߰�
ALTER TABLE emp_copy10
--NOT NULL�� ADD CONSTRAINT�� ������� �ʴ´�.
--MODIFY ename NOT NULL;
MODIFY ename CONSTRAINT emp_copy10_ename_nn NOT NULL; 
--Ȯ��
SELECT OWNER, Constraint_name, constraint_type, table_name
FROM USER_constraints
WHERE table_name = UPPER('emp_copy10');
--���̺� ���� �� NOT NULL ���
CREATE TABLE Patient(
    bunho   NUMBER(4),
    name    VARCHAR2(20) CONSTRAINT patient_name_NN NOT NULL,
    code    CHAR(2)      CONSTRAINT patient_code_NN NOT NULL,
    age     NUMBER(3)    CONSTRAINT patient_age_NN NOT NULL,
    days    NUMBER(3)    CONSTRAINT patient_days_NN NOT NULL,
    CONSTRAINT patient_bunho_PK PRIMARY KEY(bunho)
);