-- Day 45, 1005
--PL/SQL ����: PL/SQL ���� -- ���� --> DBMS ������� ����
--SQLPLUS���� ������ 1005.md�� ����
BEGIN
	DBMS_OUTPUT.PUT_LINE('HELLO, PL/SQL!!!');
END;

--�͸� ���(Anonymous)���� �� 
DECLARE 
    ename VARCHAR2(20);
    job   VARCHAR2(20);
BEGIN
    ename  := 'SMITH'; -- :=�� ����Ͽ� �Ҵ�
    job    := 'SALESMAN';
    DBMS_OUTPUT.PUT_LINE(ename || '�� ������ ' || job || '�Դϴ�.');
END;

--PL/SQL�� �Է�
ACCEPT p_username PROMPT '����� �̸��� ? ' -- PROMPT(cmd)���� ���� �Է°��� p_username�� �޴´�.
ACCEPT p_job PROMPT '����� ������ ? ' -- PROMPT(cmd)���� ���� �Է°��� p_job�� �޴´�.
DECLARE 
    ename VARCHAR2(20) := '&p_username'; --prompt������ ����Ŭ�� ���������� �Ƿ��� ��ȯ�� �ؾ��ϴµ� �� ������ &�� �Ѵ�.
    job   VARCHAR2(20) := '&p_job';      --�Է��� ����Ŭ�� �ƴ� �ٸ� �ܺ� ���α׷����� �Է��Էµ� ������ ���� ���ڿ� --> ��ȯ
BEGIN
   -- ename  := 'SMITH'; -- :=�� ����Ͽ� �Ҵ�
    --job    := 'SALESMAN';
    DBMS_OUTPUT.PUT_LINE(ename || '�� ������ ' || job || '�Դϴ�.');
END;

--PL/SQL�� ����
--������ ����: %TYPE, %ROWTYPE ���
--ACCEPT p_deptno PROMPT 'Department Number : ';
--ACCEPT p_dname  PROMPT 'Department Name   : ';
--ACCEPT p_loc    PROMPT 'Department loc    : ';
--DECLARE
--    t_deptno    dept.deptno%TYPE := &p_deptno;
 --   t_dname     dept.dname%TYPE  := UPPER('&p_deptno');
  --  t_loc       dept.loc%TYPE    := UPPER('&p_deptno');
--BEGIN
 --   INSERT INTO dept
  --  VALUES(t_deptno, t_dname, t_loc);
   -- COMMIT;
   -- DBMS_OUTPUT.PUT_LINE('INSERT SUCCESS');
--END;

----%ROWTYPE ���
ACCEPT p_empno PROMPT 'Employee Number: '
DECLARE
    v_empno     emp.empno%TYPE DEFAULT 7788; 
    v_record    emp%ROWTYPE;   --���ڵ� ��ü�� ��� 
BEGIN
    SYS.DBMS_OUTPUT.PUT_LINE('��� ��ȣ ' || ' ��� �̸� ' || ' ���� ' || ' �Ի糯¥ ');
    SYS.DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    SELECT empno, ename, job, hiredate
    INTO   v_empno, v_record.ename, v_record.job, v_record.hiredate
    FROM emp
    WHERE empno = v_empno;
    SYS.DBMS_OUTPUT.PUT_LINE(v_empno || v_record.ename || v_record.job || v_record.hiredate);
END;

--����, �ݺ���
--IF ���ǹ�
--IF THEN
ACCEPT p_num PROMPT 'INSERT A NUMBER : ';
DECLARE
    v_num   NUMBER NOT NULL := &p_num;
BEGIN
    IF v_num >=0 THEN
        DBMS_OUTPUT.PUT_LINE(v_num || ' IS A POSITIVE NUMBER');
    END IF; --IF���ǽ� ��
END;
--IF THEN ELSE
ACCEPT p_num PROMPT 'INSERT A NUMBER : ';
DECLARE
    v_num   NUMBER NOT NULL := &p_num;
