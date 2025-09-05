/*
    DDL(Data Definition Language) : 데이터 정의 언어
    오라클에서 제공하는 객체를 만들며(Create), 구조를 바꾸고(Alter), 구조 자체를 없애고(Drop)
    즉 실제 데이터 값이 아닌 구조 자체를 정의하는 언어다.
    주로 DB 관리자, 설계자가 사용한다.
    
    오라클에서 객체(구조) : 테이블(Table), 뷰(View), 시퀀스(Sequence), 인덱스(Index)
    , 패키지(Package), 트리거(Trigger), 프로시저(Procedure), 함수(Function), 동의어(Synonym), 
    사용자(User)
*/

--------------------------------------------------------------------------------
/*
    create
    객체를 생성하는 구문
*/
--------------------------------------------------------------------------------
/*
    1. 테이블 생성
    - 테이블: 행(row)과 열(column)으로 구성되는 가장 기본적 DB 객체.
             모든 데이터들은 테이블을 통해 저장된다.
             (DBMS 용어 중 하나로 , 데이터를 일종의 표 형태로 표현한 것)
    [표현법]
    create table 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형,
        ...
    );
    
    - 자료형
    >> 문자(char(바이트 크기) | varchar2(바이트 크기)) -> 크기 지정
        -> char : 최대 2000 바이트까지 지정 가능
                  고정 길이(지정한 길이보다 더 적게 들어와도 나머지는 공백으로 채워 처음 지정한 크기만큼 고정)
        -> varchar2 : 최대 4000 바이트까지 지정 가능
                  가변 길이(담긴 값에 따라 공간의 크기가 맞춰진다)
    >> 숫자(number)
    >> 날짜(date)
*/

-- 회원 정보를 담는 테이블 Member 생성
create table Member (
    mem_no number,
    mem_id varchar2(20),
    mem_passwd varchar2(20),
    mem_name varchar2(20),
    gender char(3),
    phone varchar(13),
    email varchar(50),
    mem_date date
);

--------------------------------------------------------------------------------
/*
    2. 컬럼에 Comment(주석) 달기
    
    [표현법]
    comment on column 테이블명.컬럼명 is '주석내용';
    
    >> 잘못 작성한 경우, 수정 후 다시 실행하면 간단하다
*/
comment on column Member.mem_no is '회원번호';
comment on column Member.mem_id is '아이디';
comment on column Member.mem_passwd is '비밀번호';
comment on column Member.mem_name is '회원명';
comment on column Member.gender is '성별';
comment on column Member.phone is '전화번호';
comment on column Member.email is '이메일';
comment on column Member.mem_date is '회원가입한 날짜';

-- 테이블에 데이터를 추가시킬 때
-- Insert into 테이블명 values();
insert into Member values(101,'user01','pass01','김유찬','남','010-3948-2610','yusaku@naver.com','25/10/27');
insert into Member values(102,'user02','pass02','송유미','여','010-9163-3156','yuzu@gmail.com',sysdate);

insert into member values(null,null,null,null,null,null,null,null);

--------------------------------------------------------------------------------
/*
    제약 조건 constraints
    - 원하는 데이터값(유효한 형식의 값)만 유지할 목적으로 특정 컬럼에 설정하는 제약이다
    - 데이터 무결성 보장을 목적으로 한다
      데이터 무결성 : 데이터에 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태를 말한다
      1) 개체 무결성 제약 조건 : not null, unique, primary key 조건 위배
      2) 참조 무결성 제약 조건 : foreign key(외래키) 조건 위배
      
    - 종류 : not null, unique, primary key, check(조건), foreign key(외래키)
    
    - 제약조건을 부여하는 2가지 방식
    1) 컬럼 레벨 방식 : 컬럼명 자료형 옆에 기술하면 된다
    2) 테이블 레벨 방식 : 모든 컬럼들을 나열한 수 마지막에 기술하면 된다
*/

/*
    - not null 제약 조건
    : 해당 컬럼에 반드시 값이 존재해야만 할 경우(즉, 해당 컬럼에 절대 null이면 안되는 경우)
    삽입 / 수정 시 null값을 허용하지 않도록 제한
    
    -- 주의 사항 : 오로지 컬럼 레벨 방식 밖에 불가능하다
*/

create table mem_notnull (
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50)
);

