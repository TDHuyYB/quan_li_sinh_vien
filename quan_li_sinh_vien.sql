USE [master]
GO
/****** Object:  Database [quan_li_sinh_vien]    Script Date: 9/7/2022 5:56:23 PM ******/
CREATE DATABASE [quan_li_sinh_vien]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'quan_li_sinh_vien', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\quan_li_sinh_vien.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'quan_li_sinh_vien_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\quan_li_sinh_vien_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [quan_li_sinh_vien] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [quan_li_sinh_vien].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [quan_li_sinh_vien] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET ARITHABORT OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [quan_li_sinh_vien] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [quan_li_sinh_vien] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [quan_li_sinh_vien] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET  ENABLE_BROKER 
GO
ALTER DATABASE [quan_li_sinh_vien] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [quan_li_sinh_vien] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [quan_li_sinh_vien] SET  MULTI_USER 
GO
ALTER DATABASE [quan_li_sinh_vien] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [quan_li_sinh_vien] SET DB_CHAINING OFF 
GO
ALTER DATABASE [quan_li_sinh_vien] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [quan_li_sinh_vien] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [quan_li_sinh_vien] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [quan_li_sinh_vien] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [quan_li_sinh_vien] SET QUERY_STORE = OFF
GO
USE [quan_li_sinh_vien]
GO
/****** Object:  UserDefinedFunction [dbo].[UF_avg_score_of_student]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UF_avg_score_of_student](@ma_SV nvarchar(10))
RETURNS Float
BEGIN
	DECLARE @kq float
	SELECT @kq = AVG(diem)
	FROM 
		(SELECT dbo.UF_last_score_of_studen(ma_SV, ma_MH) AS diem
		FROM dbo.ket_qua
		WHERE ma_SV = @ma_SV
		GROUP BY ma_SV, ma_MH) AS kq

	RETURN @kq
END
GO
/****** Object:  UserDefinedFunction [dbo].[UF_check_sv_in_khoa]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UF_check_sv_in_khoa] (@masv NVARCHAR(10), @makhoa VARCHAR(10))
RETURNS varchar(5)
AS
BEGIN
	DECLARE @ketqua VARCHAR(5) = 'false'; 
	IF 
		EXISTS
			(SELECT * 
			FROM dbo.sinh_vien
			INNER JOIN dbo.lop
				ON lop.ma_lop = dbo.sinh_vien.ma_lop AND lop.ma_khoa = @makhoa
			WHERE dbo.sinh_vien.ma_SV = @maSV)
			SET @ketqua = 'true'
	RETURN @ketqua
END
GO
/****** Object:  UserDefinedFunction [dbo].[UF_last_score_of_studen]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UF_last_score_of_studen] (@ma_sv nvarchar(10), @ma_MH varchar(10))
RETURNS float
AS
BEGIN
	DECLARE @kq float;
	 SELECT TOP (1) @kq = diem 
				FROM dbo.ket_qua
				WHERE dbo.ket_qua.ma_SV = @ma_sv AND dbo.ket_qua.ma_MH = @ma_MH
				ORDER BY lan_thi DESC  
	RETURN @kq
END
GO
/****** Object:  Table [dbo].[chuong_trinh_hoc]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chuong_trinh_hoc](
	[ma_CT] [varchar](10) NOT NULL,
	[ten_CT] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_CT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[giang_khoa]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[giang_khoa](
	[ma_CT] [varchar](10) NOT NULL,
	[ma_khoa] [varchar](10) NOT NULL,
	[ma_MH] [varchar](10) NOT NULL,
	[nam_hoc] [int] NOT NULL,
	[hoc_ky] [varchar](3) NULL,
	[STLT] [int] NULL,
	[STTH] [int] NULL,
	[so_tin_chi] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_CT] ASC,
	[ma_khoa] ASC,
	[ma_MH] ASC,
	[nam_hoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ket_qua]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ket_qua](
	[ma_SV] [nvarchar](10) NOT NULL,
	[ma_MH] [varchar](10) NOT NULL,
	[lan_thi] [int] NOT NULL,
	[diem] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_SV] ASC,
	[ma_MH] ASC,
	[lan_thi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[khoa]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[khoa](
	[ma_khoa] [varchar](10) NOT NULL,
	[ten_khoa] [nvarchar](100) NULL,
	[nam_thanh_lap] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_khoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[khoa_hoc]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[khoa_hoc](
	[ma_khoa_hoc] [varchar](10) NOT NULL,
	[nam_bat_dau] [int] NULL,
	[nam_ket_thuc] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_khoa_hoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lop]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lop](
	[ma_lop] [nvarchar](10) NOT NULL,
	[ma_khoa] [varchar](10) NOT NULL,
	[ma_khoa_hoc] [varchar](10) NOT NULL,
	[ma_CT] [varchar](10) NOT NULL,
	[STT] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_lop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mon_hoc]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_hoc](
	[ma_MH] [varchar](10) NOT NULL,
	[ten_MH] [nvarchar](100) NULL,
	[ma_khoa] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_MH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sinh_vien]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sinh_vien](
	[ma_SV] [nvarchar](10) NOT NULL,
	[ho_ten] [nvarchar](100) NULL,
	[nam_sinh] [int] NULL,
	[dan_toc] [nvarchar](20) NULL,
	[ma_lop] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_SV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[ssl] [varchar](9) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[chuong_trinh_hoc] ([ma_CT], [ten_CT]) VALUES (N'CD', N'Cao đẳng')
INSERT [dbo].[chuong_trinh_hoc] ([ma_CT], [ten_CT]) VALUES (N'CQ', N'Chính quy')
INSERT [dbo].[chuong_trinh_hoc] ([ma_CT], [ten_CT]) VALUES (N'TC', N'Tại chức')
GO
INSERT [dbo].[giang_khoa] ([ma_CT], [ma_khoa], [ma_MH], [nam_hoc], [hoc_ky], [STLT], [STTH], [so_tin_chi]) VALUES (N'CQ', N'CNTT', N'THCS01', 2004, N'HK1', 45, 30, 4)
INSERT [dbo].[giang_khoa] ([ma_CT], [ma_khoa], [ma_MH], [nam_hoc], [hoc_ky], [STLT], [STTH], [so_tin_chi]) VALUES (N'CQ', N'CNTT', N'THT01', 2003, N'HK1', 60, 30, 5)
INSERT [dbo].[giang_khoa] ([ma_CT], [ma_khoa], [ma_MH], [nam_hoc], [hoc_ky], [STLT], [STTH], [so_tin_chi]) VALUES (N'CQ', N'CNTT', N'THT02', 2003, N'HK2', 45, 30, 4)
GO
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212001', N'THCS01', 1, 6.5)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212001', N'THT01', 1, 4)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212001', N'THT01', 2, 7)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212001', N'THT02', 1, 8)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212002', N'THCS01', 1, 4)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212002', N'THCS01', 2, 7)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212002', N'THT01', 1, 8)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212002', N'THT02', 1, 5.5)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212003', N'THT01', 1, 6)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212003', N'THT02', 1, 4)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212003', N'THT02', 2, 6)
INSERT [dbo].[ket_qua] ([ma_SV], [ma_MH], [lan_thi], [diem]) VALUES (N'0212004', N'THT01', 1, 9)
GO
INSERT [dbo].[khoa] ([ma_khoa], [ten_khoa], [nam_thanh_lap]) VALUES (N'CNTT', N'Công nghệ thông tin', 1995)
INSERT [dbo].[khoa] ([ma_khoa], [ten_khoa], [nam_thanh_lap]) VALUES (N'VL', N'Vật lý', 1970)
GO
INSERT [dbo].[khoa_hoc] ([ma_khoa_hoc], [nam_bat_dau], [nam_ket_thuc]) VALUES (N'K2002', 2002, 2006)
INSERT [dbo].[khoa_hoc] ([ma_khoa_hoc], [nam_bat_dau], [nam_ket_thuc]) VALUES (N'K2003', 2003, 2007)
INSERT [dbo].[khoa_hoc] ([ma_khoa_hoc], [nam_bat_dau], [nam_ket_thuc]) VALUES (N'K2004', 2004, 2008)
GO
INSERT [dbo].[lop] ([ma_lop], [ma_khoa], [ma_khoa_hoc], [ma_CT], [STT]) VALUES (N'TH2002/01', N'CNTT', N'K2002', N'CQ', 1)
INSERT [dbo].[lop] ([ma_lop], [ma_khoa], [ma_khoa_hoc], [ma_CT], [STT]) VALUES (N'TH2002/02', N'CNTT', N'K2002', N'CQ', 2)
INSERT [dbo].[lop] ([ma_lop], [ma_khoa], [ma_khoa_hoc], [ma_CT], [STT]) VALUES (N'VL2003/01', N'VL', N'K2003', N'CQ', 1)
GO
INSERT [dbo].[mon_hoc] ([ma_MH], [ten_MH], [ma_khoa]) VALUES (N'THCS01', N'Cấu trúc dữ liệu 1', N'CNTT')
INSERT [dbo].[mon_hoc] ([ma_MH], [ten_MH], [ma_khoa]) VALUES (N'THCS02', N'Hệ điều hành ', N'CNTT')
INSERT [dbo].[mon_hoc] ([ma_MH], [ten_MH], [ma_khoa]) VALUES (N'THT01', N'Toán cao cấp A1', N'CNTT')
INSERT [dbo].[mon_hoc] ([ma_MH], [ten_MH], [ma_khoa]) VALUES (N'THT02', N'Toán rời rạc', N'CNTT')
INSERT [dbo].[mon_hoc] ([ma_MH], [ten_MH], [ma_khoa]) VALUES (N'VLT01', N'Toán cao cấp A1', N'VL')
GO
INSERT [dbo].[sinh_vien] ([ma_SV], [ho_ten], [nam_sinh], [dan_toc], [ma_lop]) VALUES (N'0212001', N'Nguyễn Vĩnh An', 1984, N'Kinh', N'TH2002/01')
INSERT [dbo].[sinh_vien] ([ma_SV], [ho_ten], [nam_sinh], [dan_toc], [ma_lop]) VALUES (N'0212002', N'Nguyễn Thanh Bình', 1985, N'Kinh', N'TH2002/01')
INSERT [dbo].[sinh_vien] ([ma_SV], [ho_ten], [nam_sinh], [dan_toc], [ma_lop]) VALUES (N'0212003', N'Nguyễn Thanh Cường', 1984, N'Kinh', N'TH2002/02')
INSERT [dbo].[sinh_vien] ([ma_SV], [ho_ten], [nam_sinh], [dan_toc], [ma_lop]) VALUES (N'0212004', N'Nguyễn Quốc Duy', 1983, N'Kinh', N'TH2002/02')
INSERT [dbo].[sinh_vien] ([ma_SV], [ho_ten], [nam_sinh], [dan_toc], [ma_lop]) VALUES (N'0311001', N'Phần Tuấn Anh', 1985, N'Kinh', N'VL2003/01')
INSERT [dbo].[sinh_vien] ([ma_SV], [ho_ten], [nam_sinh], [dan_toc], [ma_lop]) VALUES (N'0311002', N'Huỳnh Thanh Sang', 1984, N'Kinh', N'VL2003/01')
GO
INSERT [dbo].[test] ([ssl]) VALUES (N'1')
INSERT [dbo].[test] ([ssl]) VALUES (N'2')
INSERT [dbo].[test] ([ssl]) VALUES (N'3')
INSERT [dbo].[test] ([ssl]) VALUES (N'4')
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD FOREIGN KEY([ma_CT])
REFERENCES [dbo].[chuong_trinh_hoc] ([ma_CT])
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD FOREIGN KEY([ma_khoa])
REFERENCES [dbo].[khoa] ([ma_khoa])
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD FOREIGN KEY([ma_MH])
REFERENCES [dbo].[mon_hoc] ([ma_MH])
GO
ALTER TABLE [dbo].[ket_qua]  WITH CHECK ADD FOREIGN KEY([ma_MH])
REFERENCES [dbo].[mon_hoc] ([ma_MH])
GO
ALTER TABLE [dbo].[ket_qua]  WITH CHECK ADD FOREIGN KEY([ma_SV])
REFERENCES [dbo].[sinh_vien] ([ma_SV])
GO
ALTER TABLE [dbo].[lop]  WITH CHECK ADD FOREIGN KEY([ma_CT])
REFERENCES [dbo].[chuong_trinh_hoc] ([ma_CT])
GO
ALTER TABLE [dbo].[lop]  WITH CHECK ADD FOREIGN KEY([ma_khoa])
REFERENCES [dbo].[khoa] ([ma_khoa])
GO
ALTER TABLE [dbo].[lop]  WITH CHECK ADD FOREIGN KEY([ma_khoa_hoc])
REFERENCES [dbo].[khoa_hoc] ([ma_khoa_hoc])
GO
ALTER TABLE [dbo].[mon_hoc]  WITH CHECK ADD FOREIGN KEY([ma_khoa])
REFERENCES [dbo].[khoa] ([ma_khoa])
GO
ALTER TABLE [dbo].[sinh_vien]  WITH CHECK ADD FOREIGN KEY([ma_lop])
REFERENCES [dbo].[lop] ([ma_lop])
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD  CONSTRAINT [check_hoc_ki] CHECK  (([hoc_ky]='HK2' OR [hoc_ky]='HK1'))
GO
ALTER TABLE [dbo].[giang_khoa] CHECK CONSTRAINT [check_hoc_ki]
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD  CONSTRAINT [check_max_STC] CHECK  (([so_tin_chi]<=(6)))
GO
ALTER TABLE [dbo].[giang_khoa] CHECK CONSTRAINT [check_max_STC]
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD  CONSTRAINT [check_max_STLT] CHECK  (([STLT]<=(120)))
GO
ALTER TABLE [dbo].[giang_khoa] CHECK CONSTRAINT [check_max_STLT]
GO
ALTER TABLE [dbo].[giang_khoa]  WITH CHECK ADD  CONSTRAINT [check_max_STTH] CHECK  (([STLT]<=(60)))
GO
ALTER TABLE [dbo].[giang_khoa] CHECK CONSTRAINT [check_max_STTH]
GO
/****** Object:  StoredProcedure [dbo].[UP_check_pass_MH]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_check_pass_MH] (@ma_SV nvarchar(10), @ma_MH varchar(10))
AS
BEGIN
	DECLARE @diem FLOAT;
	IF (EXISTS
			(SELECT MAX(diem)
			FROM dbo.ket_qua
			WHERE dbo.ket_qua.ma_SV = @ma_SV AND dbo.ket_qua.ma_MH = @ma_MH)
		)

		BEGIN
			SELECT @diem = MAX(diem)
			FROM dbo.ket_qua
			WHERE dbo.ket_qua.ma_SV = @ma_SV AND dbo.ket_qua.ma_MH = @ma_MH
			IF (@diem > 5) 
				PRINT 'da qua mon'
			ELSE 
				PRINT 'chua qua mon'
		END
	ELSE
		PRINT 'chua qua mon'
END
GO
/****** Object:  StoredProcedure [dbo].[UP_compare_score]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_compare_score] (@ma_SV1 nvarchar(10), @ma_SV2 nvarchar(10), @ma_MH varchar(10))
AS
BEGIN
	DECLARE @diem_sv1 float = 0
	DECLARE @diem_sv2 float = 0

	SELECT TOP (1) @diem_sv1 = diem
	FROM dbo.ket_qua
	WHERE dbo.ket_qua.ma_SV = @ma_SV1 AND dbo.ket_qua.ma_MH = @ma_MH

	SELECT TOP(1) @diem_sv2 = diem 
	FROM dbo.ket_qua
	WHERE dbo.ket_qua.ma_SV = @ma_SV2 AND dbo.ket_qua.ma_MH = @ma_MH

	IF (@diem_sv1 >  @diem_sv2)
		PRINT @ma_SV1
	ELSE
		PRINT @ma_SV2
END
GO
/****** Object:  StoredProcedure [dbo].[UP_lan_thi_va_diem]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UP_lan_thi_va_diem] (@ma_SV VARCHAR(10), @ma_MH VARCHAR(10))
AS
BEGIN
SELECT lan_thi, diem
FROM dbo.ket_qua
WHERE dbo.ket_qua.ma_SV = @ma_SV AND dbo.ket_qua.ma_MH = @ma_MH
END
GO
/****** Object:  StoredProcedure [dbo].[UP_list_sv_from_ma_lop]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_list_sv_from_ma_lop](@ma_lop nvarchar(10))
AS
BEGIN
	SELECT * FROM dbo.sinh_vien
	WHERE dbo.sinh_vien.ma_lop = @ma_lop
END
GO
/****** Object:  StoredProcedure [dbo].[UP_List_SV_In_Khoa]    Script Date: 9/7/2022 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UP_List_SV_In_Khoa] @makhoa VARCHAR(10)
AS
begin
SELECT Sinh_Vien.* 
FROM Sinh_Vien 
LEFT JOIN Lop 
	ON Sinh_Vien.Ma_Lop = Lop.Ma_Lop
LEFT JOIN Khoa 
	ON Lop.Ma_Khoa = Khoa.Ma_Khoa 
end
GO
USE [master]
GO
ALTER DATABASE [quan_li_sinh_vien] SET  READ_WRITE 
GO
