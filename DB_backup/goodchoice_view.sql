--------------------------------------------------------
--  ������ ������ - �����-9��-21-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View CAMPING_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GOODCHOICE"."CAMPING_VIEW" ("ACCOM_NAME", "ACCOM_RATING", "ACCOM_REVIEW_COUNT", "ADDRESS", "MIN_PRICE") AS 
  (
SELECT accom_name, accom_rating, accom_review_count, address
                        , (SELECT MIN(PRICE) 
                            FROM accommodation acc JOIN room ON acc.seq =  room.seq 
                            WHERE acc.accom_id = 'C') AS min_price
                    FROM accommodation
                    WHERE accom_id = 'C'
)
;
--------------------------------------------------------
--  DDL for View GUEST_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GOODCHOICE"."GUEST_VIEW" ("ACCOM_NAME", "ACCOM_RATING", "ACCOM_REVIEW_COUNT", "ADDRESS", "MIN_PRICE") AS 
  (
SELECT accom_name, accom_rating, accom_review_count, address
                        , (SELECT MIN(PRICE) 
                            FROM accommodation acc JOIN room ON acc.seq =  room.seq 
                            WHERE acc.accom_id = 'G') AS min_price
                    FROM accommodation
                    WHERE accom_id = 'G'
)
;
--------------------------------------------------------
--  DDL for View HOTEL_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GOODCHOICE"."HOTEL_VIEW" ("ACCOM_NAME", "ACCOM_RATING", "ACCOM_REVIEW_COUNT", "ADDRESS", "MIN_PRICE") AS 
  (
SELECT accom_name, accom_rating, accom_review_count, address
                        , (SELECT MIN(PRICE) 
                            FROM accommodation acc JOIN room ON acc.seq =  room.seq 
                            WHERE acc.accom_id = 'H') AS min_price
                    FROM accommodation
                    WHERE accom_id = 'H'
)
;
--------------------------------------------------------
--  DDL for View MOTEL_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GOODCHOICE"."MOTEL_VIEW" ("ACCOM_NAME", "ACCOM_RATING", "ACCOM_REVIEW_COUNT", "ADDRESS", "MIN_PRICE") AS 
  (
SELECT accom_name, accom_rating, accom_review_count, address
                        , (SELECT MIN(PRICE) 
                            FROM accommodation acc JOIN room ON acc.seq =  room.seq 
                            WHERE acc.accom_id = 'M') AS min_price
                    FROM accommodation
                    WHERE accom_id = 'M'
)
;
--------------------------------------------------------
--  DDL for View PENSION_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GOODCHOICE"."PENSION_VIEW" ("ACCOM_NAME", "ACCOM_RATING", "ACCOM_REVIEW_COUNT", "ADDRESS", "MIN_PRICE") AS 
  (
SELECT accom_name, accom_rating, accom_review_count, address
                        , (SELECT MIN(PRICE) 
                            FROM accommodation acc JOIN room ON acc.seq =  room.seq 
                            WHERE acc.accom_id = 'P') AS min_price
                    FROM accommodation
                    WHERE accom_id = 'P'
)
;
REM INSERTING into GOODCHOICE.CAMPING_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('��õ ��� �۷���',4.9,75,'��� ��õ�� ���̸� ���ȸ� 388-2',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ��ķ��ī��ݱ۷���',8.2,137,'��� ���� ���Ǹ� â�Ǹ� 411-7',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� �ιг�õ���ı۷���',10,126,'��� ���� ������ �ιи� 215-15',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('��õ �ο�ī�ٳ��۷���',9.2,118,'��� ��õ�� ��õ�� ���� 420-1',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('��ȭ �������� ī��� ķ����',3.9,100,'��õ ��ȭ�� ȭ���� ��ȭ�� 511-1',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('������ ���� ķ����',0,149,'��õ �߱� ���յ� 810-308',50000);
REM INSERTING into GOODCHOICE.GUEST_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('ȫ�� �ҹٵ� �Խ�Ʈ�Ͽ콺',9,262,'����Ư���� ������ ������ 466-6 4F',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('ȫ�� ������ũ �Խ�Ʈ�Ͽ콺',9.4,44,'����Ư���� ������ ������ 150-10 201ȣ',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� �Ϸ� �Խ�Ʈ�Ͽ콺',9.4,160,'����Ư����ġ�� ���ʽ� ���� 261-6',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ���۳�� �Խ�Ʈ�Ͽ콺',9.9,224,'����Ư����ġ�� ���ֽ� �Ѹ��� ���縮 2557-1',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('��ġ �ؿ�� �Խ�Ʈ�Ͽ콺',9.2,304,'�λ걤���� �ؿ�뱸 �쵿 648-11',16000);
REM INSERTING into GOODCHOICE.HOTEL_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���̵� ���̺���Ʈ������ û��',8.7,74,'��� ��õ�� ���̸� ���ȸ� 388-2',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('�Ŷ����� �Ｚ',9,144,'��� ���� ���Ǹ� â�Ǹ� 411-7',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('�뺸�� �ڹ輭�� ���� ����',8.1,75,'��� ���� ������ �ιи� 215-15',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� �Ӹ��� ���� ���� ���Ÿ� �÷���',7.1,71,'��� ��õ�� ��õ�� ���� 420-1',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('��ũ��� �����̾� �ڿ�������',2.8,83,'��õ ��ȭ�� ȭ���� ��ȭ�� 511-1',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('�� �׷��� ������',0.9,101,'��õ �߱� ���յ� 810-308',140000);
REM INSERTING into GOODCHOICE.MOTEL_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ķ�۽�',6.5,51,'���� ������ ���ﵿ 825-30',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ��ġ��',0.6,147,'���� ������ ���ﵿ 677-9',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ��Ʈ�� ȣ��',0.6,68,'���� ������ ���ﵿ 677-14',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ��',4.2,75,'���� ���ʱ� ������ 748',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ��',7.6,77,'���� ������ ���ﵿ 718-12',25000);
REM INSERTING into GOODCHOICE.PENSION_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� ����� Ǯ����',9.7,278,'��� ���� �絿�� ���и� 461-6',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� �ٰ��� Ǯ����&���',9.8,142,'��� ���� �ܿ��� ���� 601',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� �츮���',10,16,'��� ���� �ܿ��� ���� 601',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('����Ű��Ǯ����',0,0,'��� ���� �빮�� ������ 5',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('���� �޻찡�����',8,134,'��� ���� ������ ���ĸ� 553-4',70000);
