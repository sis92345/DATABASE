/* 진찰부서 */
CREATE TABLE scott.department (
	code CHAR(2) NOT NULL, /* 부서 코드 */
	dname VARCHAR(15) NOT NULL /* 진찰부서명 */
);

COMMENT ON TABLE scott.department IS '진찰부서';

COMMENT ON COLUMN scott.department.code IS '부서 코드';

COMMENT ON COLUMN scott.department.dname IS '진찰부서명';

CREATE UNIQUE INDEX scott.department_code_PK
	ON scott.department (
		code ASC
	);

ALTER TABLE scott.department
	ADD
		CONSTRAINT department_code_PK
		PRIMARY KEY (
			code
		);

/* 진찰비 */
CREATE TABLE scott.checkup (
	seq NUMBER(1) NOT NULL, /* 일련번호 */
	losal NUMBER(2) NOT NULL, /* 하한가 */
	hisal NUMBER(3) NOT NULL, /* 상한가 */
	fee NUMBER(4) NOT NULL /* 진찰료 */
);

COMMENT ON TABLE scott.checkup IS '진찰비';

COMMENT ON COLUMN scott.checkup.seq IS '일련번호';

COMMENT ON COLUMN scott.checkup.losal IS '하한가';

COMMENT ON COLUMN scott.checkup.hisal IS '상한가';

COMMENT ON COLUMN scott.checkup.fee IS '진찰료';

CREATE UNIQUE INDEX scott.PK_checkup
	ON scott.checkup (
		seq ASC
	);

ALTER TABLE scott.checkup
	ADD
		CONSTRAINT PK_checkup
		PRIMARY KEY (
			seq
		);

/* 입원일수할인표 */
CREATE TABLE scott.discount (
	seq NUMBER(1) NOT NULL, /* 일련번호 */
	lodays NUMBER(3) NOT NULL, /* 하한날짜 */
	hidays NUMBER(4) NOT NULL, /* 상한날짜 */
	rate NUMBER(3,2) NOT NULL /* 할인비율 */
);

COMMENT ON TABLE scott.discount IS '입원일수할인표';

COMMENT ON COLUMN scott.discount.seq IS '일련번호';

COMMENT ON COLUMN scott.discount.lodays IS '하한날짜';

COMMENT ON COLUMN scott.discount.hidays IS '상한날짜';

COMMENT ON COLUMN scott.discount.rate IS '할인비율';

CREATE UNIQUE INDEX scott.disvount_seq_PK
	ON scott.discount (
		seq ASC
	);

ALTER TABLE scott.discount
	ADD
		CONSTRAINT disvount_seq_PK
		PRIMARY KEY (
			seq
		);

/* 환자 */
CREATE TABLE scott.patient (
	bunho NUMBER(1) NOT NULL, /* 환자번호 */
	code CHAR(2) NOT NULL, /* 부서 코드 */
	days NUMBER(4) NOT NULL, /* 환자입원일수 */
	age NUMBER(3) NOT NULL, /* 환자나이 */
	checkup_fee NUMBER(4), /* 진찰비 */
	hospital_fee NUMBER(7), /* 입원비 */
	sum NUMBER(8) /* 진료비 */
);

COMMENT ON TABLE scott.patient IS '환자';

COMMENT ON COLUMN scott.patient.bunho IS '환자번호';

COMMENT ON COLUMN scott.patient.code IS '부서 코드';

COMMENT ON COLUMN scott.patient.days IS '환자입원일수';

COMMENT ON COLUMN scott.patient.age IS '환자나이';

COMMENT ON COLUMN scott.patient.checkup_fee IS '진찰비';

COMMENT ON COLUMN scott.patient.hospital_fee IS '입원비';

COMMENT ON COLUMN scott.patient.sum IS '진료비';

CREATE UNIQUE INDEX scott.patient_bunho_PK
	ON scott.patient (
		bunho ASC
	);

ALTER TABLE scott.patient
	ADD
		CONSTRAINT patient_bunho_PK
		PRIMARY KEY (
			bunho
		);

ALTER TABLE scott.patient
	ADD
		CONSTRAINT FK_department_TO_patient
		FOREIGN KEY (
			code
		)
		REFERENCES scott.department (
			code
		);