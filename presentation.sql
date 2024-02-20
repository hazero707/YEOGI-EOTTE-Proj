-- 회원가입 및 로그인 -----------------------------------------------------------
EXEC up_insert_member('easy0525@naver.com', '1234456', '이지현', '010-5523-4090');
                    -- 아이디                  pw        닉네임       전화번호

SELECT *
FROM member;

EXEC up_login('easy0525@naver.com', '4834587');    -- 잘못된 비밀번호
EXEC up_login('easy0525@naver.com', '1234456');   -- 로그인 성공


-- 숙소 검색 -------------------------------------------------------------------
-- 1) 숙소 이름/지역으로 검색

-- 공백 처리
EXEC up_search_Keyword('강남캠퍼스');
EXEC up_search_Keyword('강 남');
-- 숙소 유형 검색
EXEC up_search_Keyword('강남', 'M');
-- 가격 검색
EXEC up_search_Keyword('강남', 'MH', 20000);
-- 정렬
EXEC up_search_Keyword('강남', 'MH', 10000, 100000, 2);
EXEC up_search_Keyword('강남', 'MH', p_sort=>1);


-- 2) 조건 선택해서 검색
EXEC up_searchH_total(p_address=>'경기 가평군', p_reservation => 1, p_swimming_pool=>1, p_hair_dryer=>1, p_breakfast=>1, p_accom_detail_id=>356, p_double=>1, p_sort=>1);
EXEC up_searchH_total(p_address=>'경기', p_swimming_pool=>1, p_hair_dryer=>1, p_breakfast=>1, p_accom_detail_id=>356, p_double=>1, p_sort=>2);


-- 3) 선택한 숙소의 정보 조회
EXEC UP_Get_Accom_Info(7);


-- 4) 선택한 숙소의 객실 정보 조회
EXEC up_Get_Room_Info(7);


-- 5) 리뷰 정보 조회
EXEC up_get_best_reviews(8, 'H');


-- 숙소 예약 -------------------------------------------------------------------
-- 1) 사용 가능 쿠폰 조회
EXEC up_getlistofavailableCoupons('alicia_walker82@naver.com', '23/10/10', 'H', '숙박', 100000);

-- 2) 사용 가능 포인트 조회
EXEC up_getavailablepoints('jackson47@naver.com');

-- 3) 결제 진행 (예약 자동)
EXEC up_inspayment('jackson47@naver.com', 1, '예약 완료', '23/10/1', '23/10/2', '결제 완료', 160000, '간편 계좌이체');
                -- 유저 아이디         룸아이디 예약 상태    체크인      체크아웃     결제 상태

SELECT *
FROM payment;

SELECT *
FROM reservation;

SELECT *
FROM safety_number;
-- 7일에 한 번 삭제하는 스케줄러


-- 4) 예약 내역 확인
EXEC up_sel_reservation('jackson47@naver.com', 89);


-- 문의 ------------------------------------------------------------------------
-- 1) 문의 작성
EXEC up_insert_inquiry('jackson47@naver.com', '호텔', '예약/결제', '010-4588-1548', 'jackson47@naver.com', '카카오페이로 결제가 안 돼요....ㅜㅜㅜ');

-- 2) 문의 내역 조회
EXEC up_get_inquiry_details('jackson47@naver.com');


-- 쿠폰 조회 -------------------------------------------------------------------
-- 1) 쿠폰 갯수 조회
EXEC up_coupon_Count('jackson47@naver.com');

-- 2) 쿠폰 리스트 조회
EXEC up_coupon_List('jackson47@naver.com', 1);
EXEC up_coupon_List('jackson47@naver.com', 2);

-- 3) 쿠폰 상세 조건 조회
EXEC up_coupon_condition(8);
EXEC up_coupon_condition(9);


-- 내 정보 수정 -----------------------------------------------------------------
EXEC up_updatememberinfo('easy0525@naver.com', '이지연', '이지', NULL, '1234456', '872148');

SELECT *
FROM member
WHERE user_id = 'easy0525@naver.com';


-- 이벤트 참여 -----------------------------------------------------------------
EXEC up_participate_in_event('easy0525@naver.com', 1);
                                -- 유저아이디    이벤트 seq
SELECT *             
FROM event_history
WHERE user_id = 'easy0525@naver.com';

