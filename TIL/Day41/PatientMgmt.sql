/* �����μ� */
CREATE TABLE scott.department (
	code CHAR(2) NOT NULL, /* �μ� �ڵ� */
	dname VARCHAR(15) NOT NULL /* �����μ��� */
);

COMMENT ON TABLE scott.department IS '�����μ�';

COMMENT ON COLUMN scott.department.code IS '�μ� �ڵ�';

COMMENT ON COLUMN scott.department.dname IS '�����μ���';

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

/* ������ */
CREATE TABLE scott.checkup (
	seq NUMBER(1) NOT NULL, /* �Ϸù�ȣ */
	losal NUMBER(2) NOT NULL, /* ���Ѱ� */
	hisal NUMBER(3) NOT NULL, /* ���Ѱ� */
	fee NUMBER(4) NOT NULL /* ������ */
);

COMMENT ON TABLE scott.checkup IS '������';

COMMENT ON COLUMN scott.checkup.seq IS '�Ϸù�ȣ';

COMMENT ON COLUMN scott.checkup.losal IS '���Ѱ�';

COMMENT ON COLUMN scott.checkup.hisal IS '���Ѱ�';

COMMENT ON COLUMN scott.checkup.fee IS '������';

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

/* �Կ��ϼ�����ǥ */
CREATE TABLE scott.discount (
	seq NUMBER(1) NOT NULL, /* �Ϸù�ȣ */
	lodays NUMBER(3) NOT NULL, /* ���ѳ�¥ */
	hidays NUMBER(4) NOT NULL, /* ���ѳ�¥ */
	rate NUMBER(3,2) NOT NULL /* ���κ��� */
);

COMMENT ON TABLE scott.discount IS '�Կ��ϼ�����ǥ';

COMMENT ON COLUMN scott.discount.seq IS '�Ϸù�ȣ';

COMMENT ON COLUMN scott.discount.lodays IS '���ѳ�¥';

COMMENT ON COLUMN scott.discount.hidays IS '���ѳ�¥';

COMMENT ON COLUMN scott.discount.rate IS '���κ���';

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

/* ȯ�� */
CREATE TABLE scott.patient (
	bunho NUMBER(1) NOT NULL, /* ȯ�ڹ�ȣ */
	code CHAR(2) NOT NULL, /* �μ� �ڵ� */
	days NUMBER(4) NOT NULL, /* ȯ���Կ��ϼ� */
	age NUMBER(3) NOT NULL, /* ȯ�ڳ��� */
	checkup_fee NUMBER(4), /* ������ */
	hospital_fee NUMBER(7), /* �Կ��� */
	sum NUMBER(8) /* ����� */
);

COMMENT ON TABLE scott.patient IS 'ȯ��';

COMMENT ON COLUMN scott.patient.bunho IS 'ȯ�ڹ�ȣ';

COMMENT ON COLUMN scott.patient.code IS '�μ� �ڵ�';

COMMENT ON COLUMN scott.patient.days IS 'ȯ���Կ��ϼ�';

COMMENT ON COLUMN scott.patient.age IS 'ȯ�ڳ���';

COMMENT ON COLUMN scott.patient.checkup_fee IS '������';

COMMENT ON COLUMN scott.patient.hospital_fee IS '�Կ���';

COMMENT ON COLUMN scott.patient.sum IS '�����';

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