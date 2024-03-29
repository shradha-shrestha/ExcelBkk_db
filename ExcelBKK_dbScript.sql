USE [master]
GO
/****** Object:  Database [ExcelBkkDB]    Script Date: 7/18/2015 5:53:08 PM ******/
CREATE DATABASE [ExcelBkkDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ExcelBkkDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLSERVER\MSSQL\DATA\ExcelBkkDB.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ExcelBkkDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLSERVER\MSSQL\DATA\ExcelBkkDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ExcelBkkDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ExcelBkkDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ExcelBkkDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ExcelBkkDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ExcelBkkDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ExcelBkkDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ExcelBkkDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ExcelBkkDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ExcelBkkDB] SET  MULTI_USER 
GO
ALTER DATABASE [ExcelBkkDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ExcelBkkDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ExcelBkkDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ExcelBkkDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [ExcelBkkDB]
GO
/****** Object:  StoredProcedure [dbo].[insertCourseDetails]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCourseDetails]
@userId BIGINT,
@courseName NVARCHAR(250),
@courseDescription NVARCHAR(MAX),
@courseCategory NVARCHAR(250),
@startTime NVARCHAR(10),
@endTime NVARCHAR(10),
@numberOfStudent BIGINT
AS
BEGIN
SET NOCOUNT ON;

INSERT INTO tblCourse(userId,courseName,courseDescription,courseCategory,startTime,endTime,numberOfStudent)
VALUES(@userId,@courseName,@courseDescription,@courseCategory,@startTime,@endTime,@numberOfStudent)
RETURN SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[insertUserDetails]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertUserDetails](
    @firstName NVARCHAR(20),
    @lastName NVARCHAR(20),
    @nickName NVARCHAR(20),     
	@dateOfBirth DateTime,
	@role NVARCHAR(20),
	@userName NVARCHAR(20),
	@password NVARCHAR (20),
	@isActive NVARCHAR (1)
)
AS
BEGIN
INSERT INTO tblUser(
    [firstName],
    [lastName],
    [nickName],
    [dateOfBirth],
    [role],
    [userName],
    [password],
    [isActive]
) VALUES (
    @firstName,
    @lastName,
    @nickName,
    @dateOfBirth,
    @role,
    @userName,
    @password,
    @isActive
)
END
GO
/****** Object:  StoredProcedure [dbo].[searchCourse]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[searchCourse]

@userId BIGINT,

@courseName NVARCHAR(MAX),

@startTime NVARCHAR(10),

@endTime NVARCHAR(10)

AS

BEGIN

DECLARE @WHERE NVARCHAR(MAX),@Z NVARCHAR(MAX)

SET @WHERE=' 1=1 '

IF(@userId > 0)

SET @WHERE=@WHERE+' AND c.userId='+CAST(@userId AS NVARCHAR)



if(@courseName !='')

SET @WHERE =@WHERE +' AND c.courseName ='''+@courseName+''''



if(@startTime != '')

SET @WHERE=@WHERE+' AND c.startTime='''+CAST(@startTime AS NVARCHAR)+''''



if(@endTime ! = '')

SET @WHERE=@WHERE+' AND c.endTime='''+CAST(@endTime AS NVARCHAR)+''''

SET @Z='SELECT c.*,u.firstName+'' ''+u.lastName as instructorName  FROM tblCourse C LEFT JOIN tbluser U ON C.userId=U.userId

WHERE C.userId=U.userId

AND '+@WHERE

--SET @Z='SELECT * FROM tblCourse WHERE '+@WHERE

--PRINT(@Z)

EXEC(@Z)

END

GO
/****** Object:  StoredProcedure [dbo].[selectUserByLoginDetails]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[selectUserByLoginDetails](    
	@userName NVARCHAR(20),
	@password NVARCHAR (20)	
)
AS
BEGIN
SELECT * FROM tblUser WHERE [userName] = @userName and [password] = @password   
END
GO
/****** Object:  StoredProcedure [dbo].[selectUserDetails]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[selectUserDetails]
@userId bigint
as
begin
select * from tblUser where userId = @userId
end

GO
/****** Object:  StoredProcedure [dbo].[updateUserDetails]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[updateUserDetails]
@userId bigint,
@firstName NVARCHAR(200),
@lastName NVARCHAR(200),
@nickName NVARCHAR(200),
@dateOfBirth DATETIME
as
begin
update tblUser set [firstName] = @firstName, [lastName] = @lastName, [nickName] = @nickName, dateofBirth = @dateOfBirth where userId = @userId
end
GO
/****** Object:  StoredProcedure [dbo].[verifyUserName]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[verifyUserName]
@userName NVARCHAR(200)
as 
begin
select * from tblUser where [userName] = @userName
end
GO
/****** Object:  Table [dbo].[tblCourse]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCourse](
	[courseId] [bigint] IDENTITY(1,1) NOT NULL,
	[userId] [bigint] NULL,
	[courseName] [nvarchar](250) NULL,
	[courseDescription] [nvarchar](max) NULL,
	[courseCategory] [nvarchar](250) NULL,
	[startTime] [nvarchar](10) NULL,
	[endTime] [nvarchar](10) NULL,
	[numberOfStudent] [bigint] NULL,
	[entryDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[courseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 7/18/2015 5:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUser](
	[userId] [bigint] IDENTITY(1,1) NOT NULL,
	[firstName] [nvarchar](200) NOT NULL,
	[lastName] [nvarchar](200) NOT NULL,
	[nickName] [nvarchar](200) NULL,
	[dateOfBirth] [datetime] NULL,
	[role] [nvarchar](20) NOT NULL,
	[userName] [nvarchar](200) NULL,
	[password] [nvarchar](200) NOT NULL,
	[isActive] [nvarchar](1) NULL,
 CONSTRAINT [UNIQUE_USERNAME] UNIQUE NONCLUSTERED 
(
	[userName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCourse] ADD  DEFAULT (getdate()) FOR [entryDate]
GO
USE [master]
GO
ALTER DATABASE [ExcelBkkDB] SET  READ_WRITE 
GO
