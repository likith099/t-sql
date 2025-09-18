ALTER TABLE [dbo].[OrderItem]
  ADD CONSTRAINT [FK_OrderItem_Order] FOREIGN KEY ([OrderId])
      REFERENCES [dbo].[Order]([OrderId]) ON DELETE CASCADE ON UPDATE NO ACTION;