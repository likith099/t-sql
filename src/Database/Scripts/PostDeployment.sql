-- Post-Deployment Script
-- This script runs after the main schema is deployed.
-- Seeding is controlled via a SQLCMD variable: SeedSampleData (default: true)
-- Set in project/publish profile, or override at deploy time.

PRINT 'Post-deployment script starting...';
GO

IF LOWER('$(SeedSampleData)') = 'true'
BEGIN
	PRINT 'Seeding sample data...';

	-- Customers
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Customer] WHERE [Email] = 'alice@example.com')
		INSERT INTO [dbo].[Customer]([FirstName],[LastName],[Email]) VALUES ('Alice','Anderson','alice@example.com');

	IF NOT EXISTS (SELECT 1 FROM [dbo].[Customer] WHERE [Email] = 'bob@example.com')
		INSERT INTO [dbo].[Customer]([FirstName],[LastName],[Email]) VALUES ('Bob','Brown','bob@example.com');

	-- Products
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Product] WHERE [Sku] = 'SKU-001')
		INSERT INTO [dbo].[Product]([Sku],[Name],[Price]) VALUES ('SKU-001','Widget', 9.99);

	IF NOT EXISTS (SELECT 1 FROM [dbo].[Product] WHERE [Sku] = 'SKU-002')
		INSERT INTO [dbo].[Product]([Sku],[Name],[Price]) VALUES ('SKU-002','Gadget', 14.99);

	-- One sample order for Alice with two items
	DECLARE @aliceId INT = (SELECT TOP 1 [CustomerId] FROM [dbo].[Customer] WHERE [Email] = 'alice@example.com');
	DECLARE @sku1 INT = (SELECT TOP 1 [ProductId] FROM [dbo].[Product] WHERE [Sku] = 'SKU-001');
	DECLARE @sku2 INT = (SELECT TOP 1 [ProductId] FROM [dbo].[Product] WHERE [Sku] = 'SKU-002');

	IF @aliceId IS NOT NULL
	BEGIN
		DECLARE @orderId INT;
		IF NOT EXISTS (SELECT 1 FROM [dbo].[Order] o JOIN [dbo].[OrderItem] oi ON o.[OrderId]=oi.[OrderId] WHERE o.[CustomerId]=@aliceId)
		BEGIN
			INSERT INTO [dbo].[Order]([CustomerId],[Subtotal],[Tax]) VALUES (@aliceId, 0, 0);
			SET @orderId = SCOPE_IDENTITY();

			IF @sku1 IS NOT NULL
				INSERT INTO [dbo].[OrderItem]([OrderId],[ProductId],[Quantity],[UnitPrice])
				SELECT @orderId, @sku1, 2, [Price] FROM [dbo].[Product] WHERE [ProductId]=@sku1;

			IF @sku2 IS NOT NULL
				INSERT INTO [dbo].[OrderItem]([OrderId],[ProductId],[Quantity],[UnitPrice])
				SELECT @orderId, @sku2, 1, [Price] FROM [dbo].[Product] WHERE [ProductId]=@sku2;

			-- Update order subtotal based on items
			UPDATE o
			SET Subtotal = x.SumTotal,
				Tax = ROUND(x.SumTotal * 0.07, 2)
			FROM [dbo].[Order] o
			CROSS APPLY (
				SELECT SUM([LineTotal]) AS SumTotal
				FROM [dbo].[OrderItem]
				WHERE [OrderId] = o.[OrderId]
			) x
			WHERE o.[OrderId] = @orderId;
		END
	END
END

GO
PRINT 'Post-deployment script complete.';
