--DAY42, 0925
--P.394 제약조건 문제
--Q1. DEPT_CONST 테이블과 EMP_CONST 테이블을 다음과 같은 특성 및 제약 조건을 지정하여 만들어 보시오
CREATE TABLE DEPT_CONST(
    deptno  NUMBER(2)    CONSTRAINT deptconst_deptno_PK PRIMARY KEY,
    dname   VARCHAR2(14) CONSTRAINT deptconst_dname_UK UNIQUE,
    loc     VARCHAR2(13) CONSTRAINT deptconst_loc_NN NOT NULL
);
--EMPCONST는 ERD로 생성함
--나머지 제약조건 부여
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_CONST';
--알 수 없는 두 제약조건 삭제
ALTER TABLE DEPT_CONST
DROP CONSTRAINT SYS_C007702;
--나머지 제약조건 부여
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'EMP_CONST';
--알 수 없는 두 제약조건 삭제
ALTER TABLE EMP_CONST
DROP CONSTRAINT SYS_C007705;
ALTER TABLE EMP_CONST
DROP CONSTRAINT SYS_C007706;
ALTER TABLE EMP_CONST
DROP CONSTRAINT FK_DEPT_CONST_TO_EMP_CONST;
ALTER TABLE EMP_CONST
DROP CONSTRAINT DEPTCONST_TEL_UNQ;
--새로운 제약 조건 부여
ALTER TABLE EMP_CONST
MODIFY ENAME CONSTRAINT EMPCONST_ENAME_NN NOT NULL; --COLUMN-LEVEL CONSTARINTL: NOT NULL은 테이블 레벨 제약조건 불가

ALTER TABLE EMP_CONST
ADD CONSTRAINT EMPCONST_TEL_UNQ UNIQUE(TEL); --TABLE-LEVEL CONSTARINT

ALTER TABLE EMP_CONST
ADD CONSTRAINT EMPCONST_SAL_CHK CHECK(SAL BETWEEN 1000 AND 9999);
--밑이  FOREIGN 반드시 확인
ALTER TABLE EMP_CONST
MODIFY DEPTNO CONSTRAINT EMPCONST_DEPTNO_FK REFERENCES DEPT_CONST(DEPTNO);

ALTER TABLE EMP_CONST
ADD CONSTRAINT EMPCONST_DEPTNO_FK FOREIGN KEY(deptno)
REFERENCES DEPT_CONST(DEPTNO);
-- 제약조건 확인
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, table_name
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP_CONST','DEPT_CONST');
--제약조건 이름 변경
ALTER TABLE DEPT_CONST
RENAME CONSTRAINT DEPTCONST_DEPTNO_PK TO PK_DEPT_CONST;
ALTER TABLE DEPT_CONST
RENAME CONSTRAINT PK_DEPT_CONST TO DEPTCONST_DEPTNO_PK;

--SEQUENCE
-- 사전작업
DROP SEQUENCE dept_deptno_seq;
-- SEQUENCE 생성
CREATE SEQUENCE test_seq
    START WITH 1
    INCREMENT BY 1
    NOCYCLE
    MAXVALUE 100
    CACHE 20;
--SEQUENCE 이용
SELECT test_seq.CURRVAL, test_seq.NEXTVAL
FROM DUAL; --MAXVALUE 100이상 에러 -만약 SEQUENCE의 조건이 CYCLE이라면 다시 0으로 돌아간다.
--SEQUENCEQ 수정
ALTER SEQUENCE test_seq
    INCREMENT BY 10;
DROP SEQUENCE test_seq;
-- SEQUENCE 활용
CREATE TABLE dept_clone
AS
SELECT *
FROM dept
WHERE 1<0;

ALTER TABLE dept_clone
ADD CONSTRAINT dept_clone_deptno_OK PRIMARY KEY(deptno); --기본 키는 절대로 중복값, NULL이 없어야 한다 --> SEQUENCE 사용

CREATE SEQUENCE DEPT_DEPTNO_SEQ
    START WITH 10
    INCREMENT BY 10
    MAXVALUE 99 -- 부서 테이블의 부서 번호는 NUMBER(2)이니까 
    CACHE 20;
    
