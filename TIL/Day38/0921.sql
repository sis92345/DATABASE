--Day38, 09-21
--DBA_XXXX
SELECT *
FROM DICTIONARY;

--DBA�� sys, �� DBA�� �� �� �ִ�.
SELECT *
FROM DBA_TABLES; --����: DBA_XXXX ���̺��� DBA(SYSTEM, SYS)�� �ƴϸ� ������ ����.

SELECT *
FROM DBA_USERS;

--ALL_XXXX
SELECT *
FROM ALL_TABLES; -- ALL_XXXX�� ������� �ٸ� ��ü���� �о�� �� �ִ�.
--���� SYS�Ҽ��� DUAL ������ �����ϴ� ��

--USER_XXXX
SELECT *
FROM USER_TABLES; -- ���� �������� ������ ������ ��ü�� �д´� 
--XX_TABLES�� ���̺��� ������ �����ش�. ���� ������ �丸 ������
--USER_VIEWS, �������� ������
--USER_SEQUENCE, �ε����� ������
--USER_INDEXIS,  SYNONYM�� ������
--USER_SYNONYM

--DDL
--CREATE
CREATE TABLE member(
    id               VARCHAR2(14), --�������� ������ 
    password         VARCHAR2(20)
);

-- ������ ���̺� Ȯ��
DESC USER_TABLES;

SELECT table_name
FROM user_tables; -- == SELECT * FROM tab;

--CREATE ��
CREATE TABLE Student1(
    hukbun         CHAR(7)      , --2020-01
    name           VARCHAR2(20) , --�������               
    address        VARCHAR2(200), --����� ������ ���ﵿ �ѵ����� 8��
    age            NUMBER(3)    ,
    birthday       DATE         ,
    email          VARCHAR2(100),
    hight          NUMBER(4, 1) , --178.3
    weight         NUMBER(4, 1)   --110.3
);

DESC USER_TABLES;
SELECT *
FROM tab;

TRUNCATE TABLE Student; --DELETE���� ����: DELETE�� DML�� Ʈ�������� ��� --> ROLLBACK�� ���� ���������� DDL�� TRUNCATE�� ROLLBACK�� �� ����.
--DROP�� �ƿ� ���̺��� ���������� TRUNCATE�� ���̺��� �����͸� ���� �����Ѵٴ� ������ �ٸ���.