--Day46, 1006
--복습 문제
--이름 ,급여, 부서번호를 입력받아 사원테이블에 자료를 등록하는 PL/SQL문
CREATE SEQUENCE emp_empno_seq
    START WITH 9000
    INCREMENT BY 1
    MAXVALUE 9999
    NOCYCLE;
--밑에 이건 왜 안되는지 확인
ACCEPT p_name   PROMPT 'NAME: ';
ACCEPT p_sal    PROMPT 'SAL: ';
ACCEPT p_deptno PROMPT 'DEPARTMENT NUMBER: ';
DECLARE
    v_ename     emp.ename%TYPE   := '&p_name';
    v_sal       emp.sal%TYPE     := &p_sal;
    v_deptno    emp.deptno%TYPE  := &p_deptno;
BEGIN
    IF v_deptno = 10 THEN 
        sal : = v_sal * 1.2;
    END IF;
    
    INSERT INTO emp(empno, ename, sal, deptno)
    VALUES(emp_empno_seq.NEXTVAL, v_ename, v_sal, v_deptno);
    COMMIT;
END;
--이름을 입력받아서 그 사람의 업무가 MANAGER, ANALYST이면 그병가 50% 가산하여 갱신, 아니면 20%를 가산
ACCEPT p_ename  PROMPT 'NAME: ';
DECLARE
    v_ename     emp.ename%TYPE   := '&p_ename';
    v_job       emp.job%TYPE;
    v_sal       emp.sal%TYPE;
BEGIN
   SELECT job, sal 
   INTO v_job, v_sal
   FROM emp
   WHERE ename = v_ename;
   
   IF v_job IN ('MANAGER', 'ANALYST') THEN
          v_sal := v_sal * 1.5;
   ELSE   v_sal := v_sal * 1.2;
   END IF;
   
   UPDATE emp
   SET sal = v_sal
   WHERE ename = v_ename;
   COMMIT;
END;

--STORED PROCDURE
--STORED PROCDURE CALL: EXECUTE or EXEC를 사용
--STORED PROCDURE ERROR 확인

--STORED PROCDURE PARAMETER
--파라메터가 없는 STORED PROCDURE

--IN
CREATE OR REPLACE PROCEDURE sp_operators
(
    FIRST  IN NUMBER,
    SECOND IN NUMBER
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(FIRST || ' + ' || SECOND || ' = ' || (FIRST + SECOND));
    DBMS_OUTPUT.PUT_LINE(FIRST || ' + ' || SECOND || ' = ' || (FIRST - SECOND));
    DBMS_OUTPUT.PUT_LINE(FIRST || ' + ' || SECOND || ' = ' || (FIRST * SECOND));
    DBMS_OUTPUT.PUT_LINE(FIRST || ' + ' || SECOND || ' = ' || (FIRST / SECOND));
END;

EXEC sp_operators(3, 5);

CREATE OR REPLACE PROCEDURE sp_hundred_sum
(
    v_last      IN NUMBER
)
IS
    i NUMBER;
    TOTAL NUMBER := 0;
BEGIN 
    FOR i IN 1..v_last LOOP
        TOTAL := TOTAL + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1부터' || v_last ||'까지의 합계는 ' ||  TOTAL || '입니다.');
END;
EXEC sp_hundred_sum(1551);

CREATE OR REPLACE PROCEDURE sp_hundred_sum_v1
(
    v_start     IN NUMBER,
    v_end       IN NUMBER
)
IS
    i NUMBER;
    TOTAL NUMBER := 0;
BEGIN 
    FOR i IN v_start..v_end LOOP
        TOTAL := TOTAL + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_start || '부터' || v_end ||'까지의 합계는 ' ||  TOTAL || '입니다.');
END;
EXEC sp_hundred_sum_v1(1000,1551);

--문제
--사원 번호와 봉급을 입력받아 업데이트하는  PL/SQL 문장을 완성하시오
CREATE OR REPLACE PROCEDURE emp_sal_update
(
    v_sal       emp.sal%TYPE,
    v_empno     emp.empno%TYPE
)
IS
BEGIN
    UPDATE emp
    SET sal = v_sal
    WHERE empno = v_empno;
    COMMIT;
END;

--사번을 받아 삭제하는 프로시저
CREATE OR REPLACE PROCEDURE sp_emp_delete
(
    v_empno     IN  emp.empno%TYPE
)
IS
BEGIN
    DELETE FROM emp WHERE empno = v_empno;
END;

--emp table에서 새로운 사원의 정보를 이름, 업무, 매니저 ,급여를 입력받아 등록하는 emp_input 프로시저를 생성
-- 단 부서번호는 매니저의 부서 번호와 동일하게 하고 보너스는 SALESMANT은 0을 그 외는 NULL
CREATE SEQUENCE emp_empno_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 999
    NOCYCLE
    CACHE 10;
--DROP SEQUENCE emp_empno_seq;
CREATE OR REPLACE PROCEDURE emp_input
(
    v_name  IN emp.ename%TYPE,
    v_job   IN emp.job%TYPE,
    v_mgr   IN emp.mgr%TYPE,
    v_sal   IN emp.sal%TYPE
)
IS
    v_deptno    emp.deptno%TYPE;
    v_comm      emp.comm%TYPE;
