select department_name as "학과 명", category as "계열" from tb_department;

select department_name || '의 정원은 ' || capacity || '명입니다.' from tb_department;

select student_name from tb_student where student_no in ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');

select department_name , category from tb_department where capacity between 20 and 30;

select professor_name from tb_professor where department_no is null;