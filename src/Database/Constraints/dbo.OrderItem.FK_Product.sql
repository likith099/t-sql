ALTER TABLE [dbo].[OrderItem]
  ADD CONSTRAINT [FK_OrderItem_Product] FOREIGN KEY ([ProductId])
      REFERENCES [dbo].[Product]([ProductId]) ON DELETE NO ACTION ON UPDATE NO ACTION;