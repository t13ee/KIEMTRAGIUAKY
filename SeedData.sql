CREATE DATABASE CourseRegistrationDb;
GO
USE CourseRegistrationDb;
GO

-- 1. TẠO CÁC BẢNG CỦA ASP.NET CORE IDENTITY
CREATE TABLE [AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(128) NOT NULL,
    [ProviderKey] nvarchar(128) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(128) NOT NULL,
    [Name] nvarchar(128) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

-- 2. TẠO CÁC BẢNG CUSTOM CHO ỨNG DỤNG
CREATE TABLE [Categories] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
);

CREATE TABLE [Courses] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(255) NOT NULL,
    [Image] nvarchar(255) NULL,
    [Credits] int NOT NULL,
    [Lecturer] nvarchar(100) NULL,
    [CategoryId] int NOT NULL,
    CONSTRAINT [PK_Courses] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Courses_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [Enrollments] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [CourseId] int NOT NULL,
    [EnrollDate] datetime2 NOT NULL,
    CONSTRAINT [PK_Enrollments] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Enrollments_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Enrollments_Courses_CourseId] FOREIGN KEY ([CourseId]) REFERENCES [Courses] ([Id]) ON DELETE CASCADE
);

-- 3. THÊM DỮ LIỆU MẪU
SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (Id, Name) VALUES
(1, N'Công nghệ phần mềm'),
(2, N'Hệ thống thông tin'),
(3, N'Mạng máy tính'),
(4, N'Khoa học máy tính');
SET IDENTITY_INSERT Categories OFF;

SET IDENTITY_INSERT Courses ON;
INSERT INTO Courses (Id, Name, Image, Credits, Lecturer, CategoryId) VALUES
(1, N'Lập trình Web với ASP.NET Core', 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=400&q=80', 3, N'Nguyễn Văn A', 1),
(2, N'Cơ sở dữ liệu SQL Server', 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=400&q=80', 3, N'Trần Thị B', 2),
(3, N'Kiến trúc máy tính', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80', 3, N'Lê Văn C', 3),
(4, N'Cấu trúc dữ liệu và giải thuật', 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=400&q=80', 4, N'Phạm Văn D', 4),
(5, N'Lập trình Java Căn bản', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400&q=80', 3, N'Hoàng Thị E', 1),
(6, N'Mạng máy tính cơ bản', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&q=80', 3, N'Đặng Văn F', 3),
(7, N'Phát triển ứng dụng Di động', 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&q=80', 3, N'Bùi Thị G', 1),
(8, N'Trí tuệ nhân tạo (AI)', 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&q=80', 3, N'Vũ Văn H', 4);
SET IDENTITY_INSERT Courses OFF;
GO
