--#############################################
-- OVER 사용법
--#############################################

http://blog.naver.com/PostView.nhn?blogId=whitefre&logNo=140148769754

★ OVER()함수란?

OVER함수는 ORDER BY, GROUP BY 서브쿼리를 개선하기 위해 나온 함수라고 할 수 있습니다.


★ 전통 SQL 사용

SELECT YYMM, PRICE
FROM (

SELECT YYMM,

SUM(TOT_PRICE) AS PRICE
FROM TABLE1
GROUP BY YYMM
ORDER BY YYMM DESC

)



★ OVER 함수 이용

SELECT YYMM,

SUM(TOT_PRICE) OVER(ORDER BY YYMM DESC) AS PRICE
FROM TABLE1



★ COUNT(*)OVER() 사용

실제 데이터와 함께 해당 테이블의 전체 로우 컬럼을 쉽고 편리하게 추출할 수 있다.


SELECT MENU_ID, MENU_NAME, COUNT(*) AS TOTALCOUNT
FROM MENU_MG
위의 쿼리를 실행하면 다음과 같은 오류 메시지가 나온다.
ORA-00937: not a single-group group function


다음 쿼리로 쉽게 전체 카운트를 추출할 수 있다.

SELECT MENU_ID, MENU_NAME, COUNT(*)OVER() AS TOTALCOUNT
FROM MENU_MG


★ OVER() 함수


COUNT(*)OVER() : 전체행 카운트
COUNT(*)OVER(PARTITION BY 컬럼) : 그룹단위로 나누어 카운트


MAX(컬럼)OVER() : 전체행 중에 최고값
MAX(컬럼)OVER(PARTITION BY 컬럼) : 그룹내 최고값


MIN(컬럼)OVER() : 전체행 중에 최소값
MIN(컬럼)OVER(PARTITION BY 컬럼) : 그룹내 최소값


SUM(컬럼)OVER() : 전체행 합
SUM(컬럼)OVER(PARTITION BY 컬럼) : 그룹내 합


AVG(컬럼)OVER() : 전체행 평균
AVG(컬럼)OVER(PARTITION BY 컬럼) : 그룹내 평균


STDDEV(컬럼)OVER() : 전체행 표준편차
STDDEV(컬럼)OVER(PARTITION BY 컬럼) : 그룹내 표준편차


RATIO_TO_REPORT(컬럼)OVER() : 현재행값/SUM(전체행값) 퍼센테이지로 나타낼경우 100곱하면 됩니다.
RATIO_TO_REPORT(컬럼)OVER(PARTITION BY 컬럼) : 현재행값 / SUM(그룹행값) 퍼센테이지로 나타낼경우 100곱하면 됩니다.

======================================================================


COUNT(expr) OVER(analytic_clause)

- 같거나 작은 조건에 대한 갯수 반환


/* 부서번호가 50인 부서 지원에 대해 각 직원의 급여보다 같거나 적게 받는 사람에 대한 누적 합을 반환. */

SELECT employee_id, salary

, COUNT(*) over(ORDER BY salary) AS "Count"

FROM employees

WHERE department_id = '50';


SUM(expr) OVER(analytic_clause)

-- 같거나 작은 값들에 대한 누적

/* 특정 값을 누적하여 결과를 보여준다. */

SELECT employee_id, salary

, SUM(salary) over(ORDER BY employee_id)

FROM employees

WHERE department_id = '50';


/* 위 예제에 더해 부서별 누적 결과를 함께 보고자 한다. */

SELECT employee_id, department_id, salary

, SUM(salary) over(ORDER BY department_id, employee_id)

, SUM(salary) over(partition by department_id order by employee_id)

FROM employees;



RANK() OVER()

--순위

SELECT SAL_SNO, SAL_YYMM, SAL_TOTAL,

RANK() OVER(ORDER BY SAL_TOTAL) AS "CONT"

FROM TB_SALARY

WHERE SAL_YYMM = '201101';


DENSE_RANK 함수

- 값의 그룹에서 값의 순위를 계산합니다. RANK와는 달리 같은 순위가 둘 이상 있어도 다음 순위는 1만 증가하여 반환.


SELECT employee_id, department_id, salary

, DENSE_RANK() over(PARTITION BY department_id ORDER BY salary DESC)

FROM employees

WHERE department_id = '50'



★ ROW_NUMBER() OVER- 특정 컬럼 기준으로 순위정하기(행번호 부여하기)