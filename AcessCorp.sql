--O SGBD utilizado no projeto foi o Microsoft SQL Server 2022

--Tabela Usuarios
-- Usada para armazenar informações sobre os usuários do sistema, incluindo detalhes de autenticação e autorização.
CREATE TABLE [dbo].[AspNetUsers](
    [Id] NVARCHAR(450) NOT NULL,
    [UserName] NVARCHAR(256) NULL,
    [NormalizedUserName] NVARCHAR(256) NULL,
    [Email] NVARCHAR(256) NULL,
    [NormalizedEmail] NVARCHAR(256) NULL,
    [EmailConfirmed] BIT NOT NULL,
    [PasswordHash] NVARCHAR(MAX) NULL,
    [SecurityStamp] NVARCHAR(MAX) NULL,
    [ConcurrencyStamp] NVARCHAR(MAX) NULL,
    [PhoneNumber] NVARCHAR(MAX) NULL,
    [PhoneNumberConfirmed] BIT NOT NULL,
    [TwoFactorEnabled] BIT NOT NULL,
    [LockoutEnd] DATETIMEOFFSET(7) NULL,
    [LockoutEnabled] BIT NOT NULL,
    [AccessFailedCount] INT NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED ([Id])
);
--Tabela de Permissões 
-- A tabela de permissões é uma tabela auxiliar que armazena as permissões associadas a cada usuário.
CREATE TABLE [dbo].[AspNetUserClaims](
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] NVARCHAR(450) NOT NULL,
    [ClaimType] NVARCHAR(MAX) NULL,
    [ClaimValue] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_Claims_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers]([Id])
);

-- Tabela de Administradores
-- A tabela de administradores armazena informações sobre os administradores do sistema, incluindo detalhes pessoais e de autenticação.
CREATE TABLE [dbo].[Administrators] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL,
    [Phone] NVARCHAR(20) NOT NULL,
    [Cpf] NVARCHAR(14) NOT NULL,
    [Cep] NVARCHAR(10) NOT NULL,
    [HouseNumber] INT NOT NULL,
    [Password] NVARCHAR(255) NOT NULL,
    [IdentityId] NVARCHAR(450) NOT NULL,
    [Image] NVARCHAR(255) NOT NULL,
    [ImageUpload] VARBINARY(MAX) NOT NULL,
    CONSTRAINT [PK_Administrators] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_Administrators_AspNetUsers] FOREIGN KEY ([IdentityId]) REFERENCES [dbo].[AspNetUsers]([Id])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];



-- Tabela de Porteiros
-- A tabela de porteiros armazena informações sobre os porteiros do sistema, incluindo detalhes pessoais e de autenticação.
-- Ela também possui uma chave estrangeira que referencia a tabela de administradores, indicando qual administrador incluiu o porteiro no sistema.
CREATE TABLE [dbo].[Doormans] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL,
    [Phone] NVARCHAR(20) NOT NULL,
    [Cpf] NVARCHAR(14) NOT NULL,
    [Cep] NVARCHAR(10) NOT NULL,
    [Password] NVARCHAR(255) NOT NULL,
    [IdentityId] NVARCHAR(450) NOT NULL,
    [AdministratorId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_Doormans] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_Doormans_AspNetUsers] FOREIGN KEY ([IdentityId]) REFERENCES [dbo].[AspNetUsers]([Id]),
    CONSTRAINT [FK_Doormans_Administrators] FOREIGN KEY ([AdministratorId]) REFERENCES [dbo].[Administrators]([Id])
) ON [PRIMARY];

-- Tabela de Entregas
-- A tabela de entregas armazena informações sobre as entregas realizadas, incluindo detalhes do entregador e do destinatário.
-- Ela também possui uma chave estrangeira que referencia a tabela de porteiros, indicando qual porteiro registrou a entrega.
CREATE TABLE [dbo].[Deliveries] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Receiver] NVARCHAR(150) NOT NULL,       
    [DeliveryDate] DATETIME2(7) NOT NULL,
    [Enterprise] NVARCHAR(150) NOT NULL,      
    [DeliveredTo] NVARCHAR(150) NOT NULL,    
    [NumberHouse] INT NOT NULL,
    [Cep] NVARCHAR(10) NOT NULL,              
    [DoormanId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_Deliveries] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Deliveries_Doormans] FOREIGN KEY ([DoormanId]) REFERENCES [dbo].[Doormans]([Id])
) ON [PRIMARY];





