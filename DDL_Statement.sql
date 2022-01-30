
                                      --- Question No 01 ---

USE master
GO

IF DB_ID ('TSPDB') IS NOT NULL
DROP DATABASE TSPDB
GO

CREATE DATABASE TSPDB
ON
(NAME='TSPDB_Data_1',
 FileName='C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\TSPDB_Data_1.mdf',
 Size = 25 MB,
 Maxsize = 100 MB,
 Filegrowth = 5%
)
LOG ON
(NAME='TSPDB_Log_1',
 FileName='C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\TSPDB_Log_1.ldf',
 Size = 2 MB,
 Maxsize = 25 MB,
 Filegrowth = 1%
)
Go
                                      --- Question No 02 ---
USE TSPDB
GO

CREATE TABLE Tsp
(TspID INT PRIMARY KEY NONCLUSTERED NOT NULL,
 TspName VARCHAR (10)
)
GO

INSERT INTO Tsp VALUES
(101,'USSL'),(102,'Data Park'),(103,'TCL IT'),(104,'PNTL')
GO

CREATE TABLE Course
(CourseID INT PRIMARY KEY NOT NULL,
 CourseName VARCHAR (10)
)
GO

INSERT INTO Course VALUES
(201,'ESAD-CS'),(202,'WPSI'),(203,'GAVE'),(204,'ESAD-J2EE')
GO

CREATE TABLE Student
(StudentID INT PRIMARY KEY NOT NULL,
 FirstName VARCHAR (10),
 LastName VARCHAR (10),
 BatchID VARCHAR (20),
 TspID INT REFERENCES Tsp (TspID),
 CourseID INT REFERENCES Course (CourseID)
)
GO

INSERT INTO Student VALUES
(11299,'RAIHAN','KABIR','USSL-29-1A-CS',101,201),(11356,'AZMAL','HOSSAIN','USSL-29-1A-CS',101,201),
(11211,'MIFTAHUL','ALAM','USSL-29-1A-WPSI',101,202),(11196,'MD.','ABDULLAH','DP-29-1A-GV',102,203),
(11567,'FAFIQUL','ISLAM','TCL-29-1M-J2EE',103,204),(11120,'SIRAJUR','RAHMAN','PNT-29-1M-GV',104,203)
GO

                                      --- Question No 03 ---
/*USE TSPDB
GO
DROP TABLE Tsp
GO*/

                                      --- Question No 04 ---
/*USE TSPDB
GO
UPDATE Tsp SET TspName='BIRDS'
WHERE TspName = 'PNTL'
GO*/
                                      --- Question No 05 ---
/*USE TSPDB
GO
DROP TABLE Tsp
GO*/
                                      --- Question No 06 ---

/*USE TSPDB
GO
DELETE FROM Tsp 
WHERE TspName = 'PNTL'
GO*/

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

                                       --- Question No 09 ---

USE TSPDB
GO

CREATE VIEW V_ESAD_CS_AllInformation
AS
SELECT  S.FirstName +''+ S.LastName AS [Student Name], S.StudentID AS [Student ID],
BatchID AS [Batch ID], T.TspName AS [TSP Name], C.CourseName [Course Name]
FROM Student AS S JOIN Tsp AS T
ON T.TspID = S.TspID JOIN Course AS C
ON C.CourseID = S.CourseID
WHERE C.CourseName='ESAD-CS'
GO

                                       --- Question No 10 ---
USE TSPDB
GO

CREATE PROC spInsertUpdateDeleteWithOutput
@WorkType VARCHAR (10),
@TspID INT,
@TspName VARCHAR (10)
AS
BEGIN
IF @WorkType = 'Insert'
BEGIN TRY
BEGIN TRAN
INSERT INTO Tsp VALUES (@TspID, @TspName)
COMMIT TRAN
END TRY
BEGIN CATCH
END CATCH
IF @WorkType = 'Update'
BEGIN
UPDATE Tsp SET TspName = @TspName WHERE TspID = @TspID
END
IF @WorkType = 'Delete'
BEGIN TRY
BEGIN TRAN
DELETE FROM Tsp WHERE TspID = @TspID
COMMIT TRAN
END TRY
BEGIN CATCH
END CATCH
END

GO

                                      --- Question No 11 ---
USE TSPDB
GO 

CREATE CLUSTERED INDEX IX_Tsp_TspName
ON Tsp(TspName)

--Justify
EXEC sp_helpindex Tsp

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

                                       --- Question No 18 (Search Case)---
USE TSPDB
GO 

SELECT CourseID AS [Course ID], CourseName AS [Course Name],
CASE WHEN CourseName= 'ESAD-CS' THEN 'C#'
	 WHEN CourseName='ESAD-J2EE' THEN 'JAVA'
ELSE 'EMPTY'
END 'Short Name'
FROM Course

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

                                       --- Question No 12 --- not complete
USE TSPDB
GO
IF OBJECT_ID ('fnTspWiseTotalStudent') IS NOT NULL
DROP FUNCTION fnTspWiseTotalStudent
GO

CREATE FUNCTION fnTspWiseTotalStudent (@StudentID INT)
RETURNS INT
BEGIN
RETURN 
( SELECT StudentID FROM Student WHERE StudentID = @StudentID
)
END
GO

--Justify

SELECT * , dbo.fnTspWiseTotalStudent (TspID) AS [Total Student] FROM Tsp WHERE TspName = 'USSL'
GO
                                       --- Question No 14 & 16 --- 
USE TSPDB
GO

CREATE TRIGGER trTspInsertUpdateDelete
ON Tsp
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE
@TspID INT,
@TspName VARCHAR (10)
SELECT * FROM inserted
BEGIN
BEGIN TRY
BEGIN TRAN
INSERT INTO Tsp VALUES (@TspID, @TspName)
UPDATE Tsp SET TspName = @TspName WHERE TspID = @TspID
DELETE FROM Tsp WHERE TspID = @TspID
COMMIT TRAN
END TRY
BEGIN CATCH
BEGIN TRAN
SELECT ERROR_MESSAGE () AS 'ERROR_MESSAGE',
	   ERROR_NUMBER () AS 'ERROR_NUMBER',
	   ERROR_LINE () AS 'ERROR_LINE',
	   ERROR_SEVERITY () AS 'ERROR_SEVERITY',
	   ERROR_STATE () AS 'ERROR_STATE'
ROLLBACK TRAN
END CATCH
END
END

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