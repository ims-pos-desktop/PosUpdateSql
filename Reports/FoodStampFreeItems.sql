IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FoodStampFreeItems')
CREATE TABLE [dbo].[FoodStampFreeItems](
	[stampId] [varchar](25) NOT NULL,
	[mcode] [varchar](25) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdBy] [varchar](25) NOT NULL,
	[createdOn] [datetime] NOT NULL,
	[modifiedBy] [varchar](25) NULL,
	[modifiedOn] [datetime] NULL,
 CONSTRAINT [PK_FoodStampFreeItems] PRIMARY KEY ([StampId],mcode),
 CONSTRAINT [FK_FoodStampFreeItems_MenuItem] FOREIGN KEY(mcode) REFERENCES [dbo].[MENUITEM] ([MCODE])
)


