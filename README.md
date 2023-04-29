# SQL_student_score
use subquery, rank over, partition by <br>
學生成績-SQL語法練習

※附件database.zip 為 YSTUDENT.MDF 壓縮檔 以 檢視SQL 或 檢視設計 作下列練習:
※得以將YSTUDENT.MDF 轉成MS SQL或MYSQL的資料庫，再以其語法作答。

1. 請計算每個人的總成績及平均(小數1位):
A. 欄位如右：學號，姓名，總分，平均。
B. 排序：總分(遞減)。<br><br>
SELECT  STUDENT.SNO, STUDENT.NAME, SUM(YSCORE.SCORE) AS 總分, convert(decimal(4,1),AVG(YSCORE.SCORE*1.0)) 平均<br>
FROM      STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO<br>
GROUP BY STUDENT.SNO, STUDENT.NAME order by 總分 desc

2. 請計算每個人單科的最高成績:
A. 欄位如右：學號，姓名，科目，最高成績。
B. 排序：學號(遞增)。<br><br>
Select ranked.sno,student.NAME,ranked.subject,ranked.score 最高成績 <br>
from ( <br>
select *, rank() over(partition by sno order by score desc) as rowno from yscore --rowid "各學號分組,依各科成績高低,排名"<br>
) as ranked      --ranked是表格<br>
inner join student on student.sno=ranked.sno<br>
where ranked.rowno = 1 order by ranked.sno --取最高排名(成績)

...

※※完整題目(13題)及作法參考如.SQL檔。Please refer to attached files for completed 13 questions & answers.※※
