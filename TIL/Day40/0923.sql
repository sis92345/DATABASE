--DAY40, 0923
--DEFAULT option
--INSERT 할 때 암시적으로 NULL이 들어가면 자동적으로 대체될 값을 지정할 때 사용
--사전작업
DROP TABLE emp_copy10;
DROP TABLE TESTTABLE;

-- 날자를 입력 안 할 경우 현재 날짜를 기본값으로 지정, 
CREATE TABLE emp_copy10(
    empno       NUMBER(4),
    ename       VARCHAR2(200),
    hiredate    DATE            DEFAULT SYSDATE, --디폴트로 들어갈 데이터는 해당 컬럼의 데이터 타입과 일치해야 한다.
    job         VARCHAR2(50)    DEFAULT 'DEVELOPER',
    sal         NUMBER(7)       DEFAULT 800000
);
--emp_copy10에 암시적으로 NULL을 넣을 경우 기본값을 넣게된다.
INSERT INTO emp_copy10(empno, ename)
VALUES(1111, '한지민');

INSERT INTO emp_copy10(empno, ename, job)
VALUES(2222, '김지민', 'SALESMAN');

--명시적으로 NULL을 넣을 경우 DEFAULT 키워드를 명시해야 DEFAULT option이 들어간다.
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES(3333, '박지민', NULL, NULL);

INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES(3333, '최지민', DEFAULT, DEFAULT);


SELECT * FROM emp_copy10; --기본값이 추가되어 있다.

-- DEFAULT option예
CREATE TABLE member -- 테이블을 복사해서 생성하면 모든 제약조건이 삭제된다.
AS 
SELECT  empno, ename
FROM emp
WHERE 1 = 0; -- 스키마만 가져온다.

DESC member;
-- 컬럼 추가
ALTER TABLE member
ADD (gender NUMBER(1));
--추가한 컬럼 수정
ALTER TABLE member
MODIFY (gender VARCHAR(7) DEFAULT '여성');

INSERT INTO member(empno, ename)
VALUES (1111, '한지민');

SELECT * FROM member;
--PRIMARY KEY
--사전준비
DROP TABLE emp_copy10;
DROP TABLE member;
--1. Column-level 제약조건으로 생성하기
CREATE TABLE Member(
    userid  CHAR(14)        PRIMARY KEY, -- Column-level 제약조건: 모든 제약 조건을 컬럼명 옆에 사용
    passwd  VARCHAR2(20),
    name    VARCHAR2(20),
    age     NUMBER(2),
    city    VARCHAR2(20)    DEFAULT 'SEOUL'
);
--1-1. Column-level 제약조건에 이름 부여해서 생성
-- 일반적인 형식: 테이블이름_컬럼이름_PK | UK | NN | FK | CK
CREATE TABLE Member(
    userid  CHAR(14)       CONSTRAINT member_userid_PK PRIMARY KEY, 
    passwd  VARCHAR2(20),
    name    VARCHAR2(20),
    age     NUMBER(2),
    city    VARCHAR2(20)    DEFAULT 'SEOUL'
);
--2. Table-level 제약조건으로 생성하기
CREATE TABLE Member(
    userid  CHAR(14),
    passwd  VARCHAR2(20),
    name    VARCHAR2(20),
    age     NUMBER(2),
    city    VARCHAR2(20) DEFAULT 'SEOUL',
    -- Table-level은 여기서부터 제약조건을 부여한다.
    CONSTRAINT member_userid_pk PRIMARY KEY(userid)
);

INSERT INTO Member(userid, passwd)
VALUES(1111, '12345');
INSERT INTO Member(userid, passwd)
VALUES(1111, '12345'); --userid는 프라이머리키이므로 중복값을 생성할 수 없다.
INSERT INTO Member(userid, passwd)
VALUES(NULL, '12345'); -- userid는 프라이머리키이므로 NULL값을 허용하지 않는다.
--PRIMARY KEY 확인
SELECT table_name
FROM USER_TABLES;

DESC USER_CONSTRAINTS;
SELECT OWNER, Constraint_name, constraint_type, table_name
FROM USER_constraints
WHERE table_name = 'MEMBER';

DROP TABLE member;
--제약조건에 이름 부여하기
-- 일반적인 형식: 테이블이름_컬럼이름_PK | UK | NN | FK | CK


--ProductMgmt.exerd로 테이블 생성
CREATE TABLE Product(
    productid   CHAR(7),
    name        VARCHAR2(20),
    price       NUMBER(8),
    pdate       DATE DEFAULT SYSDATE,
    maker       VARCHAR(20),
    -- 테이블레벨 제약조건
    CONSTRAINT product_product_id PRIMARY KEY(productid)
);
--테이블 복사해서 테이블 생성한 후, 새로 생선한 테이블에는 제약조건이 삭제됬으니까 새로 제약조건을 추가하는 방법
--테이블 복사해서 생성
CREATE TABLE emp_copy10
AS 
SELECT empno, ename, job, hiredate
FROM emp
WHERE deptno = 10;
--복사한 테이블은 제약조건이 삭제되었으므로 다시 제약조건을 부여
ALTER TABLE emp_copy10
ADD CONSTRAINT emp_copy10_empno_PK PRIMARY KEY(empno); --ADD CONSTRAINT는 제약 조건 추가
--확인
DESC USER_CONSTRAINTS;
SELECT OWNER, Constraint_name, constraint_type, table_name
FROM USER_constraints
WHERE table_name = 'MEMBER';

INSERT INTO emp_copy10(empno, ename)
VALUES (7782, '한지민'); -- 기본키 제약조건이 설정되어 있으므로 삽입할 수 없다.

--제약조건 삭제 ALTER의 DROP을 이용
ALTER TABLE emp_copy10
DROP CONSTRAINT emp_copy10_empno_PK;


--NOT NULL
--NOT NULL제약 조건 추가
ALTER TABLE emp_copy10
--NOT NULL은 ADD CONSTRAINT를 사용하지 않는다.
--MODIFY ename NOT NULL;
MODIFY ename CONSTRAINT emp_copy10_ename_nn NOT NULL; 
--확인
SELECT OWNER, Constraint_name, constraint_type, table_name
FROM USER_constraints
WHERE table_name = UPPER('emp_copy10');
--테이블 생성 시 NOT NULL 사용
CREATE TABLE Patient(
    bunho   NUMBER(4),
    name    VARCHAR2(20) CONSTRAINT patient_name_NN NOT NULL,
    code    CHAR(2)      CONSTRAINT patient_code_NN NOT NULL,
    age     NUMBER(3)    CONSTRAINT patient_age_NN NOT NULL,
    days    NUMBER(3)    CONSTRAINT patient_days_NN NOT NULL,
    CONSTRAINT patient_bunho_PK PRIMARY KEY(bunho)
);