insert into mem_notnull values(101,'user01','pass01','신유야','남','010-3281-9665',null);
insert into mem_notnull values(102,'user02',null,'홍수인','남','010-9105-8057',null);
-- not null 제약조건을 위배하여 오류 발생

insert into mem_notnull values(102,'user01','pass02','홍수인','남','010-9105-8057',null);
-- 아이디가 중복되어도 잘 추가된다

--------------------------------------------------------------------------------
/*
    unique 제약 조건
    해당 컬럼에 중복된 값이 들어가선 안되는 경우
    컬럼값에 중복값을 제한하는 제약 조건이다
    삽입 / 수정 시 기존 데이터 중 중복값이 있다면 오류가 발생한다
*/

-- 컬럼 레벨 방식
create table mem_unique (
    mem_no number not null,
    mem_id varchar2(20) not null unique,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50)
);

-- 테이블 레벨 방식
create table mem_unique_table (
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50),
    unique (mem_id)
);

insert into mem_unique_table values (1, 'user01','pass01','한소희','여',null,null);
insert into mem_unique_table values (2, 'user01','pass02','서인화','남',null,null);
-- unique 제약조건 위반이므로 insert 실패

create table mem_unique_table2 (
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50),
    unique (mem_no),
    unique (mem_id)
);

insert into mem_unique_table2 values (1, 'user01','pass01','차승훈','남',null,null);
insert into mem_unique_table2 values (2, 'user01','pass02','서보영','여',null,null);
-- mem_id의 unique 제약조건 위배
insert into mem_unique_table2 values (1, 'user02','pass02','고우람','남',null,null);
-- mem_no의 unique 제약조건 위배

create table mem_unique_table3 (
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50),
    unique (mem_no, mem_id)
);

insert into mem_unique_table3 values (1, 'user01','pass01','백유리','여',null,null);
insert into mem_unique_table3 values (2, 'user01','pass02','오성환','남',null,null);
insert into mem_unique_table3 values (2, 'user02','pass03','심재원','남',null,null);
insert into mem_unique_table3 values (2, 'user02','pass04','한소혜','여',null,null);

--------------------------------------------------------------------------------
/*
    - 제약 조건 부여 시 제약조건명까지 지어주는 방법
    >> 컬럼 레벨 방식
        create table 테이블명 (
            컬럼명 자료형 [constraints 제약조건명] 제약조건,
            컬럼명 자료형,
            ...
        );
        
    >> 테이블 레벨 방식
        create table 테이블명 (
            컬럼명 자료형,
            컬럼명 자료형,
            ...
            [constraints 제약조건명] 제약조건 (컬럼)
        );
*/

create table mem_unique2 (
    mem_no number constraint mem_no_nn not null,
    mem_id varchar2(20) constraint mem_id_nn not null,
    mem_passwd varchar2(20) constraint mem_passwd_nn not null,
    mem_name varchar2(20) constraint mem_name_nn not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50),
    constraint mem_id_uq unique(mem_id)
);

insert into mem_unique2 values (1, 'user01','pass01','차승훈','남',null,null);
insert into mem_unique2 values (2, 'user01','pass01','고진만','남',null,null);
insert into mem_unique2 values (3, 'user03','pass03','최상범','ㄴ',null,null);
-- 성별이 '남','여' 둘 중 하나만 유효한 데이터로 하고 싶을 때는?

--------------------------------------------------------------------------------
/*
    - check(조건식) 제약조건
      해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해둘 수 있다.
      해당 조건에 만족하는 데이터 값만 입력하도록 할 수 있다.
*/

create table mem_check (
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    -- gender char(3) check(gender in ('남','여')), -- 컬럼 레벨 방식 이용
    gender char(3),
    phone varchar2(13),
    email varchar2(50),
    unique(mem_id),
    check(gender in ('남','여')) -- 테이블 레벨 방식 이용
);

insert into mem_check values (101,'user01','pass01','이효진','여',null,null);
-- insert into mem_check values (102,'user02','pass02','김주현','ㄴ',null,null); -> check 제약 조건 위반
insert into mem_check values (102,'user02','pass02','김주현','남',null,null);
insert into mem_check values (103,'user03','pass03','김현중',null,null,null); -- null도 삽입할 수 있다 (check 조건이 아니어도 not null은 기술이 되지 않았기 때문)

