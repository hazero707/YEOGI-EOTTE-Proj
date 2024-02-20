--------------------------------------------------------
--  파일이 생성됨 - 목요일-9월-21-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure CAMPINGBYPRICERANGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."CAMPINGBYPRICERANGE" (
    p_min_price IN NUMBER,
    p_max_price IN NUMBER
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            R.price AS room_price
        FROM 
            ACCOMMODATION A
        JOIN 
            ROOM R ON A.ACCOM_ID = R.ACCOM_ID
        WHERE 
            R.price BETWEEN p_min_price AND p_max_price
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Room Price: ' || r.room_price);
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GET_CAMPING_BY_ETC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GET_CAMPING_BY_ETC" (
    p_WITH_PET NUMBER DEFAULT NULL,           -- 반려동물과 함께 이용 가능한지의 여부 (0 또는 1)
    p_BREAKFAST NUMBER DEFAULT NULL,          -- 조식 제공 여부 (0 또는 1)
    p_SMOKING NUMBER DEFAULT NULL,            -- 흡연 가능한지의 여부 (0 또는 1)
    p_VALET_PARKING NUMBER DEFAULT NULL,      -- 발렛 주차 서비스 제공 여부 (0 또는 1)
    p_NON_SMOKING NUMBER DEFAULT NULL,        -- 금연실 제공 여부 (0 또는 1)
    p_IN_ROOM_COOKING NUMBER DEFAULT NULL,    -- 방 내에서 요리 가능 여부 (0 또는 1)
    p_PICK_UP_AVAILABLE NUMBER DEFAULT NULL,  -- 픽업 서비스 제공 여부 (0 또는 1)
    p_CAMPFIRE NUMBER DEFAULT NULL,           -- 캠프파이어 가능 여부 (0 또는 1)
    p_CREDIT_CARD NUMBER DEFAULT NULL,        -- 신용카드 결제 가능 여부 (0 또는 1)
    p_SITE_PARK NUMBER DEFAULT NULL          -- 사이트 내 주차장 제공 여부 (0 또는 1)
) 
IS
    -- 조회를 위한 커서 정의

    vcursor SYS_REFCURSOR;




   v_sql VARCHAR2(2000);
   v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
   v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
   v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
   v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;
   v_ACCOM_REVIEW_COUNT ACCOMMODATION.ACCOM_REVIEW_COUNT%TYPE;
   v_CHECK_IN_TIME ACCOMMODATION.CHECK_IN_TIME%TYPE;
   v_CHECK_OUT_TIME ACCOMMODATION.CHECK_OUT_TIME%TYPE;
   v_AD_GRADE ACCOMMODATION.AD_GRADE%TYPE;

BEGIN
   v_sql := v_sql || 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING, A.ACCOM_REVIEW_COUNT, A.CHECK_IN_TIME, A.CHECK_OUT_TIME, A.AD_GRADE ';
   v_sql := v_sql || 'FROM ACCOMMODATION A JOIN ETC E ON A.ACCOM_ID = E.ACCOM_ID AND A.SEQ = E.SEQ ';
   v_sql := v_sql || 'WHERE A.ACCOM_ID = ''C'' ';

   IF p_WITH_PET IS NOT NULL THEN
      v_sql := v_sql || ' AND E.WITH_PET = ' || p_WITH_PET;
   END IF;
   IF p_BREAKFAST IS NOT NULL THEN
      v_sql := v_sql || ' AND E.BREAKFAST = ' || p_BREAKFAST;
   END IF;
   IF p_SMOKING IS NOT NULL THEN
      v_sql := v_sql || ' AND E.SMOKING = ' ||p_SMOKING;
   END IF;
   IF p_VALET_PARKING IS NOT NULL THEN
      v_sql := v_sql || ' AND E.VALET_PARKING = ' ||p_VALET_PARKING;
   END IF;
   IF p_NON_SMOKING IS NOT NULL THEN
      v_sql := v_sql || ' AND E.NON_SMOKING = ' ||p_NON_SMOKING;
   END IF;
   IF p_IN_ROOM_COOKING IS NOT NULL THEN
      v_sql := v_sql || ' AND E.IN_ROOM_COOKING = ' ||p_IN_ROOM_COOKING;
   END IF;
   IF p_PICK_UP_AVAILABLE IS NOT NULL THEN
      v_sql := v_sql || ' AND E.PICK_UP_AVAILABLE = ' ||p_PICK_UP_AVAILABLE;
   END IF;
   IF p_CAMPFIRE IS NOT NULL THEN
      v_sql := v_sql || ' AND E.CAMPFIRE = ' ||p_CAMPFIRE;
   END IF;
   IF p_CREDIT_CARD IS NOT NULL THEN
      v_sql := v_sql || ' AND E.CREDIT_CARD = ' ||p_CREDIT_CARD;
   END IF;
   IF p_SITE_PARK IS NOT NULL THEN
      v_sql := v_sql || ' AND E.SITE_PARK = ' ||p_SITE_PARK;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor 
         INTO v_ACCOM_ID, v_ACCOM_NAME,v_ADDRESS,
            v_ACCOM_RATING,v_ACCOM_REVIEW_COUNT,
            v_CHECK_IN_TIME, v_CHECK_OUT_TIME, v_AD_GRADE;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ACCOM_NAME || ', ' || v_ADDRESS);
    END LOOP;
    CLOSE vcursor;


END;

/
--------------------------------------------------------
--  DDL for Procedure GET_CAMPING_BY_ROOM_FACILITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GET_CAMPING_BY_ROOM_FACILITIES" (
    p_SHOWER_ROOM NUMBER DEFAULT NULL,
    p_HAIR_DRYER NUMBER DEFAULT NULL,
    p_WI_FI NUMBER DEFAULT NULL,
    p_TV NUMBER DEFAULT NULL,
    p_TOILETRIES NUMBER DEFAULT NULL,
    p_MINI_BAR NUMBER DEFAULT NULL,
    p_AC NUMBER DEFAULT NULL,
    p_REFRIGERATER NUMBER DEFAULT NULL,
    p_BATHTUB NUMBER DEFAULT NULL,
    p_IRON NUMBER DEFAULT NULL,
    p_RICE_COOKER NUMBER DEFAULT NULL,
    p_ROOM_SPA NUMBER DEFAULT NULL,
    p_POWER_SOCKET NUMBER DEFAULT NULL
) AS
    v_sql VARCHAR2(2000);
    vcursor SYS_REFCURSOR;
    v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
    v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
    v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
    v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;

BEGIN
    v_sql := 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING ';
    v_sql := v_sql || 'FROM ACCOMMODATION A JOIN ROOM_FACILITIES RF ON A.ACCOM_ID = RF.ACCOM_ID WHERE 1=1 ';

    IF p_SHOWER_ROOM IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.SHOWER_ROOM = ' || p_SHOWER_ROOM;
    END IF;
    IF p_HAIR_DRYER IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.HAIR_DRYER = ' || p_HAIR_DRYER;
    END IF;
    IF p_WI_FI IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.WI_FI = ' || p_WI_FI;
    END IF;
    IF p_TV IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.TV = ' || p_TV;
    END IF;
    IF p_TOILETRIES IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.TOILETRIES = ' || p_TOILETRIES;
    END IF;
    IF p_MINI_BAR IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.MINI_BAR = ' || p_MINI_BAR;
    END IF;
    IF p_AC IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.AC = ' || p_AC;
    END IF;
    IF p_REFRIGERATER IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.REFRIGERATER = ' || p_REFRIGERATER;
    END IF;
    IF p_BATHTUB IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.BATHTUB = ' || p_BATHTUB;
    END IF;
    IF p_IRON IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.IRON = ' || p_IRON;
    END IF;
    IF p_RICE_COOKER IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.RICE_COOKER = ' || p_RICE_COOKER;
    END IF;
    IF p_ROOM_SPA IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.ROOM_SPA = ' || p_ROOM_SPA;
    END IF;
    IF p_POWER_SOCKET IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.POWER_SOCKET = ' || p_POWER_SOCKET;
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor INTO v_ACCOM_ID, v_ACCOM_NAME, v_ADDRESS, v_ACCOM_RATING;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ACCOM_ID: ' || v_ACCOM_ID);
        DBMS_OUTPUT.PUT_LINE('ACCOM_NAME: ' || v_ACCOM_NAME);
        DBMS_OUTPUT.PUT_LINE('ADDRESS: ' || v_ADDRESS);
        DBMS_OUTPUT.PUT_LINE('ACCOM_RATING: ' || v_ACCOM_RATING);
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure GET_INQUIRY_DETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GET_INQUIRY_DETAILS" AS
    vcursor SYS_REFCURSOR;
    v_inquiry_type INQUIRY.INQUIRY_TYPE%TYPE;
    v_inquiry_content INQUIRY.INQUIRY_CONTENT%TYPE;
    v_inquiry_date INQUIRY.INQUIRY_DATE%TYPE;
    v_inquiry_status VARCHAR2(50);
BEGIN
    OPEN vcursor FOR
        SELECT 
            INQUIRY_TYPE,
            INQUIRY_CONTENT,
            INQUIRY_DATE,
            CASE 
                WHEN TO_NUMBER(STATUS) = 1 THEN '답변 완료'
                WHEN TO_NUMBER(STATUS) = 2 THEN '답변 대기'
                ELSE '알 수 없는 상태'
            END AS inquiry_status
        FROM 
            INQUIRY
        ORDER BY 
            INQUIRY_DATE DESC;

    LOOP
        FETCH vcursor INTO v_inquiry_type, v_inquiry_content, v_inquiry_date, v_inquiry_status;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('문의 유형 :' || v_inquiry_type || ', ' || '문의 내용: ' || v_inquiry_content || ', ' || '문의 날짜 :' || v_inquiry_date || ', ' || '문의 상태 : ' || v_inquiry_status);
    END LOOP;

    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure GET_PENSIONS_BY_ETC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GET_PENSIONS_BY_ETC" (
    p_accom_id IN accommodation.accom_id%TYPE, 
    p_WITH_PET NUMBER,
    p_BREAKFAST NUMBER,
    p_SMOKING NUMBER,
    p_VALET_PARKING NUMBER,
    p_NON_SMOKING NUMBER,
    p_IN_ROOM_COOKING NUMBER,
    p_PRINTER NUMBER,
    p_STORAGE NUMBER,
    p_PERSONAL_LOCKER NUMBER,
    p_FREE_PARKING NUMBER,
    p_PICK_UP_AVAILABLE NUMBER,
    p_CAMPFIRE NUMBER,
    p_CREDIT_CARD NUMBER,
    p_PWD NUMBER
) AS
BEGIN
    FOR r IN (
    SELECT DISTINCT  
    A.ACCOM_ID,
    A.ACCOM_NAME, 
    A.ADDRESS
    FROM ACCOMMODATION A
    JOIN ETC E ON A.ACCOM_ID = E.ACCOM_ID
    WHERE  p_accom_id IS NOT NULL OR E.accom_id = p_accom_id
    AND p_WITH_PET IS NULL OR E.WITH_PET = p_WITH_PET
    AND p_BREAKFAST IS NULL OR E.BREAKFAST = p_BREAKFAST
    AND p_SMOKING IS NULL OR E.SMOKING = p_SMOKING
    AND p_VALET_PARKING IS NULL OR E.VALET_PARKING = p_VALET_PARKING
    AND p_NON_SMOKING IS NULL OR E.NON_SMOKING = p_NON_SMOKING
    AND p_IN_ROOM_COOKING IS NULL OR E.IN_ROOM_COOKING = p_IN_ROOM_COOKING
    AND p_PRINTER IS NULL OR E.PRINTER = p_PRINTER
    AND p_STORAGE IS NULL OR E.STORAGE = p_STORAGE
    AND p_PERSONAL_LOCKER IS NULL OR E.PERSONAL_LOCKER = p_PERSONAL_LOCKER
    AND p_FREE_PARKING IS NULL OR E.FREE_PARKING = p_FREE_PARKING
    AND p_PICK_UP_AVAILABLE IS NULL OR E.PICK_UP_AVAILABLE = p_PICK_UP_AVAILABLE
    AND p_CAMPFIRE IS NULL OR E.CAMPFIRE = p_CAMPFIRE
    AND p_CREDIT_CARD IS NULL OR E.CREDIT_CARD = p_CREDIT_CARD
    AND p_PWD IS NULL OR E.PWD = p_PWD
  )LOOP

       DBMS_OUTPUT.PUT_LINE('ACCOM_ID: ' || r.ACCOM_ID);
       DBMS_OUTPUT.PUT_LINE('ACCOM_NAME: ' || r.ACCOM_NAME);
       DBMS_OUTPUT.PUT_LINE('ADDRESS: ' || r.ADDRESS);
       DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GET_UNANSWERED_INQUIRIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GET_UNANSWERED_INQUIRIES" AS
    vcursor SYS_REFCURSOR;
    v_answer_date INQUIRY.ANSWER_DATE%TYPE;
    v_answer_content INQUIRY.ANSWER_CONTENT%TYPE;
BEGIN
    OPEN vcursor FOR
        SELECT 
            ANSWER_DATE,
            ANSWER_CONTENT
        FROM 
            INQUIRY
        WHERE 
            ANSWER_DATE IS NULL 
            AND ANSWER_CONTENT IS NULL;

    LOOP
        FETCH vcursor INTO v_answer_date, v_answer_content;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('답변 작성일시: ' || NVL(TO_CHAR(v_answer_date), 'N/A') || ', 답변 내용: ' || NVL(v_answer_content, 'N/A'));
    END LOOP;

    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure GET_USER_DETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GET_USER_DETAILS" (p_user_id MEMBER.USER_ID%TYPE) AS
    v_user_id MEMBER.USER_ID%TYPE;
    v_user_nickname MEMBER.USER_NICKNAME%TYPE; -- Corrected this line
    v_user_name MEMBER.USER_NAME%TYPE;
    v_phone_number MEMBER.PHONE_NUMBER%TYPE;
BEGIN
    SELECT 
        user_id, 
        user_nickname, 
        NVL(user_name, '') AS user_name, 
        phone_number
    INTO 
        v_user_id, 
        v_user_nickname,  -- Corrected this line
        v_user_name, 
        v_phone_number
    FROM 
        member
    WHERE 
        user_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('유저ID(이메일): ' || v_user_id || ', 닉네임: ' || v_user_nickname || ', 예약자이름: ' || v_user_name || ', 휴대번호: ' || v_phone_number); -- Corrected this line
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the provided user_id.');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

/
--------------------------------------------------------
--  DDL for Procedure GETACCOMMODATIONBYADDRESS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETACCOMMODATIONBYADDRESS" (
    p_accom_id IN accommodation.accom_id%TYPE,
    p_address IN accommodation.address%TYPE
)
AS
    CURSOR c_accommodation IS
        SELECT *
        FROM accommodation
        WHERE accom_id = p_accom_id AND address LIKE p_address || '%';
BEGIN
    FOR r_accommodation IN c_accommodation LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r_accommodation.accom_id);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r_accommodation.address);
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GETACCOMMODATIONINFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETACCOMMODATIONINFO" (
    p_accom_id IN accommodation.accom_id%TYPE  -- 숙소 ID 파라미터
)
AS
    -- 커서 정의: 주어진 accom_id와 일치하는 모든 행 선택 
    CURSOR c_accommodation IS
        SELECT *
        FROM accommodation  -- ACCOMMODATION 테이블에서 선택
        WHERE accom_id = p_accom_id;  -- accom_id가 파라미터와 일치하는 경우만 선택  
BEGIN
     FOR r_accommodation in c_accommodation LOOP   -- 커서 반복하여 각 행에 대해 작업 수행  
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r_accommodation.accom_id);
        DBMS_OUTPUT.PUT_LINE('Name: ' || r_accommodation.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r_accommodation.address);
    END LOOP;
END GetAccommodationInfo;

/
--------------------------------------------------------
--  DDL for Procedure GETAVAILABLEPENSIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETAVAILABLEPENSIONS" (
    v_reservation IN RESERVATION_OPTION.reservation%TYPE
)
AS
    CURSOR c_available_pensions IS
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            R.reservation
        FROM 
            ACCOMMODATION A 
        JOIN 
           RESERVATION_OPTION R ON A.accom_id = R.accom_id
        WHERE 
           R.reservation = v_reservation;
BEGIN
    FOR r_available_pensions IN c_available_pensions LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r_available_pensions.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r_available_pensions.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r_available_pensions.address);
        DBMS_OUTPUT.PUT_LINE('Reservation: ' || CASE WHEN r_available_pensions.reservation = 1 THEN 'Available' ELSE 'Not Available' END);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    END LOOP;
END GetAvailablePensions;

/
--------------------------------------------------------
--  DDL for Procedure GETCAMPINGBYCAPACITY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETCAMPINGBYCAPACITY" (
     p_camping_type IN ACCOMMODATION_INFO.ACCOM_TITLE%TYPE,
     p_desired_capacity IN ROOM.CAPACITY%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            R.room_name,
            R.price,
            R.capacity,
            R.type
        FROM 
            ACCOMMODATION A
        JOIN 
            ROOM R ON A.SEQ = R.SEQ AND A.accom_id = R.accom_id
        JOIN
            ACCOMMODATION_INFO AI ON A.SEQ = AI.SEQ
        WHERE 
            R.capacity >= p_desired_capacity
            AND AI.accom_title = p_camping_type
            AND A.accom_id LIKE 'C%'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Room Name: ' || r.room_name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || r.price);
        DBMS_OUTPUT.PUT_LINE('Capacity: ' || r.capacity);
        DBMS_OUTPUT.PUT_LINE('Type: ' || r.type);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GETCAMPINGBYTYPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETCAMPINGBYTYPE" (
    p_camping_type IN ACCOMMODATION_INFO.ACCOM_TITLE%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            AI.accom_title,
            AI.detail_title
        FROM 
            ACCOMMODATION A
        JOIN 
            ACCOMMODATION_INFO AI ON A.SEQ = AI.SEQ
        WHERE 
            AI.accom_title = '캠핑/글램핑'
            AND A.accom_id LIKE 'C%'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Camping Type: ' || r.accom_title);
        DBMS_OUTPUT.PUT_LINE('Detail Title: ' || r.detail_title);
    END LOOP;
END GetCampingByType;

/
--------------------------------------------------------
--  DDL for Procedure GETLUXURYACCOMMODATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETLUXURYACCOMMODATION" (
    p_detail_title IN ACCOMMODATION_INFO.DETAIL_TITLE%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            AI.accom_title,
            AI.detail_title
        FROM 
            ACCOMMODATION A
        JOIN 
           ACCOMMODATION_INFO AI ON A.SEQ = AI.SEQ
        WHERE 
           AI.detail_title = p_detail_title -- 여기에 원하는 숙소 유형을 입력하세요.
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Accommodation Type: ' || r.accom_title);
        DBMS_OUTPUT.PUT_LINE('Detail Title: ' || r.detail_title);
    END LOOP;
END GetLuxuryAccommodation;

/
--------------------------------------------------------
--  DDL for Procedure GETPANBYTYPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETPANBYTYPE" (
    p_pan_type IN ACCOMMODATION_INFO.ACCOM_TITLE%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            AI.accom_title,
            AI.detail_title
        FROM 
            ACCOMMODATION A
        JOIN 
            ACCOMMODATION_INFO AI ON A.SEQ = AI.SEQ
        WHERE 
            AI.detail_title = '풀빌라'  --펜션/풀빌라/럭셔리
            AND A.accom_id LIKE 'P%'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Camping Type: ' || r.accom_title);
        DBMS_OUTPUT.PUT_LINE('Detail Title: ' || r.detail_title);
    END LOOP;
END GetpanByType;

/
--------------------------------------------------------
--  DDL for Procedure GETPENSIONBYCAPACITY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETPENSIONBYCAPACITY" (
    p_desired_capacity IN ROOM.CAPACITY%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            R.room_name,
            R.price,
            R.capacity,
            R.type
        FROM 
            ACCOMMODATION A
        JOIN 
           ROOM R ON A.SEQ = R.SEQ AND A.accom_id = R.accom_id
        WHERE 
           R.capacity >= p_desired_capacity -- AND ... (여기에 펜션을 구분할 수 있는 조건 추가)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Room Name: ' || r.room_name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || r.price);
        DBMS_OUTPUT.PUT_LINE('Capacity: ' || r.capacity);
        DBMS_OUTPUT.PUT_LINE('Type: ' || r.type);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    END LOOP;
END GetPensionByCapacity;

/
--------------------------------------------------------
--  DDL for Procedure GETPUBLICFACILITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETPUBLICFACILITIES" (
    p_fitness IN NUMBER ,
    p_swimming_pool IN NUMBER,
    p_sauna IN NUMBER,
    p_golf_course IN NUMBER,
    p_restaurant IN NUMBER,
    p_elevator IN NUMBER,
    p_lounge IN NUMBER,
    p_public_pc IN NUMBER,
    p_BBQ IN NUMBER,
    p_cafe IN NUMBER,
    p_public_spa         IN NUMBER ,
        p_foot_volleyball         IN        NUMBER , 
        p_seminar_room         IN        NUMBER , 
        p_convenience         IN        NUMBER , 
        p_karaoke         IN        NUMBER , 
        p_kitchen         IN        NUMBER , 
        p_laundry         IN        NUMBER , 
        p_dryer                   IN        NUMBER ,
        p_dehydrator  IN        NUMBER ,
    p_parking   IN        NUMBER ,
    p_cooking   IN        NUMBER ,
    p_public_shower IN        NUMBER ,
    p_hot_spring    IN        NUMBER ,
    p_ski_resort    IN        NUMBER ,
    p_microwave IN        NUMBER ,
    p_electrical    IN        NUMBER ,
    p_sink  IN        NUMBER ,
    p_store IN        NUMBER 
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address
        FROM 
            ACCOMMODATION A
        JOIN 
            PUBLIC_FACILITIES PF ON A.SEQ = pf.ACCOM_ID
        WHERE  
                        PF.FITNESS = P_FITNESS AND    
                        PF.SWIMMING_POOL = P_SWIMMING_POOL AND    
                        PF.SAUNA = P_SAUNA AND   
                        PF.GOLF_COURSE = P_GOLF_COURSE AND    
                        PF.RESTAURANT = P_RESTAURANT AND   
                        PF.ELEVATOR = P_ELEVATOR AND    
                        PF.LOUNGE = P_LOUNGE AND   
                        PF.PUBLIC_PC= P_PUBLIC_PC AND    
                         PF.BBQ= P_BBQ        AND  
                         PF.CAFE= P_CAFE        AND  
                         Pf.PUBLIC_SPA=P_PUBLIC_SPA        AND  
