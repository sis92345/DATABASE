CREATE OR REPLACE PROCEDURE sp_today
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Today is ' || TO_CHAR(SYSDATE, 'yyyy-mm-dd') || '.');
END;

CREATE OR REPLACE PROCEDURE sp_today_v1
(
    v_str    IN   VARCHAR2
)
IS
BEGIN
    IF v_str = 'today' THEN
        DBMS_OUTPUT.PUT_LINE('Today is ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
    ELSIF v_str = 'yesterday' THEN
        DBMS_OUTPUT.PUT_LINE('Today is ' || TO_CHAR(SYSDATE - 1, 'YYYY-MM-DD'));
    ELSIF v_str = 'tomorrow' THEN
        DBMS_OUTPUT.PUT_LINE('Today is ' || TO_CHAR(SYSDATE + 1, 'YYYY-MM-DD'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid Date.');
    END IF;
END;

CREATE OR REPLACE PROCEDURE sp_today_v2
(
    v_str   OUT    VARCHAR2
)
IS
BEGIN
    v_str := 'Today is ' || TO_CHAR(SYSDATE, 'yyyy-mm-dd');
END;

DECLARE
    g_str   VARCHAR2(50);
BEGIN
    sp_today_v2( g_str );
    DBMS_OUTPUT.PUT_LINE(g_str);
END;

CREATE OR REPLACE PROCEDURE sp_sum_v1
IS
    i  NUMBER;
    TOT   NUMBER := 0;
BEGIN
    FOR i  IN 1..100 LOOP
        TOT := TOT + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1���� 100������ ���� ' || TOT || '�Դϴ�.');
END;

CREATE OR REPLACE PROCEDURE sp_sum_v2
(
    v_start   IN   NUMBER,
    v_end     IN   NUMBER
)
IS
    i  NUMBER;
    TOT   NUMBER := 0;
BEGIN
    FOR i  IN v_start..v_end LOOP
        TOT := TOT + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_start || '���� ' || v_end || '������ ���� ' || TOT || '�Դϴ�.');
END;

CREATE OR REPLACE PROCEDURE sp_sum_v3
(
    v_start   IN   NUMBER,
    v_end     IN   NUMBER,
    v_result  OUT  VARCHAR2
)
IS
    i  NUMBER;
    TOT   NUMBER := 0;
BEGIN
    FOR i  IN v_start..v_end LOOP
        TOT := TOT + i;
    END LOOP;
    v_result := v_start || '���� ' || v_end || '������ ���� ' || TOT || '�Դϴ�.';
END;

--�̸��� �Է¹޾Ƽ� �� ����� ���� �� �μ���� �޿��� �˻��ϴ� ���ν����� �ϼ��Ͻÿ�.
CREATE OR REPLACE PROCEDURE sp_emp_dept_select
(
    v_ename   IN     emp.ename%TYPE,
    v_dname   OUT    dept.dname%TYPE,
    v_sal     OUT    emp.sal%TYPE
)
IS
BEGIN
    SELECT  dname, sal
    INTO    v_dname, v_sal
    FROM   emp INNER JOIN dept USING(deptno)
    WHERE  ename = v_ename;
END;

DECLARE
    g_dname   dept.dname%TYPE;
    g_sal     emp.sal%TYPE;
BEGIN
    sp_emp_dept_select('SCOTT', g_dname, g_sal);
    DBMS_OUTPUT.PUT_LINE('Scott�� �ٹ��ϴ� �μ��� ' || g_dname || '�̰�, ������ ' || g_sal || '�Դϴ�.');
END;

--�����ȣ�˻�, �� ���̸��� ���ﵿ���θ� �� ��
CREATE OR REPLACE PROCEDURE sp_zipcode_select
(
    v_dongName      IN     zipcode.dong%TYPE,
    v_result    OUT    VARCHAR2
)
IS
    v_zipcode    zipcode.zipcode%TYPE;
    v_sido        zipcode.sido%TYPE;
    v_gugun      zipcode.gugun%TYPE;
    v_dong       zipcode.dong%TYPE;
    v_bunji      zipcode.bunji%TYPE;
BEGIN
    SELECT zipcode, sido, gugun, dong, bunji
    INTO v_zipcode, v_sido, v_gugun, v_dong, v_bunji
    FROM zipcode 
    WHERE dong LIKE CONCAT(CONCAT('%', v_dongName), '%');
    v_result := '(' || v_zipcode || ') ' || v_sido || ' ' || v_gugun || ' ' || v_dong || ' ' || v_bunji; 
END;

EXEC sp_zipcode_select;

--Stored ProcedureL �۶���Ϳ� �⺻�� ���
CREATE OR REPLACE PROCEDURE sp_test_v1
(
    v_name IN VARCHAR2 DEFAULT '������'
)
IS 
    v_str VARCHAR2(20)
BEGIN
    v_str := '���� �̸���' || v_name || '�Դϴ�';
    DBMS_OUTPUT.PUT_LINE(v_str);
    
END;

CREATE OR REPLACE PROCEDURE sp_gugudan
(
    v_dan IN NUMBER DEFAULT 1
)
IS 
    i NUMBER;
BEGIN
   FOR i IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || i || ' = ' || (v_dan * i));
   END LOOP;
END;

--Stored Procedure�� ���� ����
CREATE OR REPLACE PROCEDURE sp_gugudan
(
    v_dan IN NUMBER DEFAULT 1,
    v_max IN NUMBER DEFAULT 9
)
IS 
    i NUMBER;
BEGIN
   FOR i IN 1..v_max LOOP
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || i || ' = ' || (v_dan * i));
   END LOOP;
