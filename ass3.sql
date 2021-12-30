USE MASTER
GO

IF EXISTS (SELECT * FROM sys.databases WHERE NAME = 'MovieCollection')
DROP DATABASE MovieCollection
GO

CREATE DATABASE MovieCollection
GO

USE MovieCollection
GO

CREATE TABLE Movie(
	MovieID int PRIMARY KEY IDENTITY(1,1),
	MovieName NVARCHAR(20),
	Duration FLOAT,
	Genre INT,
	CONSTRAINT CK_Genre CHECK (Genre BETWEEN 1 AND 8),
	Director NVARCHAR(20),
	Moneys MONEY,
	Review NVARCHAR(30)
	)
	GO
	EXEC sp_addextendedproperty
		'Movie_Description'
		,'1:Action,2:Adventure,3:Comedy,4:Crime,5:Dramas,6:Horror,7:Musical,8:War'
		,'SCHEMA','dbo'
		,'TABLE','Movie'
		,'COLUMN','Genre'

CREATE TABLE Actor(
	ActorID int PRIMARY KEY,
	ActorName NVARCHAR(20),
	Age INT,
	Salary MONEY,
	Nationality VARCHAR(20)
	)
GO
CREATE TABLE Actedln(
	ActorID INT,
	MovieID INT,
	PRIMARY KEY(ActorID,MovieID),
	CONSTRAINT FK_Actedln_Movie FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
	CONSTRAINT FK_Actedln_Actor FOREIGN KEY (ActorID) REFERENCES Actor(ActorID),
	)
GO

ALTER TABLE Movie ADD ImageLink VARCHAR(100) UNIQUE
GO

INSERT INTO Movie VALUES(N'Spiderman',2,3,N'Tony',1000,N'Siêu bom tấn',N'@hdakd')
INSERT INTO Movie VALUES(N'Ironman',2,3,N'Marco',3000,N'Siêu bom tấn',N'@hdakd1')
INSERT INTO Movie VALUES(N'Hài Tết',1.5,3,N'Alex',1000,N'Siêu bom tấn',N'@hdakdee')
INSERT INTO Movie VALUES(N'Fast and furious',2,7,N'Tony',2500,N'Siêu bom tấn',N'@hdakdre')
INSERT INTO Movie VALUES(N'Alenxander',2.4,5,N'Antony',1000,N'Siêu bom tấn',N'@hdakddx')

INSERT INTO  Actor VALUES(1,N'Rues',38,500,N'Germany')
INSERT INTO  Actor VALUES(2,N'Ramos',38,500,N'Spanish')
INSERT INTO  Actor VALUES(3,N'Pique',56,500,N'Spanish')
INSERT INTO  Actor VALUES(4,N'Kane',52,500,N'England')
INSERT INTO  Actor VALUES(5,N'Rooney',38,500,N'England')

INSERT INTO Actedln VALUES(1,2)
INSERT INTO Actedln VALUES(1,3)
INSERT INTO Actedln VALUES(3,2)
INSERT INTO Actedln VALUES(4,5)
INSERT INTO Actedln VALUES(2,4)


SELECT ActorID,COUNT(MovieID)
FROM Actedln
GROUP BY ActorID
ORDER BY COUNT(MovieID)

SELECT d.MovieID,STRING_AGG(ActorName,' ,') WITHIN GROUP ( ORDER BY ActorName ASC) AS ActorName
FROM Actor a INNER JOIN Actedln d ON a.ActorID=d.ActorID
GROUP BY d.MovieID

SELECT ActorID,ActorName,Age,Salary,Nationality
FROM Actor
WHERE Age>50

SELECT a.ActorName, AVG(a.Salary)
FROM Actor a INNER JOIN Actedln ac ON A.ActorID=ac.ActorID
GROUP BY a.ActorName


SELECT a.ActorName, COUNT(ac.MovieID)
FROM Actor a INNER JOIN Actedln ac ON A.ActorID=ac.ActorID
GROUP BY a.ActorName
HAVING  COUNT(ac.MovieID)>3