CREATE TABLE [dbo].[OrderItem]
(
  [OrderItemId] INT IDENTITY(1,1) NOT NULL CONSTRAINT [PK_OrderItem] PRIMARY KEY,
  [OrderId] INT NOT NULL,
  [ProductId] INT NOT NULL,
  [Quantity] INT NOT NULL CONSTRAINT [DF_OrderItem_Quantity] DEFAULT (1),
  [UnitPrice] DECIMAL(18,2) NOT NULL,
  [LineTotal] AS ([Quantity] * [UnitPrice]) PERSISTED
);
