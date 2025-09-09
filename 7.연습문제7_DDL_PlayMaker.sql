-- 1.
create table tb_category(
    name varchar2(10),
    use_yn char(1) default 'Y'
);

-- 2.
create table tb_class_type(
    no varchar2(5) constraint no_pk primary key,
    name varchar2(10)
);

-- 3.
alter table tb_category add constraint category_fk primary key(name);

-- 4.
alter table tb_class_type modify name not null;

-- 5. 
alter table tb_class_type modify (no varchar2(10));
alter table tb_class_type modify (name varchar2(20));
alter table tb_category modify (name varchar2(20));

-- 6. 
alter table tb_category
rename column name to category_name;
alter table tb_class_type
rename column name to category_name;
alter table tb_class_type
rename column no to category_no;

-- 7. 
alter table tb_category
rename constraint pk_category_name to primary key(category_name);