--------------------------------------------------------------------------------
/*
    - primary key(기본키) 제약 조건
      테이블에서 각 행들을 식별할 목적으로 사용된 컬럼에 부여하는 제약 조건이자 식별자다
      Ex) 회원번호, 학번, 사번, 제품번호, 예약번호, 운송장번호 등등이 이에 속한다고 보면 된다.
      
    -- primary key 제약조건을 부여 시 그 컬럼에 자동으로 not null + unique 제약조건을 부여한다
       >> 대체적으로 검색, 삭제, 수정 등에 기본키의 컬럼값을 이용한다
       
    -- 주의사항 : 한 테이블 당 오로지 1개만 설정이 가능하다
*/

create table mem_pri_key (
    mem_no number constraint mem_no_pk primary key, -- 컬럼 레벨 방식 이용
    mem_id varchar2(20) not null unique,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in ('남','여')),
    phone varchar2(13),
    email varchar2(50)
    -- , primary key(mem_no) -> 테이블 레벨 방식 이용
    -- , constraint mem_no_pk primary key (mem_no) -> 테이블 레벨 방식 제약조건 이름 부여
);

insert into mem_pri_key values (101,'user01','pass01','송나영','여',null,null);
insert into mem_pri_key values (102,'user02','pass02','우경민','남',null,null);
insert into mem_pri_key values (103,'user03','pass03','김은주',null,null,null);

--------------------------------------------------------------------------------
/*
    - 복합키
        : 기본키에 2개 이상의 컬럼을 묶어서 사용한다
        
    - 복합키 사용 예시 : 한 회원이 어떤 상품을 찜했는지에 대한 데이터를 보관하는 테이블
    -- 회원번호, 상품
            1, 드레드라이버
            1, 베이크매그넘
            1, 드레드라이버 -> 부적합
            2, 드레드라이버
            2, 베이크매그넘
            2, 베이크매그넘 -> 부적합
*/

create table tb_like (
    mem_no number,
    product_name varchar2(20),
    like_date date,
    primary key(mem_no, product_name)
);

insert into tb_like values(1, '드레드라이버', sysdate);
insert into tb_like values(1, '베이크매그넘', sysdate);
insert into tb_like values(1, '드레드라이버', sysdate); -- 복합키 오류

--------------------------------------------------------------------------------
-- 회원 등급에 대한 데이터를 보관하는 테이블
create table mem_rank(
    grade_code number primary key,
    grade_name varchar2(20) not null
);

insert into mem_rank values (10, '브론즈');
insert into mem_rank values (20, '실버');
insert into mem_rank values (30, '골드');
insert into mem_rank values (40, '다이아몬드');
insert into mem_rank values (50, '플래티넘');
insert into mem_rank values (60, '마스터');

create table mem(
    mem_no number primary key,
    mem_id varchar2(20) not null unique,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in ('남','여')),
    phone varchar2(13),
    email varchar2(50),
    grade_id number -- 회원등급을 보관할 컬럼
);

insert into mem values (1,'user01','pass01','김두한','남',null,null,60);
insert into mem values (2,'user02','pass02','황설향','여',null,null,null);
insert into mem values (3,'user03','pass03','김무옥','남',null,null,10);
insert into mem values (4,'user04','pass04','문영철','남',null,null,30);
insert into mem values (5,'user05','pass05','정진영','남',null,null,80);
-- 유효한 회원등급이 아니라도 insert가 된다

--------------------------------------------------------------------------------
/*
    - foreign key(외래키) 제약조건
      다른 테이블에 존재하는 값만 들어와야 되는 특정 컬럼에 부여하는 제약조건이다.
      -> 다른 테이블을 참조한다고 보면 된다
      -> 주로 foreign key 제약조건에 의해 테이블 간의 관계가 형성된다.
      
      >> 컬럼 레벨 방식
        -- 컬럼명 자료형 references 참조할 테이블명(참조할 컬럼명)
           컬럼명 자료형 [constraints 제약조건명] references 참조할 테이블명 [(참조할 컬럼명)]
      
      >> 테이블 레벨 방식
        -- foreign key(컬럼명) references 참조할 테이블명(참조할 컬럼명)
        [constraint 제약조건명] foreign key(컬럼명) references 참조할 테이블명 [(참조할 컬럼명)]
      
      --> 참조할 컬럼명 생략 시 참조할 테이블의 primary key로 지정된 컬럼으로 매칭한다
*/

