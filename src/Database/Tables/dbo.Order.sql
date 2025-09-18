CREATE TABLE [dbo].[Order]
(
    [OrderId] INT IDENTITY(1,1) NOT NULL CONSTRAINT [PK_Order] PRIMARY KEY,
    [CustomerId] INT NOT NULL,
    [OrderDateUtc] DATETIME2 NOT NULL CONSTRAINT [DF_Order_OrderDateUtc] DEFAULT (SYSUTCDATETIME()),
    [Subtotal] DECIMAL(18,2) NOT NULL CONSTRAINT [DF_Order_Subtotal] DEFAULT (0),
    [Tax] DECIMAL(18,2) NOT NULL CONSTRAINT [DF_Order_Tax] DEFAULT (0),
    [Total] AS ([Subtotal] + [Tax]) PERSISTED
);