BEGIN
    --부서번호
    SELECT deptno INTO v_deptno
    FROM emp
    WHERE  mgr = v_mgr;
    --보너스
    IF UPPER(v_job) = 'SALESMAN' THEN v_comm := 0;
    ELSE v_comm := NULL;
    END IF;
    INSERT INTO emp(empno, ename, job ,hiredate, mgr, sal, deptno, comm)
    VALUES(emp_empno_seq.NEXTVAL, v_name, v_job, SYSDATE, v_mgr, v_sal, v_deptno, v_comm);
    COMMIT;
END;
SHOW ERRORS;

--Stored Procedure 
--OUT MODE
CREATE OR REPLACE PROCEDURE sp_test
IS
    v_name VARCHAR2(20);
BEGIN
    v_name := '한지민';
    DBMS_OUTPUT.PUT_LINE('나의 이름은 ' || v_name || ' 입니다.'); 
END;
EXEC sp_test;

CREATE OR REPLACE PROCEDURE sp_test_v1
(
    p_name IN VARCHAR2
)
IS
    v_name VARCHAR2(20);
BEGIN
    v_name := p_name;
    DBMS_OUTPUT.PUT_LINE('나의 이름은 ' || v_name || ' 입니다.'); 
END;
EXEC sp_test_v1('한지민');
--OUT 사용
CREATE OR REPLACE PROCEDURE sp_test_v2
(
    p_name OUT VARCHAR2
)
IS
    v_name VARCHAR2(200);
BEGIN
    v_name := '나의 이름은 한지민입니다.';
    p_name := v_name;
    
END;
EXEC sp_test_v2;
--
DECLARE
    v_name VARCHAR2(50);
BEGIN
    sp_test_v2(v_name);
    DBMS_OUTPUT.PUT_LINE(v_name);
END;
--사원 수를 알려주세요.
CREATE OR REPLACE PROCEDURE sp_emp_count
(
    CNT OUT NUMBER --밖에서 CNT를 가져간다: 14가 담김
)
IS
BEGIN
    SELECT COUNT(*) INTO CNT
    FROM emp;
    --DBMS_OUTPUT.PUT_LINE('사원수는 ' || CNT || '명입니다.');
END;
EXEC sp_emp_count;
--OUT을 가져가는 방법
--1. 글로벌 변수 이용
EXEC sp_emp_count(:g_cnt );

--/SQL 처리가 정상적으로 완료되었습니다.

PRINT g_cnt
--2. SQLDEVELPOER에서
DECLARE
    v_cnt VARCHAR2(50);
BEGIN
    sp_emp_count(v_cnt);
    DBMS_OUTPUT.PUT_LINE('이 회사의 사원수는 ' || v_cnt || '명 입니다.');
END;
--OUT 활용: 사칙연산
CREATE OR REPLACE PROCEDURE sp_operators
(
    v_first     IN  NUMBER,
    v_second    IN  NUMBER,
    v_op        IN  CHAR,
    v_result    OUT  NUMBER
)
IS
BEGIN
    CASE 
        WHEN v_op = '+' THEN v_result := v_first + v_second;
        WHEN v_op = '-' THEN v_result := v_first - v_second;
        WHEN v_op = 'x' THEN v_result := v_first * v_second;
        ELSE                 v_result := v_first / v_second;
    END CASE;
END;
--RUN
--SQL> VAR g_result       NUMBER;
--> EXEC sp_operators(4, 9, '-', :g_result);

--PL/SQL 처리가 정상적으로 완료되었습니다.

--SQL> PRINT g_result;
--
-- G_RESULT
------------
--        -5
ACCEPT  p_first     PROMPT '첫번째 숫자: ';
ACCEPT  p_second    PROMPT '두번째 숫자: ';
ACCEPT  p_op        PROMPT '연산자(+,-,x,/): ';
DECLARE
    v_first     NUMBER := &p_first;
    v_second    NUMBER := &p_second;
    v_op        CHAR(1):= '&p_op';
    p_result    NUMBER;
BEGIN
    sp_operators(v_first, v_second, v_op, p_result);
    DBMS_OUTPUT.PUT_LINE(v_first || v_op || v_second || ' = ' || p_result);
END;
-- 사번을 받아 사원 이름과 봉급 검색 
CREATE OR REPLACE PROCEDURE sp_emp_select
(
    v_empno     IN  emp.empno%TYPE,
    v_ename     OUT  emp.ename%TYPE,
    v_sal       OUT  emp.sal%TYPE
)
IS
BEGIN
        SELECT ename, sal 
        INTO v_ename, v_sal
        FROM emp
        WHERE empno = v_empno;
END;
--SQL> VAR g_ename        VARCHAR2(10);
--SQL> VAR g_sal          NUMBER;
--SQL> EXEC sp_emp_select(7788, :g_ename, :g_sal);

--PL/SQL 처리가 정상적으로 완료되었습니다.

ACCEPT  p_empno     PROMPT '사원 번호: ';
DECLARE
    v_empno     emp.empno%TYPE := &p_empno;
    v_ename     emp.ename%TYPE;
    v_sal       emp.sal%TYPE;
BEGIN
    sp_emp_select(v_empno, v_ename, v_sal);
    DBMS_OUTPUT.PUT_LINE('NAME: ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('SALARY: ' || v_sal);
END;