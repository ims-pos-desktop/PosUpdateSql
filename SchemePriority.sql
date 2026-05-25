IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SchemePriority')
CREATE TABLE [dbo].[SchemePriority](
	[SchemeType] [varchar](20) NOT NULL,
	[SchemeId] [smallint] NOT NULL,
	[SchemeOrder] [smallint] NOT NULL,
	[CanStackOnManualDiscount] [bit] NOT NULL,
	[CanStackOnPrevScheme] [bit] NOT NULL,
	[CanStackNextScheme] [bit] NOT NULL,
 CONSTRAINT [PK_SchemePriority] PRIMARY KEY CLUSTERED 
(
	[SchemeType] ASC,
	[SchemeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]