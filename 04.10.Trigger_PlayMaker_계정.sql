-- 상품 입고 출고가 되면 재고수량이 변경되도록 하는 트리거를 생성
-- 테이블 3개, 시퀀스 3개 생성

-- 1) 상품에 대한 데이터 보관용 테이블(tb_product)
create table tb_product(
    pcode number primary key,    -- 상품번호
    pname varchar2(30) not null, -- 상품명
    brand varchar2(30) not null, -- 브랜드명
    stock_count number default 0 -- 재고수량
);

-- 상품번호에 넣을 시퀀스(seq_pcode)
create sequence seq_pcode
start with 101
increment by 1
nocache;

-- 샘플 데이터 (의류 위주)
insert into tb_product values(seq_pcode.nextval,'육상 민소매티','아식스',10);
insert into tb_product values(seq_pcode.nextval,'농구 유니폼 원피스','나이키',50);
insert into tb_product values(seq_pcode.nextval,'육상 브루마 쇼츠','아디다스',40);
insert into tb_product values(seq_pcode.nextval,'블랙 스니커즈','아식스',default);

-- 2) 입고용 테이블(tb_prostock)
create table tb_prostock(
    tcode number primary key,           -- 입고번호
    pcode number references tb_product, -- 상품번호
    tdate date default sysdate,         -- 입고일자
    stock_count number not null,        -- 입고수량
    stock_price number not null         -- 입고가격
);

-- 입고번호에 넣을 시퀀스(seq_tcode)
create sequence seq_tcode
nocache;

-- 3) 판매용 테이블(tb_prosale)
create table tb_prosale(
    scode number primary key,           -- 판매번호
    pcode number references tb_product, -- 상품번호
    sdate date default sysdate ,        -- 판매일자
    sale_count number not null,         -- 판매수량
    sale_price number not null          -- 판매가격
);

-- 판매번호에 넣을 시퀀스(seq_scode)
create sequence seq_scode
nocache;

-- 100번 상품을 오늘날짜로 10개 입고
insert into tb_prostock
values(seq_tcode.nextval, 101, default, 10, 35000);

-- tb_product 테이블 재고수량 10개 증가
update tb_product
set stock_count = stock_count + 10
where pcode = 101;
commit;

-- 103번 상품을 오늘 날짜로 5개 출고
insert into tb_prosale
values (seq_scode.nextval, 103, default, 5, 23000);

-- tb_product 테이블 재고수량 5개 감소
update tb_product
set stock_count = stock_count - 5
where pcode = 103;
commit;

-- tb_product 테이블에 매번 자동으로 재고수량을 update하는 트리거를 정의
-- tb_prostock 테이블에 입고(insert) 이벤트 발생 후에 update

-- update tb_product
-- set stock_count = stock_count + insert된 자료의 stock_count값
-- where pcode = 101;

-- 트리거 정의 시
create trigger trg_stock
after insert on tb_prostock
for each row
begin
    update tb_product
    set stock_count = stock_count + :new.stock_count
    where pcode = :new.pcode;
end;
/

-- 103번 상품이 오늘 날짜로 5개 입고 (현재 35개)
insert into tb_prostock
values(seq_tcode.nextval,103,default,5,28000);

-- tb_prosale 테이블에 출고(insert) 이벤트 후 update하기
create trigger trg_sale
after insert on tb_prosale
for each row
begin
    update tb_product
    set stock_count = stock_count - :new.sale_count
    where pcode = :new.pcode;
end;
/
-- 만약 재고수량이 부족하면 출고가 불가하게 정의
/*
    - 사용자 함수 예외처리
      raise_applecation_error(에러코드, 에러메시지)
      - 에러코드 : -20000 ~ -20999 사이의 코드
*/

create or replace trigger trg_sale
after insert on tb_prosale
for each row
declare
    scount number;
begin
    select stock_count
    into scount
    from tb_product
    where pcode = :new.pcode;
    
    if scount < :new.sale_count then
        raise_application_error(-20001,'재고가 부족합니다');
    else
        -- 재고 차감
        update tb_product
        set stock_count = stock_count - new:sale_count
        where pcode = :new.pcode;
    end if;
end;
/

-- 101번 상품이 오늘 날짜로 5개 출고
insert into tb_prosale
values(seq_scode.nextval,101,default, 5, 33000);

-- tb_prostock 테이블에서 입고수량을 수정할 때의 트리거
create or replace trigger trg_proup
after update on tb_prostock
for each row
begin
    update tb_product
    set stock_count = stock_count - :old.stock_count + new:stock_count
    where pcode = :new.pcode;
end;
/

update tb_prostock
set stock_count = 10
where tcode = 2;

-- tb_prostock 테이블에서 삭제 시 트리거
create or replace trigger trg_del
after delete on tb_prostock
for each row
begin
    update tb_product
    set stock_count = stock_count - :old.stock_count
    where pcode = :old.pcode;
end;
/

delete from tb_prostock where pcode = 101;