INSERT INTO DEPT_CLONE(deptno, dname, loc)
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'개발팀','SEOUL'); --10
    
INSERT INTO DEPT_CLONE(deptno, dname, loc)
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'총무팀','SEOUL'); --20
    
INSERT INTO DEPT_CLONE(deptno, dname, loc)
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'운영팀','PUSAN'); --30

SELECT *
FROM DEPT_CLONE;
--VIEW
--일반 계정은 VIEW를 사용할 수 없다.
CREATE VIEW test_view
AS
SELECT * FROM emp;
--VIEW 생성 권한 부여: SQLPLUS에서
GRANT CREATE VIEW TO SCOTT;
--FORCE: VIEW강제 생성, 기본값은 NO FORCE
CREATE FORCE VIEW test1_view
AS
SELECT * FROM aaa; --테이블이 없으면 VIEW는 만들어지지 않는다:NO FORCE, 테이블이 없어도 VIEW 생성: FORCE
-- VIEW의 삭제
DROP VIEW test1_view; --VIEW를 삭제해도 기반 테이블은 전혀 영향이 없다.

--VIEW의 생성: emp 테이블에서 10번 부서만 바라보는 VIEW
CREATE OR REPLACE VIEW emp_dept10_view
AS
SELECT empno, ename, dname, loc, sal, deptno
FROM emp NATURAL JOIN dept
WHERE deptno = 10;

--VIEW를 이용
SELECT * FROM emp_dept10_view
ORDER BY sal DESC; --ORDER BY는 이때 사용한다

SELECT * FROM emp_dept10_view
WHERE sal > 2000; --VIEW도 조건을 사용할 수 있다.
--VIEW의 수정: OR REPLACE 사용
--OR REPALEC는 같은 이름의 뷰가 존재할 경우 현재 생성할 뷰로 대체하여 생성한다.
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
--단순뷰(Simple View)는 DML이 가능하고, 복합뷰는 DML이 불가능하다.
INSERT INTO EMP1982_VIEW(EMPOLYEE_ID,EMPOLYEE_NAME)
VALUES(8888, '한지민'); --VIEW에 넣은게 아닌 테이블에 존재한다,
ROLLBACK;

CREATE OR REPLACE NOFORCE VIEW EMP1982_VIEW(EMPOLYEE_ID,EMPOLYEE_NAME, HIRE_DATE, DEPARTMENT_NAME, LOCATION, DEPARTMENT_ID)
AS
SELECT empno, ename, hiredate, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE TO_CHAR(hiredate, 'YYYY') = '1981'
WITH READ ONLY; --DML을 방지할 수 있다. 

--WITH READ ONLY: 전체 조건을 만족할 때만(전체를 대상으로 READ ONLY 수행)
--WITH CHECK OPTION: 조건절에 있는 조건을 만족할때만
CREATE OR REPLACE VIEW test_view
AS 
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 20
WITH CHECK OPTION; --지정한 조건을 만족한 DML만 가능, VIEW를 만들때 사용한 WHERE절의 조건과 일치하지 않으면 실행 거부
COMMIT; --12:25분
ROLLBACK;
INSERT INTO test_view(empno,ename,sal,deptno)
VALUES(9999, '김지민',2000,20);

--TOP-N QUERY: 
--아래는 제일 먼저 생성한 3개의 데이터를 sal 내림차순 정렬
SELECT ROWNUM, ename, sal
FROM emp
WHERE ROWNUM <=3
ORDER BY sal DESC;

CREATE OR REPLACE view emp_sal_dec_view
AS
SELECT ename, sal
FROM emp
ORDER BY sal DESC;
--새로만든 뷰의 새로만든 ROWNUM이므로 월급을 내림차순으로 정렬 --> ROWNUM 상위 3개 출력 == 월급 제일 많은 3사람 출력 
SELECT ROWNUM, ename, sal FROM emp_sal_dec_view
WHERE ROWNUM<=3;

