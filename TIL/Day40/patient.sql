--ȯ�ڰ��� ���α׷� DB

--�����μ�ǥ ���̺�
CREATE TABLE department(
    code CHAR(2),
    dname VARCHAR2(15) CONSTRAINT department_dname_NN NOT NULL,
    CONSTRAINT department_code_PK PRIMARY KEY(code)
);

INSERT INTO department VALUES('MI', '�ܰ�');
INSERT INTO department VALUES('NI', '����');
INSERT INTO department VALUES('SI', '�Ǻΰ�');
INSERT INTO department VALUES('TI', '�Ҿư�');
INSERT INTO department VALUES('VI', '����ΰ�');
INSERT INTO department VALUES('WI', '�񴢱��');
COMMIT;
--������ ���̺�
CREATE TABLE checkup(
    seq     NUMBER(1),--��� ���̺���  PK�� �־�� �ϳ� PK�� ���� ����� �����ϴٸ� �����.
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

--�Կ��ϼ� ����ǥ ���̺�
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
--ȯ�� ���̺�
CREATE TABLE Patient(
    bunho           NUMBER(1),
    code           CHAR(2)      CONSTRAINT patient_code_NN NOT NULL,    --ȯ�������ڵ�
    days            NUMBER(4)   CONSTRAINT patient_days_NN NOT NULL,  --ȯ���Կ��ϼ�
    age             NUMBER(3)   CONSTRAINT patient_age_NN NOT NULL,
    dname           VARCHAR(15),
    checkup_fee     NUMBER(4), --������
    hospital_fee`   NUMBER(7), --�Կ���
    sum             NUMBER(8),  --�����
    CONSTRAINT patient_bunho_PK PRIMARY KEY(bunho)
);
