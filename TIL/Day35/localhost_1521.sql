--0916, Day35
SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY deptno, job
ORDER BY deptno;
