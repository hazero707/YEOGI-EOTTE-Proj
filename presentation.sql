-- ȸ������ �� �α��� -----------------------------------------------------------
EXEC up_insert_member('easy0525@naver.com', '1234456', '������', '010-5523-4090');
                    -- ���̵�                  pw        �г���       ��ȭ��ȣ

SELECT *
FROM member;

EXEC up_login('easy0525@naver.com', '4834587');    -- �߸��� ��й�ȣ
EXEC up_login('easy0525@naver.com', '1234456');   -- �α��� ����


-- ���� �˻� -------------------------------------------------------------------
-- 1) ���� �̸�/�������� �˻�

-- ���� ó��
EXEC up_search_Keyword('����ķ�۽�');
EXEC up_search_Keyword('�� ��');
-- ���� ���� �˻�
EXEC up_search_Keyword('����', 'M');
-- ���� �˻�
EXEC up_search_Keyword('����', 'MH', 20000);
-- ����
EXEC up_search_Keyword('����', 'MH', 10000, 100000, 2);
EXEC up_search_Keyword('����', 'MH', p_sort=>1);


-- 2) ���� �����ؼ� �˻�
EXEC up_searchH_total(p_address=>'��� ����', p_reservation => 1, p_swimming_pool=>1, p_hair_dryer=>1, p_breakfast=>1, p_accom_detail_id=>356, p_double=>1, p_sort=>1);
EXEC up_searchH_total(p_address=>'���', p_swimming_pool=>1, p_hair_dryer=>1, p_breakfast=>1, p_accom_detail_id=>356, p_double=>1, p_sort=>2);


-- 3) ������ ������ ���� ��ȸ
EXEC UP_Get_Accom_Info(7);


-- 4) ������ ������ ���� ���� ��ȸ
EXEC up_Get_Room_Info(7);


-- 5) ���� ���� ��ȸ
EXEC up_get_best_reviews(8, 'H');


-- ���� ���� -------------------------------------------------------------------
-- 1) ��� ���� ���� ��ȸ
EXEC up_getlistofavailableCoupons('alicia_walker82@naver.com', '23/10/10', 'H', '����', 100000);

-- 2) ��� ���� ����Ʈ ��ȸ
EXEC up_getavailablepoints('jackson47@naver.com');

-- 3) ���� ���� (���� �ڵ�)
EXEC up_inspayment('jackson47@naver.com', 1, '���� �Ϸ�', '23/10/1', '23/10/2', '���� �Ϸ�', 160000, '���� ������ü');
                -- ���� ���̵�         ����̵� ���� ����    üũ��      üũ�ƿ�     ���� ����

SELECT *
FROM payment;

SELECT *
FROM reservation;

SELECT *
FROM safety_number;
-- 7�Ͽ� �� �� �����ϴ� �����ٷ�


-- 4) ���� ���� Ȯ��
EXEC up_sel_reservation('jackson47@naver.com', 89);


-- ���� ------------------------------------------------------------------------
-- 1) ���� �ۼ�
EXEC up_insert_inquiry('jackson47@naver.com', 'ȣ��', '����/����', '010-4588-1548', 'jackson47@naver.com', 'īī�����̷� ������ �� �ſ�....�̤̤�');

-- 2) ���� ���� ��ȸ
EXEC up_get_inquiry_details('jackson47@naver.com');


-- ���� ��ȸ -------------------------------------------------------------------
-- 1) ���� ���� ��ȸ
EXEC up_coupon_Count('jackson47@naver.com');

-- 2) ���� ����Ʈ ��ȸ
EXEC up_coupon_List('jackson47@naver.com', 1);
EXEC up_coupon_List('jackson47@naver.com', 2);

-- 3) ���� �� ���� ��ȸ
EXEC up_coupon_condition(8);
EXEC up_coupon_condition(9);


-- �� ���� ���� -----------------------------------------------------------------
EXEC up_updatememberinfo('easy0525@naver.com', '������', '����', NULL, '1234456', '872148');

SELECT *
FROM member
WHERE user_id = 'easy0525@naver.com';


-- �̺�Ʈ ���� -----------------------------------------------------------------
EXEC up_participate_in_event('easy0525@naver.com', 1);
                                -- �������̵�    �̺�Ʈ seq
SELECT *             
FROM event_history
WHERE user_id = 'easy0525@naver.com';

