/*
    07.DDL 실습문제
    도서관리 프로그램을 만들기 위한 테이블들 만들기
    이때, 제약조건에 이름을 부여할 것.
       각 컬럼에 주석달기
*/

/*
    1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
    컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음

    - 3개 정도의 샘플 데이터 추가하기
*/

create table tb_publisher (
    pub_no number constraint publisher_pk primary key,
    pub_name varchar2(50) constraint publisher_nn not null,
    phone varchar2(13)
);

comment on column tb_publisher.pub_no is '출판사 번호';
comment on column tb_publisher.pub_name is '출판사명';
comment on column tb_publisher.phone is '출판사 전화번호';

insert into tb_publisher values (1, '조선출간','010-3013-0224');
insert into tb_publisher values (2, '동아북스','010-1920-9352');
insert into tb_publisher values (3, '시대출판','010-6912-3328');

/*
    2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
    컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
	BK_PRICE(가격) NUMBER
	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
    - 5개 정도의 샘플 데이터 추가하기
*/

create table tb_book (
    bk_no number constraint book_pk primary key,
    bk_title varchar(50) constraint book_nn_title not null,
    bk_author varchar(20) constraint book_nn_author not null,
    bk_price number,
    bk_pub_no number constraint book_fk references tb_publisher(pub_no) on delete cascade
);

comment on column tb_book.bk_no is '도서 번호';
comment on column tb_book.bk_title is '도서명';
comment on column tb_book.bk_author is '저자명';
comment on column tb_book.bk_price is '가격';
comment on column tb_book.bk_pub_no is '출판사 번호';

insert into tb_book values (1,'엘도라도','맥베스 글리온',33000,3);
insert into tb_book values (2,'유전의 위대함','로드리고 조지',25000,1);
insert into tb_book values (3,'일본여행길라잡이','구라이 시타',40000,3);
insert into tb_book values (4,'모바일앱완성넘버원','신세계',55000,2);
insert into tb_book values (5,'독립시대','김두한',30000,2);

/*
    3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
   ADDRESS(주소) VARCHAR2(70)
   PHONE(연락처) VARCHAR2(13)
   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)

   - 5개 정도의 샘플 데이터 추가하기
*/

create table tb_member (
    member_no number constraint member_pk primary key,
    member_id varchar2(30) constraint member_uq unique,
    member_pwd varchar2(30) constraint member_nn_pwd not null,
    member_name varchar2(20) constraint member_nn_name not null,
    gender char(1) constraint member_ck_gen check(gender in ('M','F')),
    address varchar2(70),
    phone varchar2(13),
    status char(1) default 'N' constraint member_ck_sta check(status in ('Y','N')) ,
    enroll_date date default sysdate constraint member_nn_en not null
);

comment on column tb_member.member_no is '회원번호';
comment on column tb_member.member_id is '아이디';
comment on column tb_member.member_pwd is '비밀번호';
comment on column tb_member.member_name is '회원명';
comment on column tb_member.gender is '성별';
comment on column tb_member.address is '주소';
comment on column tb_member.phone is '연락처';
comment on column tb_member.status is '탈퇴여부';
comment on column tb_member.enroll_date is '가입일';

insert into tb_member
values (1,'user01','pass01','유용욱','M','서울시 송파구','010-3172-2094','N','2022-03-20');
insert into tb_member
values (2,'user02','pass02','선관일','M','서울시 구로구','010-1603-7160','Y','2019-10-15');
insert into tb_member
values (3,'user03','pass03','권유리','F','서울시 서대문구','010-5915-7753','N','2020-07-16');
insert into tb_member
values (4,'user04','pass04','양승모','M','서울시 노원구','010-7037-6295','N','2018-05-19');
insert into tb_member
values (5,'user05','pass05','정채은','F','서울시 종로구','010-4883-6157','N','2023-09-03');


/*
    4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
	RENT_DATE(대여일) DATE -- 기본값 SYSDATE

   - 3개 정도 샘플데이터 추가하기
*/

create table tb_rent (
    rent_no number constraint rent_pk primary key,
    rent_mem_no number constraint rent_fk_mem references tb_member(member_no),
    rent_book_no number constraint rent_fk_book references tb_book(bk_no),
    rent_date date default sysdate
);

comment on column tb_rent.rent_no is '대여번호';
comment on column tb_rent.rent_mem_no is '대여회원번호';
comment on column tb_rent.rent_book_no is '대여도서번호';
comment on column tb_rent.rent_date is '대여일';

insert into tb_rent values (1, 3, 1, '23/01/20');
insert into tb_rent values (2, 1, 5, '24/07/19');
insert into tb_rent values (3, 4, 4, '20/11/16');
insert into tb_rent values (4, 3, 3, '21/06/23');