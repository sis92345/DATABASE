--환자관리 프로그램 DB

--진찰부서표 테이블
CREATE TABLE department(
    code CHAR(2),
    dname VARCHAR2(15) CONSTRAINT department_dname_NN NOT NULL,
    CONSTRAINT department_code_PK PRIMARY KEY(code)
);

INSERT INTO department VALUES('MI', '외과');
INSERT INTO department VALUES('NI', '내과');
INSERT INTO department VALUES('SI', '피부과');
INSERT INTO department VALUES('TI', '소아과');
INSERT INTO department VALUES('VI', '산부인과');
INSERT INTO department VALUES('WI', '비뇨기과');
COMMIT;
--진찰비 테이블
CREATE TABLE checkup(
    seq     NUMBER(1),--모든 테이블은  PK가 있어야 하나 PK로 만들 대상이 부족하다면 만든다.
    loage   NUMBER(2)   CONSTRAINT check_up_loage_NN NOT NULL,
    hiage   NUMBER(3)   CONSTRAINT check_up_hiage_NN NOT NULL,
    fee     NUMBER(4)   CONSTRAINT check_up_fee_NN NOT NULL,
    CONSTRAINT checkup_seq_PK PRIMARY KEY(seq)
);

INSERT INTO checkup VALUES(1, 0, 9, 7000);
INSERT INTO checkup VALUES(2, 10, 19, 5000);
INSERT INTO checkup VALUES(3, 20, 29, 8000);
INSERT INTO checkup VALUES(4, 30, 39, 7000);
INSERT INTO checkup VALUES(5, 40, 49, 4500);
INSERT INTO checkup VALUES(6, 50, 120, 2300);
COMMIT;

--입원일수 할인표 테이블
CREATE TABLE discount(
	seq		NUMBER(1),
	lodays 	NUMBER(3)  	CONSTRAINT discount_lodays_NN NOT NULL,
	hidays	NUMBER(4)	CONSTRAINT discount_hidays_NN NOT NULL,
	rate 	NUMBER(3,2)	CONSTRAINT discount_rate_NN NOT NULL,
	CONSTRAINT discount_seq_PK PRIMARY KEY(seq)
);

INSERT INTO discount VALUES(1, 0, 9, 1.00);
INSERT INTO discount VALUES(2, 10, 14, 0.85);
INSERT INTO discount VALUES(3, 15, 19, 0.80);
INSERT INTO discount VALUES(4, 20, 29, 0.70);
INSERT INTO discount VALUES(5, 30, 99, 0.77);
INSERT INTO discount VALUES(6, 100, 9999, 0.68);

DROP TABLE Patient;
--환자 테이블
CREATE TABLE Patient(
    bunho           NUMBER(1),
    code           CHAR(2)      CONSTRAINT patient_code_NN NOT NULL,    --환자진찰코드
    days            NUMBER(4)   CONSTRAINT patient_days_NN NOT NULL,  --환자입원일수
    age             NUMBER(3)   CONSTRAINT patient_age_NN NOT NULL,
    dname           VARCHAR(15),
    checkup_fee     NUMBER(4), --진찰비
    hospital_fee`   NUMBER(7), --입원비
    sum             NUMBER(8),  --진료비
    CONSTRAINT patient_bunho_PK PRIMARY KEY(bunho)
);