create table mem2 (
    mem_no number primary key,
    mem_id varchar2(20) not null unique,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in ('남','여')),
    phone varchar2(13),
    email varchar2(50),
    grade_id number references mem_rank(grade_code) -- 컬럼 레벨 방식
    -- grade_id number references mem_grade -> 컬럼 레벨 방식(만약 그게 primary key면 생략도 된다)
    
    -- 테이블 레벨 방식
    -- grade_id number,
    -- foreign key(grade_id) references mem_rank
);

insert into mem2 values(1,'user01','pass01','김두한','남',null,null,null);
insert into mem2 values(2,'user02','pass02','김무옥','남',null,null,40);
insert into mem2 values(3,'user03','pass03','문영철','남',null,null,40);

-- mem_rank(부모 테이블) -|-------<- mem2(자식 테이블)

--> 이때, 부모 테이블에서 데이터 값을 삭제한다면 문제 발생!
/*
    - 자식 테이블이 부모 데이터값을 사용하지 않고 있다면 삭제 가능
    - 자식 데이블이 부모 데이터값을 사용하고 있을 때 문제가 발생하므로 삭제가 불가하다
*/

-- mem_rank 테이블에서 40번을 삭제
-- 삭제 시 : delete from 테이블명 (where 조건);
-- 삭제 시 : delete from 테이블명; -> 테이블 내 모든 데이터가 삭제된다
--          delete from 테이블명 where 조건; -> 조건에 맞는 데이터만 삭제된다
delete from mem_rank where grade_code = 60; --> 삭제된다
delete from mem_rank where grade_code = 40; --> 외래키로 지정된 걸 자식 테이블이 쓰고 있어서 삭제가 안된다

insert into mem_rank values (60, '마스터');
-- 부모 테이블로부터 무조건 삭제가 안되는 삭제제한 옵션이 걸려있다? -> 기본값이다

-- insert into mem2 values(3,'user03','pass03','문영철','남',null,null,80); -> 외래키 오류

--------------------------------------------------------------------------------
/*
    - 자식 테이블 생성 시 외래키 제약조건 부여할 때 삭제 옵션 지정이 가능
        - 삭제 옵션 : 부모 테이블의 데이터 삭제 시, 데이터를 사용하고 있는 자식 테이블의 값을 어떻게 삭제할지의 옵션이다
        
    > on delete restricted(기본값) : 삭제제한 옵션, 자식 테이블이 사용하고 있으면 부모 테이블의 데이터는 삭제를 할 수 없다
    > on delete set null : 부모 데이터 삭제 시 자식 테이블 값을 null로 바꾸고 부모 데이터는 삭제한다.
    > on delete cascade : 부모 데이터 삭제 시 자식 테이블 값까지 함께 삭제한다(즉, 행 전부를 삭제).
*/

drop table mem;
drop table mem2;

create table mem(
    mem_no number primary key,
    mem_id varchar2(20) not null unique,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in ('남','여')),
    phone varchar2(13),
    email varchar2(50),
    grade_id number references mem_rank on delete set null
);

insert into mem values (1,'user01','pass01','김두한','남',null,null,60);
insert into mem values(2,'user02','pass02','김무옥','남',null,null,40);
insert into mem values(3,'user03','pass03','문영철','남',null,null,30);
insert into mem values(4,'user04','pass04','김영태','남',null,null,50);

delete from mem_rank where grade_code = 60; --> 부모 테이블 값은 삭제되고 자식 테이블에는 삭제된 값이 null로 반영됨
insert into mem_rank values(60,'마스터');

create table mem2(
    mem_no number primary key,
    mem_id varchar2(20) not null unique,
    mem_passwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in ('남','여')),
    phone varchar2(13),
    email varchar2(50),
    grade_id number references mem_rank on delete cascade
);

insert into mem2 values (1,'user01','pass01','김두한','남',null,null,50);
insert into mem2 values(2,'user02','pass02','김무옥','남',null,null,40);
insert into mem2 values(3,'user03','pass03','문영철','남',null,null,30);
insert into mem2 values(4,'user04','pass04','김영태','남',null,null,50);
insert into mem2 values(5,'user05','pass05','심재원','남',null,null,60);
insert into mem2 values(6,'user06','pass06','고명자','여',null,null,60);