--부서별로 부서명, 최소 급여, 최대 급여, 부서의 평균 급여를 포함하는 DEPT_SUM VIEW 생성
CREATE OR REPLACE VIEW DEPT_SUM(deptno, dname, min_sal, max_sal, avg_sal)
AS
SELECT  emp.deptno, dept.dname, MAX(sal),MIN(sal), TRUNC(AVG(sal))
FROM emp INNER JOIN dept ON (emp.deptno = dept.deptno)
GROUP BY emp.deptno, dept.dname;

DESC dept_sum;
SELECT * FROM dept_sum;

--2. emp table에서 사원번호, 이름, 업무를 포함하는 emp_view VIEW를 생성하시오
CREATE OR REPLACE VIEW EMP_VIEW
AS
SELECT empno, ename, job
FROM emp;
--3. 위 2번에서 생성하 VIEW를 이용하여 10번 부서의 자료만 조회하시오
SELECT *
FROM emp_view
WHERE deptno = 10;
--4. 위 2번에서 생상한 VIEW를 Data Dictionary에서 조회하시오
DESC USER_VIEWS;
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS
WHERE VIEW_NAME = UPPER('EMP_VIEW');
--5. 이름, 업무, 급여, 부서명, 위치를 포함하는 emp_dept_name 이라는 VIEW을 생성하시오
CREATE OR REPLACE VIEW EMP_DEPT_NAME("이름", "업무", "급여", "부서명", "위치")
AS
SELECT ename, job, sal, dname, loc
FROM emp e INNER JOIN dept d ON(e.deptno = d.deptno);

SELECT * FROM EMP_DEPT_NAME;

--6. 1987년에 입사한 사원을 볼 수 있는 뷰
CREATE OR REPLACE VIEW emp1987_view 
AS
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate BETWEEN '87/01/01' AND '87/12/31';
-- WHERE hiredate >= 87/01/01 AND hiredate <= '87/12/31';
-- WHERE SUBSTR(hiredate,1,2) = '87';
-- WHERE hiredate LIKE '87%';
-- WHERE TO_CHAR(hiredate,'YYYY') = '1987';

--1. DEPT TABLE의 기본 키 열로 사용할 시퀀스를 다음 조건에 맞게 생성하시오
-- 시퀀스 값은 60에서 시작해서 10씩 증가하며 최대 200까지 가능하도록 한다
-- 시퀀스 이름은 dept_deptno_seq이다.
CREATE SEQUENCE  dept_deptno_seq
    START WITH 60
    INCREMENT BY 10
    MAXVALUE 200;
DROP SEQUENCE dept_deptno_seq;
--2. 위 1에서 만든 시퀀스의 이름, 최대값, 증가분, 마지막 번호의 정보를 아래와 같이 출력되도록 Data_Dictionary에서 조회
SELECT SEQUENCE_NAME, MAX_VALUE, INCREMENT_BY, LAST_NUMBER
FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'DEPT_DEPTNO_SEQ';

--3. 위 1에서 만든 시퀀스를 이용하여 부서이름은 education, 부서 위치는 seoul로 새 행을 dept 테이블에 추가하고 아래와 같이 조회
COMMIT;
INSERT INTO dept
VALUES(DEPT_DEPTNO_SEQ.NEXTVAL , 'EDUCATION','SEOUL');

--INDEX
--UNIQUE INDEX: 열에 중복값이 존재하지 않아야 한다.
DESC USER_INDEXES;
SELECT INDEX_NAME, INDEX_TYPE, TABLE_NAME
FROM USER_INDEXS;

--P.357
--Q1
--1-1 EMP 테이블과 같은 구조의 데이터를 저장하는 EMPIDX테이블을 만들어 보세요
CREATE TABLE EMPIDX
AS
SELECT *
FROM emp
WHERE 1<0;
--1-2 생성한 EMPIDX 테이블의 EMPNO열에 IDX_EMPID_EMPNO 인덱스를 만들어 보세요
CREATE INDEX IDX_EMPID_EMPNO ON EMPIDX(EMPNO ASC);
--1-3 마지막으로 인덱스가 잘 생성되었는지 데이터 사전 뷰를 통해 확인하시오
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