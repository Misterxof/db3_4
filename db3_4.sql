1)
SELECT  empname, startdate - 10 AS minus_10d,
        startdate + 10 AS plus_10d,
        ADD_MONTHS(startdate, -6) AS minus_6m,
        ADD_MONTHS(startdate, 6) AS plus_6m,
        ADD_MONTHS(startdate, -12) AS minus_1y,
        ADD_MONTHS(startdate, 12) AS plus_1y
FROM emp NATURAL JOIN career
WHERE empname = 'JOHN KLINTON';

2) 
SELECT john_sd - alex_sd
FROM (
    SELECT startdate AS john_sd
    FROM emp NATURAL JOIN career
    WHERE empname = 'JOHN MARTIN'
    ) x,
    (
    SELECT startdate AS alex_sd
    FROM emp NATURAL JOIN career
    WHERE empname = 'ALEX BOUSH'
    ) y;
 
3)
SELECT ROUND(MONTHS_BETWEEN(max_sd,min_sd), 2), ROUND(MONTHS_BETWEEN(max_sd, min_sd)/12, 2)
FROM (SELECT MIN(startdate) min_sd, MAX(startdate) max_sd FROM emp NATURAL JOIN career) x;
 
4)
SELECT empname, startdate, next_sd,
        next_sd - startdate diff
FROM (
    SELECT deptno, empname, startdate, LEAD(startdate)over(ORDER BY startdate) next_sd
    FROM emp NATURAL JOIN career NATURAL JOIN dept
    )
WHERE deptno=20;
 
5)
SELECT startdate, ADD_MONTHS(TRUNC(startdate,'y'),12) -  TRUNC(startdate, 'y') num_of_days_in_that_year FROM career;

6)
SELECT TO_NUMBER(TO_CHAR(SYSDATE,'dd')) DAY,
       TO_NUMBER(TO_CHAR(SYSDATE,'mm')) MONTH,
       TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')) YEAR,
       TO_NUMBER(TO_CHAR(SYSDATE,'ss')) sec,
       TO_NUMBER(TO_CHAR(SYSDATE,'mi')) MIN,
       TO_NUMBER(TO_CHAR(SYSDATE,'hh24')) HOUR
FROM dual;

7)
SELECT TRUNC(SYSDATE, 'mm') firstday,
       LAST_DAY(SYSDATE) lastday
FROM dual;

8)
SELECT ROWNUM qtr,
    ADD_MONTHS(TRUNC(SYSDATE,'y'), (ROWNUM - 1) * 3) q_start,
    ADD_MONTHS(TRUNC(SYSDATE,'y'), ROWNUM * 3) - 1 q_end  
FROM emp
WHERE ROWNUM <= 4;
 
 
9)
WITH x AS (SELECT TRUNC(SYSDATE,'y')+level-1 DAY
FROM dual CONNECT BY LEVEL <= ADD_MONTHS(TRUNC(SYSDATE,'y'), 12) - TRUNC(SYSDATE,'y'))
SELECT * FROM x
WHERE TO_CHAR(DAY, 'dy') = 'mon';
 
10) 
WITH x AS (
SELECT *
FROM (
SELECT TO_CHAR(TRUNC(SYSDATE,'mm')+level-1,'iw') week_number,
        TO_CHAR(TRUNC(SYSDATE,'mm')+level-1,'dd') day_number_in_month,
        TO_NUMBER(TO_CHAR(TRUNC(SYSDATE,'mm')+level-1,'d')) day_of_week,
        TO_CHAR(TRUNC(SYSDATE,'mm')+level-1,'mm') cur_month,
        TO_CHAR(SYSDATE,'mm') MONTH
 FROM dual
   CONNECT BY LEVEL <= 31
         )
   WHERE cur_month = MONTH
  )
  SELECT MAX(CASE day_of_week WHEN 2 THEN day_number_in_month END) Mo,
         MAX(CASE day_of_week WHEN 3 THEN day_number_in_month END) Tu,
         MAX(CASE day_of_week WHEN 4 THEN day_number_in_month END) We,
         MAX(CASE day_of_week WHEN 5 THEN day_number_in_month END) Th,
         MAX(CASE day_of_week WHEN 6 THEN day_number_in_month END) Fr,
         MAX(CASE day_of_week WHEN 7 THEN day_number_in_month END) Sa,
         MAX(CASE day_of_week WHEN 1 THEN day_number_in_month END) Su
 FROM x
GROUP BY week_number  
ORDER BY week_number