delete from mem_rank where grade_code = 60;
-- 삭제되는데 자식값까지 함께 삭제된다

--------------------------------------------------------------------------------
/*
    - default 기본값
     : 컬럼을 선정하지 않고 insert할 시 null이 아닌 기본값을 insert할 때
     
     -- 컬럼명 자료형 default 기본값 [제약조건]
     ----> 제약조건보다 앞에 기술
*/

create table member2 (
    mem_no number primary key,
    mem_name varchar2(20) not null,
    hobby varchar2(20) default '없다',
    mem_date date default sysdate 
);

insert into member2 values (1,'조병옥','해킹','22/10/30');
insert into member2 values (2,'조일환',null, null);
insert into member2 values (3,'최동열',default, default);

insert into member2 (mem_no, mem_name) values (4,'유태권');

--------------------------------------------------------------------------------
/*
    -------------------- PlayMaker 계정용 ---------------------------------
    - Subquery를 이용한 테이블 생성
      테이블 복사하기
      
      [표현식]
      create table 테이블명 as 서브쿼리;
*/
-- employee 테이블을 복제한 새로운 테이블 생성
create table employee_copy as select * from employee;
-- 컬럼, 데이터값 등은 복사
-- 제약조건의 경우, not null만 복사되고 다른 조건은 배제된다
-- default도 복사가 되지 않아서 배제된다

-- 데이터는 필요 없고, 구조만 복사하고자 할 때?
create table employee_copy2 as select * from employee where 1=0;
drop table employee_copy2;
create table employee_copy2 as select emp_id, emp_name, salary, bonus from employee where 1=0;

-- 기존 테이블 구조에 없는 컬럼을 만들려면?
create table employee_copy3 as select emp_id, emp_name, salary, salary*12 from employee;

-- 서브쿼리 select절에 산술식 또는 함수식 기술이 된 경우, 반드시 별칭을 붙여야 한다
create table employee_copy3 as select emp_id, emp_name, salary, salary*12 연봉 from employee;

--------------------------------------------------------------------------------
/*
    - 테이블을 다 생성한 후 제약조건을 추가
      alter table 테이블명 변경할 내용;
      
    - primary key : alter table 테이블명 add primary key(컬럼명);
    - foreign key : alter table 테이블명 add foreign key(컬럼명) references 참조할 테이블명 [(참조할 컬럼명)];
    - unique : alter table 테이블명 add unique(컬럼명);
    - check : alter table 테이블명 add check(컬럼에 대한 조건식);
    - not null : alter table 테이블명 modify 컬럼명 not null;
    - default : alter table 테이블명 modify 컬럼명 default값;
*/

-- employee_copy 테이블에 primary key 추가
alter table employee_copy add primary key(emp_id);
-- employee_copy 테이블에 foreign key(dept_code) 추가 (참조 : department(dept_id))
alter table employee_copy add foreign key(dept_code) references department(dept_id);
-- employee_copy 테이블에 foreign key(job_code) 추가 (참조 : job(job_code))
alter table employee_copy add foreign key(job_code) references job(job_code);
-- department 테이블에 location_id에 외래키 추가 (참조 : location(local_code))
alter table department add foreign key(location_id) references location(local_code);
-- employee_copy 테이블에 ent_yn 값을 'N'으로 수정
alter table employee_copy modify ent_yn default 'N';
-- employee_copy 테이블에 comment 넣기
comment on column employee_copy.emp_id is '사원번호';
comment on column employee_copy.emp_name is '사원명';
comment on column employee_copy.emp_no is '주민번호';
comment on column employee_copy.email is '이메일';
comment on column employee_copy.phone is '전화번호';
comment on column employee_copy.dept_code is '부서코드';
comment on column employee_copy.job_code is '직급코드';
comment on column employee_copy.salary is '급여';
comment on column employee_copy.bonus is '보너스';
comment on column employee_copy.manager_id is '사수번호';
comment on column employee_copy.hire_date is '입사일';
comment on column employee_copy.end_date is '종료일';
comment on column employee_copy.ent_yn is '퇴사여부';