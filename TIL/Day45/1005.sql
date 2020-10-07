-- Day 45, 1005
--PL/SQL 기초: PL/SQL 실행 -- 보기 --> DBMS 출력으로 실행
--SQLPLUS에서 실행은 1005.md를 참고
BEGIN
	DBMS_OUTPUT.PUT_LINE('HELLO, PL/SQL!!!');
END;

--익명 블록(Anonymous)위의 예 
DECLARE 
    ename VARCHAR2(20);
    job   VARCHAR2(20);
BEGIN
    ename  := 'SMITH'; -- :=를 사용하여 할당
    job    := 'SALESMAN';
    DBMS_OUTPUT.PUT_LINE(ename || '의 직업은 ' || job || '입니다.');
END;

--PL/SQL의 입력
ACCEPT p_username PROMPT '당신의 이름은 ? ' -- PROMPT(cmd)에서 받은 입력값이 p_username에 받는다.
ACCEPT p_job PROMPT '당신의 직업은 ? ' -- PROMPT(cmd)에서 받은 입력값이 p_job에 받는다.
DECLARE 
    ename VARCHAR2(20) := '&p_username'; --prompt변수가 오라클의 지역변수가 되려면 변환을 해야하는데 이 역할을 &가 한다.
    job   VARCHAR2(20) := '&p_job';      --입력은 오라클이 아닌 다른 외부 프로그램에서 입력입력된 변수는 전부 문자열 --> 변환
BEGIN
   -- ename  := 'SMITH'; -- :=를 사용하여 할당
    --job    := 'SALESMAN';
    DBMS_OUTPUT.PUT_LINE(ename || '의 직업은 ' || job || '입니다.');
END;

--PL/SQL의 변수
--참조형 변수: %TYPE, %ROWTYPE 사용
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

----%ROWTYPE 사용
ACCEPT p_empno PROMPT 'Employee Number: '
DECLARE
    v_empno     emp.empno%TYPE DEFAULT 7788; 
    v_record    emp%ROWTYPE;   --레코드 전체를 사용 
BEGIN
    SYS.DBMS_OUTPUT.PUT_LINE('사원 번호 ' || ' 사원 이름 ' || ' 직무 ' || ' 입사날짜 ');
    SYS.DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    SELECT empno, ename, job, hiredate
    INTO   v_empno, v_record.ename, v_record.job, v_record.hiredate
    FROM emp
    WHERE empno = v_empno;
    SYS.DBMS_OUTPUT.PUT_LINE(v_empno || v_record.ename || v_record.job || v_record.hiredate);
END;

--조건, 반복문
--IF 조건문
--IF THEN
ACCEPT p_num PROMPT 'INSERT A NUMBER : ';
DECLARE
    v_num   NUMBER NOT NULL := &p_num;
BEGIN
    IF v_num >=0 THEN
        DBMS_OUTPUT.PUT_LINE(v_num || ' IS A POSITIVE NUMBER');
    END IF; --IF조건식 끝
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
    END IF; --IF조건식 끝
END;
--활용: 윤년
DECLARE
    v_year NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
BEGIN
    IF (MOD(v_year,400) = 0) OR (MOD(v_year, 4) = 0) AND (MOD(v_year, 100) <> 0) THEN 
        DBMS_OUTPUT.PUT_LINE(v_year || '년은 윤년입니다.');
    ELSE 
         DBMS_OUTPUT.PUT_LINE(v_year || '년은 윤년이 아닙니다.');
    END IF;
END;
--IF THEN ELSIF
ACCEPT p_season PROMPT 'INSERT A FAVORITE SEASON : ';
DECLARE
    v_season   VARCHAR2(6);
BEGIN
    v_season := '&p_season';
    IF v_season = '봄' or v_season = 'SPRING' THEN
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: 개나리, 진달래');
    ELSIF v_season = '여름' or v_season = 'SUMMER' THEN
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: 장미, 이카시아');
    ELSIF v_season = '가을' or v_season = 'FALL' THEN
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: 코스모스, 백합');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_season || ' IS YOUR FAVORITE SEASON: 동백, 매화');
    END IF; --IF조건식 끝
END;    
--DECODE 복습
CREATE TABLE emp_clone(empno, ename, sal, hiredate, deptno)
AS 
SELECT empno, ename, sal, hiredate, deptno
FROM emp;

SELECT empno, ename, sal, deptno, DECODE(deptno, 10, sal * 1.1,
                                                 20, sal * 1.2,
                                                 30, sal * 1.3, sal) AS "BONUS"
FROM emp;

--IF를 이용

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

--반복문
--기본 LOOP
DEClARE
    i NUMBER := 1;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(i || CHR(9));
        i := 1 + i;
        EXIT WHEN i > 5; --자바의 BREAK
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
--문제
--Q1. 숫자 1부터10까지의 숫자 중 오른쪽과 같이 홀수만 출력하는 PL/SQL 프로그램을 작성하라
DECLARE 
    i NUMBER;
    cnt NUMBER :=0;
BEGIN
    i := 1;
    WHILE i < 11 LOOP
        IF (MOD(i,2) = 1) THEN
            DBMS_OUTPUT.PUT_LINE('현재 i의 값' || i);
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
--Q2. DEPT 테이블의 deptno와 자료형이 같은 변수 v_deptno를 선언, --> 집가서 해보기
--v_deptno 변수 값에 10, ,20, 30, 40을 대입했을 때 다음과 같이 부서의 이름을 출력하는 프로그램을 출력
ACCEPT p_deptno PROMPT '부서 번호: ';
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
IS --익명 블록의 DECLERE
    v_str VARCHAR2(20);
BEGIN
    v_str := 'HELLO, WORLD';
    DBMS_OUTPUT.PUT_LINE(v_str);
END;
--SQLPLUS에서 실행
--SQL> SET SERVEROUTPUT ON
--SQL> EXECUTE sp_test
--HELLO, WORLD
CREATE OR REPLACE PROCEDURE sp_gugudan
IS
    i   NUMBER;
    j   NUMBER;
BEGIN
    FOR i IN 1..9 LOOP  --i의 범위는 1부터 9까지
        FOR j IN 2..9 LOOP
            DBMS_OUTPUT.PUT(j|| '*' || i || '=' || (j*i) || CHR(9));
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
--데이터 사전
DESC USER_PROCEDURES;

SELECT OBJECT_NAME
FROM USER_PROCEDURES;

SELECT *
FROM USER_SOURCE;

--Stored Procedure의 파라메터
--IN

CREATE OR REPLACE PROCEDURE sp_test <--Call By Name: 이름으로만 실행
IS
    v_str VARCHAR2(30);
BEGIN
    v_str = '한지민';
    DBMS_OUTPUT.PUT_LINE('당신의 이름은 ' || v_str || '입니다.');
END;
--파라미터를 이용
CREATE OR REPLACE PROCEDURE sp_test -- <--Call By Name: 이름으로만 실행
(p_name    IN  VARCHAR2) --따로 지정하지 않으면 IN
IS
    v_str VARCHAR2(30);
BEGIN
    v_str := p_name;
    DBMS_OUTPUT.PUT_LINE('당신의 이름은 ' || v_str || '입니다.');
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