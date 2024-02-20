--------------------------------------------------------
--  파일이 생성됨 - 목요일-9월-21-2023   
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
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('포천 베어스 글램핑',4.9,75,'경기 포천시 내촌면 신팔리 388-2',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('가평 더캠프카라반글램핑',8.2,137,'경기 가평군 설악면 창의리 411-7',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('가평 두밀노천스파글램핑',10,126,'경기 가평군 가평읍 두밀리 215-15',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('연천 로열카바나글램핑',9.2,118,'경기 연천군 연천읍 고문리 420-1',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('강화 낙조힐링 카라반 캠핑장',3.9,100,'인천 강화군 화도면 장화리 511-1',50000);
Insert into GOODCHOICE.CAMPING_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('용유도 서해 캠핑장',0,149,'인천 중구 을왕동 810-308',50000);
REM INSERTING into GOODCHOICE.GUEST_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('홍대 롬바드 게스트하우스',9,262,'서울특별시 마포구 서교동 466-6 4F',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('홍대 딸기핑크 게스트하우스',9.4,44,'서울특별시 마포구 동교동 150-10 201호',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('속초 하루 게스트하우스',9.4,160,'강원특별자치도 속초시 동명동 261-6',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('제주 쉬멍놀멍 게스트하우스',9.9,224,'제주특별자치도 제주시 한림읍 협재리 2557-1',16000);
Insert into GOODCHOICE.GUEST_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('김치 해운대 게스트하우스',9.2,304,'부산광역시 해운대구 우동 648-11',16000);
REM INSERTING into GOODCHOICE.HOTEL_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('에이든 바이베스트웨스턴 청담',8.7,74,'경기 포천시 내촌면 신팔리 388-2',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('신라스테이 삼성',9,144,'경기 가평군 설악면 창의리 411-7',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('노보텔 앰배서더 서울 강남',8.1,75,'경기 가평군 가평읍 두밀리 215-15',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('조선 팰리스 서울 강남 럭셔리 컬렉션',7.1,71,'경기 연천군 연천읍 고문리 420-1',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('오크우드 프리미어 코엑스센터',2.8,83,'인천 강화군 화도면 장화리 511-1',140000);
Insert into GOODCHOICE.HOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('더 그랜드 섬오름',0.9,101,'인천 중구 을왕동 810-308',140000);
REM INSERTING into GOODCHOICE.MOTEL_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('강남 캠퍼스',6.5,51,'서울 강남구 역삼동 825-30',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('역삼 리치웰',0.6,147,'서울 강남구 역삼동 677-9',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('역삼 인트로 호텔',0.6,68,'서울 강남구 역삼동 677-14',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('강남 봄',4.2,75,'서울 서초구 반포동 748',25000);
Insert into GOODCHOICE.MOTEL_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('역삼 린',7.6,77,'서울 강남구 역삼동 718-12',25000);
REM INSERTING into GOODCHOICE.PENSION_VIEW
SET DEFINE OFF;
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('양평 엘모로 풀빌라',9.7,278,'경기 양평군 양동면 쌍학리 461-6',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('양평 다가섬 풀빌라&펜션',9.8,142,'경기 양평군 단월면 명성리 601',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('양평 우리펜션',10,16,'경기 양평군 단월면 명성리 601',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('디토키즈풀빌라',0,0,'경기 양평군 용문면 연수리 5',70000);
Insert into GOODCHOICE.PENSION_VIEW (ACCOM_NAME,ACCOM_RATING,ACCOM_REVIEW_COUNT,ADDRESS,MIN_PRICE) values ('양평 햇살가득펜션',8,134,'경기 양평군 서종면 서후리 553-4',70000);
