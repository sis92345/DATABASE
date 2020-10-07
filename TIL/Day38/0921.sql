--Day38, 09-21
--DBA_XXXX
SELECT *
FROM DICTIONARY;

--DBA는 sys, 즉 DBA만 볼 수 있다.
SELECT *
FROM DBA_TABLES; --오류: DBA_XXXX 테이블은 DBA(SYSTEM, SYS)가 아니면 권한이 없다.

SELECT *
FROM DBA_USERS;

--ALL_XXXX
SELECT *
FROM ALL_TABLES; -- ALL_XXXX는 허락받은 다른 객체까지 읽어올 수 있다.
--따라서 SYS소속인 DUAL 계정이 존재하는 것

--USER_XXXX
SELECT *
FROM USER_TABLES; -- 현재 접속중인 계정이 소유한 객체를 읽는다 
--XX_TABLES는 테이블의 집합을 보여준다. 만약 유저의 뷰만 볼려면
--USER_VIEWS, 시퀀스를 볼려면
--USER_SEQUENCE, 인덱스를 볼려면
--USER_INDEXIS,  SYNONYM를 볼려면
--USER_SYNONYM

--DDL
--CREATE
CREATE TABLE member(
    id               VARCHAR2(14), --가변길이 문자형 
    password         VARCHAR2(20)
);

-- 생성한 테이블 확인
DESC USER_TABLES;

SELECT table_name
FROM user_tables; -- == SELECT * FROM tab;

--CREATE 예
CREATE TABLE Student1(
    hukbun         CHAR(7)      , --2020-01
    name           VARCHAR2(20) , --김빛나라               
    address        VARCHAR2(200), --서울시 강남구 역삼동 한독빌딩 8층
    age            NUMBER(3)    ,
    birthday       DATE         ,
    email          VARCHAR2(100),
    hight          NUMBER(4, 1) , --178.3
    weight         NUMBER(4, 1)   --110.3
);

DESC USER_TABLES;
SELECT *
FROM tab;

TRUNCATE TABLE Student; --DELETE와의 차이: DELETE는 DML로 트렌젝션의 대상 --> ROLLBACK로 복구 가능하지만 DDL인 TRUNCATE는 ROLLBACK할 수 없다.
--DROP은 아예 테이블을 삭제하지만 TRUNCATE는 테이블의 데이터만 전부 삭제한다는 점에서 다르다.