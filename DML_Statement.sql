
                                      --- Question No 03 ---
USE TSPDB
GO
DELETE FROM Tsp WHERE TspID = 102
GO

                                      --- Question No 04 ---
USE TSPDB
GO
UPDATE Tsp SET TspName='BIRDS'
WHERE TspName = 'PNTL'
GO
                                      --- Question No 05 ---
USE TSPDB
GO
DROP TABLE Tsp
GO
                                      --- Question No 06 ---

USE TSPDB
GO
ALTER TABLE Course
DROP COLUMN CourseName
GO

                                      --- Question No 07 ---
USE TSPDB
GO
USE TSPDB
GO
SELECT count (S.StudentID) AS [Total Student], S.FirstName+' '+S.LastName AS [Student Name] , T.TspName AS [TSP Name]
FROM Student AS S JOIN Tsp AS T
ON T.TspID = S.TspID JOIN Course AS C
ON C.CourseID = S.CourseID
GROUP BY T.TspName, S.FirstName+' '+S.LastName 
HAVING T.TspName = 'USSL'
ORDER BY T.TspName ASC

GO
                                      --- Question No 08 ---
USE TSPDB
GO

SELECT  S.FirstName +''+ S.LastName AS [Student Name], S.StudentID AS [Student ID],
BatchID AS [Batch ID], T.TspName AS [TSP Name], C.CourseName [Course Name]
FROM Student AS S JOIN Tsp AS T
ON T.TspID = S.TspID JOIN Course AS C
ON C.CourseID = S.CourseID
WHERE T.TspName IN
(SELECT TspName FROM Tsp WHERE TspName = 'USSL')
GO

                                       --- Question No 15 --- 
USE TSPDB
GO

SELECT * FROM Course
GO

BEGIN TRY
BEGIN TRAN
INSERT INTO Course VALUES (305,'ICT')
INSERT INTO Course VALUES (306,'FREELANCING')
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
GO

                                      --- Question No 18 (Simple Case)---
USE TSPDB
GO 

SELECT CourseID AS [Course ID], CourseName AS [Course Name],
CASE CourseName
WHEN 'ESAD-CS' THEN 'C#'
WHEN 'ESAD-J2EE' THEN 'JAVA'
ELSE 'NO NEED'
END 'Short Name'
FROM Course
GO

                                       --- Question No 18 (Search Case)---
USE TSPDB
GO 

SELECT CourseID AS [Course ID], CourseName AS [Course Name],
CASE WHEN CourseName= 'ESAD-CS' THEN 'C#'
	 WHEN CourseName='ESAD-J2EE' THEN 'JAVA'
ELSE 'EMPTY'
END 'Short Name'
FROM Course
GO

                                       --- Question No 21 ---
USE TSPDB
GO

CREATE TABLE Tsp_New
(TspID INT PRIMARY KEY NOT NULL,
 TspName VARCHAR (10)
)
GO

INSERT INTO Tsp_New VALUES
(301,'BIRDS'),(302,'ARTECH'),(303,'RIT')
GO

USE TSPDB
GO

SELECT * FROM Tsp
SELECT * FROM Tsp_New
GO
MERGE Tsp_New AS TN
USING Tsp AS T
ON TN.TspID = T.TspID
WHEN MATCHED THEN 
UPDATE SET TN.TspName = T.TspName
WHEN NOT MATCHED BY TARGET THEN
INSERT (TspID,TspName) VALUES (T.TspID, T.TspName)
;
GO

                                       --- Question No 17 ---