Pf.FOOT_VOLLEYBALL=P_FOOT_VOLLEYBALL        AND  
Pf.SEMINAR_ROOM=P_SEMINAR_ROOM        AND  
Pf.CONVENIENCE=P_CONVENIENCE        AND  
Pf.KARAOKE=P_KARAOKE        AND  
Pf.KITCHEN=P_KITCHEN        AND  
Pf.LAUNDRY=P_LAUNDRY        AND  
Pf.DRYER = P_DRYER AND
PF.DEHYDRATOR= P_DEHYDRATOR AND
PF.parking = P_parking AND
PF.cooking = P_cooking AND
PF.public_shower = P_public_shower AND
PF.hot_spring = P_hot_spring AND
PF.ski_resort = P_ski_resort AND
PF.microwave = P_microwave AND
PF.electrical = P_electrical AND
PF.sink = P_sink AND
PF.store = P_store
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);

    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GETREVIEWLIST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETREVIEWLIST" (
    p_accom_id IN accommodation.accom_id%TYPE
)
AS
    CURSOR c_reviews IS
        SELECT 
            R.room_name AS 방이름,
            RE.user_id,
            RE.created_at AS 작성일자,
            SUBSTR(RE.content, 1, 10) AS 리뷰내용10자리뽑 ,
            RE.rating AS 평점,
            RE.content 리뷰내용,
            RE.FILE_URL 이미지
        FROM 
          ROOM R JOIN REVIEW RE ON R.room_id = RE.room_id 
        WHERE R.accom_id = p_accom_id;
BEGIN
    FOR r_review IN c_reviews LOOP
        DBMS_OUTPUT.PUT_LINE('방이름: ' || r_review.방이름);
        DBMS_OUTPUT.PUT_LINE('사용자 ID: ' || r_review.user_id);
        DBMS_OUTPUT.PUT_LINE('작성일자: ' || TO_CHAR(r_review.작성일자,'YYYY-MM-DD HH24:MI'));
        DBMS_OUTPUT.PUT_LINE('리뷰내용(첫 10자): ' || r_review.리뷰내용10자리뽑);
        DBMS_OUTPUT.PUT_LINE('평점: ' || TO_CHAR(r_review.평점));
        DBMS_OUTPUT.PUT_LINE('리뷰 내용: ' || r_review.리뷰내용);
        DBMS_OUTPUT.PUT_LINE('이미지 URL: ' || r_review.이미지);
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GETROOMDETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETROOMDETAILS" (
    p_accom_id IN accommodation.accom_id%TYPE
)
AS
    CURSOR c_rooms IS
        SELECT 
            ROOM_NAME AS 객실명, 
            CASE ACCOM_RESERVATION WHEN 0 THEN '불가능' ELSE '가능' END AS 대실가능여부,
            CASE rental_room WHEN 0 THEN '불가능' ELSE '가능' END AS 모텔숙박여부,
            CASE reservation WHEN 0 THEN '불가능' ELSE '가능' END AS 숙박가능여부,
            check_in_time AS 체크인, 
            check_out_time AS 체크아웃, 
            PRICE AS 가격
        FROM ROOM, motel_reservation_options, reservation_option, ACCOMMODATION
        WHERE  ACCOMMODATION.accom_id = p_accom_id;
BEGIN
    FOR r_room IN c_rooms LOOP
        DBMS_OUTPUT.PUT_LINE('객실명: ' || r_room.객실명);
        DBMS_OUTPUT.PUT_LINE('대실 가능 여부: ' || r_room.대실가능여부);
        DBMS_OUTPUT.PUT_LINE('모텔 숙박 가능 여부: ' || r_room.모텔숙박여부);
        DBMS_OUTPUT.PUT_LINE('숙박 가능 여부: ' || r_room.숙박가능여부);
        DBMS_OUTPUT.PUT_LINE('체크인 시간: ' || TO_CHAR(r_room.체크인));
        DBMS_OUTPUT.PUT_LINE('체크아웃 시간: ' || TO_CHAR(r_room.체크아웃));
        DBMS_OUTPUT.PUT_LINE('객실 가격: $' || TO_CHAR(r_room.가격));
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GETROOMFACILITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GETROOMFACILITIES" (
    p_room_spa IN NUMBER ,
    p_mini_bar IN NUMBER,
    p_wi_fi IN NUMBER,
    p_toiletries IN NUMBER,
    p_tv IN NUMBER,
    p_ac IN NUMBER,
    p_refrigerater IN NUMBER,
    p_shower_room IN NUMBER,
    p_bathtub IN NUMBER,
    p_hair_dryer IN NUMBER,
    p_iron IN NUMBER,
    p_rice_cooker IN NUMBER,
    p_power_socket IN NUMBER
) AS
BEGIN
    FOR r IN (
        SELECT DISTINCT 
            A.accom_id,
            A.accom_name,
            A.address
        FROM 
            ACCOMMODATION A
        JOIN 
            ROOM_FACILITIES RF ON A.SEQ = RF.SEQ
        WHERE 
            RF.ROOM_SPA = p_room_spa
        AND RF.MINI_BAR = p_mini_bar
        AND RF.WI_FI = p_wi_fi
        AND RF.TOILETRIES = p_toiletries
        AND RF.TV = p_tv
        AND RF.AC = p_ac
        AND RF.REFRIGERATER = p_refrigerater
        AND RF.SHOWER_ROOM = p_shower_room
        AND RF.BATHTUB = p_bathtub
        AND RF.HAIR_DRYER = p_hair_dryer
        AND RF.IRON = p_iron
        AND RF.RICE_COOKER = p_rice_cooker
        AND RF.POWER_SOCKET = p_power_socket
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);

    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure GYPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."GYPE" (
    p_camping_type IN ACCOMMODATION_INFO.ACCOM_TITLE%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            AI.accom_title,
            AI.detail_title
        FROM 
            ACCOMMODATION A
        JOIN 
            ACCOMMODATION_INFO AI ON A.SEQ = AI.SEQ
        WHERE 
            AI.accom_title = '펜션/풀빌라/럭셔리'
            AND A.accom_id LIKE 'P%'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Camping Type: ' || r.accom_title);
        DBMS_OUTPUT.PUT_LINE('Detail Title: ' || r.detail_title);
    END LOOP;
END Gype;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_INQUIRY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."INSERT_INQUIRY" (
    p_user_id IN VARCHAR2,
    p_category_type IN VARCHAR2,
    p_inquiry_type IN VARCHAR2,
    p_phone_number IN VARCHAR2,
    p_email IN VARCHAR2,
    p_inquiry_content IN VARCHAR2
) AS
BEGIN
   INSERT INTO inquiry (
      inquiry_id, 
      user_id, 
      inquiry_date, 
      category_type, 
      inquiry_type, 
      phone_number,
      email,
      inquiry_content
   ) VALUES (
     inquiry_ID_SEQ.nextval, -- 문의 ID   
     p_user_id, -- 회원 ID
     SYSDATE, -- 문의 일시 (현재 시간)
     p_category_type, -- 카테고리 유형
     p_inquiry_type, -- 문의 유형
     p_phone_number, -- 휴대폰 번호 (문자열로 처리)
     p_email ,-- 이메일 주소  
     p_inquiry_content  --문의 내용 
   );
END;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_MEMBER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."INSERT_MEMBER" (
    p_user_id IN VARCHAR2,
    p_user_pw IN VARCHAR2,
    p_user_nickname IN VARCHAR2,
    p_phone_number IN VARCHAR2
) AS
BEGIN
    INSERT INTO member (
        user_id,
        user_pw,
        user_nickname,
        phone_number,
        user_name,
        user_grade,
        user_points,
        user_coupons
    ) VALUES (
        p_user_id, -- 사용자 ID
        p_user_pw, -- 사용자 PW
         NVL(p_user_nickname, 'Guest'||TO_CHAR(SYSDATE,'HH24MISS')), -- 닉네임. NULL이면 Guest와 현재 시간을 붙인 문자열(랜덤 느낌?)
         p_phone_number, -- 전화번호
         NULL , -- 예약자 이름 NULL
         NULL, -- 등급. NULL
         NULL, -- 보유 포인트 NULL
         NULL  -- 보유 쿠폰 수 NULL
    );
END;

/
--------------------------------------------------------
--  DDL for Procedure PARTICIPATE_IN_EVENT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."PARTICIPATE_IN_EVENT" (
  p_user_id IN VARCHAR2,
  p_event_id IN NUMBER,
  p_winner_status IN VARCHAR2)
IS
  v_coupon_type_id NUMBER;
  v_event_point NUMBER;
BEGIN
  -- 이벤트 참여 기록
  INSERT INTO event_history (event_id, user_id, winner_status, participation_date)
    VALUES (p_event_id, p_user_id, p_winner_status, SYSDATE);

  IF p_winner_status = 'Y' THEN -- 당첨된 경우
    SELECT coupon_type_id, event_point 
      INTO v_coupon_type_id, v_event_point 
      FROM event WHERE event_id = p_event_id;

    IF v_coupon_type_id IS NOT NULL THEN -- 쿠폰이 있는 경우
      UPDATE member SET user_coupons = user_coupons + 1 WHERE user_id = p_user_id;
    END IF;

    IF v_event_point IS NOT NULL THEN -- 포인트가 있는 경우
      UPDATE member SET user_points = user_points + v_event_point WHERE user_id = p_user_id;
    END IF;

  END IF;

END;

/
--------------------------------------------------------
--  DDL for Procedure PENSIONS_A
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."PENSIONS_A" (
    p_detail_title IN ACCOMMODATION_INFO.DETAIL_TITLE%TYPE
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            AI.accom_title,
            AI.detail_title
        FROM 
            ACCOMMODATION A
        JOIN 
           ACCOMMODATION_INFO AI ON A.SEQ = AI.SEQ
        WHERE 
           AI.accom_title = '펜션/풀빌라/럭셔리'
           AND A.accom_id LIKE 'P%'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Accommodation Type: ' || r.accom_title);
        DBMS_OUTPUT.PUT_LINE('Detail Title: ' || r.detail_title);
    END LOOP;
END Pensions_a;

/
--------------------------------------------------------
--  DDL for Procedure PRINT_ACCOMMODATION_INFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."PRINT_ACCOMMODATION_INFO" (rec IN accommodation%ROWTYPE)
IS
  min_price NUMBER;
BEGIN
  SELECT MIN(price) INTO min_price FROM room WHERE seq = rec.seq;

  DBMS_OUTPUT.PUT_LINE(rec.accom_name || ' ' || TO_CHAR(rec.accom_rating,'90.9') ||
                       CASE WHEN rec.accom_rating BETWEEN 9.5 AND 10.0 THEN ' 최고에요'
                       WHEN rec.accom_rating BETWEEN 9.0 AND 9.5 THEN ' 추천해요'
                       WHEN rec.accom_rating BETWEEN 8.0 AND 9.0 THEN ' 만족해요'
                       ELSE ' 좋아요' END ||
                       '(' ||rec.accom_review_count|| ') ' ||
                       REGEXP_REPLACE(rec.address,'([0-9]|-[0-9])') ||
                       min_price ||'원');
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_ACCOMMODATION_BED_TYPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_ACCOMMODATION_BED_TYPE" (
      p_accom_id IN accommodation.accom_id%TYPE DEFAULT NULL
    , p_reservation IN reservation_option.reservation%TYPE DEFAULT NULL
    , p_promotion IN reservation_option.promotion%TYPE DEFAULT NULL
    , p_price IN ROOM.price%TYPE DEFAULT NULL
    , p_capacity IN ROOM.capacity%TYPE DEFAULT NULL
    , p_SINGLE IN bed_type.SINGLE%TYPE DEFAULT NULL
    , p_double IN bed_type.double%TYPE DEFAULT NULL
    , p_twin IN bed_type.twin%TYPE DEFAULT NULL
    , p_Ondol IN bed_type.Ondol%TYPE DEFAULT NULL
    , p_laundry IN public_facilities.laundry%TYPE DEFAULT NULL
    , p_lounge IN public_facilities.lounge%TYPE DEFAULT NULL
    , p_kitchen IN public_facilities.kitchen%TYPE DEFAULT NULL
    , p_dryer IN public_facilities.dryer%TYPE DEFAULT NULL
    , p_dehydrator IN public_facilities.dehydrator%TYPE DEFAULT NULL
    , p_elevator IN public_facilities.elevator%TYPE DEFAULT NULL
    , p_parking IN public_facilities.parking%TYPE DEFAULT NULL
    , p_public_pc IN public_facilities.public_pc%TYPE DEFAULT NULL
    , p_BBQ IN public_facilities.BBQ%TYPE DEFAULT NULL
    , p_cafe IN public_facilities.cafe%TYPE DEFAULT NULL
    , p_microwave IN public_facilities.microwave%TYPE DEFAULT NULL
    , p_cooking IN public_facilities.cooking%TYPE DEFAULT NULL
    , p_wi_fi IN room_facilities.wi_fi%TYPE DEFAULT NULL
    , p_power_socket IN room_facilities.power_socket%TYPE DEFAULT NULL
    , p_toiletries IN room_facilities.toiletries%TYPE DEFAULT NULL
    , p_AC IN room_facilities.AC%TYPE DEFAULT NULL
    , p_refrigerater IN room_facilities.refrigerater%TYPE DEFAULT NULL
    , p_shower_room IN room_facilities.shower_room%TYPE DEFAULT NULL
    , p_bathtub IN room_facilities.bathtub%TYPE DEFAULT NULL
    , p_hair_dryer IN room_facilities.hair_dryer%TYPE DEFAULT NULL
    , p_iron IN room_facilities.iron%TYPE DEFAULT NULL
    , p_tv IN room_facilities.tv%TYPE DEFAULT NULL
    , p_breakfast IN etc.breakfast%TYPE DEFAULT NULL
    , p_personal_locker IN etc.personal_locker%TYPE DEFAULT NULL
    , p_smoking IN etc.smoking%TYPE DEFAULT NULL
    , p_with_pet IN etc.with_pet%TYPE DEFAULT NULL
    , p_storage IN etc.storage%TYPE DEFAULT NULL
    , p_printer IN etc.printer%TYPE DEFAULT NULL
    , p_free_parking IN etc.free_parking%TYPE DEFAULT NULL
    , p_credit_card IN etc.credit_card%TYPE DEFAULT NULL
    
)
IS
    -- 조회를 위한 커서 정의

    vcursor SYS_REFCURSOR;

   v_sql VARCHAR2(2000);
   v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
   v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
   v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
   v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;
   v_ACCOM_REVIEW_COUNT ACCOMMODATION.ACCOM_REVIEW_COUNT%TYPE;
   v_CHECK_IN_TIME ACCOMMODATION.CHECK_IN_TIME%TYPE;
   v_CHECK_OUT_TIME ACCOMMODATION.CHECK_OUT_TIME%TYPE;
   v_AD_GRADE ACCOMMODATION.AD_GRADE%TYPE;

BEGIN
   v_sql := v_sql || 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING, A.ACCOM_REVIEW_COUNT, A.CHECK_IN_TIME, A.CHECK_OUT_TIME, A.AD_GRADE ';
   v_sql := v_sql || 'FROM ACCOMMODATION A JOIN BED_TYPE E ON A.ACCOM_ID = E.ACCOM_ID AND A.SEQ = E.SEQ 
                                           JOIN PUBLIC_FACILITIES PF ON A.ACCOM_ID = PF.ACCOM_ID AND A.SEQ = PF.SEQ
                                           JOIN ROOM_FACILITIES RF ON A.ACCOM_ID = RF.ACCOM_ID AND A.SEQ = RF.SEQ
                                           JOIN ETC E ON A.ACCOM_ID = E.ACCOM_ID AND A.SEQ = E.SEQ ';
   v_sql := v_sql || 'WHERE A.ACCOM_ID = ''G'' ';

   IF p_reservation IS NOT NULL THEN
      v_sql := v_sql || ' AND E.reservation = ' || p_reservation;
   END IF;
   IF p_promotion IS NOT NULL THEN
      v_sql := v_sql || ' AND E.promotion = ' || p_promotion;
   END IF;
   IF p_price IS NOT NULL THEN
      v_sql := v_sql || ' AND E.price = ' || p_price;    --------------------비트윈값 이케어케 해야함.
   END IF;
   IF p_capacity IS NOT NULL THEN
      v_sql := v_sql || ' AND E.capacity = ' || p_capacity;
   END IF;
   IF p_capacity IS NOT NULL THEN
      v_sql := v_sql || ' AND E.capacity = ' || p_capacity;
   END IF;
   IF p_capacity IS NOT NULL THEN
      v_sql := v_sql || ' AND E.capacity = ' || p_capacity;
   END IF;
   IF p_single IS NOT NULL THEN
      v_sql := v_sql || ' AND E.single = ' || p_single;
   END IF;
   IF p_double IS NOT NULL THEN
      v_sql := v_sql || ' AND E.double = ' || p_double;
   END IF;
   IF p_twin IS NOT NULL THEN
      v_sql := v_sql || ' AND E.twin = ' ||p_twin;
   END IF;
   IF p_Ondol IS NOT NULL THEN
      v_sql := v_sql || ' AND E.Ondol = ' ||p_Ondol;
   END IF;  
   IF p_laundry IS NOT NULL THEN
      v_sql := v_sql || ' AND E.laundry = ' ||p_laundry;
   END IF;  
   IF p_lounge IS NOT NULL THEN
      v_sql := v_sql || ' AND E.lounge = ' ||p_lounge;
   END IF;  
   IF p_kitchen IS NOT NULL THEN
      v_sql := v_sql || ' AND E.kitchen = ' ||p_kitchen;
   END IF;  
   IF p_dryer IS NOT NULL THEN
      v_sql := v_sql || ' AND E.dryer = ' ||p_dryer;
   END IF;  
   IF p_dehydrator IS NOT NULL THEN
      v_sql := v_sql || ' AND E.dehydrator = ' ||p_dehydrator;
   END IF;  
   IF p_elevator IS NOT NULL THEN
      v_sql := v_sql || ' AND E.elevator = ' ||p_elevator;
   END IF;  
   IF p_parking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.parking = ' ||p_parking;
   END IF;  
   IF p_public_pc IS NOT NULL THEN
      v_sql := v_sql || ' AND E.public_pc = ' ||p_public_pc;
   END IF;  
   IF p_BBQ IS NOT NULL THEN
      v_sql := v_sql || ' AND E.BBQ = ' ||p_BBQ;
   END IF;  
   IF p_cafe IS NOT NULL THEN
      v_sql := v_sql || ' AND E.cafe = ' ||p_cafe;
   END IF;  
   IF p_microwave IS NOT NULL THEN
      v_sql := v_sql || ' AND E.microwave = ' ||p_microwave;
   END IF;  
   IF p_cooking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.cooking = ' ||p_cooking;
   END IF;  
   IF p_wi_fi IS NOT NULL THEN
      v_sql := v_sql || ' AND E.wi_fi = ' ||p_wi_fi;
   END IF;  
   IF p_power_socket IS NOT NULL THEN
      v_sql := v_sql || ' AND E.power_socket = ' ||p_power_socket;
   END IF;  
   IF p_toiletries IS NOT NULL THEN
      v_sql := v_sql || ' AND E.toiletries = ' ||p_toiletries;
   END IF;  
   IF p_AC IS NOT NULL THEN
      v_sql := v_sql || ' AND E.AC = ' ||p_AC;
   END IF;  
   IF p_refrigerater IS NOT NULL THEN
      v_sql := v_sql || ' AND E.refrigerater = ' ||p_refrigerater;
   END IF;  
   IF p_shower_room IS NOT NULL THEN
      v_sql := v_sql || ' AND E.shower_room = ' ||p_shower_room;
   END IF; 
   IF p_bathtub IS NOT NULL THEN
      v_sql := v_sql || ' AND E.bathtub = ' ||p_bathtub;
   END IF; 
   IF p_hair_dryer IS NOT NULL THEN
      v_sql := v_sql || ' AND E.hair_dryer = ' ||p_hair_dryer;
   END IF; 
   IF p_iron IS NOT NULL THEN
      v_sql := v_sql || ' AND E.iron = ' ||p_iron;
   END IF; 
   IF p_tv IS NOT NULL THEN
      v_sql := v_sql || ' AND E.tv = ' ||p_tv;
   END IF; 
   IF p_breakfast IS NOT NULL THEN
      v_sql := v_sql || ' AND E.breakfast = ' ||p_breakfast;
   END IF; 
   IF p_personal_locker IS NOT NULL THEN
      v_sql := v_sql || ' AND E.personal_locker = ' ||p_personal_locker;
   END IF; 
   IF p_smoking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.smoking = ' ||p_smoking;
   END IF; 
   IF p_with_pet IS NOT NULL THEN
      v_sql := v_sql || ' AND E.with_pet = ' ||p_with_pet;
   END IF; 
   IF p_storage IS NOT NULL THEN
      v_sql := v_sql || ' AND E.storage = ' ||p_storage;
   END IF; 
   IF p_printer IS NOT NULL THEN
      v_sql := v_sql || ' AND E.printer = ' ||p_printer;
   END IF; 
   IF p_free_parking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.free_parking = ' ||p_free_parking;
   END IF; 
   IF p_credit_card IS NOT NULL THEN
      v_sql := v_sql || ' AND E.credit_card = ' ||p_credit_card;
   END IF; 
    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor 
         INTO v_ACCOM_ID, v_ACCOM_NAME,v_ADDRESS,
            v_ACCOM_RATING,v_ACCOM_REVIEW_COUNT,
            v_CHECK_IN_TIME, v_CHECK_OUT_TIME, v_AD_GRADE;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ACCOM_NAME || ', ' || v_ADDRESS);
    END LOOP;
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_ACCOMMODATION_G_TOTAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_ACCOMMODATION_G_TOTAL" ( --  게스트하우스 숙소 전체 조회 
      p_accom_id IN accommodation.accom_id%TYPE DEFAULT NULL
    , p_reservation IN reservation_option.reservation%TYPE DEFAULT NULL
    , p_promotion IN reservation_option.promotion%TYPE DEFAULT NULL
    , p_price IN ROOM.price%TYPE DEFAULT NULL
    , p_capacity IN ROOM.capacity%TYPE DEFAULT NULL
    , p_SINGLE IN bed_type.SINGLE%TYPE DEFAULT NULL
    , p_double IN bed_type.double%TYPE DEFAULT NULL
    , p_twin IN bed_type.twin%TYPE DEFAULT NULL
    , p_Ondol IN bed_type.Ondol%TYPE DEFAULT NULL
    , p_laundry IN public_facilities.laundry%TYPE DEFAULT NULL
    , p_lounge IN public_facilities.lounge%TYPE DEFAULT NULL
    , p_kitchen IN public_facilities.kitchen%TYPE DEFAULT NULL
    , p_dryer IN public_facilities.dryer%TYPE DEFAULT NULL
    , p_dehydrator IN public_facilities.dehydrator%TYPE DEFAULT NULL
    , p_elevator IN public_facilities.elevator%TYPE DEFAULT NULL
    , p_parking IN public_facilities.parking%TYPE DEFAULT NULL
    , p_public_pc IN public_facilities.public_pc%TYPE DEFAULT NULL
    , p_BBQ IN public_facilities.BBQ%TYPE DEFAULT NULL
    , p_cafe IN public_facilities.cafe%TYPE DEFAULT NULL
    , p_microwave IN public_facilities.microwave%TYPE DEFAULT NULL
    , p_cooking IN public_facilities.cooking%TYPE DEFAULT NULL
    , p_wi_fi IN room_facilities.wi_fi%TYPE DEFAULT NULL
    , p_power_socket IN room_facilities.power_socket%TYPE DEFAULT NULL
    , p_toiletries IN room_facilities.toiletries%TYPE DEFAULT NULL
    , p_AC IN room_facilities.AC%TYPE DEFAULT NULL
    , p_refrigerater IN room_facilities.refrigerater%TYPE DEFAULT NULL
    , p_shower_room IN room_facilities.shower_room%TYPE DEFAULT NULL
    , p_bathtub IN room_facilities.bathtub%TYPE DEFAULT NULL
    , p_hair_dryer IN room_facilities.hair_dryer%TYPE DEFAULT NULL
    , p_iron IN room_facilities.iron%TYPE DEFAULT NULL
    , p_tv IN room_facilities.tv%TYPE DEFAULT NULL
    , p_breakfast IN etc.breakfast%TYPE DEFAULT NULL
    , p_personal_locker IN etc.personal_locker%TYPE DEFAULT NULL
    , p_smoking IN etc.smoking%TYPE DEFAULT NULL
    , p_with_pet IN etc.with_pet%TYPE DEFAULT NULL
    , p_storage IN etc.storage%TYPE DEFAULT NULL
    , p_printer IN etc.printer%TYPE DEFAULT NULL
    , p_free_parking IN etc.free_parking%TYPE DEFAULT NULL
    , p_credit_card IN etc.credit_card%TYPE DEFAULT NULL
    
)
IS
    -- 조회를 위한 커서 정의

    vcursor SYS_REFCURSOR;

   v_sql VARCHAR2(2000);
   v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
   v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
   v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
   v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;
   v_ACCOM_REVIEW_COUNT ACCOMMODATION.ACCOM_REVIEW_COUNT%TYPE;
   v_CHECK_IN_TIME ACCOMMODATION.CHECK_IN_TIME%TYPE;
   v_CHECK_OUT_TIME ACCOMMODATION.CHECK_OUT_TIME%TYPE;
   v_AD_GRADE ACCOMMODATION.AD_GRADE%TYPE;

