--------------------------------------------------------
--  파일이 생성됨 - 목요일-9월-21-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRG_COUPON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "GOODCHOICE"."TRG_COUPON_INSERT" 
AFTER INSERT ON coupon
FOR EACH ROW
BEGIN
   INSERT INTO event (event_id, coupon_type_id, event_name,
                      event_point, winner_limit,
                      start_date, end_date)
   VALUES (event_id_seq.NEXTVAL,
           :NEW.coupon_type_id,
           '자동생성 이벤트',
           1000,
           50,
           :NEW.start_date,
           :NEW.end_date);
END;
/
ALTER TRIGGER "GOODCHOICE"."TRG_COUPON_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UT_SAFE_NUM
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "GOODCHOICE"."UT_SAFE_NUM" 
AFTER INSERT ON reservation
FOR EACH ROW 
DECLARE
v_cnt NUMBER;
BEGIN 
 SELECT count(*) INTO v_cnt
 FROM safety_number
 WHERE user_id = :new.user_id;
 IF (v_cnt=0) THEN
 INSERT INTO safety_number (user_id,safety_number,create_at)
  VALUES(:new.user_id,'050'
  ||(SELECT substr(phone_number,10,4)FROM member WHERE user_id = :new.user_id)
  ||(SELECT substr(phone_number,5,4)FROM member WHERE user_id = :new.user_id)
  ,SYSDATE  
  );
  END IF;
END;
/
ALTER TRIGGER "GOODCHOICE"."UT_SAFE_NUM" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UT_USER_COUPON
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "GOODCHOICE"."UT_USER_COUPON" -- 쿠폰 발급시 유저 쿠폰수 갱신
BEFORE INSERT ON coupon_status
FOR EACH ROW 
BEGIN
  UPDATE member SET user_coupons = (SELECT count(1)+1 FROM coupon_status where user_id = :new.user_id)
  WHERE user_id = :new.user_id;
END;
/
ALTER TRIGGER "GOODCHOICE"."UT_USER_COUPON" ENABLE;
