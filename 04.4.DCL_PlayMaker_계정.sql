create table test (
    test_id number,
    test_name varchar2(20)
);

insert into test values (1,'도명호');

select * from PlayMaker.employee;

insert into PlayMaker.department
values('DA','생산부','L3');

insert into PlayMaker.department
values('DB','개발부','L2');

commit;

drop user test2 cascade;

