--Day41 0924
--Constraint
CREATE TABLE dept_copy
AS 
SELECT *
FROM dept;

--테이블을 복사하면 제약조건은 삭제된다.
SELECT owner, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('dept_copy');

-- 이미 만들어진 테이블에 제약조건을 부여
--NOT NULL 제약조건의 변경은 MODIFY를 사용
--ADD CONSTRAINT는 테이블 레벨 제약 조건만 가능
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
-- 테이블 생성 
CREATE TABLE emp_copy 참조하는 테이블: 자식 테이블
AS 
SELECT * FROM emp;

CREATE TABLE dept_copy --참조당하는 테이블: 부모테이블
AS
SELECT * FROM dept;
-- 기본키 부여
ALTER TABLE emp_copy
ADD CONSTRAINT emp_copy_empno_PK PRIMARY KEY(empno);

ALTER TABLE dept_copy
ADD CONSTRAINT dept_copy_dept_PK PRIMARY KEY(deptno);
--FOREIGN KEY 부여
ALTER TABLE emp_copy
ADD CONSTRAINT emp_copy_deptno_FK FOREIGN KEY(deptno) 
REFERENCES dept_copy(deptno);

INSERT INTO emp_copy(empno, ename, deptno)
VALUES(8888, '한지민', 50); --50번 부서는 없으므로 오류

DESC USER_CONSTRAINTS;
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = UPPER('emp_copy');

--테이블 생성 시 FOREIGN KEY 생성
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
-- 컬럼레벨 제약조건은 FOREIGN KEY 키워드를 사용하지 않는다.
CREATE TABLE Cart(
    cart_id     NUMBER(10),
    member_id   NUMBER(5) CONSTRAINT cart_member_id_FK REFERENCES member(member_id),
    product_id  NUMBER(5),
    CONSTRAINT cart_cart_id_PK PRIMARY KEY(cart_id),
    CONSTRAINT cart_product_id_FK FOREIGN KEY(product_id) REFERENCES Product(product_id)
); --만약 참조할 테이블에 값이 하나도 존재하지 않는다면 외래키를 지정할 수 없다.

INSERT INTO dept1(deptno, danme, loc)
VALUES(10, '개발팀','SEOUL');
INSERT INTO dept1(deptno, danme, loc)
VALUES(20, '총무팀','SEOUL');
INSERT INTO emp1(empno, ename, deptno)
VALUES(1111, '한지민','SEOUL'); -- emp.deptno가 참조하는 dept.DEPTNO에는 SEOUL이라는 값이 없다.

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
REFERENCES dept1(deptno) ON DELETE CASCADE; -- 부모 데이터 삭제 시 참조하는 자식 데이터도 같이 삭제됨

-- ON DELETE SET NULL: 부모 데이터가 삭제되면 이를 참조하는 자식 테이블의 데이터를 삭제하지 않고 대신 NULL로 바꾼다.
INSERT INTO dept1(deptno, danme, loc)
VALUES(10, '개발팀','SEOUL');

ALTER TABLE emp1
ADD CONSTRAINT emp1_deptno_FK FOREIGN KEY(deptno) 
REFERENCES dept1(deptno) ON DELETE SET NULL; -- 부모 데이터 삭제 시 참조하는 자식 데이터도 같이 삭제됨

INSERT INTO emp1(empno, ename, deptno)
VALUES(1111, '한지민',10);

DELETE FROM dept1
WHERE deptno = 10;

SELECT * FROM emp1; -- ON DELETE SET NULL: 한지민 데이터의 값은 NULL로 바뀐다.

--UNIQUE
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = UPPER('PATIENT');

-- 부서 테이블의 부서명에 유일키를 지정하자
ALTER TABLE dept1
ADD CONSTRAINT dept1_dname_UK UNIQUE(danme);

INSERT INTO dept1
VALUES(10, '개발팀', 'SEOUL');

INSERT INTO dept1
VALUES(20, '총무팀', 'SEOUL');

INSERT INTO dept1
VALUES(50, '총무팀', 'SEOUL'); -- dname은 유니크이므로 같은 값을 입력할 수 없다.

--CHECK: 부서의 위치는 서울, 부산,대전, 대구, 인천, 광주, 울산만 가능해야 한다.
ALTER TABLE dept1
ADD CONSTRAINT dept1_loc_CK CHECK (loc IN ('SEOUL','PUSAN', '대구','인천','대전','울산'));

INSERT INTO dept1
VALUES(40, '디자인팀', '대구');


INSERT INTO dept1
VALUES(60, '디자인팀', '평양'); --CHECK 제약 조건에 위배

-- 제약조건 및 DEFAULT OPTION 복습
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
    CONSTRAINT studnet_city_CK CHECK(city IN ('서울', '부산', '부천')),
    CONSTRAINT studnet_city_UK UNIQUE(city),
    CONSTRAINT studnet_gender_CK CHECK(gender IN ('1', '0')),
    --CONSTRAINT studnet_zipcode_FK FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode): 참조할 부모 테이블의 값은 유니크, 기본키
    CONSTRAINT studnet_zipcode_FK FOREIGN KEY(seq) REFERENCES zipcode(seq)
);

-- 테이블 정리
DROP TABLE Patient;
DROP TABLE checkup;
DROP TABLE department;
DROP TABLE discount
;



INSERT INTO department VALUES('MI', '외과');
INSERT INTO department VALUES('NI', '내과');
INSERT INTO department VALUES('SI', '피부과');
INSERT INTO department VALUES('TI', '소아과');
INSERT INTO department VALUES('VI', '산부인과');
INSERT INTO department VALUES('WI', '비뇨기과');
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
--SEQUENCE 생성
CREATE SEQUENCE dept_deptno_SEQ
--나머지는 생략가능
    MAXVALUE 100
    NOCYCLE;
--SEQUENCE 수정
--ALTER SEQUENCE
--SEQUENCE의 START WITH는 수정할 수 없다.
ALTER SEQUENCE dept_deptno_SEQ
    MAXVALUE 1000;
--SEQUENCE 삭제
DROP SEQUENCE dept_deptno_SEQ;
DESC USER_SEQUENCES;
SELECT *
FROM USER_SEQUENCES;
--SEQUENCE 사용

CREATE TABLE test1(
    no NUMBER(7) CONSTRAINT test1_no_PK PRIMARY KEY,
    job VARCHAR(20) CONSTRAINT test1_job_FK REFERENCES emp(job)
);