-- Tabela de Visitantes
-- A tabela de visitantes armazena informações sobre os visitantes do condomínio. 
-- Tabela relacionada à tabela de porteiros, indicando qual porteiro registrou o visitante.
CREATE TABLE [dbo].[Guests] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,            
    [LastName] NVARCHAR(100) NOT NULL,        
    [Email] NVARCHAR(150) NOT NULL,            
    [Phone] NVARCHAR(20) NOT NULL,            
    [Cpf] NVARCHAR(14) NOT NULL,                
    [DoormanId] UNIQUEIDENTIFIER NULL,         
    [Cep] NVARCHAR(10) NOT NULL,               
    [CepGuest] NVARCHAR(10) NOT NULL,           
    CONSTRAINT [PK_Guests] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Guests_Doormans] FOREIGN KEY ([DoormanId]) REFERENCES [dbo].[Doormans]([Id])
) ON [PRIMARY];


-- Tabela de Moradores
-- A tabela de moradores armazena informações sobre os moradores do condomínio, incluindo detalhes pessoais e de contato.
-- Ela também possui uma chave estrangeira que referencia a tabela de administradores, indicando qual administrador incluiu o morador no sistema.
CREATE TABLE [dbo].[Residents] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,           
    [LastName] NVARCHAR(100) NOT NULL,        
    [Email] NVARCHAR(150) NOT NULL,           
    [Phone] NVARCHAR(20) NOT NULL,             
    [Cpf] NVARCHAR(14) NOT NULL,               
    [Cep] NVARCHAR(10) NOT NULL,                
    [HouseNumber] INT NOT NULL,
    [AdministratorId] UNIQUEIDENTIFIER NULL,
    [Image] NVARCHAR(255) NOT NULL,              
    [ImageUpload] VARBINARY(MAX) NOT NULL,      
    CONSTRAINT [PK_Residents] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Residents_Administrators] FOREIGN KEY ([AdministratorId]) REFERENCES [dbo].[Administrators]([Id])
) ON [PRIMARY];

-- Inserts para a tabela AspNetUsers

INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES

(N'08c1f06c-ab3d-4aaf-9d5d-2b3e6a38a320', N'henrique', N'HENRIQUE', N'henriquesiqueira@acesscorp.com.br', N'HENRIQUESIQUEIRA@ACESSCORP.COM.BR', 1, N'AQAAAAEAACcQAAAAEDUrcSxL3yxMTZzbsK4D6RrZ2zZ2RZs3TnUopJ9g8K0S4IjD1A7F3ufLmSnvYKm7RQ==', N'SEC123SEC123SEC123SEC123SEC123SE', N'CONC1234-CONC-5678-CONC-90ABCDEF1234', N'11987654321', 1, 0, NULL, 1, 0),
(N'0a25c2c9-ee5b-433c-a5f0-ed18bbd1ba20', N'rafael', N'RAFAEL', N'rafa.almeida@acesscorp.com.br', N'RAFA.ALMEIDA@ACESSCORP.COM.BR', 1, N'AQAAAAEAACcQAAAAEF4tr3BL4UhzNz9RtxEcvRaZ3vXzZas5DoT2Q7dB+eH4Xl8MxD1fYu6Ke1jMjk8+Kw==', N'SEC234SEC234SEC234SEC234SEC234SE', N'CONC2345-CONC-6789-CONC-01BCDEFG2345', N'11912345678', 1, 0, NULL, 1, 0),
(N'0a788e52-1121-42ee-9ade-87a5b3f818ad', N'gabriela', N'GABRIELA', N'gabriela.ferreira@acesscorp.com.br', N'GABRIELA.FERREIRA@ACESSCORP.COM.BR', 1, N'AQAAAAEAACcQAAAAEGs4rvHZ5XoiPz0QyzFdvRbY4sYzabs6EpU3R8fE+gJ5Ym9NyE2gZv7Lf2kNkl9+Jx==', N'SEC345SEC345SEC345SEC345SEC345SE', N'CONC3456-CONC-7890-CONC-12CDEFGH3456', N'11999887766', 1, 0, NULL, 1, 0),
(N'1dd4160f-66b2-4821-bc58-db9345efa981', N'hebert', N'HEBERT', N'hebert.alquimim@acesscorp.com.br', N'HEBERT.ALQUIMIM@ACESSCORP.COM.BR', 1, N'AQAAAAEAACcQAAAAEIRRar5K0UhzOm8ZqsLhwEfZ5lRpZwt3ZrU7W5dZ+YjWUm0KpF2gXr9Qf3zLzja0Kw==', N'SEC456SEC456SEC456SEC456SEC456SE', N'CONC4567-CONC-8901-CONC-23DEFGHI4567', N'11666665555', 1, 0, NULL, 1, 0),
(N'38e0a7a4-3266-4c86-8d81-46339bdf0875', N'pamela', N'PAMELA', N'pamela.silvestre@acesscorp.com.br', N'PAMELA.SILVESTRE@ACESSCORP.COM.BR', 1, N'AQAAAAEAACcQAAAAEOQvpsR7L3hxOm9XptMhwGgY6mTqZxt4AsU8Y6fF+ZkXWn1LqG3hYr0Rg4aNkcb1Jz==', N'SEC567SEC567SEC567SEC567SEC567SE', N'CONC5678-CONC-9012-CONC-34EFGHIJ5678', N'11555554444', 1, 0, NULL, 1, 0),
(N'3fa85f64-5717-4562-b3fc-2c963f66afa6', N'vinicius', N'VINICIUS', N'vinicius.viana@acesscorp.com.br', N'VINICIUS.VIANA@ACESSCORP.COM.BR', 1, N'AQAAAAEAACcQAAAAEPSTqsS8N4ixPn0YruNiwHhZ7nUrYyu5BtV9Z7gG+lLXVo2MrH4iZs1Sh5bOlwd2Lk==', N'SEC678SEC678SEC678SEC678SEC678SE', N'CONC6789-CONC-0123-CONC-45FGHIJK6789', N'11444443333', 1, 0, NULL, 1, 0);

