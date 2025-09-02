-- 1. 학과별 학생수를 구해서 "학과번호","학생수(명)" 형식으로 헤더를 만들어 결과를 조회하라
select department_no as "학과번호", count(*) as "학생수(명)"
from tb_student group by department_no order by department_no;

-- 2. 지도교수를 배정받지 못한 학생 수는?
select count(*) from tb_student group by coach_professor_no 
having coach_professor_no is null;

-- 3. 학번이 A112113인 유고운 학생의 년도별 평점을 구하라
select substr(term_no,1,4) as 년도, round(avg(point),1) as "년도 별 평점"
from tb_grade where student_no = 'A112113'
group by substr(term_no,1,4) order by 년도;

-- 4. 학과별 휴학생 수를 구하라 (학과번호, 휴학여부 이용)
select department_no as 학과번호, count(case when absence_yn = 'Y' then 1 end) 
as "휴학생 수" from tb_student
group by department_no order by 학과번호;

-- 5. 동명이인 학생들의 이름을 조회하라
select student_name as 동일이름, count(*) as "동명인 수"
from tb_student group by student_name
having count(*) > 1 order by student_name;

-- 6. 학번이 A112113인 유고운 학생의 년도, 학기 별 평점 및 년도별 누적 평점, 총 평점을 구하라
-- (평점은 소수점 1자리까지 반올림하라)

-- 1) 학기별 평점
select substr(term_no,1,4) as 년도, substr(term_no,5,2) as 학기, round(avg(point),1) as 평점
from tb_grade where student_no = 'A112113'
group by substr(term_no,1,4), substr(term_no,5,2)

union all

-- 2) 년도별 평점
select substr(term_no,1,4) as 년도, null as 학기, round(avg(point),1) as 평점
from tb_grade where student_no = 'A112113'
group by substr(term_no,1,4)

union all

-- 3) 총 평점
select null as 평점, null as 학기, round(avg(point),1) as 평점
from tb_grade where student_no = 'A112113'

order by 년도 nulls last, 학기 nulls last;