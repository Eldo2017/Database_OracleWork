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