-- Inserts para a tabela AspNetUserClaims

SET IDENTITY_INSERT [dbo].[AspNetUserClaims] ON

INSERT INTO [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES
(1,    N'08c1f06c-ab3d-4aaf-9d5d-2b3e6a38a320', N'Permission', N'FullAccess'),
(2,    N'0a25c2c9-ee5b-433c-a5f0-ed18bbd1ba20', N'Permission', N'FullAccess'),
(3,    N'0a788e52-1121-42ee-9ade-87a5b3f818ad', N'Permission', N'FullAccess'),
(4,    N'1dd4160f-66b2-4821-bc58-db9345efa981', N'Permission', N'LimitedAccess'),
(5,    N'38e0a7a4-3266-4c86-8d81-46339bdf0875', N'Permission', N'LimitedAccess'),
(6,    N'3fa85f64-5717-4562-b3fc-2c963f66afa6', N'Permission', N'LimitedAccess');


SET IDENTITY_INSERT [dbo].[AspNetUserClaims] OFF;

-- Inserts para a tabela Administradores

INSERT [dbo].[Administrators] 
([Id], [Name], [LastName], [Email], [Phone], [Cpf], [Cep], [HouseNumber], [Password], [IdentityId], [Image], [ImageUpload]) 
VALUES 
(N'a1f3e0c5-1f2b-4e36-bc47-d726bbbc3c77', N'Henrique', N'Siqueira de Lima', N'henriquesiqueira@acesscorp.com.br', N'11987654321', N'12345678901', N'03633000', 1, N'Rs@2025', N'08c1f06c-ab3d-4aaf-9d5d-2b3e6a38a320', N'', 0x),
(N'b2c4d1d6-2e3c-4d47-ad28-834b65a2ee88', N'Rafael', N'Almeida', N'rafa.almeida@acesscorp.com.br', N'11912345678', N'23456789012', N'03633000', 2, N'Rs@1234', N'08c1f06c-ab3d-4aaf-9d5d-2b3e6a38a320', N'', 0x),
(N'c3d5e2e7-3f4d-5e58-be39-945c76b3ff99', N'Gabriela', N'Ferreira dos Santos', N'gabriela.ferreira@acesscorp.com.br', N'11999887766', N'34567890123', N'03633000', 3, N'Gf@1234', N'08c1f06c-ab3d-4aaf-9d5d-2b3e6a38a320', N'', 0x);

-- Inserts para a tabela Porteiros

INSERT [dbo].[Doormans] 
([Id], [Name], [LastName], [Email], [Phone], [Cpf], [Cep], [Password], [IdentityId], [AdministratorId]) 
VALUES 
(N'8d0c99b7-90cf-490e-b203-025be1ba895a', N'Hebert', N'Alquimim', N'hebert.alquimim@acesscorp.com.br', N'11987654321', N'37015369613', N'03633000', N'Ha@1234', N'0a25c2c9-ee5b-433c-a5f0-ed18bbd1ba20', N'b2c4d1d6-2e3c-4d47-ad28-834b65a2ee88'),
(N'3fa85f64-5717-4562-b3fc-2c963f66afa6', N'Pamela', N'Silvestre', N'pamela.silvestre@acesscorp.com.br', N'11912345678', N'94281382747', N'03633000', N'Ps@1234', N'0a25c2c9-ee5b-433c-a5f0-ed18bbd1ba20', N'a1f3e0c5-1f2b-4e36-bc47-d726bbbc3c77'),
(N'1948665e-cfe9-4169-bade-4dc94f93a85e', N'Vinicius', N'Viana', N'vinicius.viana@acesscorp.com.br', N'11934567890', N'29956899054', N'03633000', N'Vv@1234', N'0a25c2c9-ee5b-433c-a5f0-ed18bbd1ba20', N'a1f3e0c5-1f2b-4e36-bc47-d726bbbc3c77');

-- Inserts para a tabela Entregas

INSERT [dbo].[Deliveries] 
([Id], [Receiver], [DeliveryDate], [Enterprise], [DeliveredTo], [NumberHouse], [Cep], [DoormanId]) 
VALUES 
(N'9a97f821-4b91-4bcd-9b2e-b91f7f34d9a1', N'Hebert', CAST(N'2025-03-26T10:15:00.0000000' AS DateTime2), N'Amazon', N'Matheus', 24, N'03633000', N'8d0c99b7-90cf-490e-b203-025be1ba895a'),
(N'3cbb176e-cb82-4aa5-91b4-155a8e37c0a8', N'Pamela', CAST(N'2025-03-27T14:30:00.0000000' AS DateTime2), N'Mercado Livre', N'Juliana', 10, N'03633000', N'3fa85f64-5717-4562-b3fc-2c963f66afa6'),
(N'f1e2d3c4-b5a6-7890-1234-abcdef123456', N'Hebert', CAST(N'2025-03-28T09:45:00.0000000' AS DateTime2), N'Magalu', N'Ana Paula', 5, N'03633000', N'8d0c99b7-90cf-490e-b203-025be1ba895a');


-- Inserts para a tabela Visitante

INSERT [dbo].[Guests] 
([Id], [Name], [LastName], [Email], [Phone], [Cpf], [DoormanId], [Cep], [CepGuest]) 
VALUES 
(N'b1c21dd3-9b8a-4d1d-b002-2c3c27d5e3a0', N'Ana', N'Souza', N'ana.souza_23@example.com', N'11987654321', N'34567890123', N'3fa85f64-5717-4562-b3fc-2c963f66afa6', N'03633000', N'01001000'),
(N'c4e9aaef-d0de-4e10-a6e6-6acdb21579b6', N'Paulo', N'Joaquim', N'p.joaquim89@example.com', N'11912345678', N'45678901234', N'3fa85f64-5717-4562-b3fc-2c963f66afa6', N'03633000', N'02020000'),
(N'd7f8e9a1-1c23-4d56-b789-123456abcdef', N'Luciana', N'Martins', N'l.martins@example.com', N'11911223344', N'56789012345', N'3fa85f64-5717-4562-b3fc-2c963f66afa6', N'03633000', N'03030000');

-- Inserts para a tabela Moradores

INSERT [dbo].[Residents]
([Id], [Name], [LastName], [Email], [Phone], [Cpf], [Cep], [HouseNumber], [AdministratorId], [Image], [ImageUpload])
VALUES
('3b72c49a-7f0a-44c9-8c0f-f64d527fd101', 'Lucas', 'Marques', 'l.marques01@example.com', '998877665', '12345678901', '03633000', 15, 'a1f3e0c5-1f2b-4e36-bc47-d726bbbc3c77', '', 0x),
('ea1e83e3-b69c-499b-86c1-1dc31220c6fd', 'Fernanda', 'Souza', 'fernanda.souza22@example.com', '987654321', '23456789012', '03633000', 23, 'a1f3e0c5-1f2b-4e36-bc47-d726bbbc3c77', '', 0x),
('f15a3b12-8b3f-4e2f-8ccf-9fef2d42c987', 'Juliana', 'Castro', 'juliana.castro88@example.com', '912345678', '34567890123', '03633000', 10, 'c3d5e2e7-3f4d-5e58-be39-945c76b3ff99', '', 0x);