END;

CREATE TABLE emp_clone(empno, ename, job, hiredate)
AS 
SELECT empno, ename, job, hiredate
FROM emp
WHERE 0 > 1;

CREATE OR REPLACE PROCEDURE sp_emp_clone_insert
(
    v_empno     IN      emp_clone.empno%TYPE, 
    v_ename     IN      emp_clone.ename%TYPE, 
    v_job       IN      emp_clone.job%TYPE      DEFAULT 'CLERK',
    v_hiredate  IN      emp_clone.hiredate%TYPE DEFAULT SYSDATE
)
IS
BEGIN
    INSERT INTO emp_clone
    VALUES(v_empno, v_ename, v_job, v_hiredate);
    COMMIT;
END;
--���ν��� ����
DROP PROCEDURE emp_input;

--CURSOR
--CURSOR ����
--�Ʒ��� PL/SQL�� ������ ����: PL/SQL�� �ϳ��� ���� �ʰ��ϴ� ����� ������ �� ����. --> ����� Ŀ���� �̿��ؼ� ó��
DECLARE
    v_empno  emp.empno%TYPE;
    v_ename  emp.ename%TYPE;
    v_job    emp.job%TYPE;
BEGIN
    SELECE empno, ename, job
    INTO v_empno, v_ename, v_job
    FROM emp
    WHERE deptno = 10;
END;

--Ŀ���� �̿��� ó��
DECLARE
    v_empno  emp.empno%TYPE;
    v_ename  emp.ename%TYPE;
    v_job    emp.job%TYPE;
    --Ŀ�� ����
    CURSOR mycursor IS
    SELECT empno, ename, job --SELECT INTO�� �ƴ� �Ϲ� SELECT ���
    FROM emp
    WHERE deptno = 10;
BEGIN
    --Ŀ�� ����: �̶� Ŀ���� ��� ���� ù��° ���� ����Ų��.
    OPEN mycursor;
    --FETCH
    LOOP
        FETCH mycursor INTO v_empno, v_ename, v_job; --empno�� ã�Ƽ� v_empno�� �ְ�, ename�� ã�� v_ename�� �ְ�, job�� ã�Ƽ� v_job�� �ִ´�. �� �� ������ ����
        EXIT WHEN mycursor%NOTFOUND; --Ŀ���� ���� ���� ã�� �� ������ ������ Ż��
        DBMS_OUTPUT.PUT_LINE(v_empno || ' ' || v_ename || ' ' || v_job);
    END LOOP;
    --CLOSE
    CLOSE mycursor;
END;
--OPEN, CLOSE�� �����ϴ� Ŀ��
--�Ʒ��� �� 1����
CREATE OR REPLACE PROCEDURE sp_emp_cursor
(
    v_deptno    IN  emp.deptno%TYPE
)
IS
    CURSOR mycursor IS
    SELECT empno, ename, sal FROM emp WHERE deptno = v_deptno;
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
BEGIN
    OPEN mycursor;
        LOOP
            FETCH mycursor INTO v_empno, v_ename, v_sal;
            IF mycursor%NOTFOUND THEN EXIT;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_empno || ' ' || v_ename || ' ' || v_sal);
        END LOOP;
    CLOSE mycursor;
END;
EXEC sp_emp_cursor(20);
--���⼭ �ݺ����� FOR LOOP�� �ٲٸ� OPEN, CLOSE ���� ����
CREATE OR REPLACE PROCEDURE sp_emp_cursor_v2
(
    v_deptno    IN  emp.deptno%TYPE
)
IS
    CURSOR mycursor IS
    SELECT empno, ename, sal FROM emp WHERE deptno = v_deptno;
    v_temp  emp%ROWTYPE; --8���� �÷��� ������ ����
BEGIN
    FOR v_temp IN mycursor LOOP --v_emp���� �÷��� ������ �ִ�.
        IF mycursor%NOTFOUND THEN EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_temp.empno || ' ' || v_temp.ename || ' ' || v_temp.sal);
    END LOOP;
END;
EXEC sp_emp_cursor(20);
CREATE OR REPLACE PROCEDURE sp_c
    CURSOR c IS
    SELECT deptno, COUNT(sal), TRUNC(AVG(sal)), MAX(sal), MIN(sal)
    FROM emp 
    GROUP BY deptno
    ORDER BY deprtno;
    v_deptno    emp.deptno%TYPE;
    v_cntsal    NUMBER;
    v_avgsal    NUMBER;
    v_minsal    NUMBER;
BEGIN
    FOR v_temp IN c LOOP
    OPEN c;
    LOOP
        FETCH c INTO v_deptno, v_cntsal, v_avgsal, v_minsal;
        IF c%NOTFOUND THEN EXIT;
        END IF;
    END LOOP;
    CLOSE c;
    END LOOP;
END;

--SYS_REFCURSOR: �ٸ� ���� ���
CREATE OR REPLACE PROCEDURE sp_zipcode_select
(
    v_dongName  IN zipcode.dong%TYPE,
    v_recode    OUT SYS_REFCURSOR
)
AS 
BEGIN
    OPEN v_recode FOR
        SELECT  zipcode, sido, gugun, dong, bunji
        FROM zipcode
        WHERE dong LIKE CONCAT(CONCAT('%',v_dongName),'%');
    CLOSE v_recode;
END;