BEGIN
   v_sql := v_sql || 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING, A.ACCOM_REVIEW_COUNT, A.CHECK_IN_TIME, A.CHECK_OUT_TIME, A.AD_GRADE ';
   v_sql := v_sql || 'FROM ACCOMMODATION A JOIN BED_TYPE E ON A.ACCOM_ID = E.ACCOM_ID AND A.SEQ = E.SEQ 
                                           JOIN PUBLIC_FACILITIES PF ON A.ACCOM_ID = PF.ACCOM_ID AND A.SEQ = PF.SEQ
                                           JOIN ROOM_FACILITIES RF ON A.ACCOM_ID = RF.ACCOM_ID AND A.SEQ = RF.SEQ
                                           JOIN ETC E ON A.ACCOM_ID = E.ACCOM_ID AND A.SEQ = E.SEQ ';
   v_sql := v_sql || 'WHERE A.ACCOM_ID = ''G'' ';

   IF p_reservation IS NOT NULL THEN
      v_sql := v_sql || ' AND E.reservation = ' || p_reservation;
   END IF;
   IF p_promotion IS NOT NULL THEN
      v_sql := v_sql || ' AND E.promotion = ' || p_promotion;
   END IF;
   IF p_price IS NOT NULL THEN
      v_sql := v_sql || ' AND E.price = ' || p_price;    --------------------비트윈값 이케어케 해야함.
   END IF;
   IF p_capacity IS NOT NULL THEN
      v_sql := v_sql || ' AND E.capacity = ' || p_capacity;
   END IF;
   IF p_capacity IS NOT NULL THEN
      v_sql := v_sql || ' AND E.capacity = ' || p_capacity;
   END IF;
   IF p_capacity IS NOT NULL THEN
      v_sql := v_sql || ' AND E.capacity = ' || p_capacity;
   END IF;
   IF p_single IS NOT NULL THEN
      v_sql := v_sql || ' AND E.single = ' || p_single;
   END IF;
   IF p_double IS NOT NULL THEN
      v_sql := v_sql || ' AND E.double = ' || p_double;
   END IF;
   IF p_twin IS NOT NULL THEN
      v_sql := v_sql || ' AND E.twin = ' ||p_twin;
   END IF;
   IF p_Ondol IS NOT NULL THEN
      v_sql := v_sql || ' AND E.Ondol = ' ||p_Ondol;
   END IF;  
   IF p_laundry IS NOT NULL THEN
      v_sql := v_sql || ' AND E.laundry = ' ||p_laundry;
   END IF;  
   IF p_lounge IS NOT NULL THEN
      v_sql := v_sql || ' AND E.lounge = ' ||p_lounge;
   END IF;  
   IF p_kitchen IS NOT NULL THEN
      v_sql := v_sql || ' AND E.kitchen = ' ||p_kitchen;
   END IF;  
   IF p_dryer IS NOT NULL THEN
      v_sql := v_sql || ' AND E.dryer = ' ||p_dryer;
   END IF;  
   IF p_dehydrator IS NOT NULL THEN
      v_sql := v_sql || ' AND E.dehydrator = ' ||p_dehydrator;
   END IF;  
   IF p_elevator IS NOT NULL THEN
      v_sql := v_sql || ' AND E.elevator = ' ||p_elevator;
   END IF;  
   IF p_parking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.parking = ' ||p_parking;
   END IF;  
   IF p_public_pc IS NOT NULL THEN
      v_sql := v_sql || ' AND E.public_pc = ' ||p_public_pc;
   END IF;  
   IF p_BBQ IS NOT NULL THEN
      v_sql := v_sql || ' AND E.BBQ = ' ||p_BBQ;
   END IF;  
   IF p_cafe IS NOT NULL THEN
      v_sql := v_sql || ' AND E.cafe = ' ||p_cafe;
   END IF;  
   IF p_microwave IS NOT NULL THEN
      v_sql := v_sql || ' AND E.microwave = ' ||p_microwave;
   END IF;  
   IF p_cooking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.cooking = ' ||p_cooking;
   END IF;  
   IF p_wi_fi IS NOT NULL THEN
      v_sql := v_sql || ' AND E.wi_fi = ' ||p_wi_fi;
   END IF;  
   IF p_power_socket IS NOT NULL THEN
      v_sql := v_sql || ' AND E.power_socket = ' ||p_power_socket;
   END IF;  
   IF p_toiletries IS NOT NULL THEN
      v_sql := v_sql || ' AND E.toiletries = ' ||p_toiletries;
   END IF;  
   IF p_AC IS NOT NULL THEN
      v_sql := v_sql || ' AND E.AC = ' ||p_AC;
   END IF;  
   IF p_refrigerater IS NOT NULL THEN
      v_sql := v_sql || ' AND E.refrigerater = ' ||p_refrigerater;
   END IF;  
   IF p_shower_room IS NOT NULL THEN
      v_sql := v_sql || ' AND E.shower_room = ' ||p_shower_room;
   END IF; 
   IF p_bathtub IS NOT NULL THEN
      v_sql := v_sql || ' AND E.bathtub = ' ||p_bathtub;
   END IF; 
   IF p_hair_dryer IS NOT NULL THEN
      v_sql := v_sql || ' AND E.hair_dryer = ' ||p_hair_dryer;
   END IF; 
   IF p_iron IS NOT NULL THEN
      v_sql := v_sql || ' AND E.iron = ' ||p_iron;
   END IF; 
   IF p_tv IS NOT NULL THEN
      v_sql := v_sql || ' AND E.tv = ' ||p_tv;
   END IF; 
   IF p_breakfast IS NOT NULL THEN
      v_sql := v_sql || ' AND E.breakfast = ' ||p_breakfast;
   END IF; 
   IF p_personal_locker IS NOT NULL THEN
      v_sql := v_sql || ' AND E.personal_locker = ' ||p_personal_locker;
   END IF; 
   IF p_smoking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.smoking = ' ||p_smoking;
   END IF; 
   IF p_with_pet IS NOT NULL THEN
      v_sql := v_sql || ' AND E.with_pet = ' ||p_with_pet;
   END IF; 
   IF p_storage IS NOT NULL THEN
      v_sql := v_sql || ' AND E.storage = ' ||p_storage;
   END IF; 
   IF p_printer IS NOT NULL THEN
      v_sql := v_sql || ' AND E.printer = ' ||p_printer;
   END IF; 
   IF p_free_parking IS NOT NULL THEN
      v_sql := v_sql || ' AND E.free_parking = ' ||p_free_parking;
   END IF; 
   IF p_credit_card IS NOT NULL THEN
      v_sql := v_sql || ' AND E.credit_card = ' ||p_credit_card;
   END IF; 
    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor 
         INTO v_ACCOM_ID, v_ACCOM_NAME,v_ADDRESS,
            v_ACCOM_RATING,v_ACCOM_REVIEW_COUNT,
            v_CHECK_IN_TIME, v_CHECK_OUT_TIME, v_AD_GRADE;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ACCOM_NAME || ', ' || v_ADDRESS);
    END LOOP;
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_ACCOMMODATION_RESERVATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_ACCOMMODATION_RESERVATION" 
(
    v_accom_id IN accommodation.accom_id%TYPE
    , v_reservation_date IN reservation.reservation_date%TYPE
    , v_accom_detail_id IN accommodation.accom_detail_id%TYPE
    , v_accom_name IN accommodation.accom_name%TYPE
    , v_address IN accommodation.address%TYPE
    , v_accom_rating IN accommodation.accom_rating%TYPE
)
AS
    TYPE printForm IS RECORD
    (
        accom_id accommodation.accom_id%TYPE,
        reservation_date accommodation.accom_detail_id%TYPE,
        accom_detail_id accommodation.accom_name%TYPE,
        accom_name accommodation.address%TYPE,
        address accommodation.accom_rating%TYPE,
        accom_rating reservation.reservation_date%TYPE
    );

    r_accommodation_reservation printForm;

    CURSOR c_accommodation_reservation IS
        SELECT DISTINCT a.accom_id,a.accom_detail_id, a.accom_name, a.address, a.accom_rating,
               b.reservation_date
        FROM accommodation a JOIN room r ON a.accom_id = r.accom_id AND a.seq = r.seq
                             JOIN reservation b ON r.room_id = b.room_id
        WHERE a.accom_id = v_accom_id 
            AND (v_reservation_date IS NULL OR b.reservation_date LIKE v_reservation_date || '%');



BEGIN
    FOR r_accommodation_reservation IN c_accommodation_reservation
        LOOP
        DBMS_OUTPUT.PUT_LINE('accom_id : ' || r_accommodation_reservation.accom_id); 
        DBMS_OUTPUT.PUT_LINE('reservation_date : ' || r_accommodation_reservation.reservation_date); 
        DBMS_OUTPUT.PUT_LINE('accom_detail_id : ' || r_accommodation_reservation.accom_detail_id);
        DBMS_OUTPUT.PUT_LINE('accom_name : ' || r_accommodation_reservation.accom_name);
        DBMS_OUTPUT.PUT_LINE('address : ' || r_accommodation_reservation.address); 
        DBMS_OUTPUT.PUT_LINE('accom_rating : ' || r_accommodation_reservation.accom_rating); 
        END LOOP;

END;

/
--------------------------------------------------------
--  DDL for Procedure UP_ACCOMMODATION_ROOM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_ACCOMMODATION_ROOM" 
(
    v_accom_id IN accommodation.accom_id%TYPE
    , v_capacity IN room.capacity%TYPE
    , v_accom_detail_id IN accommodation.accom_detail_id%TYPE
    , v_accom_name IN accommodation.accom_name%TYPE
    , v_address IN accommodation.address%TYPE
    , v_accom_rating IN accommodation.accom_rating%TYPE
)
AS
    CURSOR c_accommodation_room
    IS
        SELECT DISTINCT a.accom_id, a.accom_detail_id, a.accom_name, a.address, a.accom_rating,
               r.capacity
        FROM accommodation a JOIN room r ON a.accom_id = r.accom_id AND a.seq = r.seq
        WHERE a.accom_id = v_accom_id 
            AND (v_capacity IS NULL OR r.capacity LIKE v_capacity || '%');
BEGIN
    FOR r_accommodation_room IN c_accommodation_room
        LOOP
        DBMS_OUTPUT.PUT_LINE('accom_id : ' || r_accommodation_room.accom_id); 
        DBMS_OUTPUT.PUT_LINE('capacity : ' || r_accommodation_room.capacity); 
        DBMS_OUTPUT.PUT_LINE('accom_detail_id : ' || r_accommodation_room.accom_detail_id);
        DBMS_OUTPUT.PUT_LINE('accom_name : ' || r_accommodation_room.accom_name);
        DBMS_OUTPUT.PUT_LINE('address : ' || r_accommodation_room.address); 
        DBMS_OUTPUT.PUT_LINE('accom_rating : ' || r_accommodation_room.accom_rating);
        END LOOP;

END;

/
--------------------------------------------------------
--  DDL for Procedure UP_CAMPING_BY_ROOM_FACILITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_CAMPING_BY_ROOM_FACILITIES" (
    p_SHOWER_ROOM NUMBER DEFAULT NULL,
    p_HAIR_DRYER NUMBER DEFAULT NULL,
    p_WI_FI NUMBER DEFAULT NULL,
    p_TV NUMBER DEFAULT NULL,
    p_TOILETRIES NUMBER DEFAULT NULL,
    p_MINI_BAR NUMBER DEFAULT NULL,
    p_AC NUMBER DEFAULT NULL,
    p_REFRIGERATER NUMBER DEFAULT NULL,
    p_BATHTUB NUMBER DEFAULT NULL,
    p_IRON NUMBER DEFAULT NULL,
    p_RICE_COOKER NUMBER DEFAULT NULL,
    p_ROOM_SPA NUMBER DEFAULT NULL,
    p_POWER_SOCKET NUMBER DEFAULT NULL
) AS
    v_sql VARCHAR2(2000);
    vcursor SYS_REFCURSOR;
    v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
    v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
    v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
    v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;

BEGIN
    v_sql := 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING ';
    v_sql := v_sql || 'FROM ACCOMMODATION A JOIN ROOM_FACILITIES RF ON A.ACCOM_ID = RF.ACCOM_ID WHERE 1=1 ';

    IF p_SHOWER_ROOM IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.SHOWER_ROOM = ' || p_SHOWER_ROOM;
    END IF;
    IF p_HAIR_DRYER IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.HAIR_DRYER = ' || p_HAIR_DRYER;
    END IF;
    IF p_WI_FI IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.WI_FI = ' || p_WI_FI;
    END IF;
    IF p_TV IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.TV = ' || p_TV;
    END IF;
    IF p_TOILETRIES IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.TOILETRIES = ' || p_TOILETRIES;
    END IF;
    IF p_MINI_BAR IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.MINI_BAR = ' || p_MINI_BAR;
    END IF;
    IF p_AC IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.AC = ' || p_AC;
    END IF;
    IF p_REFRIGERATER IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.REFRIGERATER = ' || p_REFRIGERATER;
    END IF;
    IF p_BATHTUB IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.BATHTUB = ' || p_BATHTUB;
    END IF;
    IF p_IRON IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.IRON = ' || p_IRON;
    END IF;
    IF p_RICE_COOKER IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.RICE_COOKER = ' || p_RICE_COOKER;
    END IF;
    IF p_ROOM_SPA IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.ROOM_SPA = ' || p_ROOM_SPA;
    END IF;
    IF p_POWER_SOCKET IS NOT NULL THEN
        v_sql := v_sql || ' AND RF.POWER_SOCKET = ' || p_POWER_SOCKET;
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor INTO v_ACCOM_ID, v_ACCOM_NAME, v_ADDRESS, v_ACCOM_RATING;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ACCOM_ID: ' || v_ACCOM_ID);
        DBMS_OUTPUT.PUT_LINE('ACCOM_NAME: ' || v_ACCOM_NAME);
        DBMS_OUTPUT.PUT_LINE('ADDRESS: ' || v_ADDRESS);
        DBMS_OUTPUT.PUT_LINE('ACCOM_RATING: ' || v_ACCOM_RATING);
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_COUPON
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_COUPON" (
  p_coupon_type_id IN NUMBER,
  p_coupon_name IN NVARCHAR2,
  p_available_accom IN NVARCHAR2,
  p_available_days IN NUMBER,
  p_available_type IN NVARCHAR2,
  p_available_pay_type IN NVARCHAR2,
  p_discount_amount IN NUMBER,
  p_min_pay_amount IN NUMBER, 
  p_max_discount_amount IN NUMBER, 
  p_start_date DATE, 
  p_end_date DATE)
IS
BEGIN
INSERT INTO coupon (coupon_type_id, coupon_name, available_accom, available_days,
                    available_type, available_pay_type, discount_amount,
                    min_pay_amount, max_discount_amount,start_date,end_date)
VALUES (p_coupon_type_id,p_coupon_name,p_available_accom,p_available_days,p_available_type,p_available_pay_type,p_discount_amount ,
        p_min_pay_amount ,p_max_discount_amount ,p_start_date ,p_end_date);
COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_COUPON_CONDITION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_COUPON_CONDITION" -- 보유 쿠폰 상세 사용조건 조회
    (
        p_coupon_type_id coupon.coupon_type_id%TYPE
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_available_days coupon.available_days%TYPE;
    v_available_type coupon.available_type%TYPE;
    v_available_pay_type coupon.available_pay_type%TYPE;
    v_min_pay_amount coupon.min_pay_amount%TYPE;
BEGIN
    v_sql := 'SELECT available_days, available_type, available_pay_type, min_pay_amount ';
    v_sql := v_sql||' FROM coupon
                    WHERE coupon_type_id = :p_coupon_type_id';

    OPEN v_cur FOR v_sql USING p_coupon_type_id;
    LOOP
        FETCH v_cur INTO v_available_days, v_available_type, v_available_pay_type, v_min_pay_amount;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('사용조건 상세');
        IF v_available_days=12345 THEN
            DBMS_OUTPUT.PUT_LINE('일,월,화,수,목');
        END IF;
        IF v_available_type!='모두' THEN
        DBMS_OUTPUT.PUT_LINE(v_available_type||'전용');
        END IF;
        IF v_available_pay_type!='모든 결제 수단' THEN
            DBMS_OUTPUT.PUT_LINE(v_available_pay_type||'로 결제 시');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KB페이, 휴대폰 결제, PAYCO, 법인 카드, 신용/체크 카드, 간편
계좌 이체, 카카오페이, 토스, 네이버페이로 결제 시');
        END IF;
        IF v_min_pay_amount!= 0 THEN
            DBMS_OUTPUT.PUT_LINE('최소 결제 금액 : '||v_min_pay_amount||'원');
        END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_COUPON_COUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_COUPON_COUNT" -- 총 보유 쿠폰 갯수, 7일내 소멸 예정 쿠폰 갯수 조회
    (
        p_user_id member.user_id%TYPE
    )
IS
    v_coupon_cnt NUMBER(3);
    v_exp_cnt NUMBER(2);
BEGIN
    SELECT NVL(user_coupons, 0) INTO v_coupon_cnt
    FROM member
    WHERE user_id = p_user_id;
    DBMS_OUTPUT.PUT_LINE('보유쿠폰 '||v_coupon_cnt||'장');

    SELECT COUNT(cs.coupon_type_id) INTO v_exp_cnt
    FROM coupon_status cs JOIN coupon c ON cs.coupon_type_id = c.coupon_type_id
    WHERE cs.user_id = p_user_id AND cs.status = 0 AND c.end_date BETWEEN SYSDATE AND SYSDATE+7;
    DBMS_OUTPUT.PUT_LINE('7일 이내 소멸예정 쿠폰 '||v_exp_cnt||'장');
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_COUPON_LIST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_COUPON_LIST" -- 보유 쿠폰 리스트 조회
    (
        p_user_id member.user_id%TYPE
        , p_sort NUMBER := 1 -- 1혜택순 2.남은기간순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_discount_amount NVARCHAR2(30);
    v_max_discount_amount NVARCHAR2(30);
    v_expiry_date NVARCHAR2(50);
    v_remaining_period NVARCHAR2(30);
    v_coupon_name coupon.coupon_name%TYPE;
    v_available_accom NVARCHAR2(50);
    v_num_condition NUMBER(1);
BEGIN
    v_sql := 'SELECT CASE
                        WHEN discount_amount > 1 THEN discount_amount||''원''
                        ELSE discount_amount*100||''%''
                        END|| '' 할인'' "discount_amount"
                    , CASE max_discount_amount
                        WHEN 0 THEN ''''
                        ELSE ''최대 ''||max_discount_amount||''원 할인''
                        END "max_discount_amount"
                    , CASE TRUNC(end_date)
                        WHEN TRUNC(SYSDATE) THEN
                        TRUNC((end_date-SYSDATE)*24)||''시간 ''||TRUNC(((end_date-SYSDATE)*24
                        -TRUNC((end_date-SYSDATE)*24))*60)||''분''
                        ELSE TRUNC(end_date-SYSDATE)||''일''
                      END||'' 남음'' "remaining_period"
                    , TO_NUMBER(TO_CHAR(start_date, ''MM''))||''.''||TO_NUMBER(TO_CHAR(start_date, ''DD''))
                      ||TO_CHAR(start_date, '' (DY) HH24:MI'')
                      ||'' - ''||TO_NUMBER(TO_CHAR(end_date, ''MM''))||''.''||TO_NUMBER(TO_CHAR(end_date, ''DD''))
                      ||TO_CHAR(end_date, '' (DY) HH24:MI'') "expiry_date"
                    , coupon_name
                    , available_accom  "available_accom"
                    , 0 + DECODE(available_days, ''1234567'', 0, 1)
                        + DECODE(available_type, ''모두'', 0, 1)
                        + DECODE(available_pay_type, ''모든 결제 수단'', 0, 1)
                        + DECODE(min_pay_amount, 0, 0, 1) "num_condition" ';
    v_sql := v_sql||'FROM coupon c JOIN coupon_status cs ON c.coupon_type_id = cs.coupon_type_id ';
    v_sql := v_sql||'WHERE user_id = :p_user_id AND status = 0 ';

    IF p_sort = 1 THEN           -- 혜택순 : %면 최대 할인 가능 금액, 원이면 할인 금액 순으로 정렬
        v_sql := v_sql||'ORDER BY CASE
                                    WHEN discount_amount > 1 THEN discount_amount
                                    ELSE max_discount_amount
                                 END DESC';
    ELSIF p_sort = 2 THEN        -- 남은기간순
        v_sql := v_sql||'ORDER BY end_date';
    END IF;

    OPEN v_cur FOR v_sql USING p_user_id;
    LOOP
        FETCH v_cur INTO v_discount_amount, v_max_discount_amount, v_remaining_period, v_expiry_date, v_coupon_name, v_available_accom, v_num_condition;
        IF v_discount_amount IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('보유한 쿠폰이 없습니다.');
        END IF;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_discount_amount);
        DBMS_OUTPUT.PUT_LINE(v_max_discount_amount);
        DBMS_OUTPUT.PUT_LINE(v_remaining_period||'  '||v_expiry_date);
        DBMS_OUTPUT.PUT_LINE(v_coupon_name);
        IF v_available_accom='CGHMP' THEN
            DBMS_OUTPUT.PUT_LINE('모든 숙소 사용 가능');
        ELSE DBMS_OUTPUT.PUT_LINE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
             (v_available_accom,'C','캠핑 '),'G','글램핑 '),'H','호텔 '),'M','모텔 '),'P','펜션 ')||'사용 가능');
        END IF;
        IF v_num_condition != 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_num_condition||'개의 사용조건이 더 있습니다. 상세를 확인하세요.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('--------------');
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_DELSAFE_NUM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_DELSAFE_NUM" --안심번호 스케쥴
IS
v_create_at DATE;
v_user_id VARCHAR2(200);
 CURSOR safe_num IS
    SELECT user_id,create_at FROM safety_number WHERE CREATE_AT+7 <= to_char(sysdate,'YY/MM/DD');
BEGIN
 OPEN safe_num;
 LOOP
  FETCH safe_num INTO v_user_id,v_create_at;
  IF v_create_at+7 <= to_char(sysdate,'YY/MM/DD') THEN
 DELETE FROM safety_number WHERE USER_ID = v_user_id; 
 END IF; 
  EXIT WHEN safe_num%NOTFOUND;
 END LOOP;
 close safe_num;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_FIND_ACCOM_BY_FACILITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_FIND_ACCOM_BY_FACILITIES" (
    p_SWIMMING_POOL NUMBER DEFAULT NULL,
    p_LOUNGE NUMBER DEFAULT NULL,
    p_PUBLIC_PC NUMBER DEFAULT NULL,
    p_BBQ NUMBER DEFAULT NULL,
    p_CAFE NUMBER DEFAULT NULL,
    p_CONVENIENCE NUMBER DEFAULT NULL,
    p_KARAOKE NUMBER DEFAULT NULL,
    p_KITCHEN NUMBER DEFAULT NULL,
    p_LAUNDRY NUMBER DEFAULT NULL,
    p_DRYER NUMBER DEFAULT NULL,
    p_DEHYDRATOR NUMBER DEFAULT NULL,
    p_PARKING NUMBER DEFAULT NULL,
    p_COOKING NUMBER DEFAULT NULL,
    p_PUBLIC_SHOWER NUMBER DEFAULT NULL,
    p_MICROWAVE NUMBER DEFAULT NULL,
    p_ELECTRICAL NUMBER DEFAULT NULL,
    p_SINK NUMBER DEFAULT NULL,
    p_STORE NUMBER DEFAULT NULL
) 
IS
    vcursor SYS_REFCURSOR;
    v_sql VARCHAR2(4000);
    v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
    v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
    v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
    v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;
    v_ACCOM_REVIEW_COUNT ACCOMMODATION.ACCOM_REVIEW_COUNT%TYPE;
    v_CHECK_IN_TIME ACCOMMODATION.CHECK_IN_TIME%TYPE;
    v_CHECK_OUT_TIME ACCOMMODATION.CHECK_OUT_TIME%TYPE;
    v_AD_GRADE ACCOMMODATION.AD_GRADE%TYPE;

BEGIN
    v_sql := 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING, A.ACCOM_REVIEW_COUNT, A.CHECK_IN_TIME, A.CHECK_OUT_TIME, A.AD_GRADE ';
    v_sql := v_sql || 'FROM ACCOMMODATION A JOIN PUBLIC_FACILITIES PF ON A.ACCOM_ID = PF.ACCOM_ID  ';
    v_sql := v_sql || 'WHERE A.ACCOM_ID = ''C'' ';
     IF p_SWIMMING_POOL IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.SWIMMING_POOL = ' || p_SWIMMING_POOL;
    END IF;

    IF p_LOUNGE IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.LOUNGE = ' || p_LOUNGE;
    END IF;

    IF p_PUBLIC_PC IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.PUBLIC_PC = ' || p_PUBLIC_PC;
    END IF;

    IF p_BBQ IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.BBQ = ' || p_BBQ;
    END IF;

    IF p_CAFE IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.CAFE = ' || p_CAFE;
    END IF;

    IF p_CONVENIENCE IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.CONVENIENCE = ' || p_CONVENIENCE;
    END IF;

    IF p_KARAOKE IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.KARAOKE = ' || p_KARAOKE;
    END IF;

    IF p_KITCHEN IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.KITCHEN = ' || p_KITCHEN;
    END IF;

    IF p_LAUNDRY IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.LAUNDRY = ' || p_LAUNDRY;
    END IF;

    IF p_DRYER IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.DRYER = ' || p_DRYER;
    END IF;

    IF p_DEHYDRATOR IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.DEHYDRATOR = ' || p_DEHYDRATOR;
    END IF;

    IF p_PARKING IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.PARKING = ' || p_PARKING;
    END IF;

    IF p_COOKING IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.COOKING = ' || p_COOKING;
    END IF;

    IF p_PUBLIC_SHOWER IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.PUBLIC_SHOWER = ' || p_PUBLIC_SHOWER;
    END IF;

    IF p_MICROWAVE IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.MICROWAVE = ' || p_MICROWAVE;
    END IF;

    IF p_ELECTRICAL IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.ELECTRICAL = ' || p_ELECTRICAL;
    END IF;

    IF p_SINK IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.SINK = ' || p_SINK;
    END IF;

    IF p_STORE IS NOT NULL THEN
        v_sql := v_sql || ' AND PF.STORE = ' || p_STORE;
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor 
         INTO v_ACCOM_ID, v_ACCOM_NAME, v_ADDRESS, v_ACCOM_RATING, v_ACCOM_REVIEW_COUNT, v_CHECK_IN_TIME, v_CHECK_OUT_TIME, v_AD_GRADE;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ACCOM_NAME || ', ' || v_ADDRESS);
    END LOOP;
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_FIND_ACCOM_BY_FACILITIESS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_FIND_ACCOM_BY_FACILITIESS" 
(
    v_fitness IN PUBLIC_FACILITIES.FITNESS%TYPE DEFAULT NULL,
    v_swimming_pool IN PUBLIC_FACILITIES.SWIMMING_POOL%TYPE DEFAULT NULL,
    v_sauna IN PUBLIC_FACILITIES.SAUNA%TYPE DEFAULT NULL,
    v_golf_course IN PUBLIC_FACILITIES.GOLF_COURSE%TYPE DEFAULT NULL,
    v_restaurant IN PUBLIC_FACILITIES.RESTAURANT%TYPE DEFAULT NULL,
    v_elevator IN PUBLIC_FACILITIES.ELEVATOR%TYPE DEFAULT NULL,
    v_lounge IN PUBLIC_FACILITIES.LOUNGE%TYPE DEFAULT NULL,
    v_public_pc IN PUBLIC_FACILITIES.PUBLIC_PC%TYPE DEFAULT NULL,
    v_bbq IN PUBLIC_FACILITIES.BBQ%TYPE DEFAULT NULL,
    v_cafe IN PUBLIC_FACILITIES.CAFE%TYPE DEFAULT NULL,
    v_public_spa IN PUBLIC_FACILITIES.PUBLIC_SPA%TYPE DEFAULT NULL,
    v_foot_volleyball IN PUBLIC_FACILITIES.FOOT_VOLLEYBALL%TYPE DEFAULT NULL,
    v_seminar_room IN PUBLIC_FACILITIES.SEMINAR_ROOM%TYPE DEFAULT NULL,
    v_convenience IN PUBLIC_FACILITIES.CONVENIENCE%TYPE DEFAULT NULL,
    v_karaoke IN PUBLIC_FACILITIES.KARAOKE%TYPE DEFAULT NULL,
    v_kitchen IN PUBLIC_FACILITIES.KITCHEN%TYPE DEFAULT NULL,
    v_laundry IN PUBLIC_FACILITIES.LAUNDRY%TYPE DEFAULT NULL,
    v_dryer IN PUBLIC_FACILITIES.DRYER%TYPE DEFAULT NULL,
    v_dehydrator IN PUBLIC_FACILITIES.DEHYDRATOR%TYPE DEFAULT NULL,
    v_parking IN PUBLIC_FACILITIES.PARKING%TYPE DEFAULT NULL,
    v_cooking IN PUBLIC_FACILITIES.COOKING%TYPE DEFAULT NULL,
     v_ski_resort IN PUBLIC_FACILITIES.SKI_RESORT%TYPE DEFAULT NULL,
    v_microwave IN PUBLIC_FACILITIES.MICROWAVE%TYPE DEFAULT NULL
)
AS
    CURSOR c_find_accom IS
        SELECT DISTINCT  a.*
        FROM ACCOMMODATION a
             JOIN PUBLIC_FACILITIES pf ON a.ACCOM_ID = pf.ACCOM_ID
         WHERE (v_fitness IS NULL OR pf.FITNESS = v_fitness)
          AND (v_swimming_pool IS NULL OR pf.SWIMMING_POOL = v_swimming_pool)
          AND (v_sauna IS NULL OR pf.SAUNA = v_sauna)
          AND (v_golf_course IS NULL OR pf.GOLF_COURSE = v_golf_course)
          AND (v_restaurant IS NULL OR pf.RESTAURANT = v_restaurant)
          AND (v_elevator IS NULL OR pf.ELEVATOR = v_elevator)
          AND (v_lounge IS NULL OR pf.LOUNGE = v_lounge)
          AND (v_public_pc IS NULL OR pf.PUBLIC_PC = v_public_pc)
          AND (v_bbq IS NULL OR pf.BBQ = v_bbq)
          AND (v_cafe IS NULL OR pf.CAFE = v_cafe)
          AND (v_public_spa IS NULL OR pf.PUBLIC_SPA = v_public_spa)
          AND (v_foot_volleyball IS NULL OR pf.FOOT_VOLLEYBALL = v_foot_volleyball)
          AND (v_seminar_room IS NULL OR pf.SEMINAR_ROOM = v_seminar_room)
          AND (v_convenience IS NULL OR pf.CONVENIENCE = v_convenience)
          AND (v_karaoke IS NULL OR pf.KARAOKE = v_karaoke)
          AND (v_kitchen IS NULL OR pf.KITCHEN = v_kitchen)
          AND (v_laundry IS NULL OR pf.LAUNDRY = v_laundry)
          AND (v_dryer IS NULL OR pf.DRYER = v_dryer)
          AND (v_dehydrator IS NULL OR pf.DEHYDRATOR = v_dehydrator)
          AND (v_parking IS NULL OR pf.PARKING = v_parking)
          AND (v_cooking IS NULL OR pf.COOKING = v_cooking)
          AND (v_ski_resort IS NULL OR pf.SKI_RESORT = v_ski_resort)
          AND (v_microwave IS NULL OR pf.MICROWAVE = v_microwave)
        ORDER BY a.ACCOM_RATING DESC; 

BEGIN
    FOR r_find_accom IN c_find_accom
    LOOP
       DBMS_OUTPUT.PUT_LINE('accom_id : ' || r_find_accom.accom_id); 
       DBMS_OUTPUT.PUT_LINE('accom_name : ' || r_find_accom.accom_name);
       DBMS_OUTPUT.PUT_LINE('address : ' || r_find_accom.address);
       DBMS_OUTPUT.PUT_LINE('accom_rating : ' || r_find_accom.accom_rating);
       DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GET_ACCOM_INFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GET_ACCOM_INFO" (
        p_seq accommodation.accom_id%TYPE  -- 숙소 seq
    )
IS
    v_accom accommodation%ROWTYPE;
    v_detail_title accommodation_info.detail_title%TYPE;
BEGIN
    SELECT a.accom_name, a.address, a.accom_rating, ai.detail_title
        INTO v_accom.accom_name, v_accom.address, v_accom.accom_rating, v_detail_title
    FROM accommodation a JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd
                                                    AND a.accom_id = ai.main_cd
    WHERE a.seq = p_seq;

    DBMS_OUTPUT.PUT_LINE(v_detail_title||' '||v_accom.accom_name);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_accom.accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom.accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom.accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom.accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                                END);
    DBMS_OUTPUT.PUT_LINE(v_accom.address);
END UP_Get_Accom_Info;

/
--------------------------------------------------------
--  DDL for Procedure UP_GET_BEST_REVIEWS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GET_BEST_REVIEWS" (
    p_seq      IN NUMBER,
    p_accom_id IN VARCHAR2
) AS
    -- 컬렉션 타입 정의
    TYPE review_info_type IS RECORD (
        room_name ROOM.room_name%TYPE,
        user_id REVIEW.user_id%TYPE,
        created_at REVIEW.created_at%TYPE,
        review_title VARCHAR2(100), -- 변경된 부분: 충분한 길이로 조정
        rating REVIEW.rating%TYPE,
        review_content REVIEW.content%TYPE,
        file_url REVIEW.FILE_URL%TYPE
    );
    TYPE review_list_type IS TABLE OF review_info_type;
    -- 컬렉션 변수 선언
    v_review_list review_list_type := review_list_type();
BEGIN
   -- SELECT 문에서 BULK COLLECT INTO 절 사용하여 결과 저장
   SELECT R.room_name, user_id, RE.created_at, SUBSTR(RE.content, 1, 10), RE.rating, RE.content, RE.FILE_URL 
   BULK COLLECT INTO v_review_list 
   FROM ROOM R
   JOIN REVIEW RE ON R.room_id = RE.room_id
   WHERE r.seq      = p_seq 
   AND   r.accom_id = p_accom_id
   ORDER BY re.rating DESC;
   -- 결과 처리 (예: 반복문으로 출력)
   FOR i IN 1..v_review_list.COUNT LOOP
       DBMS_OUTPUT.PUT_LINE('방이름: ' || v_review_list(i).room_name);
       DBMS_OUTPUT.PUT_LINE('회원 ID: ' || v_review_list(i).user_id);
       DBMS_OUTPUT.PUT_LINE('작성일자: ' || v_review_list(i).created_at);
       DBMS_OUTPUT.PUT_LINE('리뷰 제목: ' || v_review_list(i).review_title);
       DBMS_OUTPUT.PUT_LINE('평점: ' || v_review_list(i).rating);
       DBMS_OUTPUT.PUT_LINE('리뷰 내용: ' || v_review_list(i).review_content);
       DBMS_OUTPUT.PUT_LINE('이미지 URL: ' || v_review_list(i).file_url);
       DBMS_OUTPUT.PUT_LINE('ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
   END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GET_CAMPING_BY_ETC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GET_CAMPING_BY_ETC" (
    p_WITH_PET NUMBER DEFAULT NULL,
    p_BREAKFAST NUMBER DEFAULT NULL,
    p_SMOKING NUMBER DEFAULT NULL,
    p_VALET_PARKING NUMBER DEFAULT NULL,
    p_NON_SMOKING NUMBER DEFAULT NULL,
    p_IN_ROOM_COOKING NUMBER DEFAULT NULL,
    p_PICK_UP_AVAILABLE NUMBER DEFAULT NULL,
    p_CAMPFIRE NUMBER DEFAULT NULL,
    p_CREDIT_CARD NUMBER DEFAULT NULL,
    p_SITE_PARK NUMBER DEFAULT NULL
) 
IS
    vcursor SYS_REFCURSOR;
    v_sql VARCHAR2(2000);
    v_ACCOM_ID ACCOMMODATION.ACCOM_ID%TYPE;
    v_ACCOM_NAME ACCOMMODATION.ACCOM_NAME%TYPE;
    v_ADDRESS ACCOMMODATION.ADDRESS%TYPE;
    v_ACCOM_RATING ACCOMMODATION.ACCOM_RATING%TYPE;
    v_ACCOM_REVIEW_COUNT ACCOMMODATION.ACCOM_REVIEW_COUNT%TYPE;
    v_CHECK_IN_TIME ACCOMMODATION.CHECK_IN_TIME%TYPE;
    v_CHECK_OUT_TIME ACCOMMODATION.CHECK_OUT_TIME%TYPE;
    v_AD_GRADE ACCOMMODATION.AD_GRADE%TYPE;

BEGIN
    v_sql := 'SELECT A.ACCOM_ID, A.ACCOM_NAME, A.ADDRESS, A.ACCOM_RATING, A.ACCOM_REVIEW_COUNT, A.CHECK_IN_TIME, A.CHECK_OUT_TIME, A.AD_GRADE ';
    v_sql := v_sql || 'FROM ACCOMMODATION A JOIN ETC E ON A.ACCOM_ID = E.ACCOM_ID WHERE A.ACCOM_ID LIKE ''%c%'' ';

    IF p_WITH_PET IS NOT NULL THEN
        v_sql := v_sql || ' AND E.WITH_PET = ' || p_WITH_PET;
    END IF;

    IF p_BREAKFAST IS NOT NULL THEN
        v_sql := v_sql || ' AND E.BREAKFAST = ' || p_BREAKFAST;
    END IF;

    IF p_SMOKING IS NOT NULL THEN
        v_sql := v_sql || ' AND E.SMOKING = ' || p_SMOKING;
    END IF;

    IF p_VALET_PARKING IS NOT NULL THEN
        v_sql := v_sql || ' AND E.VALET_PARKING = ' || p_VALET_PARKING;
    END IF;

    IF p_NON_SMOKING IS NOT NULL THEN
        v_sql := v_sql || ' AND E.NON_SMOKING = ' || p_NON_SMOKING;
    END IF;

    IF p_IN_ROOM_COOKING IS NOT NULL THEN
        v_sql := v_sql || ' AND E.IN_ROOM_COOKING = ' || p_IN_ROOM_COOKING;
    END IF;

    IF p_PICK_UP_AVAILABLE IS NOT NULL THEN
        v_sql := v_sql || ' AND E.PICK_UP_AVAILABLE = ' || p_PICK_UP_AVAILABLE;
    END IF;

    IF p_CAMPFIRE IS NOT NULL THEN
        v_sql := v_sql || ' AND E.CAMPFIRE = ' || p_CAMPFIRE;
    END IF;

    IF p_CREDIT_CARD IS NOT NULL THEN
        v_sql := v_sql || ' AND E.CREDIT_CARD = ' || p_CREDIT_CARD;
    END IF;

    IF p_SITE_PARK IS NOT NULL THEN
        v_sql := v_sql || ' AND E.SITE_PARK = ' || p_SITE_PARK;
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_sql);

    OPEN vcursor FOR v_sql; 
    LOOP
        FETCH vcursor 
         INTO v_ACCOM_ID, v_ACCOM_NAME, v_ADDRESS, v_ACCOM_RATING, v_ACCOM_REVIEW_COUNT, v_CHECK_IN_TIME, v_CHECK_OUT_TIME, v_AD_GRADE;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ACCOM_NAME || ', ' || v_ADDRESS);
    END LOOP;
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GET_INQUIRY_DETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GET_INQUIRY_DETAILS" 
(
 p_user_id VARCHAR2
)
AS
    vcursor SYS_REFCURSOR;
    v_inquiry_type INQUIRY.INQUIRY_TYPE%TYPE;
    v_inquiry_content INQUIRY.INQUIRY_CONTENT%TYPE;
    v_inquiry_date INQUIRY.INQUIRY_DATE%TYPE;
    v_inquiry_status VARCHAR2(500);
BEGIN
    OPEN vcursor FOR
        SELECT 
            INQUIRY_TYPE AS "문의 유형",
            INQUIRY_CONTENT AS "문의 내용",
            INQUIRY_DATE AS "작성일",
            CASE 
                WHEN STATUS = 1 THEN '답변 완료'
                WHEN STATUS = 2 THEN '답변 대기'
                ELSE '알 수 없는 상태'
            END AS "문의 상태"
        FROM 
            INQUIRY
        WHERE user_id = p_user_id
        ORDER BY 
            INQUIRY_DATE DESC;

    LOOP
        FETCH vcursor INTO v_inquiry_type, v_inquiry_content, v_inquiry_date, v_inquiry_status;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_inquiry_type || ', ' || v_inquiry_content || ', ' || v_inquiry_date || ', ' || v_inquiry_status);
    END LOOP;

    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GET_ROOM_INFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GET_ROOM_INFO" 
    (
        p_seq accommodation.seq%TYPE
    )
IS
BEGIN
    FOR v_room IN (
       SELECT room_name, price
       FROM room
       WHERE seq = p_seq
       ORDER BY price)
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_room.room_name);
        DBMS_OUTPUT.PUT_LINE('가격       '||v_room.price||'원');
        DBMS_OUTPUT.PUT_LINE('ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
   END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GET_USER_DETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GET_USER_DETAILS" (p_user_id MEMBER.USER_ID%TYPE) AS
    v_user_id MEMBER.USER_ID%TYPE;
    v_user_nickname MEMBER.USER_NICKNAME%TYPE; -- Corrected this line
    v_user_name MEMBER.USER_NAME%TYPE;
    v_phone_number MEMBER.PHONE_NUMBER%TYPE;
BEGIN
    SELECT 
        user_id, 
        user_nickname, 
        NVL(user_name, '') AS user_name, 
        phone_number
    INTO 
        v_user_id, 
        v_user_nickname,  -- Corrected this line
        v_user_name, 
        v_phone_number
    FROM 
        member
    WHERE 
        user_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('유저ID(이메일): ' || v_user_id || ', 닉네임: ' || v_user_nickname || ', 예약자이름: ' || v_user_name || ', 휴대번호: ' || v_phone_number); -- Corrected this line
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the provided user_id.');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETACCOMMODATIONBYADDRESS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETACCOMMODATIONBYADDRESS" (
    p_accom_id IN accommodation.accom_id%TYPE, -- 숙소 ID 파라미터
    p_address IN accommodation.address%TYPE -- 주소 파라미터
)
AS
    -- 커서 정의: 주어진 숙소 ID와 일치하고, 
    -- 주어진 문자열로 시작하는 주소를 가진 모든 행 선택 
    CURSOR c_accommodation IS
        SELECT *
        FROM accommodation
        WHERE accom_id = p_accom_id AND address LIKE p_address || '%';
BEGIN
    -- 커서를 반복하여 각 행에 대해 작업 수행 
    FOR r_accommodation IN c_accommodation LOOP
        -- DBMS_OUTPUT.PUT_LINE을 사용하여 숙소 ID 및 주소 출력 
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r_accommodation.accom_id);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r_accommodation.address);
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETACCOMMODATIONRATING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETACCOMMODATIONRATING" (
    p_accom_id IN accommodation.accom_id%TYPE  -- 숙소 ID 파라미터
)
AS
    accom_rating accommodation.accom_rating%TYPE;  -- 평균 별점을 저장할 변수 선언
    review_count accommodation.accom_review_count%TYPE;  -- 리뷰 개수를 저장할 변수 선언
BEGIN
    SELECT accom_rating, accom_review_count 
    INTO accom_rating, review_count  -- 선택된 값들을 각각의 변수에 할당 
    FROM (SELECT * FROM accommodation WHERE accom_id = p_accom_id AND ROWNUM = 1);  -- 주어진 ID와 일치하는 첫 번째 행만 선택

    DBMS_OUTPUT.PUT_LINE('평균 별점: ' || TO_CHAR(accom_rating));   -- 평균 별점 출력  
    DBMS_OUTPUT.PUT_LINE('전체 리뷰 개수: ' || TO_CHAR(review_count));   -- 전체 리뷰 개수 출력  
EXCEPTION 
  WHEN NO_DATA_FOUND THEN   -- 데이터가 없을 경우 예외 처리  
     DBMS_OUTPUT.PUT_LINE('해당 ID의 숙소가 존재하지 않습니다.');   -- 오류 메시지 출력  
END UP_GetAccommodationRating;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETAVAILABLEPOINTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETAVAILABLEPOINTS" 
(
    p_user_id member.user_id%TYPE
)
IS
    v_user_points member.user_points%TYPE;
BEGIN
    SELECT SUM(balance) INTO v_user_points
    FROM point_history
    WHERE user_id = p_user_id;

    UPDATE member
    SET user_points = v_user_points
    WHERE user_id = p_user_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------' );
    DBMS_OUTPUT.PUT_LINE('사용가능 포인트 : ' || v_user_points);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------' );
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETLISTOFAVAILABLECOUPONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETLISTOFAVAILABLECOUPONS" 
(
    p_user_id member.user_id%TYPE
    , p_start_date reservation.start_date%TYPE
    , p_accom_id accommodation.accom_id%TYPE
    , p_reserve_type coupon.available_type%TYPE
    , p_price room.price%TYPE
)
IS
    v_coupon_id coupon_status.coupon_id%TYPE;
    v_coupon_name coupon.coupon_name%TYPE;
    v_discount_amount coupon.discount_amount%TYPE;
--        v_discount_amount NUMBER;
    v_max_discount_amount coupon.max_discount_amount%TYPE;
    v_available_pay_type coupon.available_pay_type%TYPE;

BEGIN
    FOR v_record IN (
        SELECT coupon_id, coupon_name, discount_amount, max_discount_amount, available_pay_type
        FROM coupon_status cstat JOIN coupon c ON cstat.coupon_type_id = c.coupon_type_id
        WHERE user_id = p_user_id
                AND status = 0 -- 미사용 상태
                AND available_accom LIKE '%' || p_accom_id || '%' -- 현재 숙소에 사용할 수 있는
                AND available_days LIKE '%' || TO_CHAR(p_start_date, 'd') || '%' -- 해당 요일(체크인 날짜 기준)에 사용 가능한
                AND available_type IN (p_reserve_type, '모두')  -- 선택한 숙박 유형 또는 모두
                AND min_pay_amount <= p_price -- 결제 금액이 쿠폰의 최소 결제 요구 금액을 큰
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('---------------------------------------' );
        DBMS_OUTPUT.PUT_LINE('쿠폰 ID : ' || v_record.coupon_id);
        DBMS_OUTPUT.PUT_LINE('쿠폰명 : ' || v_record.coupon_name);
        DBMS_OUTPUT.PUT_LINE('할인액/비율 : ' || TO_CHAR(v_record.discount_amount, '999990.99') );
        DBMS_OUTPUT.PUT_LINE('최대 할인가능액 : ' || v_record.max_discount_amount);
        DBMS_OUTPUT.PUT_LINE('사용 결제수단 : ' || v_record.available_pay_type);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------' );
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETMEMINFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETMEMINFO" 
(
    p_user_id member.user_id%TYPE
)
IS
    v_user_name member.user_name%TYPE;
    v_phone_num  member.phone_number%TYPE;
BEGIN
    SELECT user_name, phone_number INTO v_user_name, v_phone_num
    FROM member
    WHERE user_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('예약자 이름 : ' || v_user_name || ', 연락처 : ' || v_phone_num); -- 이름, 연락처
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETPUBLICFACILITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETPUBLICFACILITIES" (
    p_fitness IN NUMBER ,
    p_swimming_pool IN NUMBER,
    p_sauna IN NUMBER,
    p_golf_course IN NUMBER,
    p_restaurant IN NUMBER,
    p_elevator IN NUMBER,
    p_lounge IN NUMBER,
    p_public_pc IN NUMBER,
    p_BBQ IN NUMBER,
    p_cafe IN NUMBER,
    p_public_spa         IN NUMBER ,
        p_foot_volleyball         IN        NUMBER , 
        p_seminar_room         IN        NUMBER , 
        p_convenience         IN        NUMBER , 
        p_karaoke         IN        NUMBER , 
        p_kitchen         IN        NUMBER , 
        p_laundry         IN        NUMBER , 
        p_dryer                   IN        NUMBER ,
        p_dehydrator  IN        NUMBER ,
    p_parking   IN        NUMBER ,
    p_cooking   IN        NUMBER ,
    p_public_shower IN        NUMBER ,
    p_hot_spring    IN        NUMBER ,
    p_ski_resort    IN        NUMBER ,
    p_microwave IN        NUMBER ,
    p_electrical    IN        NUMBER ,
    p_sink  IN        NUMBER ,
    p_store IN        NUMBER 
) AS
BEGIN
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address
        FROM 
            ACCOMMODATION A
        JOIN 
            PUBLIC_FACILITIES PF ON A.SEQ = pf.ACCOM_ID
        WHERE  
                        PF.FITNESS = P_FITNESS AND    
                        PF.SWIMMING_POOL = P_SWIMMING_POOL AND    
                        PF.SAUNA = P_SAUNA AND   
                        PF.GOLF_COURSE = P_GOLF_COURSE AND    
                        PF.RESTAURANT = P_RESTAURANT AND   
                        PF.ELEVATOR = P_ELEVATOR AND    
                        PF.LOUNGE = P_LOUNGE AND   
                        PF.PUBLIC_PC= P_PUBLIC_PC AND    
                         PF.BBQ= P_BBQ        AND  
                         PF.CAFE= P_CAFE        AND  
                         Pf.PUBLIC_SPA=P_PUBLIC_SPA        AND  
Pf.FOOT_VOLLEYBALL=P_FOOT_VOLLEYBALL        AND  
Pf.SEMINAR_ROOM=P_SEMINAR_ROOM        AND  
Pf.CONVENIENCE=P_CONVENIENCE        AND  
Pf.KARAOKE=P_KARAOKE        AND  
Pf.KITCHEN=P_KITCHEN        AND  
Pf.LAUNDRY=P_LAUNDRY        AND  
Pf.DRYER = P_DRYER AND
PF.DEHYDRATOR= P_DEHYDRATOR AND
PF.parking = P_parking AND
PF.cooking = P_cooking AND
PF.public_shower = P_public_shower AND
PF.hot_spring = P_hot_spring AND
PF.ski_resort = P_ski_resort AND
PF.microwave = P_microwave AND
PF.electrical = P_electrical AND
PF.sink = P_sink AND
PF.store = P_store
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);

    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_GETROOMDETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_GETROOMDETAILS" (
    p_accom_id IN accommodation.accom_id%TYPE
)
AS
BEGIN
    FOR r_room IN (
        SELECT 
            r.ROOM_NAME AS room_name,
            CASE ro.reservation WHEN 0 THEN '불가능' ELSE '가능' END AS reservation_possible,
            a.check_in_time AS check_in_time, 
            a.check_out_time AS check_out_time, 
            r.PRICE AS price
        FROM ROOM r, reservation_option ro, ACCOMMODATION a
        WHERE r.seq = ro.seq
        and   r.accom_id = ro.accom_id
        and   ro.seq = a.seq
        and   ro.accom_id = a.accom_id
        AND a.accom_id = p_accom_id)
    LOOP
        DBMS_OUTPUT.PUT_LINE('객실명: ' || r_room.room_name);
        DBMS_OUTPUT.PUT_LINE('숙박 가능 여부: ' || r_room.reservation_possible);
		DBMS_OUTPUT.PUT_LINE('체크인 시간: ' || r_room.check_in_time);
		DBMS_OUTPUT.PUT_LINE('체크아웃 시간: '||r_room.check_out_time);
		DBMS_OUTPUT.PUT_LINE('가격: '||r_room.price);  
        DBMS_OUTPUT.PUT_LINE('ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
   END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_INSERT_INQUIRY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_INSERT_INQUIRY" (
    p_user_id IN VARCHAR2,
    p_category_type IN VARCHAR2,
    p_inquiry_type IN VARCHAR2,
    p_phone_number IN VARCHAR2 DEFAULT NULL,
    p_email IN VARCHAR2 DEFAULT NULL,
    p_inquiry_content IN VARCHAR2
) AS
BEGIN
   INSERT INTO inquiry (
      inquiry_id, 
      user_id, 
      inquiry_date, 
      category_type, 
      inquiry_type, 
      phone_number,
      email,
      inquiry_content
   ) VALUES (
     inquiry_ID_SEQ.nextval, -- 문의 ID   
     p_user_id, -- 회원 ID
     SYSDATE, -- 문의 일시 (현재 시간)
     p_category_type, -- 카테고리 유형
     p_inquiry_type, -- 문의 유형
     p_phone_number, -- 휴대폰 번호 (문자열로 처리)
     p_email ,-- 이메일 주소  
     p_inquiry_content  --문의 내용 
   );
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_INSERT_MEMBER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_INSERT_MEMBER" (
    p_user_id IN VARCHAR2,
    p_user_pw IN VARCHAR2,
    p_user_nickname IN VARCHAR2,
    p_phone_number IN VARCHAR2
) AS
BEGIN
    INSERT INTO member (
        user_id,
        user_pw,
        user_nickname,
        phone_number,
        user_name,
        user_grade,
        user_points,
        user_coupons
    ) VALUES (
        p_user_id, -- 사용자 ID
        p_user_pw, -- 사용자 PW
         NVL(p_user_nickname, 'Guest'||TO_CHAR(SYSDATE,'HH24MISS')),
         p_phone_number, -- 전화번호
         NULL , -- 예약자 이름 NULL
         NULL, -- 등급. NULL
         NULL, -- 보유 포인트 NULL
         NULL  -- 보유 쿠폰 수 NULL
    );
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_INSPAYMENT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_INSPAYMENT" 
(
    -- 예약 관련
    p_user_id member.user_id%TYPE
    , p_room_id room.room_id%TYPE
    , p_rsv_status reservation.status%TYPE := '예약 완료'
    , p_start_date VARCHAR2
    , p_end_date VARCHAR2

    -- 결제 관련
    , p_pay_status payment.status%TYPE
    , p_pay_amount payment.pay_amount%TYPE := '결제 완료'
    , p_pay_method payment.pay_method%TYPE
)
IS
    v_pay_date DATE DEFAULT sysdate;
    v_rsv_id reservation.reservation_id%TYPE;
BEGIN
    -- 예약 내역 추가, vrsv_id는 OUT 파라미터
    up_insRsv(p_user_id, p_room_id, p_rsv_status, p_start_date, p_end_date, v_rsv_id);

    INSERT INTO payment
    VALUES(PAY_ID_SEQ.NEXTVAL, v_rsv_id, p_pay_status, v_pay_date, p_pay_amount, p_pay_method);



    DBMS_OUTPUT.PUT_LINE(' ' );
    DBMS_OUTPUT.PUT_LINE('결제 ID : ' || PAY_ID_SEQ.CURRVAL );
    DBMS_OUTPUT.PUT_LINE('예약 ID : ' || v_rsv_id  );
    DBMS_OUTPUT.PUT_LINE('상태 : ' || p_pay_status );
    DBMS_OUTPUT.PUT_LINE('결제일시 : ' || v_pay_date );
    DBMS_OUTPUT.PUT_LINE('결제금액 : ' || p_pay_amount );
    DBMS_OUTPUT.PUT_LINE('결제방식 : ' || p_pay_method );
    DBMS_OUTPUT.PUT_LINE('---------------------------------------' );


    COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_INSRSV
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_INSRSV" 
(
    p_user_id member.user_id%TYPE
    , p_room_id room.room_id%TYPE
    , p_status reservation.status%TYPE
    , p_start_date VARCHAR2
    , p_end_date VARCHAR2
    , p_rsv_id OUT reservation.reservation_id%TYPE -- 예약ID를 반환

)
IS
    v_reservation_date DATE DEFAULT SYSDATE;
    v_rsv_id reservation.reservation_id%TYPE 
        := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MI') ||  DBMS_RANDOM.STRING('X',6); -- 예약ID 생성
    v_start_date DATE := TO_DATE(p_start_date, 'YYYY-MM-DD HH24:MI');
    v_end_date DATE := TO_DATE(p_end_date, 'YYYY-MM-DD HH24:MI');        

BEGIN
    INSERT INTO reservation
    VALUES(v_rsv_id, p_user_id, p_room_id, v_reservation_date, p_status, v_start_date, v_end_date);
    
    DBMS_OUTPUT.PUT_LINE('------------- 예 약 완 료 -------------' );
    DBMS_OUTPUT.PUT_LINE('예약 ID : ' || v_rsv_id );
    DBMS_OUTPUT.PUT_LINE('객실 ID : ' || p_room_id );
    DBMS_OUTPUT.PUT_LINE('예약일시 : ' || v_reservation_date );
    DBMS_OUTPUT.PUT_LINE('이용시작일 : ' ||  TO_CHAR(v_start_date, 'YYYY"년" MM"월" DD"일" DY HH24:MI') );
    DBMS_OUTPUT.PUT_LINE('이용종료일 : ' || TO_CHAR(v_end_date, 'YYYY"년" MM"월" DD"일" DY HH24:MI') );
    DBMS_OUTPUT.PUT_LINE('상태 : ' || p_status );
    
    COMMIT;
    p_rsv_id := v_rsv_id; -- 예약 ID를 OUT 파라미터에 할당
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_LOGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_LOGIN" --로그인
(
  I_ID        IN VARCHAR2, -- [필수 : 로그인 아이디]
  I_PW           IN VARCHAR2 -- [필수 : 로그인 비밀번호]                                                                                       
)
IS
M_COUNT  NUMBER; 
V_USER_ID VARCHAR2(200);
V_USER_PW VARCHAR2(200);
BEGIN
   SELECT COUNT(*) INTO M_COUNT
          FROM MEMBER
   WHERE TRIM(USER_ID) = TRIM(I_ID)
       AND TRIM(USER_PW) = TRIM(I_PW)
   ;
   IF M_COUNT > 0 THEN -- [검색된 데이터가 있는 경우 : 정상 로그인 사용자]                   
           DBMS_OUTPUT.PUT_LINE('정상 로그인 성공');                    
   ELSE     
          DBMS_OUTPUT.PUT_LINE('등록된 사용자가 아닙니다. 회원가입을 진행해주세요.');           
   END IF;
END UP_LOGIN;

/
--------------------------------------------------------
--  DDL for Procedure UP_P_PRICERANGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_P_PRICERANGE" (
    p_accom_id IN accommodation.accom_id%TYPE,
    p_min_price IN NUMBER,  -- 최소 가격 파라미터
    p_max_price IN NUMBER   -- 최대 가격 파라미터
) AS
BEGIN
    -- 커서를 반복하여 각 행에 대해 작업 수행 
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            R.price AS room_price  -- 방의 가격을 room_price라는 별칭으로 선택
        FROM 
            ACCOMMODATION A  -- ACCOMMODATION 테이블에서 선택
        JOIN 
           ROOM R ON A.ACCOM_ID = R.ACCOM_ID  -- ROOM과 조인 (accom_id가 일치하는 경우)
        WHERE 
           R.price BETWEEN p_min_price AND p_max_price  -- price가 파라미터 범위 내인 경우만 선택  
           AND A.accom_id LIKE 'c%'   -- accom_id가 'P'로 시작하는 경우만 선택
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Room Price: ' || r.room_price);
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_PARTICIPATE_IN_EVENT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_PARTICIPATE_IN_EVENT" (
    p_user_id IN VARCHAR2
  , p_event_id IN NUMBER
  , p_winner_status IN VARCHAR2 := 1
  )
IS
  v_coupon_type_id NUMBER;
  v_event_point NUMBER;
BEGIN
  -- 이벤트 참여 기록
  INSERT INTO event_history (event_id, user_id, winner_status, participation_date)
    VALUES (p_event_id, p_user_id, p_winner_status, SYSDATE);

  IF p_winner_status = 1 THEN -- 당첨된 경우
    SELECT coupon_type_id, event_point 
      INTO v_coupon_type_id, v_event_point 
      FROM event WHERE event_id = p_event_id;

    IF v_coupon_type_id IS NOT NULL THEN -- 쿠폰이 있는 경우
      UPDATE member SET user_coupons = user_coupons + 1 WHERE user_id = p_user_id;
    END IF;

    IF v_event_point IS NOT NULL THEN -- 포인트가 있는 경우
      UPDATE member SET user_points = user_points + v_event_point WHERE user_id = p_user_id;
    END IF;

  END IF;

END;

/
--------------------------------------------------------
--  DDL for Procedure UP_PENSIONBYPRICERANGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_PENSIONBYPRICERANGE" (
    p_min_price IN NUMBER,  -- 최소 가격 파라미터
    p_max_price IN NUMBER   -- 최대 가격 파라미터
) AS
BEGIN
    -- 커서를 반복하여 각 행에 대해 작업 수행 
    FOR r IN (
        SELECT 
            A.accom_id,
            A.accom_name,
            A.address,
            R.price AS room_price  -- 방의 가격을 room_price라는 별칭으로 선택
        FROM 
            ACCOMMODATION A  -- ACCOMMODATION 테이블에서 선택
        JOIN 
           ROOM R ON A.ACCOM_ID = R.ACCOM_ID  -- ROOM과 조인 (accom_id가 일치하는 경우)
        WHERE 
           R.price BETWEEN p_min_price AND p_max_price  -- price가 파라미터 범위 내인 경우만 선택  
           AND UPPER(A.accom_id) LIKE 'C%'   -- accom_id가 'C'로 시작하는 경우만 선택 (대소문자 구분 없이)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Accommodation ID: ' || r.accom_id);
        DBMS_OUTPUT.PUT_LINE('Accommodation Name: ' || r.accom_name);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.address);
        DBMS_OUTPUT.PUT_LINE('Room Price: ' || r.room_price);
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_POINT_COUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_POINT_COUNT" -- 총 보유 포인트 , 30일내 소멸 예정 쿠폰 갯수 조회
    (
        p_user_id member.user_id%TYPE
    )
IS
    v_point_cnt NUMBER(10);
    v_exp_cnt NUMBER(10);
BEGIN
    SELECT NVL(user_points, 0) INTO v_point_cnt
    FROM member
    WHERE user_id = p_user_id;
    DBMS_OUTPUT.PUT_LINE('내포인트');
    DBMS_OUTPUT.PUT_LINE(v_point_cnt||'P');

   SELECT sum(balance) INTO v_exp_cnt
   FROM point_history 
   WHERE user_id = p_user_id AND end_date BETWEEN SYSDATE AND SYSDATE+30;
    DBMS_OUTPUT.PUT_LINE('30일 내' ||v_exp_cnt|| 'P가 소멸될 예정이에요');
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_RECOMMEND_ACCOMMODATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_RECOMMEND_ACCOMMODATION" -- 해당 조건에 부합하는 숙소 추천순으로 출력
(
    p_reservation_date IN RESERVATION.RESERVATION_DATE%TYPE
   ,p_camping_type IN ROOM.TYPE%TYPE
   ,p_capacity IN ROOM.CAPACITY%TYPE
   ,p_price IN ROOM.PRICE%TYPE
   ,p_public_facilities IN PUBLIC_FACILITIES.SEQ%TYPE
   ,p_room_facilities IN ROOM_FACILITIES.SEQ%TYPE
   ,p_etc_conditions IN ETC.SEQ%TYPE
   ,p_reservation_option IN reservation_option.SEQ%TYPE
   ,p_bed_type IN bed_type.SEQ%TYPE   -- where 조건에 들어갈 애들
)
AS
v_accom_id VARCHAR2(20);
v_accom_detail_id VARCHAR2(20);
v_accom_name NVARCHAR2(100);
v_address NVARCHAR2(100);
v_accom_rating NUMBER;  -- 출력 부분
    CURSOR c_recommend_accommodation IS
        SELECT DISTINCT a.accom_id, a.accom_detail_id, a.accom_name, a.address, a.accom_rating
        FROM ACCOMMODATION a
             JOIN ROOM r ON a.ACCOM_ID = r.ACCOM_ID AND a.seq = r.seq
             LEFT JOIN RESERVATION res ON a.ACCOM_ID = res.ROOM_ID AND res.RESERVATION_DATE = p_reservation_date
             JOIN PUBLIC_FACILITIES pf ON a.ACCOM_ID = pf.ACCOM_ID AND a.seq = pf.seq
             JOIN ROOM_FACILITIES rf ON a.ACCOM_ID = rf.ACCOM_ID AND a.seq = rf.seq
             JOIN ETC e ON a.ACCOM_ID = e.ACCOM_ID AND a.seq = e.seq
             JOIN reservation_option ro ON a.accom_id = ro.accom_id AND a.seq = ro.seq-- 예약옵션 + 숙소
             JOIN bed_type bt ON a.accom_id = bt.accom_id AND a.seq = bt.seq -- 베드 타입 + 숙소
        WHERE res.ROOM_ID IS NULL -- 예약되지 않은 캠핑장
          AND r.TYPE = p_camping_type
          AND r.CAPACITY = p_capacity
          AND r.PRICE <= p_price
          AND pf.SEQ = p_public_facilities
          AND rf.SEQ = p_room_facilities
          AND e.SEQ = p_etc_conditions
          AND ro.SEQ = p_reservation_option  -- 기타의 seq 같음
          AND bt.SEQ = p_bed_type -- 기타의 seq 같음
        ORDER BY a.ACCOM_RATING DESC; 
BEGIN
   OPEN c_recommend_accommodation;   
   FETCH c_recommend_accommodation INTO v_accom_id,v_accom_detail_id,v_accom_name,v_address,v_accom_rating;
    LOOP
       DBMS_OUTPUT.PUT_LINE('accom_id : ' || v_accom_id); 
        DBMS_OUTPUT.PUT_LINE('accom_detail_id : ' || v_accom_detail_id);
        DBMS_OUTPUT.PUT_LINE('accom_name : ' || v_accom_name);
        DBMS_OUTPUT.PUT_LINE('address : ' || v_address); 
        DBMS_OUTPUT.PUT_LINE('accom_rating : ' || v_accom_rating);
    EXIT WHEN c_recommend_accommodation%NOTFOUND;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_RECOMMEND_PENSIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_RECOMMEND_PENSIONS" --  해당 조건에 부합하는 숙소 추천순으로 출력
(
    p_reservation_date IN RESERVATION.RESERVATION_DATE%TYPE
   ,p_camping_type IN ROOM.TYPE%TYPE
   ,p_capacity IN ROOM.CAPACITY%TYPE
   ,p_price IN ROOM.PRICE%TYPE
   ,p_public_facilities IN PUBLIC_FACILITIES.SEQ%TYPE
   ,p_room_facilities IN ROOM_FACILITIES.SEQ%TYPE
   ,p_etc_conditions IN ETC.SEQ%TYPE
   ,p_reservation_option IN reservation_option.SEQ%TYPE
      -- where 조건에 들어갈 애들
)
AS
v_accom_id VARCHAR2(20);
v_accom_detail_id VARCHAR2(20);
v_accom_name NVARCHAR2(100);
v_address NVARCHAR2(100);
v_accom_rating NUMBER;  -- 출력 부분
    CURSOR c_recommend_accommodation IS
        SELECT DISTINCT a.accom_id, a.accom_detail_id, a.accom_name, a.address, a.accom_rating
        FROM ACCOMMODATION a
             JOIN ROOM r ON a.ACCOM_ID = r.ACCOM_ID
             LEFT JOIN RESERVATION res ON a.ACCOM_ID = res.ROOM_ID AND res.RESERVATION_DATE = p_reservation_date
             JOIN PUBLIC_FACILITIES pf ON a.ACCOM_ID = pf.ACCOM_ID
             JOIN ROOM_FACILITIES rf ON a.ACCOM_ID = rf.ACCOM_ID
             JOIN ETC e ON a.ACCOM_ID = e.ACCOM_ID
             JOIN reservation_option ro ON a.accom_id = ro.accom_id -- 예약옵션 + 숙소
        WHERE res.ROOM_ID IS NULL -- 예약되지 않은 캠핑장
          AND r.TYPE = p_camping_type
          AND r.CAPACITY = p_capacity
          AND r.PRICE <= p_price
          AND pf.SEQ = p_public_facilities
          AND rf.SEQ = p_room_facilities
          AND e.SEQ = p_etc_conditions
          AND ro.SEQ = p_reservation_option  -- 기타의 seq 같음

        ORDER BY a.ACCOM_RATING DESC; 
BEGIN
   OPEN c_recommend_accommodation;   
   FETCH c_recommend_accommodation INTO v_accom_id,v_accom_detail_id,v_accom_name,v_address,v_accom_rating;
    LOOP
       DBMS_OUTPUT.PUT_LINE('accom_id : ' || v_accom_id); 
        DBMS_OUTPUT.PUT_LINE('accom_detail_id : ' || v_accom_detail_id);
        DBMS_OUTPUT.PUT_LINE('accom_name : ' || v_accom_name);
        DBMS_OUTPUT.PUT_LINE('address : ' || v_address); 
        DBMS_OUTPUT.PUT_LINE('accom_rating : ' || v_accom_rating);
    EXIT WHEN c_recommend_accommodation%NOTFOUND;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_REIVEW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_REIVEW" (  
  P_review_id IN NUMBER,
  p_user_id IN VARCHAR2,
  p_room_id IN NUMBER,  
  P_created_at IN DATE,
  p_rating IN NUMBER,
  p_content IN VARCHAR2,
  P_file_url IN VARCHAR2
  )
IS
BEGIN
INSERT INTO review (REVIEW_ID,USER_ID,ROOM_ID,CREATED_AT,RATING,CONTENT,FILE_URL)
VALUES (P_review_id,p_user_id,p_room_id,P_created_at,p_rating,p_content,P_file_url);
COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_RELOADROOMINFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_RELOADROOMINFO" 
(
    p_accom_seq accommodation.seq%TYPE
    , p_accom_id accommodation.accom_id%TYPE
    , p_start_date reservation.start_date%TYPE
    , p_end_date reservation.end_date%TYPE
)
IS

BEGIN
    FOR v_record IN (
                    SELECT r.*, a.check_in_time, a.check_out_time
                    FROM room r 
                        JOIN accommodation a ON r.seq = a.seq AND r.accom_id = a.accom_id
                    WHERE r.seq = p_accom_seq AND r.accom_id = p_accom_id 
                            AND (
                                    SELECT COUNT(room.room_id)
                                    FROM reservation rsv 
                                        JOIN room ON rsv.room_id = room.room_id 
                                    WHERE room.accom_id = p_accom_id
                                        AND room.seq = p_accom_seq
                                        AND rsv.start_date < TO_DATE(p_start_date) 
                                        AND rsv.end_date <= TO_DATE(p_start_date) 
                                        AND rsv.start_date >= TO_DATE(p_end_date) 
                                        AND rsv.end_date > TO_DATE(p_end_date)
                            ) = 0
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('객실 ID : ' || v_record.room_id || ', ' || 
                            '객실 명 : ' || v_record.room_name || ', ' ||
                            '금액 : ' || v_record.price || ', ' || 
                            '숙박 유형 : ' || v_record.type || ', ' ||
                            '체크인 시간 : ' || v_record.check_in_time || ', ' || 
                            '체크아웃 시간 : ' || v_record.check_out_time
                            );

    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCH_CAPACITY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCH_CAPACITY" -- 희망 인원을 수용하는 호텔 검색 (완성)
(
    p_capacity IN NUMBER 
)
IS
    v_sql VARCHAR2(2000);
    c_capacity SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%TYPE;
    v_accom_rating accommodation.accom_rating%TYPE;
    v_accom_review_count accommodation.accom_review_count%TYPE;
    v_address accommodation.address%TYPE;
    v_min_price room.price%TYPE;

BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address, MIN(price) min_price
              FROM accommodation a
              JOIN room r ON a.seq = r.seq
              WHERE a.accom_id = ''H'' AND capacity >= :p_capacity
              GROUP BY accom_name, accom_rating, accom_review_count, address';

    OPEN c_capacity FOR v_sql USING p_capacity;

    LOOP
        FETCH c_capacity INTO
            v_accom_name,
            v_accom_rating,
            v_accom_review_count,
            v_address,
            v_min_price;

        EXIT WHEN c_capacity%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_accom_name || ' ' || TO_CHAR(v_accom_rating, '90.9') ||
            CASE
                WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN ' 최고에요'
                WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN ' 추천해요'
                WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN ' 만족해요'
                ELSE ' 좋아요'
            END ||
            '(' || v_accom_review_count || ') ' ||
            REGEXP_REPLACE(v_address, '([0-9]|-[0-9])', '') ||
            ' ' || v_min_price || '원'
        );
    END LOOP;

    CLOSE c_capacity;

END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCH_KEYWORD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCH_KEYWORD" -- 숙소 이름/지역으로 검색해서 조회
    (
        p_keyword NVARCHAR2
        , p_accom_id VARCHAR2 := 'MHGPC'
        , p_minprice NUMBER := 0
        , p_maxprice NUMBER := 99999999999
        , p_sort NUMBER := 1  -- 1거리순(추천순) 2낮은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%TYPE;
    v_accom_rating accommodation.accom_rating%TYPE;
    v_accom_review_count accommodation.accom_review_count%TYPE;
    v_address accommodation.address%TYPE;
    v_min_price room.price%TYPE;
BEGIN
    v_sql := 'SELECT DISTINCT accom_name, accom_rating, accom_review_count, address
                    , (SELECT MIN(price) FROM room WHERE seq = a.seq) min_price ';
    v_sql := v_sql||'FROM accommodation a JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE (REPLACE(accom_name, '' '') LIKE ''%'||REPLACE(p_keyword, ' ')||'%''
                           OR REPLACE(address, '' '') LIKE ''%'||REPLACE(p_keyword, ' ')||'%'') ';
    v_sql := v_sql||'AND INSTR(:p_accom_id, a.accom_id) > 0 ';
    v_sql := v_sql||'AND price BETWEEN :p_minprice AND :p_maxprice ';
    IF p_sort=1 THEN
        v_sql := v_sql||'ORDER BY accom_rating*accom_review_count DESC ';
    ELSIF p_sort=2 THEN
        v_sql := v_sql||'ORDER BY min_price ';
    END IF;

    OPEN v_cur FOR v_sql USING p_accom_id, p_minprice, p_maxprice;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])')
                        ||' '||v_min_price||'원');
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_BED
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_BED" -- 베드 타입에 따른 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_single bed_type.single%TYPE := 0    -- 싱글
        , p_double bed_type.double%TYPE := 0    -- 더블
        , p_twin bed_type.twin%TYPE := 0        -- 트윈
        , p_ondol bed_type.ondol%TYPE := 0      -- 온돌
        , p_sort NUMBER := 1
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%TYPE;
    v_accom_rating accommodation.accom_rating%TYPE;
    v_accom_review_count accommodation.accom_review_count%TYPE;
    v_address accommodation.address%TYPE;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN

    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade
              FROM accommodation a JOIN bed_type bt ON a.seq = bt.seq
                                   JOIN room r ON a.seq = r.seq
              WHERE a.accom_id = ''H'' AND address LIKE :p_address || ''%'' ';

    IF p_single =1 THEN
        v_sql := v_sql||'AND single = 1 ';
    END IF;
    IF p_double =1 THEN
        v_sql := v_sql||'AND double = 1 ';
    END IF;
    IF p_twin =1 THEN 
        v_sql := v_sql||'AND twin = 1 ';
    END IF;               
    IF p_ondol =1 THEN
        v_sql := v_sql||'AND ondol = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_DETAIL_ID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_DETAIL_ID" -- 호텔/리조트 유형 조건에 부합하는 호텔 목록 조회
(
    p_address accommodation.address%TYPE := '서울'   -- 지역
   , p_accom_detail_id accommodation.accom_detail_id%TYPE DEFAULT NULL     -- 5성급, 특급, 특1급
   , p_sort NUMBER := 1 -- 1추천순 2낮은가격순 3높은가격순
)
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
    v_detail_title accommodation_info.detail_title%TYPE;
    v_detail_id_range VARCHAR2(60) := SUBSTR(p_accom_detail_id, 1,1);
BEGIN
    -- 성급을 쉼표로 구분된 문자열로 작성
    FOR i IN 2.. LENGTH(p_accom_detail_id)
    LOOP
        v_detail_id_range := v_detail_id_range || ',' || SUBSTR(p_accom_detail_id, i,1);
    END LOOP;

    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title ';
    v_sql := v_sql||'FROM accommodation a 
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''H'' 
                        AND address LIKE :p_address || ''%'' 
                        AND ai.main_cd = ''H'' ';

    IF p_accom_detail_id IS NOT NULL THEN
         v_sql := v_sql||'AND a.accom_detail_id IN (' || v_detail_id_range || ') '; -- 바인드 변수 적용 불가라, 문자열 결합 방식 사용
    END IF;

    v_sql := v_sql || 'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title ';

    IF p_sort = 1 THEN
        v_sql := v_sql || 'ORDER BY ad_grade, accom_rating * accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql || 'ORDER BY min_price, accom_rating * accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql || 'ORDER BY max_price DESC, accom_rating * accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade, v_detail_title;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_detail_title|| ' ' ||v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_ETC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_ETC" -- 기타 서비스 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_with_pet etc.with_pet%TYPE := 0
        , p_breakfast etc.breakfast%TYPE := 0
        , p_smoking etc.smoking%TYPE := 0
        , p_valet_parking etc.valet_parking%TYPE := 0
        , p_non_smoking etc.non_smoking%TYPE := 0
        , p_in_room_cooking etc.in_room_cooking%TYPE := 0
        , p_printer etc.printer%TYPE := 0
        , p_storage etc.storage%TYPE := 0
        , p_personal_locker etc.personal_locker%TYPE := 0
        , p_free_parking etc.free_parking%TYPE := 0
        , p_pick_up_available etc.pick_up_available%TYPE := 0
        , p_campfire etc.campfire%TYPE := 0
        , p_credit_card etc.credit_card%TYPE := 0
        , p_pwd etc.pwd%TYPE := 0
        , p_eq_rental etc.eq_rental%TYPE := 0
        , p_site_park etc.site_park%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade
             FROM accommodation a JOIN etc e ON a.seq = e.seq
                                  JOIN room r ON a.seq = r.seq
             WHERE a.accom_id = ''H'' AND address LIKE :p_address || ''%'' ';

    IF p_with_pet=1 THEN
        v_sql := v_sql||'AND with_pet = 1 ';
    END IF;
    IF p_breakfast=1 THEN
        v_sql := v_sql||'AND breakfast = 1 ';
    END IF;
    IF p_smoking=1 THEN
        v_sql := v_sql||'AND smoking = 1 ';
    END IF;
    IF p_valet_parking=1 THEN
        v_sql := v_sql||'AND valet_parking = 1 ';
    END IF;
    IF p_non_smoking=1 THEN
        v_sql := v_sql||'AND non_smoking = 1 ';
    END IF;
    IF p_in_room_cooking=1 THEN
        v_sql := v_sql||'AND in_room_cooking = 1 ';
    END IF;
    IF p_printer=1 THEN
        v_sql := v_sql||'AND printer = 1 ';
    END IF;
    IF p_storage=1 THEN
        v_sql := v_sql||'AND storage = 1 ';
    END IF;
    IF p_personal_locker=1 THEN
        v_sql := v_sql||'AND personal_locker = 1 ';
    END IF;
    IF p_free_parking=1 THEN
        v_sql := v_sql||'AND free_parking = 1 ';
    END IF;
    IF p_pick_up_available=1 THEN
        v_sql := v_sql||'AND pick_up_available = 1 ';
    END IF;
    IF p_pick_up_available=1 THEN
        v_sql := v_sql||'AND pick_up_available = 1 ';
    END IF;
    IF p_campfire=1 THEN
        v_sql := v_sql||'AND campfire = 1 ';
    END IF;
    IF p_credit_card=1 THEN
        v_sql := v_sql||'AND credit_card = 1 ';
    END IF;
    IF p_pwd=1 THEN
        v_sql := v_sql||'AND pwd = 1 ';
    END IF;
    IF p_eq_rental=1 THEN
        v_sql := v_sql||'AND eq_rental = 1 ';
    END IF;
    IF p_site_park=1 THEN
        v_sql := v_sql||'AND site_park = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_LOC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_LOC" -- 기초자치단체 단위 지역별로 분류된 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울시 강남구'  -- 지역
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade ';
    v_sql := v_sql||'FROM accommodation a JOIN room r ON a.seq = r.seq  ';
    v_sql := v_sql||'WHERE a.accom_id = ''H'' AND address LIKE :p_address||''%''
                         AND (SELECT reservation FROM reservation_option WHERE seq = a.seq) = 1
                    GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    BEGIN
        LOOP
            FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
            EXIT WHEN v_cur%NOTFOUND;
                DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                                    ||' '||CASE
                                           WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                           WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                           WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                           ELSE '좋아요'
                                      END  ||'('||v_accom_review_count||')'
                                    ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])', ''));
            IF p_sort = 3 THEN
                DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
            ELSE
                DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
            END IF;
        END LOOP;
    END;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_PUBFAC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_PUBFAC" -- 공용시설 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_fitness public_facilities.fitness%TYPE := 0
        , p_swimming_pool public_facilities.swimming_pool%TYPE := 0
        , p_sauna public_facilities.sauna%TYPE := 0
        , p_golf_course public_facilities.golf_course%TYPE := 0
        , p_restaurant public_facilities.restaurant%TYPE := 0
        , p_elevator public_facilities.elevator%TYPE := 0
        , p_lounge public_facilities.lounge%TYPE := 0
        , p_public_pc public_facilities.public_pc%TYPE := 0
        , p_bbq public_facilities.bbq%TYPE := 0
        , p_cafe public_facilities.cafe%TYPE := 0
        , p_public_spa public_facilities.public_spa%TYPE := 0
        , p_foot_volleyball public_facilities.foot_volleyball%TYPE := 0
        , p_seminar_room public_facilities.seminar_room%TYPE := 0
        , p_convenience public_facilities.convenience%TYPE := 0
        , p_karaoke public_facilities.karaoke%TYPE := 0
        , p_kitchen public_facilities.kitchen%TYPE := 0
        , p_laundry public_facilities.laundry%TYPE := 0
        , p_dryer public_facilities.dryer%TYPE := 0
        , p_dehydrator public_facilities.dehydrator%TYPE := 0
        , p_parking public_facilities.parking%TYPE := 0
        , p_cooking public_facilities.cooking%TYPE := 0
        , p_public_shower public_facilities.public_shower%TYPE := 0
        , p_hot_spring public_facilities.hot_spring%TYPE := 0
        , p_ski_resort public_facilities.ski_resort%TYPE := 0
        , p_microwave public_facilities.microwave%TYPE := 0
        , p_electrical public_facilities.electrical%TYPE := 0
        , p_sink public_facilities.sink%TYPE := 0
        , p_store public_facilities.store%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade
                        FROM accommodation a JOIN public_facilities pf ON a.seq = pf.seq
                                             JOIN room r ON a.seq = r.seq
                        WHERE a.accom_id = ''H'' AND address LIKE :p_address || ''%'' ';

    IF p_fitness =1 THEN
        v_sql := v_sql||'AND fitness = 1 ';
    END IF;
    IF p_swimming_pool =1 THEN
        v_sql := v_sql||'AND swimming_pool = 1 ';
    END IF;
    IF p_sauna =1 THEN 
        v_sql := v_sql||'AND sauna = 1 ';
    END IF;               
    IF p_golf_course =1 THEN
        v_sql := v_sql||'AND golf_course = 1 ';
    END IF;
    IF p_restaurant =1 THEN
        v_sql := v_sql||'AND restaurant = 1 ';
    END IF;
    IF p_elevator =1 THEN
        v_sql := v_sql||'AND elevator = 1 ';
    END IF;
    IF p_lounge =1 THEN
        v_sql := v_sql||'AND lounge = 1 ';
    END IF;
    IF p_public_pc =1 THEN
        v_sql := v_sql||'AND public_pc = 1 ';
    END IF;
    IF p_bbq =1 THEN
        v_sql := v_sql||'AND bbq = 1 ';
    END IF;
    IF p_cafe =1 THEN
        v_sql := v_sql||'AND cafe = 1 ';
    END IF;
    IF p_public_spa =1 THEN
        v_sql := v_sql||'AND public_spa = 1 ';
    END IF;
    IF p_foot_volleyball =1 THEN
        v_sql := v_sql||'AND foot_volleyball = 1 ';
    END IF;
    IF p_seminar_room =1 THEN
        v_sql := v_sql||'AND seminar_room = 1 ';
    END IF;
    IF p_convenience =1 THEN
        v_sql := v_sql||'AND convenience = 1 ';
    END IF;
    IF p_karaoke =1 THEN
        v_sql := v_sql||'AND karaoke = 1 ';
    END IF;
    IF p_kitchen =1 THEN
        v_sql := v_sql||'AND kitchen = 1 ';
    END IF;
    IF p_laundry =1 THEN
        v_sql := v_sql||'AND laundry = 1 ';
    END IF;
    IF p_dryer =1 THEN
        v_sql := v_sql||'AND dryer = 1 ';
    END IF;
    IF p_dehydrator =1 THEN
        v_sql := v_sql||'AND dehydrator = 1 ';
    END IF;
    IF p_parking =1 THEN
        v_sql := v_sql||'AND parking = 1 ';
    END IF;
    IF p_cooking =1 THEN
        v_sql := v_sql||'AND cooking = 1 ';
    END IF;
    IF p_public_shower =1 THEN
        v_sql := v_sql||'AND public_shower = 1 ';
    END IF;
    IF p_hot_spring =1 THEN
        v_sql := v_sql||'AND hot_spring = 1 ';
    END IF;
    IF p_ski_resort =1 THEN
        v_sql := v_sql||'AND ski_resort = 1 ';
    END IF;
    IF p_microwave =1 THEN
        v_sql := v_sql||'AND microwave = 1 ';
    END IF;
    IF p_electrical =1 THEN
        v_sql := v_sql||'AND electrical = 1 ';
    END IF;
    IF p_sink =1 THEN
        v_sql := v_sql||'AND sink = 1 ';
    END IF;
    IF p_store =1 THEN
        v_sql := v_sql||'AND store  = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_RESEROPTIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_RESEROPTIONS" -- 예약 옵션 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_reservation reservation_option.reservation%TYPE := 0
        , p_promotion reservation_option.promotion%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade ';
    v_sql := v_sql||'FROM accommodation a JOIN reservation_option ro ON a.seq = ro.seq
                                          JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''H'' AND address LIKE :p_address || ''%'' ';

    IF p_reservation = 1 THEN
        v_sql := v_sql||'AND reservation = 1 ';
    END IF;
    IF p_promotion = 1 THEN
        v_sql := v_sql||'AND promotion = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price ASC, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    BEGIN
        LOOP
            FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
            EXIT WHEN v_cur%NOTFOUND;
                DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                                    ||' '||CASE
                                           WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                           WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                           WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                           ELSE '좋아요'
                                      END  ||'('||v_accom_review_count||')'
                                    ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
            IF p_sort = 3 THEN
                DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
            ELSE
                DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
            END IF;
        END LOOP;
    END;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_RFAC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_RFAC" -- 객실 내 시설 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_room_spa room_facilities.room_spa %TYPE := 0
        , p_mini_bar room_facilities.mini_bar %TYPE := 0
        , p_wi_fi room_facilities.wi_fi %TYPE := 0
        , p_toiletries room_facilities.toiletries %TYPE := 0
        , p_tv room_facilities.tv %TYPE := 0
        , p_ac room_facilities.ac %TYPE := 0
      --  , p_refrigerator room_facilities.refrigerator%TYPE := 0
        , p_shower_room room_facilities.shower_room %TYPE := 0
        , p_bathtub room_facilities.bathtub %TYPE := 0
        , p_hair_dryer room_facilities.hair_dryer %TYPE := 0
        , p_iron room_facilities.iron %TYPE := 0
        , p_rice_cooker room_facilities.rice_cooker %TYPE := 0
        , p_power_socket room_facilities.power_socket %TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade
             FROM accommodation a JOIN room_facilities rf ON a.seq = rf.seq
                                  JOIN room r ON a.seq = r.seq
             WHERE a.accom_id = ''H'' AND address LIKE :p_address || ''%'' ';

    IF p_room_spa = 1 THEN
    v_sql := v_sql || 'AND room_spa = 1';
    END IF;
    IF p_mini_bar = 1 THEN
    v_sql := v_sql || 'AND mini_bar = 1';
    END IF;
    IF p_wi_fi = 1 THEN
    v_sql := v_sql || 'AND wi_fi = 1';
    END IF;
    IF p_toiletries = 1 THEN
    v_sql := v_sql || 'AND toiletries = 1';
    END IF;
    IF p_tv = 1 THEN
    v_sql := v_sql || 'AND tv = 1';
    END IF;
    IF p_ac = 1 THEN
    v_sql := v_sql || 'AND ac = 1';
    END IF;
--    IF p_refrigerator = 1 THEN
--    v_sql := v_sql || 'AND refrigerator = 1';
--    END IF;
    IF p_shower_room = 1 THEN
    v_sql := v_sql || 'AND shower_room = 1';
    END IF;
    IF p_bathtub = 1 THEN
    v_sql := v_sql || 'AND bathtub = 1';
    END IF;
    IF p_hair_dryer = 1 THEN
    v_sql := v_sql || 'AND hair_dryer = 1';
    END IF;
    IF p_iron = 1 THEN
    v_sql := v_sql || 'AND iron = 1';
    END IF;
    IF p_rice_cooker = 1 THEN
    v_sql := v_sql || 'AND rice_cooker = 1';
    END IF;
    IF p_power_socket = 1 THEN
    v_sql := v_sql || 'AND power_socket = 1';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHH_TOTAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHH_TOTAL" 
(
-- 지역
    p_address accommodation.address%TYPE := '서울시 강남구'  -- 지역

-- 예약 옵션
    , p_reservation reservation_option.reservation%TYPE := 0
    , p_promotion reservation_option.promotion%TYPE := 0

-- 공용시설
    , p_fitness public_facilities.fitness%TYPE := 0
    , p_swimming_pool public_facilities.swimming_pool%TYPE := 0
    , p_sauna public_facilities.sauna%TYPE := 0
    , p_golf_course public_facilities.golf_course%TYPE := 0
    , p_restaurant public_facilities.restaurant%TYPE := 0
    , p_elevator public_facilities.elevator%TYPE := 0
    , p_lounge public_facilities.lounge%TYPE := 0
    , p_public_pc public_facilities.public_pc%TYPE := 0
    , p_bbq public_facilities.bbq%TYPE := 0
    , p_cafe public_facilities.cafe%TYPE := 0
    , p_public_spa public_facilities.public_spa%TYPE := 0
    , p_foot_volleyball public_facilities.foot_volleyball%TYPE := 0
    , p_seminar_room public_facilities.seminar_room%TYPE := 0
    , p_convenience public_facilities.convenience%TYPE := 0
    , p_karaoke public_facilities.karaoke%TYPE := 0
    , p_kitchen public_facilities.kitchen%TYPE := 0
    , p_laundry public_facilities.laundry%TYPE := 0
    , p_dryer public_facilities.dryer%TYPE := 0
    , p_dehydrator public_facilities.dehydrator%TYPE := 0
    , p_parking public_facilities.parking%TYPE := 0
    , p_cooking public_facilities.cooking%TYPE := 0
    , p_public_shower public_facilities.public_shower%TYPE := 0
    , p_hot_spring public_facilities.hot_spring%TYPE := 0
    , p_ski_resort public_facilities.ski_resort%TYPE := 0
    , p_microwave public_facilities.microwave%TYPE := 0
    , p_electrical public_facilities.electrical%TYPE := 0
    , p_sink public_facilities.sink%TYPE := 0
    , p_store public_facilities.store%TYPE := 0

-- 객실 내 시설
    , p_room_spa room_facilities.room_spa%TYPE := 0
    , p_mini_bar room_facilities.mini_bar%TYPE := 0
    , p_wi_fi room_facilities.wi_fi%TYPE := 0
    , p_toiletries room_facilities.toiletries%TYPE := 0
    , p_tv room_facilities.tv%TYPE := 0
    , p_ac room_facilities.ac%TYPE := 0
    , p_refrigerater room_facilities.refrigerater%TYPE := 0
    , p_shower_room room_facilities.shower_room%TYPE := 0
    , p_bathtub room_facilities.bathtub%TYPE := 0
    , p_hair_dryer room_facilities.hair_dryer%TYPE := 0
    , p_iron room_facilities.iron%TYPE := 0
    , p_rice_cooker room_facilities.rice_cooker%TYPE := 0
    , p_power_socket room_facilities.power_socket%TYPE := 0
    
-- 기타 서비스
    , p_with_pet etc.with_pet%TYPE := 0
    , p_breakfast etc.breakfast%TYPE := 0
    , p_smoking etc.smoking%TYPE := 0
    , p_valet_parking etc.valet_parking%TYPE := 0
    , p_non_smoking etc.non_smoking%TYPE := 0
    , p_in_room_cooking etc.in_room_cooking%TYPE := 0
    , p_printer etc.printer%TYPE := 0
    , p_storage etc.storage%TYPE := 0
    , p_personal_locker etc.personal_locker%TYPE := 0
    , p_free_parking etc.free_parking%TYPE := 0
    , p_pick_UP_SUB_available etc.pick_up_available%TYPE := 0
    , p_campfire etc.campfire%TYPE := 0
    , p_credit_card etc.credit_card%TYPE := 0
    , p_pwd etc.pwd%TYPE := 0
    , p_eq_rental etc.eq_rental%TYPE := 0
    , p_site_park etc.site_park%TYPE := 0

-- 세부 유형
    , p_accom_detail_id accommodation.accom_detail_id%TYPE DEFAULT NULL    -- 5성급, 특급, 특1급

-- 베드 타입
    , p_single bed_type.single%TYPE := 0    -- 싱글
    , p_double bed_type.double%TYPE := 0    -- 더블
    , p_twin bed_type.twin%TYPE := 0        -- 트윈
    , p_ondol bed_type.ondol%TYPE := 0      -- 온돌
    
-- 정렬 방식
    , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
)
IS
    v_sql_loc VARCHAR2(2000);
    v_sql_ReserOptions VARCHAR2(2000);
    v_sql_pubfac VARCHAR2(2000);
    v_sql_rfac VARCHAR2(2000);
    v_sql_etc VARCHAR2(2000);
    v_sql_detail_id VARCHAR2(2000);
    v_sql_bed VARCHAR2(2000);
    v_sql_result CLOB;

    vcursor SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%TYPE;
    v_accom_rating accommodation.accom_rating%TYPE;
    v_accom_review_count accommodation.accom_review_count%TYPE;
    v_address accommodation.address%TYPE;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
    v_detail_title accommodation_info.detail_title%TYPE;

BEGIN
    -- 기존 조건별 프로시저를 편집하여, "SUB_"를 붙여 호출용 프로시저로 만듬
    -- 각 호출용 프로시저는 OUT 파라미터로 동적 쿼리문을 반환
    -- 각 조건은 파라미터명과 같이 입력해서 헷갈리지 않도록 해야 함.
    UP_SUB_searchH_Loc(p_address=>p_address, p_sql=>v_sql_loc);
    UP_SUB_searchH_ReserOptions(p_address=>p_address, p_sql=>v_sql_ReserOptions);
    UP_SUB_searchH_pubfac(p_address=>p_address, p_swimming_pool=> p_swimming_pool, p_sql=>v_sql_pubfac);
    UP_SUB_searchH_rfac(p_address=>p_address, p_hair_dryer=> p_hair_dryer,p_sql=>v_sql_rfac);
    UP_SUB_searchH_etc(p_address=>p_address, p_breakfast=> p_breakfast, p_sql=>v_sql_etc);
    UP_SUB_searchH_detail_id(p_address=>p_address, p_accom_detail_id=>p_accom_detail_id, p_sql=>v_sql_detail_id);
    UP_SUB_searchH_bed(p_address=>p_address, p_double=>p_double, p_sql=>v_sql_bed);

    -- 반환된 동적 쿼리문들을 INTERSECT로 결합하여 교집합인 값만 출력
    v_sql_result := v_sql_loc || ' INTERSECT ' || v_sql_ReserOptions  || ' INTERSECT ' ||
                    v_sql_pubfac || ' INTERSECT ' || v_sql_rfac || ' INTERSECT ' || 
                    v_sql_etc || ' INTERSECT ' || v_sql_detail_id || ' INTERSECT ' || 
                    v_sql_bed;

    -- ORDER BY는 마지막에 붙여야 함.
    IF p_sort = 1 THEN
        v_sql_result := v_sql_result || ' ORDER BY ad_grade, accom_rating DESC, accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql_result := v_sql_result || ' ORDER BY min_price, accom_rating DESC, accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql_result := v_sql_result || ' ORDER BY max_price DESC, accom_rating DESC, accom_review_count DESC';
    END IF;

--        DBMS_OUTPUT.PUT_LINE(v_sql_result); -- 쿼리 확인용

    OPEN vcursor FOR v_sql_result;
    LOOP
        -- INTERSECT 때문에 컬럼 개수를 통일하기 위해, v_detail_title 추가
        FETCH vcursor INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade, v_detail_title;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('------------------------------------------' || CHR(10) ||
                            '숙소명 : ' || v_accom_name || CHR(10) || 
                            '숙소 평점 : ' || v_accom_rating || CHR(10) || 
                            '숙소 리뷰 수 : ' || v_accom_review_count || CHR(10) || 
                            '주소 : ' || v_address || CHR(10) ||
                            '객실 최저가 : ' || v_min_price || CHR(10) || 
                            '객실 최고가 : ' || v_max_price || CHR(10) || 
                            '광고등급 : ' || NVL(TO_CHAR(v_ad_grade), '-') || CHR(10) || 
                            '세부 유형 : ' || v_detail_title
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('------------------------------------------'); -- 닫기
    CLOSE vcursor;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_BNF
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_BNF" -- 특정 혜택을 가진 모텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_cancel_the_reservation motel_benefit.cancel_the_reservation%TYPE := 0
        , p_special_price motel_benefit.special_price%TYPE := 0
        , p_accom_top1000 motel_benefit.accom_top1000%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade ';
    v_sql := v_sql||'FROM accommodation a JOIN motel_benefit mpf ON a.seq = mpf.seq
                                          JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''M'' AND address LIKE :p_address || ''%'' ';
    IF p_cancel_the_reservation =1 THEN
        v_sql := v_sql||'AND cancel_the_reservation = 1 ';
    END IF;
    IF p_special_price =1 THEN
        v_sql := v_sql||'AND special_price = 1 ';
    END IF;
    IF p_accom_top1000 =1 THEN 
        v_sql := v_sql||'AND accom_top1000 = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_LOCCITY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_LOCCITY" -- 광역자치단체 단위 지역별 추천 모텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'  -- 지역
    )
IS
BEGIN
    FOR v_accom IN (SELECT accom_name, accom_rating, accom_review_count, address, ad_grade, MIN(price) min_price
                    FROM accommodation a JOIN room r ON a.seq = r.seq
                    WHERE a.accom_id = 'M' AND address LIKE p_address||'%'
                    GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade
                    ORDER BY ad_grade DESC, accom_rating*accom_review_count DESC)

    LOOP
        DBMS_OUTPUT.PUT_LINE(v_accom.accom_name
                            ||' '||TO_CHAR(v_accom.accom_rating, '90.0')
                            ||' '||CASE
                                   WHEN v_accom.accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom.accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom.accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                              END
                            ||'('||v_accom.accom_review_count||')'
                            ||' '||REGEXP_REPLACE(v_accom.address, '([0-9]|-[0-9])')
                            ||' '||v_accom.min_price||'원');
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_LOCTOWN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_LOCTOWN" -- 기초자치단체 단위 지역별로 분류된 모텔 목록 조회
    (
        p_address accommodation.address%TYPE  -- 지역
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade ';
    v_sql := v_sql||'FROM accommodation a JOIN motel_reservation_options ro ON a.seq = ro.seq
                                          JOIN room r ON a.seq = r.seq  ';
    v_sql := v_sql||'WHERE a.accom_id = ''M'' AND address LIKE :p_address||''%''
                    GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    BEGIN
        LOOP
            FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
            EXIT WHEN v_cur%NOTFOUND;
                DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                                    ||' '||CASE
                                           WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                           WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                           WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                           ELSE '좋아요'
                                      END  ||'('||v_accom_review_count||')'
                                    ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])', ''));
            IF p_sort = 3 THEN
                DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
            ELSE
                DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
            END IF;
        END LOOP;
    END;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_PLAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_PLAY" -- 놀이시설 조건에 부합하는 모텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_m_swimming_pool motel_play_facility.m_swimming_pool%TYPE := 0
        , p_m_karaoke motel_play_facility.m_karaoke%TYPE := 0
        , p_billiard_table motel_play_facility.billiard_table%TYPE := 0
        , p_game_console motel_play_facility.game_console%TYPE := 0
        , p_massage_chair motel_play_facility.massage_chair%TYPE := 0
        , p_couple_pc motel_play_facility.couple_pc%TYPE := 0
        , p_m_mini_bar motel_play_facility.m_mini_bar%TYPE := 0
        , p_tv_3d motel_play_facility.tv_3d%TYPE := 0
        , p_beam_projector motel_play_facility.beam_projector%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade
             FROM accommodation a JOIN motel_play_facility mpf ON a.seq = mpf.seq
                                  JOIN room r ON a.seq = r.seq
             WHERE a.accom_id = ''M'' AND address LIKE :p_address || ''%'' ';
    IF p_m_swimming_pool=1 THEN
        v_sql := v_sql||'AND m_swimming_pool = 1 ';
    END IF;
    IF p_m_karaoke=1 THEN
        v_sql := v_sql||'AND m_karaoke = 1 ';
    END IF;
    IF p_billiard_table=1 THEN 
        v_sql := v_sql||'AND billiard_table = 1 ';
    END IF;               
    IF p_game_console=1 THEN
        v_sql := v_sql||'AND game_console = 1 ';
    END IF;
    IF p_massage_chair=1 THEN
        v_sql := v_sql||'AND massage_chair = 1 ';
    END IF;
    IF p_couple_pc=1 THEN
        v_sql := v_sql||'AND couple_pc = 1 ';
    END IF;
    IF p_m_mini_bar=1 THEN
        v_sql := v_sql||'AND m_mini_bar = 1 ';
    END IF;
    IF p_tv_3d=1 THEN
        v_sql := v_sql||'AND tv_3d = 1 ';
    END IF;
    IF p_beam_projector=1 THEN
        v_sql := v_sql||'AND beam_projector = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_PRICE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_PRICE" -- 희망 가격의 객실을 가진 모텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_minprice NUMBER := 0
        , p_maxprice NUMBER := 99999999999
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%TYPE;
    v_accom_rating accommodation.accom_rating%TYPE;
    v_accom_review_count accommodation.accom_review_count%TYPE;
    v_address accommodation.address%TYPE;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_reviewvalue NUMBER;
    v_ad_grade accommodation.ad_grade%TYPE;
    v_rating_review_product NUMBER;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                    , MIN(price) min_price
                    , MAX(price) max_price
                    , ad_grade, accom_rating*accom_review_count
             FROM accommodation a JOIN room r ON a.seq = r.seq
             WHERE a.accom_id = ''M'' AND address LIKE :p_address || ''%'' 
                   AND price BETWEEN :p_minprice AND :p_maxprice
             GROUP BY accom_name, accom_rating, accom_review_count, address
                    , ad_grade, accom_rating*accom_review_count ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address, p_minprice, p_maxprice;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price
                      , v_ad_grade, v_rating_review_product;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_RESEROPTIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_RESEROPTIONS" -- 예약 옵션 조건에 부합하는 모텔 목록 조회
    (
        p_address accommodation.address%TYPE   -- 지역
        , p_accom_reservation motel_reservation_options.accom_reservation%TYPE := 0
        , p_rental_room motel_reservation_options.rental_room%TYPE := 0
        , p_off50  motel_reservation_options.off50%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade ';
    v_sql := v_sql||'FROM accommodation a JOIN motel_reservation_options ro ON a.seq = ro.seq
                                          JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''M'' AND address LIKE :p_address || ''%'' ';

    IF p_accom_reservation = 1 THEN
        v_sql := v_sql||'AND accom_reservation = 1 ';
    END IF;
    IF p_rental_room = 1 THEN
        v_sql := v_sql||'AND rental_room = 1 ';
    END IF;
    IF p_off50 = 1 THEN 
        v_sql := v_sql||'AND off50 = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    BEGIN
        LOOP
            FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
            EXIT WHEN v_cur%NOTFOUND;
                DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                                    ||' '||CASE
                                           WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                           WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                           WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                           ELSE '좋아요'
                                      END  ||'('||v_accom_review_count||')'
                                    ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
            IF p_sort = 3 THEN
                DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
            ELSE
                DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
            END IF;
        END LOOP;
    END;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_SPA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_SPA" -- 스파시설 조건에 부합하는 모텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_spa_whirlpool_bathtub motel_spafacilities.spa_whirlpool_bathtub%TYPE := 0
        , p_sauna_jjimjilbang motel_spafacilities.sauna_jjimjilbang%TYPE := 0
        , p_massage_bed motel_spafacilities.massage_bed%TYPE := 0
        , p_hinoki_bath motel_spafacilities.hinoki_bath%TYPE := 0
        , p_open_air_bath motel_spafacilities.open_air_bath%TYPE := 0
        , p_half_bath motel_spafacilities.half_bath%TYPE := 0
        , p_bathroom_tv motel_spafacilities.bathroom_tv%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade ';
    v_sql := v_sql||'FROM accommodation a JOIN motel_spafacilities mpf ON a.seq = mpf.seq
                                          JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''M'' AND address LIKE :p_address || ''%'' ';
    IF p_spa_whirlpool_bathtub =1 THEN
        v_sql := v_sql||'AND spa_whirlpool_bathtub = 1 ';
    END IF;
    IF p_sauna_jjimjilbang =1 THEN
        v_sql := v_sql||'AND sauna_jjimjilbang = 1 ';
    END IF;
    IF p_massage_bed =1 THEN 
        v_sql := v_sql||'AND massage_bed = 1 ';
    END IF;               
    IF p_hinoki_bath =1 THEN
        v_sql := v_sql||'AND hinoki_bath = 1 ';
    END IF;
    IF p_open_air_bath =1 THEN
        v_sql := v_sql||'AND open_air_bath = 1 ';
    END IF;
    IF p_half_bath =1 THEN
        v_sql := v_sql||'AND half_bath = 1 ';
    END IF;
    IF p_bathroom_tv =1 THEN
        v_sql := v_sql||'AND bathroom_tv = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEARCHM_UNQTHEME
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEARCHM_UNQTHEME" -- 이색테마 조건에 부합하는 모텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_unmanned motel_uniquetheme.unmanned%TYPE := 0
        , p_party_room motel_uniquetheme.party_room%TYPE := 0
        , p_mirror_room motel_uniquetheme.mirror_room%TYPE := 0
        , p_duplex_room motel_uniquetheme.duplex_room%TYPE := 0
        , p_princess_room motel_uniquetheme.princess_room%TYPE := 0
        , p_twin_bed motel_uniquetheme.twin_bed%TYPE := 0
        , p_outdoor_terrace motel_uniquetheme.outdoor_terrace%TYPE := 0
        , p_ocean_view motel_uniquetheme.ocean_view%TYPE := 0
        , p_lake_view motel_uniquetheme.lake_view%TYPE := 0
        , p_sky_view motel_uniquetheme.sky_view%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade
                        FROM accommodation a JOIN motel_uniquetheme mu ON a.seq = mu.seq
                                             JOIN room r ON a.seq = r.seq
                        WHERE a.accom_id = ''M'' AND address LIKE :p_address || ''%'' ';

    IF p_unmanned=1 THEN
        v_sql := v_sql||'AND unmanned = 1 ';
    END IF;
    IF p_party_room=1 THEN
        v_sql := v_sql||'AND party_room = 1 ';
    END IF;
    IF p_mirror_room=1 THEN 
        v_sql := v_sql||'AND mirror_room = 1 ';
    END IF;               
    IF p_duplex_room=1 THEN
        v_sql := v_sql||'AND duplex_room = 1 ';
    END IF;
    IF p_princess_room=1 THEN
        v_sql := v_sql||'AND princess_room = 1 ';
    END IF;
    IF p_twin_bed=1 THEN
        v_sql := v_sql||'AND twin_bed = 1 ';
    END IF;
    IF p_outdoor_terrace=1 THEN
        v_sql := v_sql||'AND outdoor_terrace = 1 ';
    END IF;
    IF p_ocean_view=1 THEN
        v_sql := v_sql||'AND ocean_view = 1 ';
    END IF;
    IF p_lake_view=1 THEN
        v_sql := v_sql||'AND lake_view = 1 ';
    END IF;
    IF p_sky_view=1 THEN
        v_sql := v_sql||'AND sky_view = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade ';

    IF p_sort = 1 THEN
        v_sql := v_sql||'ORDER BY ad_grade, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 2 THEN
        v_sql := v_sql||'ORDER BY min_price, accom_rating*accom_review_count DESC';
    ELSIF p_sort = 3 THEN
        v_sql := v_sql||'ORDER BY max_price DESC, accom_rating*accom_review_count DESC';
    END IF;

    OPEN v_cur FOR v_sql USING p_address;
    LOOP
        FETCH v_cur INTO v_accom_name, v_accom_rating, v_accom_review_count, v_address, v_min_price, v_max_price, v_ad_grade;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT(v_accom_name||TO_CHAR(v_accom_rating, '90.0')
                        ||' '||CASE
                                   WHEN v_accom_rating BETWEEN 9.5 AND 10.0 THEN '최고에요'
                                   WHEN v_accom_rating BETWEEN 9.0 AND 9.5 THEN '추천해요'
                                   WHEN v_accom_rating BETWEEN 8.0 AND 9.0 THEN '만족해요'
                                   ELSE '좋아요'
                               END  ||'('||v_accom_review_count||')'
                        ||' '||REGEXP_REPLACE(v_address, '([0-9]|-[0-9])'));
         IF p_sort = 3 THEN
            DBMS_OUTPUT.PUT_LINE(v_max_price || '원');
         ELSE
            DBMS_OUTPUT.PUT_LINE(v_min_price || '원');
         END IF;
    END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SEL_RESERVATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SEL_RESERVATION" 
(
 p_user_id VARCHAR2,
 p_room_id NUMBER
)
IS
 v_start_date DATE;
 v_end_date  DATE;
 v_reservation_id  VARCHAR2(100);
 v_user_id VARCHAR2(100);
 v_safety_number VARCHAR2(50);
 v_status VARCHAR2(50);
BEGIN
SELECT r.start_date,r.end_date, r.reservation_id,m.user_id,s.safety_number,r.status
INTO v_start_date,v_end_date,v_reservation_id,v_user_id,v_safety_number,v_status
FROM RESERVATION r , member m, safety_number s
WHERE r.user_id = m.user_id
AND   m.user_id = s.user_id
AND   r.user_id = p_user_id
AND   r.room_id = p_room_id;
 DBMS_OUTPUT.PUT_LINE( '상태 : ' || v_status);
 DBMS_OUTPUT.PUT_LINE('체크인 : ' || v_start_date);
 DBMS_OUTPUT.PUT_LINE('체크아웃 : ' || v_end_date);
 DBMS_OUTPUT.PUT_LINE('예약번호 : ' || v_reservation_id);
 DBMS_OUTPUT.PUT_LINE('예약자이름 : ' ||  v_user_id);
 DBMS_OUTPUT.PUT_LINE('안심번호 : ' || v_safety_number);                       
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_BED
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_BED" -- 베드 타입에 따른 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_single bed_type.single%TYPE := 0    -- 싱글
        , p_double bed_type.double%TYPE := 0    -- 더블
        , p_twin bed_type.twin%TYPE := 0        -- 트윈
        , p_ondol bed_type.ondol%TYPE := 0      -- 온돌
        , p_sort NUMBER := 1
        , p_sql OUT VARCHAR2
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%TYPE;
    v_accom_rating accommodation.accom_rating%TYPE;
    v_accom_review_count accommodation.accom_review_count%TYPE;
    v_address accommodation.address%TYPE;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN

    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title 
              FROM accommodation a  
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN bed_type bt ON a.seq = bt.seq
                                   JOIN room r ON a.seq = r.seq
              WHERE a.accom_id = ''H'' AND address LIKE ''' || p_address || '%'' ';

    IF p_single =1 THEN
        v_sql := v_sql||'AND single = 1 ';
    END IF;
    IF p_double =1 THEN
        v_sql := v_sql||'AND double = 1 ';
    END IF;
    IF p_twin =1 THEN 
        v_sql := v_sql||'AND twin = 1 ';
    END IF;               
    IF p_ondol =1 THEN
        v_sql := v_sql||'AND ondol = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title  ';

    p_sql := v_sql;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_DETAIL_ID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_DETAIL_ID" -- 호텔/리조트 유형 조건에 부합하는 호텔 목록 조회
(
    p_address accommodation.address%TYPE := '서울'   -- 지역
   , p_accom_detail_id VARCHAR2 DEFAULT NULL     -- 5성급, 특급, 특1급
   , p_sort NUMBER := 1 -- 1추천순 2낮은가격순 3높은가격순
   , p_sql OUT VARCHAR2
)
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
    v_detail_title accommodation_info.detail_title%TYPE;
    v_detail_id_range VARCHAR2(60) := SUBSTR(p_accom_detail_id, 1,1);
BEGIN
    -- 성급을 쉼표로 구분된 문자열로 작성
    FOR i IN 2.. LENGTH(p_accom_detail_id)
    LOOP
        v_detail_id_range := v_detail_id_range || ',' || SUBSTR(p_accom_detail_id, i,1);
    END LOOP;

    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title ';
    v_sql := v_sql||'FROM accommodation a 
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''H'' 
                        AND address LIKE ''' || p_address || '%'' ' || 
                        'AND ai.main_cd = ''H'' ';

    IF p_accom_detail_id IS NOT NULL THEN
         v_sql := v_sql||'AND a.accom_detail_id IN (' || v_detail_id_range || ') '; -- 바인드 변수 적용 불가라, 문자열 결합 방식 사용
    END IF;

    v_sql := v_sql || 'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title ';

    p_sql := v_sql;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_ETC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_ETC" -- 기타 서비스 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_with_pet etc.with_pet%TYPE := 0
        , p_breakfast etc.breakfast%TYPE := 0
        , p_smoking etc.smoking%TYPE := 0
        , p_valet_parking etc.valet_parking%TYPE := 0
        , p_non_smoking etc.non_smoking%TYPE := 0
        , p_in_room_cooking etc.in_room_cooking%TYPE := 0
        , p_printer etc.printer%TYPE := 0
        , p_storage etc.storage%TYPE := 0
        , p_personal_locker etc.personal_locker%TYPE := 0
        , p_free_parking etc.free_parking%TYPE := 0
        , p_pick_UP_SUB_available etc.pick_up_available%TYPE := 0
        , p_campfire etc.campfire%TYPE := 0
        , p_credit_card etc.credit_card%TYPE := 0
        , p_pwd etc.pwd%TYPE := 0
        , p_eq_rental etc.eq_rental%TYPE := 0
        , p_site_park etc.site_park%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
        , p_sql OUT VARCHAR2
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title 
             FROM accommodation a  
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN etc e ON a.seq = e.seq
                                  JOIN room r ON a.seq = r.seq
             WHERE a.accom_id = ''H'' AND address LIKE ''' || p_address || '%'' ';

    IF p_with_pet=1 THEN
        v_sql := v_sql||'AND with_pet = 1 ';
    END IF;
    IF p_breakfast=1 THEN
        v_sql := v_sql||'AND breakfast = 1 ';
    END IF;
    IF p_smoking=1 THEN
        v_sql := v_sql||'AND smoking = 1 ';
    END IF;
    IF p_valet_parking=1 THEN
        v_sql := v_sql||'AND valet_parking = 1 ';
    END IF;
    IF p_non_smoking=1 THEN
        v_sql := v_sql||'AND non_smoking = 1 ';
    END IF;
    IF p_in_room_cooking=1 THEN
        v_sql := v_sql||'AND in_room_cooking = 1 ';
    END IF;
    IF p_printer=1 THEN
        v_sql := v_sql||'AND printer = 1 ';
    END IF;
    IF p_storage=1 THEN
        v_sql := v_sql||'AND storage = 1 ';
    END IF;
    IF p_personal_locker=1 THEN
        v_sql := v_sql||'AND personal_locker = 1 ';
    END IF;
    IF p_free_parking=1 THEN
        v_sql := v_sql||'AND free_parking = 1 ';
    END IF;
    IF p_pick_UP_SUB_available=1 THEN
        v_sql := v_sql||'AND pick_UP_SUB_available = 1 ';
    END IF;
    IF p_pick_UP_SUB_available=1 THEN
        v_sql := v_sql||'AND pick_UP_SUB_available = 1 ';
    END IF;
    IF p_campfire=1 THEN
        v_sql := v_sql||'AND campfire = 1 ';
    END IF;
    IF p_credit_card=1 THEN
        v_sql := v_sql||'AND credit_card = 1 ';
    END IF;
    IF p_pwd=1 THEN
        v_sql := v_sql||'AND pwd = 1 ';
    END IF;
    IF p_eq_rental=1 THEN
        v_sql := v_sql||'AND eq_rental = 1 ';
    END IF;
    IF p_site_park=1 THEN
        v_sql := v_sql||'AND site_park = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title  ';

    p_sql := v_sql;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_LOC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_LOC" 
(
    p_address accommodation.address%TYPE := '서울시 강남구'  -- 지역
    , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
    , p_sql OUT VARCHAR2
)
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade , ai.detail_title ';
    v_sql := v_sql||'FROM accommodation a 
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN room r ON a.seq = r.seq  ';
    v_sql := v_sql||'WHERE a.accom_id = ''H'' AND address LIKE ''' || p_address || '%'' ' ||
                         'AND (SELECT reservation FROM reservation_option WHERE seq = a.seq) = 1 
                    GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title  ';

    p_sql := v_sql;

END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_PUBFAC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_PUBFAC" -- 공용시설 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_fitness public_facilities.fitness%TYPE := 0
        , p_swimming_pool public_facilities.swimming_pool%TYPE := 0
        , p_sauna public_facilities.sauna%TYPE := 0
        , p_golf_course public_facilities.golf_course%TYPE := 0
        , p_restaurant public_facilities.restaurant%TYPE := 0
        , p_elevator public_facilities.elevator%TYPE := 0
        , p_lounge public_facilities.lounge%TYPE := 0
        , p_public_pc public_facilities.public_pc%TYPE := 0
        , p_bbq public_facilities.bbq%TYPE := 0
        , p_cafe public_facilities.cafe%TYPE := 0
        , p_public_spa public_facilities.public_spa%TYPE := 0
        , p_foot_volleyball public_facilities.foot_volleyball%TYPE := 0
        , p_seminar_room public_facilities.seminar_room%TYPE := 0
        , p_convenience public_facilities.convenience%TYPE := 0
        , p_karaoke public_facilities.karaoke%TYPE := 0
        , p_kitchen public_facilities.kitchen%TYPE := 0
        , p_laundry public_facilities.laundry%TYPE := 0
        , p_dryer public_facilities.dryer%TYPE := 0
        , p_dehydrator public_facilities.dehydrator%TYPE := 0
        , p_parking public_facilities.parking%TYPE := 0
        , p_cooking public_facilities.cooking%TYPE := 0
        , p_public_shower public_facilities.public_shower%TYPE := 0
        , p_hot_spring public_facilities.hot_spring%TYPE := 0
        , p_ski_resort public_facilities.ski_resort%TYPE := 0
        , p_microwave public_facilities.microwave%TYPE := 0
        , p_electrical public_facilities.electrical%TYPE := 0
        , p_sink public_facilities.sink%TYPE := 0
        , p_store public_facilities.store%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
        , p_sql OUT VARCHAR2
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title 
                        FROM accommodation a  
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN public_facilities pf ON a.seq = pf.seq
                                             JOIN room r ON a.seq = r.seq
                        WHERE a.accom_id = ''H'' AND address LIKE ''' || p_address || '%'' ';

    IF p_fitness =1 THEN
        v_sql := v_sql||'AND fitness = 1 ';
    END IF;
    IF p_swimming_pool =1 THEN
        v_sql := v_sql||'AND swimming_pool = 1 ';
    END IF;
    IF p_sauna =1 THEN 
        v_sql := v_sql||'AND sauna = 1 ';
    END IF;               
    IF p_golf_course =1 THEN
        v_sql := v_sql||'AND golf_course = 1 ';
    END IF;
    IF p_restaurant =1 THEN
        v_sql := v_sql||'AND restaurant = 1 ';
    END IF;
    IF p_elevator =1 THEN
        v_sql := v_sql||'AND elevator = 1 ';
    END IF;
    IF p_lounge =1 THEN
        v_sql := v_sql||'AND lounge = 1 ';
    END IF;
    IF p_public_pc =1 THEN
        v_sql := v_sql||'AND public_pc = 1 ';
    END IF;
    IF p_bbq =1 THEN
        v_sql := v_sql||'AND bbq = 1 ';
    END IF;
    IF p_cafe =1 THEN
        v_sql := v_sql||'AND cafe = 1 ';
    END IF;
    IF p_public_spa =1 THEN
        v_sql := v_sql||'AND public_spa = 1 ';
    END IF;
    IF p_foot_volleyball =1 THEN
        v_sql := v_sql||'AND foot_volleyball = 1 ';
    END IF;
    IF p_seminar_room =1 THEN
        v_sql := v_sql||'AND seminar_room = 1 ';
    END IF;
    IF p_convenience =1 THEN
        v_sql := v_sql||'AND convenience = 1 ';
    END IF;
    IF p_karaoke =1 THEN
        v_sql := v_sql||'AND karaoke = 1 ';
    END IF;
    IF p_kitchen =1 THEN
        v_sql := v_sql||'AND kitchen = 1 ';
    END IF;
    IF p_laundry =1 THEN
        v_sql := v_sql||'AND laundry = 1 ';
    END IF;
    IF p_dryer =1 THEN
        v_sql := v_sql||'AND dryer = 1 ';
    END IF;
    IF p_dehydrator =1 THEN
        v_sql := v_sql||'AND dehydrator = 1 ';
    END IF;
    IF p_parking =1 THEN
        v_sql := v_sql||'AND parking = 1 ';
    END IF;
    IF p_cooking =1 THEN
        v_sql := v_sql||'AND cooking = 1 ';
    END IF;
    IF p_public_shower =1 THEN
        v_sql := v_sql||'AND public_shower = 1 ';
    END IF;
    IF p_hot_spring =1 THEN
        v_sql := v_sql||'AND hot_spring = 1 ';
    END IF;
    IF p_ski_resort =1 THEN
        v_sql := v_sql||'AND ski_resort = 1 ';
    END IF;
    IF p_microwave =1 THEN
        v_sql := v_sql||'AND microwave = 1 ';
    END IF;
    IF p_electrical =1 THEN
        v_sql := v_sql||'AND electrical = 1 ';
    END IF;
    IF p_sink =1 THEN
        v_sql := v_sql||'AND sink = 1 ';
    END IF;
    IF p_store =1 THEN
        v_sql := v_sql||'AND store  = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title  ';

    p_sql := v_sql;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_RESEROPTIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_RESEROPTIONS" -- 예약 옵션 조건에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_reservation reservation_option.reservation%TYPE := 0
        , p_promotion reservation_option.promotion%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
        , p_sql OUT VARCHAR2
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title  ';
    v_sql := v_sql||'FROM accommodation a  
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN reservation_option ro ON a.seq = ro.seq
                                          JOIN room r ON a.seq = r.seq ';
    v_sql := v_sql||'WHERE a.accom_id = ''H'' AND address LIKE ''' || p_address || '%'' ';

    IF p_reservation = 1 THEN
        v_sql := v_sql||'AND reservation = 1 ';
    END IF;
    IF p_promotion = 1 THEN
        v_sql := v_sql||'AND promotion = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title  ';

    p_sql := v_sql;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_SUB_SEARCHH_RFAC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_SUB_SEARCHH_RFAC" -- 객실 내 시설에 부합하는 호텔 목록 조회
    (
        p_address accommodation.address%TYPE := '서울'   -- 지역
        , p_room_spa room_facilities.room_spa%TYPE := 0
        , p_mini_bar room_facilities.mini_bar%TYPE := 0
        , p_wi_fi room_facilities.wi_fi%TYPE := 0
        , p_toiletries room_facilities.toiletries%TYPE := 0
        , p_tv room_facilities.tv%TYPE := 0
        , p_ac room_facilities.ac%TYPE := 0
        , p_refrigerater room_facilities.refrigerater%TYPE := 0
        , p_shower_room room_facilities.shower_room%TYPE := 0
        , p_bathtub room_facilities.bathtub%TYPE := 0
        , p_hair_dryer room_facilities.hair_dryer%TYPE := 0
        , p_iron room_facilities.iron%TYPE := 0
        , p_rice_cooker room_facilities.rice_cooker%TYPE := 0
        , p_power_socket room_facilities.power_socket%TYPE := 0
        , p_sort NUMBER := 1     -- 1거리순(광고순) 2낮은가격순 3높은가격순
        , p_sql OUT VARCHAR2
    )
IS
    v_sql VARCHAR2(2000);
    v_cur SYS_REFCURSOR;
    v_accom_name accommodation.accom_name%type;
    v_accom_rating accommodation.accom_rating%type;
    v_accom_review_count accommodation.accom_review_count%type;
    v_address accommodation.address%type;
    v_min_price room.price%TYPE;
    v_max_price room.price%TYPE;
    v_ad_grade accommodation.ad_grade%TYPE;
BEGIN
    v_sql := 'SELECT accom_name, accom_rating, accom_review_count, address 
                        , MIN(price) min_price
                        , MAX(price) max_price
                        , ad_grade, ai.detail_title 
             FROM accommodation a  
                        JOIN accommodation_info ai ON a.accom_detail_id = ai.sub_cd AND a.accom_id = ai.main_cd
                        JOIN room_facilities rf ON a.seq = rf.seq
                                  JOIN room r ON a.seq = r.seq
             WHERE a.accom_id = ''H'' AND address LIKE ''' || p_address || '%'' ';

    IF p_room_spa=1 THEN
        v_sql := v_sql||'AND room_spa = 1 ';
    END IF;
    IF p_mini_bar=1 THEN
        v_sql := v_sql||'AND mini_bar = 1 ';
    END IF;
    IF p_wi_fi=1 THEN
        v_sql := v_sql||'AND wi_fi = 1 ';
    END IF;
    IF p_toiletries=1 THEN
        v_sql := v_sql||'AND toiletries = 1 ';
    END IF;
    IF p_tv=1 THEN
        v_sql := v_sql||'AND tv = 1 ';
    END IF;
    IF p_ac=1 THEN
        v_sql := v_sql||'AND ac = 1 ';
    END IF;
    IF p_refrigerater=1 THEN
        v_sql := v_sql||'AND refrigerater = 1 ';
    END IF;
    IF p_shower_room=1 THEN
        v_sql := v_sql||'AND shower_room = 1 ';
    END IF;
    IF p_bathtub=1 THEN
        v_sql := v_sql||'AND bathtub = 1 ';
    END IF;
    IF p_hair_dryer=1 THEN
        v_sql := v_sql||'AND hair_dryer = 1 ';
    END IF;
    IF p_iron=1 THEN
        v_sql := v_sql||'AND iron = 1 ';
    END IF;
    IF p_rice_cooker=1 THEN
        v_sql := v_sql||'AND rice_cooker = 1 ';
    END IF;
    IF p_power_socket=1 THEN
        v_sql := v_sql||'AND power_socket = 1 ';
    END IF;

    v_sql := v_sql||'GROUP BY accom_name, accom_rating, accom_review_count, address, ad_grade, ai.detail_title  ';


    p_sql := v_sql;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_UPDATEMEMBERINFO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_UPDATEMEMBERINFO" 
(
	p_userId member.user_id%TYPE DEFAULT NULL
	, p_newName member.user_name%TYPE DEFAULT NULL
	, p_newNickname member.user_nickname%TYPE DEFAULT NULL
	, p_newPhoneNumber member.phone_number%TYPE DEFAULT NULL
	, p_user_pw member.user_pw%TYPE DEFAULT NULL
	, p_newPassword member.user_pw%TYPE DEFAULT NULL
)
IS
	v_user_pw member.user_pw%TYPE;

BEGIN
	IF p_newName IS NOT NULL THEN
		UPDATE member
		SET user_name = p_newName
		WHERE user_id = p_userId;
        DBMS_OUTPUT.PUT_LINE('ID : ' || p_userId || '의 예약자 이름을 ' || p_newName || ' (으)로 변경하였습니다.');
	END IF;

	IF p_newNickname IS NOT NULL THEN	
		UPDATE member
		SET user_nickname = p_newNickname
		WHERE user_id = p_userId;
        DBMS_OUTPUT.PUT_LINE('ID : ' || p_userId || '의 닉네임을 ' || p_newNickname || ' (으)로 변경하였습니다.');
	END IF;

	IF p_newPhoneNumber IS NOT NULL THEN
		UPDATE member
		SET phone_number = p_newPhoneNumber
		WHERE user_id = p_userId;
        DBMS_OUTPUT.PUT_LINE('ID : ' || p_userId || '의 휴대폰 번호를 ' || p_newPhoneNumber || ' (으)로 변경하였습니다.');
	END IF;

	IF p_user_pw IS NOT NULL AND p_newPassword IS NOT NULL THEN
		SELECT user_pw INTO v_user_pw
		FROM member
		WHERE user_id = p_userId;

		IF v_user_pw = p_user_pw THEN
			UPDATE member
			SET user_pw = p_newPassword
			WHERE user_id = p_userId;
            DBMS_OUTPUT.PUT_LINE('ID : ' || p_userId || '의 비밀번호를 변경하였습니다.');
		ELSE
            DBMS_OUTPUT.PUT_LINE('ID : ' || p_userId || '의 비밀번호 변경이 실패했습니다. 에러를 확인해주세요!!');
			RAISE_APPLICATION_ERROR(-20999, '> 기존 비밀번호가 일치하지 않습니다!!');
		END IF;

	END IF;

	COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_UPDATEUSEDCOUPON
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_UPDATEUSEDCOUPON" 
(
    p_coupon_id coupon_status.coupon_id%TYPE
)
IS
BEGIN
    UPDATE coupon_status
    SET status = 1
    WHERE coupon_id = p_coupon_id;

    DBMS_OUTPUT.PUT_LINE('쿠폰ID : ' || p_coupon_id || ', 사용 처리하였습니다.');
END;

/
--------------------------------------------------------
--  DDL for Procedure UP_UPDATEUSEDPOINT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GOODCHOICE"."UP_UPDATEUSEDPOINT" 
(
    p_usedpoint point_detail.usepoint%TYPE
    , p_user_id point_history.user_id%TYPE
)
IS
    v_usedpoint point_detail.usepoint%TYPE := p_usedpoint;
    v_eachpoint POINT_HISTORY.BALANCE%TYPE;
    v_gap NUMBER DEFAULT 0;
	v_user_points member.user_points%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('회원 사용 가능 포인트 차감 : -' || v_usedpoint);
    UPDATE member 
    SET user_points = user_points - v_usedpoint
    WHERE user_id = p_user_id;

    FOR v_row IN(SELECT point_id, balance
                    FROM point_history
                    WHERE user_id = p_user_id
                    AND status = 0)
    LOOP
        v_eachpoint := v_row.balance;
        DBMS_OUTPUT.PUT_LINE('각 포인트 ID에 대해 차감 진행 중. 잔여 차감액 : ' || v_usedpoint);
        IF v_usedpoint >= v_eachpoint THEN -- 차감해야 할 포인트가 개별 포인트의 잔액보다 큼

            v_usedpoint := v_usedpoint - v_eachpoint;
            -- 적립된 포인트 잔액을 0으로 갱신하고 사용 처리
            UPDATE point_history 
            SET balance = 0, status = 1
            WHERE point_id = v_row.point_id;

            -- 차감된 포인트 내역을 기록
            INSERT INTO USED_POINT
            VALUES(POINT_LOG_SEQ.NEXTVAL, p_user_id, v_eachpoint, 'A',SYSDATE); 
            DBMS_OUTPUT.PUT_LINE('포인트 ID : ' || v_row.point_id || ', 전액 사용(' || v_eachpoint || ')');

            INSERT INTO POINT_DETAIL
            VALUES(POINT_LOG_SEQ.CURRVAL, v_row.point_id, v_eachpoint); 

        ELSIF v_usedpoint < v_eachpoint THEN -- 차감해야 할 포인트가 개별 포인트의 잔액보다 작음
            v_gap := v_eachpoint - v_usedpoint;

            -- 차감된 포인트 내역을 기록
            INSERT INTO USED_POINT
            VALUES(POINT_LOG_SEQ.NEXTVAL, p_user_id, v_usedpoint, 'A',SYSDATE); 

            INSERT INTO POINT_DETAIL
            VALUES(POINT_LOG_SEQ.CURRVAL, v_row.point_id, v_usedpoint); 

            DBMS_OUTPUT.PUT_LINE('포인트 ID : ' || v_row.point_id || ' 의 잔액 :' || v_gap);

            -- 적립된 포인트 잔액을 남은 잔액으로 갱신
            UPDATE point_history 
            SET balance = v_gap
            WHERE point_id = v_row.point_id;

			-- 포인트 차감 작업 완료
            v_usedpoint := 0; 
        END IF;   

    EXIT WHEN v_usedpoint = 0;
    END LOOP;
    COMMIT;

	-- 회원의 사용 가능 포인트 갱신
	SELECT SUM(balance) INTO v_user_points
    FROM point_history
    WHERE user_id = p_user_id;

	UPDATE member
    SET user_points = v_user_points
    WHERE user_id = p_user_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('포인트 사용 처리 완료하였습니다.');

END;

/
