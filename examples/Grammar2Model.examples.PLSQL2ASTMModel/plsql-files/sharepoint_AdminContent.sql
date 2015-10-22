CREATE TABLE [SiteQuota](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SessionId] [smallint] NOT NULL,
	[SMOpCode] [tinyint] NOT NULL,
	[DocId] [uniqueidentifier] NOT NULL,
	[DiskUsed] [bigint] NOT NULL,
	[UpdateTimeStamp] [bit] NOT NULL,
	[SQId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [SiteQuota_SiteId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[SessionId] ASC,
	[SMOpCode] ASC,
	[DocId] ASC,
	[SQId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO