--Day41 0924
--Constraint
CREATE TABLE dept_copy
AS 
SELECT *
FROM dept;

--���̺��� �����ϸ� ���������� �����ȴ�.
SELECT owner, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('dept_copy');

-- �̹� ������� ���̺� ���������� �ο�
--NOT NULL ���������� ������ MODIFY�� ���
--ADD CONSTRAINT�� ���̺� ���� ���� ���Ǹ� ����
ALTER TABLE dept_copy
MODIFY loc DEFAULT 'SEOUL';

ALTER TABLE dept_copy
ADD CONSTRAINT dept_copy_deptno_PK PRIMARY KEY(deptno);

ALTER TABLE dept_copy
MODIFY dname CONSTRAINT dept_copy_dname_NN NOT NULL;

ALTER TABLE dept_copy
MODIFY loc CONSTRAINT dept_copy_loc_NN NOT NULL;

DROP TABLE dept_copy;
DROP TABLE emp_copy10;
DROP TABLE member;
DROP TABLE Product; 
--FOREIGN KEY
-- ���̺� ���� 
CREATE TABLE emp_copy �����ϴ� ���̺�: �ڽ� ���̺�
AS 
SELECT * FROM emp;

CREATE TABLE dept_copy --�������ϴ� ���̺�: �θ����̺�
AS
SELECT * FROM dept;
-- �⺻Ű �ο�
ALTER TABLE emp_copy
ADD CONSTRAINT emp_copy_empno_PK PRIMARY KEY(empno);

ALTER TABLE dept_copy
ADD CONSTRAINT dept_copy_dept_PK PRIMARY KEY(deptno);
--FOREIGN KEY �ο�
ALTER TABLE emp_copy
ADD CONSTRAINT emp_copy_deptno_FK FOREIGN KEY(deptno) 
REFERENCES dept_copy(deptno);

INSERT INTO emp_copy(empno, ename, deptno)
VALUES(8888, '������', 50); --50�� �μ��� �����Ƿ� ����

DESC USER_CONSTRAINTS;
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = UPPER('emp_copy');

--���̺� ���� �� FOREIGN KEY ����
CREATE TABLE member(
    member_id   NUMBER(5),
    member_name VARCHAR2(20) CONSTRAINT member_member_id_NN NOT NULL,
    CONSTRAINT member_member_id_PK PRIMARY KEY(member_id)
);
CREATE TABLE Product(
    product_id      NUMBER(5),
    product_name    VARCHAR2(30) CONSTRAINT product_product_name_NN NOT NULL,
    CONSTRAINT product_product_id_PK PRIMARY KEY(product_id)
);
-- �÷����� ���������� FOREIGN KEY Ű���带 ������� �ʴ´�.
CREATE TABLE Cart(
    cart_id     NUMBER(10),
    member_id   NUMBER(5) CONSTRAINT cart_member_id_FK REFERENCES member(member_id),
    product_id  NUMBER(5),
    CONSTRAINT cart_cart_id_PK PRIMARY KEY(cart_id),
    CONSTRAINT cart_product_id_FK FOREIGN KEY(product_id) REFERENCES Product(product_id)
); --���� ������ ���̺� ���� �ϳ��� �������� �ʴ´ٸ� �ܷ�Ű�� ������ �� ����.

INSERT INTO dept1(deptno, danme, loc)
VALUES(10, '������','SEOUL');
INSERT INTO dept1(deptno, danme, loc)
VALUES(20, '�ѹ���','SEOUL');
INSERT INTO emp1(empno, ename, deptno)
VALUES(1111, '������','SEOUL'); -- emp.deptno�� �����ϴ� dept.DEPTNO���� SEOUL�̶�� ���� ����.

DELETE FROM dept1
WHERE deptno = 10;

SELECT *
FROM dept1;

SELECT constraint_type, constraint_name, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'EMP1';

ALTER TABLE emp1
DROP CONSTRAINT emp1_deptno_FK;

ALTER TABLE emp1
ADD CONSTRAINT emp1_deptno_FK FOREIGN KEY(deptno) 
REFERENCES dept1(deptno) ON DELETE CASCADE; -- �θ� ������ ���� �� �����ϴ� �ڽ� �����͵� ���� ������

-- ON DELETE SET NULL: �θ� �����Ͱ� �����Ǹ� �̸� �����ϴ� �ڽ� ���̺��� �����͸� �������� �ʰ� ��� NULL�� �ٲ۴�.
INSERT INTO dept1(deptno, danme, loc)
VALUES(10, '������','SEOUL');

ALTER TABLE emp1
ADD CONSTRAINT emp1_deptno_FK FOREIGN KEY(deptno) 
REFERENCES dept1(deptno) ON DELETE SET NULL; -- �θ� ������ ���� �� �����ϴ� �ڽ� �����͵� ���� ������

INSERT INTO emp1(empno, ename, deptno)
VALUES(1111, '������',10);

DELETE FROM dept1
WHERE deptno = 10;

SELECT * FROM emp1; -- ON DELETE SET NULL: ������ �������� ���� NULL�� �ٲ��.

--UNIQUE
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = UPPER('PATIENT');

-- �μ� ���̺��� �μ��� ����Ű�� ��������
ALTER TABLE dept1
ADD CONSTRAINT dept1_dname_UK UNIQUE(danme);

INSERT INTO dept1
VALUES(10, '������', 'SEOUL');

INSERT INTO dept1
VALUES(20, '�ѹ���', 'SEOUL');

INSERT INTO dept1
VALUES(50, '�ѹ���', 'SEOUL'); -- dname�� ����ũ�̹Ƿ� ���� ���� �Է��� �� ����.

--CHECK: �μ��� ��ġ�� ����, �λ�,����, �뱸, ��õ, ����, ��길 �����ؾ� �Ѵ�.
ALTER TABLE dept1
ADD CONSTRAINT dept1_loc_CK CHECK (loc IN ('SEOUL','PUSAN', '�뱸','��õ','����','���'));

INSERT INTO dept1
VALUES(40, '��������', '�뱸');


INSERT INTO dept1
VALUES(60, '��������', '���'); --CHECK ���� ���ǿ� ����

-- �������� �� DEFAULT OPTION ����
DROP TABLE student;

CREATE TABLE Student(
    hakbun          CHAR(7),
    name            VARCHAR2(20)          CONSTRAINT student_name_NN NOT NULL,
    math            NUMBER(3)    DEFAULT 0  CONSTRAINT student_math_NN NOT NULL,
    age             NUMBER(3)    DEFAULT 20  CONSTRAINT student_age_NN NOT NULL,
    seq             NUMBER(5),
    city            VARCHAR2(30),
    gender          CHAR(1)      DEFAULT 0,
    CONSTRAINT studnet_hakbun_PK PRIMARY KEY(hakbun), --PK
    CONSTRAINT studnet_math_CK CHECK(math BETWEEN 0 AND 100), --CK
    CONSTRAINT studnet_age_CK CHECK(age >19),
    CONSTRAINT studnet_city_CK CHECK(city IN ('����', '�λ�', '��õ')),
    CONSTRAINT studnet_city_UK UNIQUE(city),
    CONSTRAINT studnet_gender_CK CHECK(gender IN ('1', '0')),
    --CONSTRAINT studnet_zipcode_FK FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode): ������ �θ� ���̺��� ���� ����ũ, �⺻Ű
    CONSTRAINT studnet_zipcode_FK FOREIGN KEY(seq) REFERENCES zipcode(seq)
);

-- ���̺� ����
DROP TABLE Patient;
DROP TABLE checkup;
DROP TABLE department;
DROP TABLE discount
;



INSERT INTO department VALUES('MI', '�ܰ�');
INSERT INTO department VALUES('NI', '����');
INSERT INTO department VALUES('SI', '�Ǻΰ�');
INSERT INTO department VALUES('TI', '�Ҿư�');
INSERT INTO department VALUES('VI', '����ΰ�');
INSERT INTO department VALUES('WI', '�񴢱��');
COMMIT;


INSERT INTO checkup VALUES(1, 0, 9, 7000);
INSERT INTO checkup VALUES(2, 10, 19, 5000);
INSERT INTO checkup VALUES(3, 20, 29, 8000);
INSERT INTO checkup VALUES(4, 30, 39, 7000);
INSERT INTO checkup VALUES(5, 40, 49, 4500);
INSERT INTO checkup VALUES(6, 50, 120, 2300);
COMMIT;


INSERT INTO discount VALUES(1, 0, 9, 1.00);
INSERT INTO discount VALUES(2, 10, 14, 0.85);
INSERT INTO discount VALUES(3, 15, 19, 0.80);
INSERT INTO discount VALUES(4, 20, 29, 0.70);
INSERT INTO discount VALUES(5, 30, 99, 0.77);
INSERT INTO discount VALUES(6, 100, 9999, 0.68);
COMMIT;

SELECT *
FROM checkup
WHERE 25 BETWEEN losal AND hisal;
TRUNCATE TABLE Patient;

--SEQUENCE
--SEQUENCE ����
CREATE SEQUENCE dept_deptno_SEQ
--�������� ��������
    MAXVALUE 100
    NOCYCLE;
--SEQUENCE ����
--ALTER SEQUENCE
--SEQUENCE�� START WITH�� ������ �� ����.
ALTER SEQUENCE dept_deptno_SEQ
    MAXVALUE 1000;
--SEQUENCE ����
DROP SEQUENCE dept_deptno_SEQ;
DESC USER_SEQUENCES;
SELECT *
FROM USER_SEQUENCES;
--SEQUENCE ���

CREATE TABLE test1(
    no NUMBER(7) CONSTRAINT test1_no_PK PRIMARY KEY,
    job VARCHAR(20) CONSTRAINT test1_job_FK REFERENCES emp(job)
);