BEGIN
    IF v_num >=0 THEN
        DBMS_OUTPUT.PUT_LINE(v_num || ' IS A POSITIVE NUMBER');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_num || ' IS A NEGATIVE NUMBER');
    END IF; --IF���ǽ� ��
END;
--Ȱ��: ����
DECLARE
    v_year NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
BEGIN
    IF (MOD(v_year,400) = 0) OR (MOD(v_year, 4) = 0) AND (MOD(v_year, 100) <> 0) THEN 
        DBMS_OUTPUT.PUT_LINE(v_year || '���� �����Դϴ�.');
    ELSE 
         DBMS_OUTPUT.PUT_LINE(v_year || '���� ������ �ƴմϴ�.');
    END IF;
END;
--IF THEN ELSIF
ACCEPT p_season PROMPT 'INSERT A FAVORITE SEASON : ';
DECLARE
    v_season   VARCHAR2(6);
BEGIN
    v_season := '&p_season';
    IF v_season = '��' or v_season = 'SPRING' THEN
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: ������, ���޷�');
    ELSIF v_season = '����' or v_season = 'SUMMER' THEN
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: ���, ��ī�þ�');
    ELSIF v_season = '����' or v_season = 'FALL' THEN
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: �ڽ���, ����');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: ����, ��ȭ');
    END IF; --IF���ǽ� ��
END;    
--DECODE ����
CREATE TABLE emp_clone(empno, ename, sal, hiredate, deptno)
AS 
SELECT empno, ename, sal, hiredate, deptno
FROM emp;

SELECT empno, ename, sal, deptno, DECODE(deptno, 10, sal * 1.1,
                                                 20, sal * 1.2,
                                                 30, sal * 1.3, sal) AS "BONUS"
FROM emp;

--IF�� �̿�

DECLARE 
    v_deptno emp_clone.deptno%TYPE;
    v_bonus emp_clone.sal%TYPE;
    v_sal emp_clone.sal%TYPE;
    v_empno emp_clone.empno%TYPE;
BEGIN
    SELECT deptno, sal, empno INTO v_deptno, v_sal,v_empno FROM emp_clone WHERE empno = 7788;
    if v_deptno = 10 THEN v_bonus := v_sal * 0.1;
    ELSIF v_deptno = 20 THEN v_bonus := v_sal * 0.2;
    ELSIF v_deptno = 30 THEN v_bonus := v_sal * 0.3;
    ELSE v_bonus := v_sal;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_empno || ' ' || v_deptno || ' ' || v_sal || ' ' || v_bonus);
END;

--CASE 
ACCEPT p_name   PROMPT;
ACCEPT p_kor;
ACCEPT p_eng;
ACCEPT p_mat;
DECLARE
BEGIN
END;

--�ݺ���
--�⺻ LOOP
DEClARE
    i NUMBER := 1;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(i || CHR(9));
        i := 1 + i;
        EXIT WHEN i > 5; --�ڹ��� BREAK
    END LOOP;
END;
--WHILE LOOP
DEClARE
    i NUMBER := 1;
BEGIN 
    WHILE i < 6 LOOP
        DBMS_OUTPUT.PUT_LINE(i || CHR(9));
        i := 1 + i;
    END LOOP;
END;

DECLARE 
    v_deptno NUMBER := 10;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN 
    WHILE v_deptno <= 60 LOOP 
        SELECT dname, loc
        INTO v_dname, v_loc
        FROM dept
        WHERE deptno = v_deptno;
         DBMS_OUTPUT.PUT_LINE(v_deptno || CHR(9) || v_dname || CHR(9) || v_loc);
        v_deptno := v_deptno + 10;
    END LOOP;
END;
--FOR LOOP
--����
--Q1. ���� 1����10������ ���� �� �����ʰ� ���� Ȧ���� ����ϴ� PL/SQL ���α׷��� �ۼ��϶�
DECLARE 
    i NUMBER;
    cnt NUMBER :=0;
