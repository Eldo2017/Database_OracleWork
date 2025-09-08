/*
    DCL : Data Control Language
    - 데이터 제어 언어 : 계정에 시스템 권한이나 객체의 접근 권한 등을 부여(grant) 
    또는 회수(revoke)하는 구문을 말한다
     >> 시스템 권한 : DB에 접근하는 권한, 객체를 생성할 수 있는 권한
     >> 객체 접근 권한 : 특정 객체를 조작할 수 있는 권한
    
    - 시스템 권한 종류
     >> create session : 접속할 수 있는 권한
     >> create table : 테이블을 생성할 수 있는 권한
     >> create view : 뷰를 생성할 수 있는 권한
     >> create sequence : 시퀀스를 생성할 수 있는 권한
       ...
*/

-- 1. sample 사용자 계정 생성
alter session set "_oracle_script" = true;
create user sample identified by 1234;
-- 접속 시 오류가 난다 -> 접속권한 조차 없어서

-- 2. 이 테이블에 접속 권한 session 부여
grant create session to sample;
-- sample에 접속해 테이블 생성하면 오류 생긴다

-- 3. 테이블 생성 권한
grant create table to sample;

-- 4. tablespace 할당
alter user sample quota unlimited on users;
-- or
-- alter user sample quota 20M on users; -> 유한으로 하려면은 이렇게 해라

----------------------------------------------------------------------------
/*
    - 객체 접근 권한 종류
      특정 객체에 접근해 조작할 수 있는 권한
      
      권한의 종류
      select table, view, sequence
      insert table, view
      update table, view
      delete table, view

      [표현식]
      grant 권한종류 on 특정객체 to 계정명
      - grant 권한종류 on 권한이 있는 user.특정객체 to 권한 줄 user
*/
-- sample계정에 PlayMaker계정의 employee를 select할 수 있는 권한
grant select on PlayMaker.employee to sample;

-- sample계정에 PlayMaker계정의 department를 insert할 수 있는 권한
grant insert on PlayMaker.department to sample;

---------------------------------------------------------------------------
/*
    - 권한 회수하기
      revoke 회수할 권한 on from 계정명;
*/
revoke select on PlayMaker.employee from sample;
revoke insert on PlayMaker.department from sample;

---------------------------------------------------------------------------
/*
    - role
      특정 권한들을 하나의 집합으로 모아둔 것
      
      connect : create, session
      resource : create table, create view, create sequence ...
      dba : 시스템 및 객체 관리에 대한 모든 권한을 갖고 있는 role
      
      - 23ai 버전에서 신규의 role 추가
      db_developer_role : connect, resource, 기타 개발 관련 권한 등등 포함
      
      [표현식]
      grant connect, resource to 계정명;
      grant db_developer_role to 계정명;
*/
create user test2 identified by 1234;
grant db_developer_role to test2;
alter user test2 quota unlimited on users;

-- 테이블 role_sys_privs에 role이 정의돼있다
select * from role_sys_privs;

select * from role_sys_privs
where role ='resource';