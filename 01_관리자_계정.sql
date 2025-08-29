-- 한 줄 주석 (ctrl + /) --

/*
    여러 줄 주석
    alt + shift + c
*/

-- 실행 시 단축키 : 한 줄 실행 -> 커서를 그 줄에 놓고 ctrl + enter
--                여러 행 실행 -> 실행하고 싶은 줄을 블럭으로 잡은 후, ctrl + enter

-- 사용자 계정 조회하기 --

select * from dba_users;

-- 사용자 생성하기 --
-- 오라클 12버전부터 일반 사용자는 c##으로 시작하는 이름을 반드시 가져야 한다 --

-- create user Woojin identified by '1234'; --
create user c##Woojin identified by 1234;

-- c##을 회피하려면? --
alter session set "_oracle_script" = true;
create user Woojin identified by 1234;

-- 용량에 제한을 안 두고 테이블 구역을 할당한다 --
alter user PlayMaker default tablespace users quota unlimited on users;

-- 특정 용량만큼 테이블 구역을 할당한다 --
alter user PlayMaker quota 30M on users;

-- 테이블에 권한 요청 --
grant create table to PlayMaker;

-- 일반적으로 사용자를 생성하기 위해서는 --
alter session set "_oracle_script" = true;
create user 계정명 identified by 1234;
grant connect, resource to 계정명;


alter user 계정명 default tablespace users quora unlimited on users;

-- 계정을 삭제하고 싶다면? --
drop user 계정명 cascade; -- 테이블이 있을 때 cascade를 붙여라 --

alter session set "_oracle_script" = true;
create user Workbook_PlayMaker identified by 1234;
grant connect, create table to Workbook_PlayMaker;
alter user Workbook_PlayMaker quota unlimited on users;