BEGIN
    i := 1;
    WHILE i < 11 LOOP
        IF (MOD(i,2) = 1) THEN
            DBMS_OUTPUT.PUT_LINE('���� i�� ��' || i);
        END IF;
    END LOOP;
END;

DECLARE 
    i NUMBER;
    CNT NUMBER := 0;
BEGIN 
    FOR i IN 65..95 LOOP
         DBMS_OUTPUT.PUT(CHR(i)||CHR(9));
         CNT := CNT + 1;
         IF MOD(CNT, 5) = 0 THEN
            DBMS_OUTPUT.NEW_LINE();
         END IF;
    END LOOP;
END;
--Q2. DEPT ���̺��� deptno�� �ڷ����� ���� ���� v_deptno�� ����, --> ������ �غ���
--v_deptno ���� ���� 10, ,20, 30, 40�� �������� �� ������ ���� �μ��� �̸��� ����ϴ� ���α׷��� ���
ACCEPT p_deptno PROMPT '�μ� ��ȣ: ';
DECLARE
    v_deptno = dept.deptno%TYPE := '&p_deptno';
BEGIN
    WHERE v_deptno <41 LOOP
        DBMS_OUTPUT.PUT_LINE('DNAME: ' || i);
    END LOOP;
END;

--Stored Procedure
--CREATE PROCEDURE
CREATE OR REPLACE PROCEDURE sp_test
IS --�͸� ����� DECLERE
    v_str VARCHAR2(20);
BEGIN
    v_str := 'HELLO, WORLD';
    DBMS_OUTPUT.PUT_LINE(v_str);
END;
--SQLPLUS���� ����
--SQL> SET SERVEROUTPUT ON
--SQL> EXECUTE sp_test
--HELLO, WORLD
CREATE OR REPLACE PROCEDURE sp_gugudan
IS
    i   NUMBER;
    j   NUMBER;
BEGIN
    FOR i IN 1..9 LOOP  --i�� ������ 1���� 9����
        FOR j IN 2..9 LOOP
            DBMS_OUTPUT.PUT(j|| '*' || i || '=' || (j*i) || CHR(9));
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
--������ ����
DESC USER_PROCEDURES;

SELECT OBJECT_NAME
FROM USER_PROCEDURES;

SELECT *
FROM USER_SOURCE;

--Stored Procedure�� �Ķ����
--IN

CREATE OR REPLACE PROCEDURE sp_test <--Call By Name: �̸����θ� ����
IS
    v_str VARCHAR2(30);
BEGIN
    v_str = '������';
    DBMS_OUTPUT.PUT_LINE('����� �̸��� ' || v_str || '�Դϴ�.');
END;
--�Ķ���͸� �̿�
CREATE OR REPLACE PROCEDURE sp_test -- <--Call By Name: �̸����θ� ����
(p_name    IN  VARCHAR2) --���� �������� ������ IN
IS
    v_str VARCHAR2(30);
BEGIN
    v_str := p_name;
    DBMS_OUTPUT.PUT_LINE('����� �̸��� ' || v_str || '�Դϴ�.');
END;

CREATE OR REPLACE PROCEDURE sp_emp_dept_select
(t_empno IN emp.empno%TYPE)
IS
    v_empno     emp.empno%TYPE;
    v_ename     emp.ename%TYPE;
    v_dname     dept.dname%TYPE;
    v_loc       dept.loc%TYPE;
BEGIN
    SELECT empno, ename, dname, loc 
    INTO v_empno, v_ename, v_dname, v_loc
    FROM emp NATURAL JOIN dept
    WHERE empno = t_empno;
    DBMS_OUTPUT.PUT_LINE(v_empno || ' ' || v_ename || ' ' || v_dname || ' ' || v_loc);
END;


CREATE OR REPLACE PROCEDURE sp_emp_clone_delete
(
t_empno IN emp_clone.empno%TYPE
)
IS 
BEGIN
    DELETE FROM emp_clone
    WHERE empno = t_empno;
    COMMIT;
END;