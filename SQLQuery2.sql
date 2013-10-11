



INSERT INTO account VALUES
(2000),
(1500),
(750),
(550),
(150),
(20000),
(15000),
(7000),
(8900),
(7526),
(3500),
(3700),
(8672),
(610),
(8500),
(30000),
(10000),
(6000),
(3000),
(1000);


INSERT INTO accountholder VALUES
('A',123123,123123,'asd@hotmail.com',3123),
('B',310453,441223,'faswww@hotmail.com',4122),
('C',121212,411233,'vwwwe@hotmail.com',5111),
('D',250667,144122,'blalblab@hotmail.com',4124),
('E',230778,511223,'sdfffdd@hotmail.com',7755),
('F',090883,515152,'weeaqqq@hotmail.com',3223),
('G',031093,321888,'naweeews@hotmail.com',0990),
('H',270164,418888,'asdwwetyy@hotmail.com',3447),
('I',130574,247745,'muuuu@hotmail.com',1744),
('J',150387,979797,'qqweee@hotmail.com',1322);

INSERT INTO aha VALUES
(1,1),
(1,2),
(1,4),
(2,17),
(2,15),
(2,10),
(2,12),
(3,3),
(3,15),
(4,15),
(5,5),
(6,18),
(7,15),
(7,16),
(7,5),
(7,3),
(8,4),
(8,7),
(9,7),
(9,8),
(9,9),
(9,17),
(10,10),
(10,20);

CREATE PROCEDURE calculateInterests
AS
BEGIN TRANSACTION [transInterest]
BEGIN TRY

INSERT INTO intrest
	SELECT account.id,tInterest.aInterest,SYSDATETIME() AS currentDate
	FROM (SELECT account.id AS aID,account.balance * 1.01 AS aInterest FROM account) AS tInterest,account
	WHERE account.id = tInterest.aID
COMMIT TRANSACTION [transInterest]
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION [transInterest]
END CATCH
GO
GO


CREATE PROCEDURE addAccountHolder @name varchar(80), @birthdate int, @telephone varchar(20),@email varchar(225),@pin int
AS
BEGIN TRANSACTION [transAddAH]
BEGIN TRY
INSERT INTO accountholder VALUES
(@name,@birthdate,@telephone,@email,@pin)
COMMIT TRANSACTION [transAddAH]
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION [transAddAH]
END CATCH
GO
GO


CREATE PROCEDURE linkAccount @lAHid int, @lAid int
AS
BEGIN TRANSACTION [transLinkAccount]
BEGIN TRY
INSERT INTO aha VALUES
(@lAHid,@lAid)
COMMIT TRANSACTION [transLinkAccount]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transLinkAccount]
END CATCH
GO
GO


CREATE PROCEDURE openAccount @ahID int
AS
BEGIN TRANSACTION [transOpenAccount]
BEGIN TRY
INSERT INTO account VALUES
(0)
DECLARE @accountid int
SET @accountid = (SELECT MAX(account.id) AS newestID FROM account)
EXEC linkAccount @lAHid = @ahID, @lAid = @accountid
COMMIT TRANSACTION [transOpenAccount]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transOpenAccount]
END CATCH
GO
GO


CREATE PROCEDURE confirmLoginAccess @AHid int, @AHpin int, @Aid int, @result int OUTPUT
AS
BEGIN TRANSACTION [transConfirmLogin]
BEGIN TRY
	IF EXISTS
(SELECT aha.aID, aha.ahID,accountholder.id,accountholder.pin FROM aha INNER JOIN accountholder
	ON aha.ahID = accountholder.id AND accountholder.id = @AHid AND accountholder.pin = @AHpin AND aha.aid = @Aid) 
	SET @result = 1
	ELSE SET @result = 0
COMMIT TRANSACTION [transConfirmLogin]
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION [transConfirmLogin]
END CATCH
GO
GO
