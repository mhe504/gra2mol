SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
ALTER TABLE [SiteQuota] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllDocs](
	[Id] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[DirName] [nvarchar](256) NOT NULL,
	[LeafName] [nvarchar](128) NOT NULL,
	[Level] [tinyint] NOT NULL,
	[ParentId] [uniqueidentifier] NOT NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NULL,
	[DoclibRowId] [int] NULL,
	[Type] [tinyint] NOT NULL,
	[SortBehavior] [tinyint] NOT NULL,
	[Size] [int] NULL,
	[ETagVersion]  AS (case when [InternalVersion] IS NULL then NULL else ([InternalVersion]+[BumpVersion]*(256))/(256) end),
	[EffectiveVersion]  AS (case when [InternalVersion] IS NULL then NULL else [InternalVersion]+[BumpVersion]*(256) end),
	[InternalVersion] [int] NULL,
	[ContentVersion] [int] NOT NULL,
	[NextBSN] [bigint] NULL,
	[MetadataNextBSN] [bigint] NULL,
	[StreamSchema] [tinyint] NULL,
	[HasStream]  AS (case when [Type]=(0) AND ([DocFlags]&(256))=(256) AND [SetupPath] IS NULL OR [SetupPath] IS NOT NULL AND ([DocFlags]&(64))=(64) then (1) else (0) end),
	[BumpVersion] [tinyint] NOT NULL,
	[UIVersion] [int] NOT NULL,
	[Dirty]  AS (case when [BumpVersion]<>(0) then CONVERT([bit],(1),0) else CONVERT([bit],(0),0) end),
	[ListDataDirty] [bit] NOT NULL,
	[DocFlags] [int] NULL,
	[ThicketFlag] [bit] NULL,
	[CharSet] [int] NULL,
	[ProgId] [nvarchar](255) NULL,
	[TimeCreated] [datetime] NOT NULL,
	[TimeLastModified] [datetime] NOT NULL,
	[NextToLastTimeModified] [datetime] NULL,
	[MetaInfoTimeLastModified] [datetime] NULL,
	[TimeLastWritten] [datetime] NULL,
	[SetupPathVersion] [tinyint] NOT NULL,
	[SetupPath] [nvarchar](255) NULL,
	[SetupPathUser] [nvarchar](255) NULL,
	[CheckoutUserId] [int] NULL,
	[DraftOwnerId] [int] NULL,
	[CheckoutDate] [datetime] NULL,
	[CheckoutExpires] [datetime] NULL,
	[VersionCreatedSinceSTCheckout] [bit] NOT NULL,
	[LTCheckoutUserId]  AS (case when ([DocFlags]&(32))=(32) then [CheckoutUserId]  end),
	[CheckinComment] [nvarchar](1023) NULL,
	[IsCheckoutToLocal]  AS (case when ([DocFlags]&(512))=(512) then (1) else (0) end),
	[VirusVendorID] [int] NULL,
	[VirusStatus] [tinyint] NULL,
	[VirusInfo] [nvarchar](255) SPARSE  NULL,
	[VirusInfoEx] [varbinary](max) NULL,
	[MetaInfo] [dbo].[tCompressedBinary] NULL,
	[MetaInfoSize] [int] NULL,
	[MetaInfoVersion] [int] NOT NULL,
	[UnVersionedMetaInfo] [dbo].[tCompressedBinary] NULL,
	[UnVersionedMetaInfoSize] [int] NULL,
	[UnVersionedMetaInfoVersion] [int] NULL,
	[WelcomePageUrl] [nvarchar](260) NULL,
	[WelcomePageParameters] [nvarchar](max) NULL,
	[IsCurrentVersion] [bit] NOT NULL,
	[AuditFlags] [int] NULL,
	[InheritAuditFlags] [int] NULL,
	[UIVersionString]  AS ((CONVERT([nvarchar],[UIVersion]/(512),0)+'.')+CONVERT([nvarchar],[UIVersion]%(512),0)),
	[ScopeId] [uniqueidentifier] NOT NULL,
	[BuildDependencySet] [varbinary](max) NULL,
	[ParentVersion] [int] NULL,
	[ParentVersionString]  AS ((CONVERT([nvarchar],[ParentVersion]/(512),0)+'.')+CONVERT([nvarchar],[ParentVersion]%(512),0)),
	[TransformerId] [uniqueidentifier] NULL,
	[ParentLeafName] [nvarchar](128) NULL,
	[CtoOffset] [smallint] NULL,
	[Extension]  AS (case when charindex(N'.',[LeafName] collate Latin1_General_BIN)>(0) then right([LeafName],charindex(N'.',reverse([LeafName]) collate Latin1_General_BIN)-(1)) else N'' end),
	[ExtensionForFile]  AS (case when [Type]=(0) AND charindex(N'.',[LeafName] collate Latin1_General_BIN)>(0) then right([LeafName],charindex(N'.',reverse([LeafName]) collate Latin1_General_BIN)-(1)) else N'' end),
	[ItemChildCount] [int] NOT NULL,
	[FolderChildCount] [int] NOT NULL,
	[FileFormatMetaInfo] [varbinary](max) NULL,
	[FileFormatMetaInfoSize] [int] NOT NULL,
	[FFMConsistent] [bit] NULL,
	[ListSchemaVersion] [int] NULL,
	[ClientId] [varbinary](16) NULL,
 CONSTRAINT [AllDocs_ParentId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DeleteTransactionId] ASC,
	[ParentId] ASC,
	[Id] ASC,
	[Level] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllDocs] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personalization](
	[tp_SiteId] [uniqueidentifier] NOT NULL,
	[tp_WebPartID] [uniqueidentifier] NOT NULL,
	[tp_PageUrlID] [uniqueidentifier] NOT NULL,
	[tp_UserID] [int] NOT NULL,
	[tp_PartOrder] [int] NULL,
	[tp_ZoneID] [nvarchar](64) NULL,
	[tp_IsIncluded] [bit] NOT NULL,
	[tp_FrameState] [tinyint] NOT NULL,
	[tp_PerUserProperties] [varbinary](max) NULL,
	[tp_Cache] [varbinary](max) NULL,
	[tp_Size] [bigint] NOT NULL,
	[tp_Deleted] [bit] NOT NULL,
 CONSTRAINT [Personalization_PK] PRIMARY KEY CLUSTERED 
(
	[tp_SiteId] ASC,
	[tp_PageUrlID] ASC,
	[tp_WebPartID] ASC,
	[tp_UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Personalization] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PreviewSiteRequests](
	[SiteId] [uniqueidentifier] NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[RequestUpgrade] [bit] NOT NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[LastProcessDate] [datetime] NOT NULL,
	[RetryCount] [int] NOT NULL,
	[NewSiteId] [uniqueidentifier] NULL,
	[DestinationDbId] [uniqueidentifier] NULL,
	[SendEmail] [bit] NOT NULL,
 CONSTRAINT [PreviewSiteRequests_SiteId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [PreviewSiteRequests] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllUserDataJunctions](
	[tp_SiteId] [uniqueidentifier] NOT NULL,
	[tp_DeleteTransactionId] [varbinary](16) NOT NULL,
	[tp_IsCurrentVersion] [bit] NOT NULL,
	[tp_ParentId] [uniqueidentifier] NOT NULL,
	[tp_DocId] [uniqueidentifier] NOT NULL,
	[tp_FieldId] [uniqueidentifier] NOT NULL,
	[tp_CalculatedVersion] [int] NOT NULL,
	[tp_Level] [tinyint] NOT NULL,
	[tp_UIVersion] [int] NOT NULL,
	[tp_Id] [int] NOT NULL,
	[tp_Ordinal] [int] NOT NULL,
	[tp_SourceListId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AllUserDataJunctions_PK] PRIMARY KEY CLUSTERED 
(
	[tp_SiteId] ASC,
	[tp_DeleteTransactionId] ASC,
	[tp_IsCurrentVersion] ASC,
	[tp_ParentId] ASC,
	[tp_DocId] ASC,
	[tp_CalculatedVersion] ASC,
	[tp_Level] ASC,
	[tp_FieldId] ASC,
	[tp_Ordinal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllUserDataJunctions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RoleAssignment](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ScopeId] [uniqueidentifier] NOT NULL,
	[RoleId] [int] NOT NULL,
	[PrincipalId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [RoleAssignment] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Resources](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ResourceName] [nvarchar](520) NOT NULL,
	[BitType] [bit] NOT NULL,
	[BitDirty] [bit] NOT NULL,
	[LCID] [int] NOT NULL,
	[NvarcharVal] [nvarchar](256) NULL,
	[NtextVal] [nvarchar](max) NULL,
 CONSTRAINT [Resources_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC,
	[ListId] ASC,
	[ResourceName] ASC,
	[LCID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Resources] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RecycleBin](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[BinId] [tinyint] NOT NULL,
	[DeleteUserId] [int] NOT NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL,
	[DeleteDate] [datetime] NOT NULL,
	[ItemType] [tinyint] NOT NULL,
	[ListId] [uniqueidentifier] NULL,
	[DocId] [uniqueidentifier] NULL,
	[DocVersionId] [int] NULL,
	[ListItemId] [int] NULL,
	[Title] [nvarchar](260) NOT NULL,
	[DirName] [nvarchar](256) NOT NULL,
	[LeafName] [nvarchar](128) NOT NULL,
	[AuthorId] [int] NULL,
	[Size] [bigint] NOT NULL,
	[ListDirName] [nvarchar](256) NULL,
	[ScopeId] [uniqueidentifier] NULL,
	[ProgId] [nvarchar](255) NULL,
	[ChildDeleteTransactionId] [varbinary](16) NOT NULL,
	[OriginalItemType] [tinyint] NULL,
	[EffectiveDeleteTransactionId] [varbinary](16) NOT NULL,
 CONSTRAINT [RecycleBin_EffDelId] PRIMARY KEY NONCLUSTERED 
(
	[SiteId] ASC,
	[EffectiveDeleteTransactionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [RecycleBin] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Workflow](
	[Id] [uniqueidentifier] NOT NULL,
	[TemplateId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ItemGUID] [uniqueidentifier] NULL,
	[TaskListId] [uniqueidentifier] NULL,
	[AdminTaskListId] [varbinary](16) NULL,
	[Author] [int] NULL,
	[Modified] [datetime] NOT NULL,
	[Created] [datetime] NULL,
	[InternalState] [int] NULL,
	[LockMachineId] [uniqueidentifier] NULL,
	[LockMachinePID] [int] NULL,
	[InstanceDataVersion] [int] NOT NULL,
	[InstanceDataSize] [int] NULL,
	[InstanceData] [varbinary](max) NULL,
	[Modifications] [nvarchar](max) NULL,
	[HistorySize] [int] NULL,
	[History] [varbinary](max) NULL,
	[StatusVersion] [int] NOT NULL,
	[Status1] [int] NULL,
	[Status2] [int] NULL,
	[Status3] [int] NULL,
	[Status4] [int] NULL,
	[Status5] [int] NULL,
	[Status6] [int] NULL,
	[Status7] [int] NULL,
	[Status8] [int] NULL,
	[Status9] [int] NULL,
	[Status10] [int] NULL,
	[TextStatus1] [nvarchar](128) NULL,
	[TextStatus2] [nvarchar](128) NULL,
	[TextStatus3] [nvarchar](128) NULL,
	[TextStatus4] [nvarchar](128) NULL,
	[TextStatus5] [nvarchar](128) NULL,
	[ActivityDetails] [varbinary](max) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
 CONSTRAINT [Workflow_IdUnique] PRIMARY KEY NONCLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Workflow] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WelcomeNames](
	[LeafName] [nvarchar](128) NOT NULL,
	[Rank] [int] NOT NULL,
 CONSTRAINT [WelcomeNames_PK] PRIMARY KEY CLUSTERED 
(
	[LeafName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [WelcomeNames] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WebsPlus](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[TitleResource] [nvarchar](520) NULL,
	[DescriptionResource] [nvarchar](520) NULL,
	[IsTranLocked] [bit] NOT NULL,
	[TranLockerId] [uniqueidentifier] NULL,
	[TranLockExpiryTime] [datetime] NULL,
	[TranLockRefCount] [int] NOT NULL,
	[AlternateMUICultures] [nvarchar](max) NULL,
	[OverwriteMUICultures] [bit] NOT NULL,
 CONSTRAINT [WebsPlus_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [WebsPlus] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WebPartLists](
	[tp_SiteId] [uniqueidentifier] NOT NULL,
	[tp_ListId] [uniqueidentifier] NOT NULL,
	[tp_WebId] [uniqueidentifier] NOT NULL,
	[tp_PageUrlID] [uniqueidentifier] NOT NULL,
	[tp_WebPartID] [uniqueidentifier] NOT NULL,
	[tp_UserID] [int] NULL,
	[tp_Level] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [WebPartLists] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WebMembers](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [WebMembers_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [WebMembers] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Versions](
	[VersionId] [uniqueidentifier] NOT NULL,
	[Version] [nvarchar](64) NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](255) NULL,
	[TimeStamp] [datetime] NULL,
	[FinalizeTimeStamp] [datetime] NULL,
	[Mode] [int] NULL,
	[ModeStack] [int] NULL,
	[Updates] [int] NOT NULL,
	[Notes] [nvarchar](1024) NULL,
 CONSTRAINT [Versions_PK] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TimerLock](
	[ID] [int] NOT NULL,
	[LockedBy] [uniqueidentifier] NOT NULL,
	[LockedTime] [datetime] NOT NULL,
 CONSTRAINT [TimerLock_PK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [TimerLock] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ContentTypes](
	[SiteId] [uniqueidentifier] NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Scope] [nvarchar](256) NOT NULL,
	[ContentTypeId] [dbo].[tContentTypeId] NOT NULL,
	[Version] [int] NOT NULL,
	[NextChildByte] [tinyint] NOT NULL,
	[Size] [int] NOT NULL,
	[Definition] [nvarchar](max) NULL,
	[ResourceDir] [nvarchar](128) NULL,
	[SolutionId] [uniqueidentifier] NULL,
	[IsFromFeature] [bit] NOT NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ContentTypes] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StorageMetricsChanges](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DocId] [uniqueidentifier] NOT NULL,
	[DeltaSize] [bigint] NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [StorageMetricsChanges_DocId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DocId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [StorageMetricsChanges] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StorageMetrics](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DocId] [uniqueidentifier] NOT NULL,
	[TotalSize] [bigint] NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [StorageMetrics_DocId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DocId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [StorageMetrics] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Solutions](
	[Name] [nvarchar](128) NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NULL,
	[SolutionId] [uniqueidentifier] NOT NULL,
	[Hash] [nvarchar](50) NOT NULL,
	[SolutionGalleryItemId] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[HasAssemblies] [tinyint] NOT NULL,
	[ResourceQuota] [float] NOT NULL,
	[RecentInvocations] [int] NOT NULL,
	[ValidatorsHash] [char](64) NOT NULL,
	[ValidationErrorUrl] [nvarchar](4000) NULL,
	[ValidationErrorMessage] [nvarchar](4000) NULL,
	[Definitions] [varbinary](max) NULL,
	[AppInstanceId] [uniqueidentifier] NULL,
	[SolutionLevel] [int] NOT NULL,
	[WebPartData] [varbinary](max) NULL,
	[Flags] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Solutions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SolutionResourceUsageWindowed](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SolutionId] [uniqueidentifier] NOT NULL,
	[ResourceId] [uniqueidentifier] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[DaysAgo] [int] NOT NULL,
	[SampleCount] [int] NOT NULL,
	[ResourceUsage] [float] NULL,
 CONSTRAINT [SolutionResourceUsageWindowed_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SolutionResourceUsageWindowed] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SolutionResourceUsageLog](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SolutionId] [uniqueidentifier] NOT NULL,
	[ResourceId] [uniqueidentifier] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[SampleCount] [int] NOT NULL,
	[ResourceUsage] [float] NULL,
 CONSTRAINT [SolutionResourceUsageLog_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SolutionResourceUsageLog] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SolutionResourceUsageDailyOrdinal](
	[DaysAgo] [int] NOT NULL,
 CONSTRAINT [SolutionResourceUsageDailyOrdinal_PK] PRIMARY KEY CLUSTERED 
(
	[DaysAgo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SolutionResourceUsageDailyOrdinal] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SolutionResourceUsageDaily](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SolutionId] [uniqueidentifier] NOT NULL,
	[ResourceId] [uniqueidentifier] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DaysAgo] [int] NOT NULL,
	[SampleCount] [int] NOT NULL,
	[ResourceUsage] [float] NULL,
 CONSTRAINT [SolutionResourceUsageDaily_Report] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DaysAgo] DESC,
	[SolutionId] ASC,
	[ResourceId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SolutionResourceUsageDaily] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SolutionFiles](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SolutionId] [uniqueidentifier] NOT NULL,
	[SolutionWebId] [uniqueidentifier] NULL,
	[SolutionLevel] [int] NOT NULL,
	[SolutionHash] [nvarchar](50) NOT NULL,
	[SolutionFilePath] [nvarchar](255) NOT NULL,
	[Flags] [int] NOT NULL,
	[LastModifiedTime] [datetime] NOT NULL,
	[Size] [int] NOT NULL,
	[Content] [varbinary](max) NOT NULL,
	[FeatureId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [SolutionFiles] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteVersions](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[VersionId] [uniqueidentifier] NOT NULL,
	[Version] [nvarchar](64) NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TimeStamp] [datetime] NULL,
	[UserName] [nvarchar](255) NULL,
 CONSTRAINT [SiteVersionsId_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC,
	[VersionId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SiteVersions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUserSyncQueue](
	[SiteId] [uniqueidentifier] NOT NULL,
	[LastAttempt] [datetime] NOT NULL,
	[RetryCount] [int] NOT NULL,
	[ForceSync] [bit] NOT NULL,
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [SiteUserSyncQueue_SiteId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SiteUserSyncQueue] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUpgradeSessions](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SubscriptionId] [varbinary](16) NULL,
	[SessionId] [uniqueidentifier] NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[SessionXML] [nvarchar](max) NOT NULL,
	[UpgradeStatus] [int] NOT NULL,
	[UpgradeType] [int] NOT NULL,
	[ErrorCount] [int] NOT NULL,
	[WarningCount] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
	[RetryCount] [int] NOT NULL,
	[LogFileLocation] [nvarchar](260) NOT NULL,
	[SendEmail] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [SiteUpgradeSessions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllUserData](
	[tp_ID] [int] NOT NULL,
	[tp_ListId] [uniqueidentifier] NOT NULL,
	[tp_SiteId] [uniqueidentifier] NOT NULL,
	[tp_RowOrdinal] [tinyint] NOT NULL,
	[tp_Version] [int] NOT NULL,
	[tp_Author] [int] NULL,
	[tp_Editor] [int] NULL,
	[tp_Modified] [datetime] NULL,
	[tp_Created] [datetime] NULL,
	[tp_Ordering] [varchar](512) NULL,
	[tp_ThreadIndex] [varbinary](512) NULL,
	[tp_HasAttachment] [bit] NOT NULL,
	[tp_ModerationStatus] [int] NOT NULL,
	[tp_IsCurrent] [bit] NOT NULL,
	[tp_ItemOrder] [float] NULL,
	[tp_InstanceID] [int] NULL,
	[tp_GUID] [uniqueidentifier] NOT NULL,
	[tp_CopySource] [nvarchar](260) NULL,
	[tp_HasCopyDestinations] [bit] NULL,
	[tp_AuditFlags] [int] NULL,
	[tp_InheritAuditFlags] [int] NULL,
	[tp_Size] [int] NOT NULL,
	[tp_WorkflowVersion] [int] NULL,
	[tp_WorkflowInstanceID] [uniqueidentifier] NULL,
	[tp_ParentId] [uniqueidentifier] NOT NULL,
	[tp_DocId] [uniqueidentifier] NOT NULL,
	[tp_DeleteTransactionId] [varbinary](16) NOT NULL,
	[tp_ContentTypeId] [dbo].[tContentTypeId] NULL,
	[tp_Level] [tinyint] NOT NULL,
	[tp_IsCurrentVersion] [bit] NOT NULL,
	[tp_UIVersion] [int] NOT NULL,
	[tp_CalculatedVersion] [int] NOT NULL,
	[tp_UIVersionString]  AS ((CONVERT([nvarchar],[tp_UIVersion]/(512),0)+'.')+CONVERT([nvarchar],[tp_UIVersion]%(512),0)),
	[tp_DraftOwnerId] [int] NULL,
	[tp_CheckoutUserId] [int] NULL,
	[tp_AppAuthor] [int] NULL,
	[tp_AppEditor] [int] NULL,
	[bit1] [bit] SPARSE  NULL,
	[bit2] [bit] SPARSE  NULL,
	[bit3] [bit] SPARSE  NULL,
	[bit4] [bit] SPARSE  NULL,
	[bit5] [bit] SPARSE  NULL,
	[bit6] [bit] SPARSE  NULL,
	[bit7] [bit] SPARSE  NULL,
	[bit8] [bit] SPARSE  NULL,
	[bit9] [bit] SPARSE  NULL,
	[bit10] [bit] SPARSE  NULL,
	[bit11] [bit] SPARSE  NULL,
	[bit12] [bit] SPARSE  NULL,
	[bit13] [bit] SPARSE  NULL,
	[bit14] [bit] SPARSE  NULL,
	[bit15] [bit] SPARSE  NULL,
	[bit16] [bit] SPARSE  NULL,
	[bit17] [bit] SPARSE  NULL,
	[bit18] [bit] SPARSE  NULL,
	[bit19] [bit] SPARSE  NULL,
	[bit20] [bit] SPARSE  NULL,
	[bit21] [bit] SPARSE  NULL,
	[bit22] [bit] SPARSE  NULL,
	[bit23] [bit] SPARSE  NULL,
	[bit24] [bit] SPARSE  NULL,
	[bit25] [bit] SPARSE  NULL,
	[bit26] [bit] SPARSE  NULL,
	[bit27] [bit] SPARSE  NULL,
	[bit28] [bit] SPARSE  NULL,
	[bit29] [bit] SPARSE  NULL,
	[bit30] [bit] SPARSE  NULL,
	[bit31] [bit] SPARSE  NULL,
	[bit32] [bit] SPARSE  NULL,
	[bit33] [bit] SPARSE  NULL,
	[bit34] [bit] SPARSE  NULL,
	[bit35] [bit] SPARSE  NULL,
	[bit36] [bit] SPARSE  NULL,
	[bit37] [bit] SPARSE  NULL,
	[bit38] [bit] SPARSE  NULL,
	[bit39] [bit] SPARSE  NULL,
	[bit40] [bit] SPARSE  NULL,
	[bit41] [bit] SPARSE  NULL,
	[bit42] [bit] SPARSE  NULL,
	[bit43] [bit] SPARSE  NULL,
	[bit44] [bit] SPARSE  NULL,
	[bit45] [bit] SPARSE  NULL,
	[bit46] [bit] SPARSE  NULL,
	[bit47] [bit] SPARSE  NULL,
	[bit48] [bit] SPARSE  NULL,
	[bit49] [bit] SPARSE  NULL,
	[bit50] [bit] SPARSE  NULL,
	[bit51] [bit] SPARSE  NULL,
	[bit52] [bit] SPARSE  NULL,
	[bit53] [bit] SPARSE  NULL,
	[bit54] [bit] SPARSE  NULL,
	[bit55] [bit] SPARSE  NULL,
	[bit56] [bit] SPARSE  NULL,
	[bit57] [bit] SPARSE  NULL,
	[bit58] [bit] SPARSE  NULL,
	[bit59] [bit] SPARSE  NULL,
	[bit60] [bit] SPARSE  NULL,
	[bit61] [bit] SPARSE  NULL,
	[bit62] [bit] SPARSE  NULL,
	[bit63] [bit] SPARSE  NULL,
	[bit64] [bit] SPARSE  NULL,
	[bit65] [bit] SPARSE  NULL,
	[bit66] [bit] SPARSE  NULL,
	[bit67] [bit] SPARSE  NULL,
	[bit68] [bit] SPARSE  NULL,
	[bit69] [bit] SPARSE  NULL,
	[bit70] [bit] SPARSE  NULL,
	[bit71] [bit] SPARSE  NULL,
	[bit72] [bit] SPARSE  NULL,
	[bit73] [bit] SPARSE  NULL,
	[bit74] [bit] SPARSE  NULL,
	[bit75] [bit] SPARSE  NULL,
	[bit76] [bit] SPARSE  NULL,
	[bit77] [bit] SPARSE  NULL,
	[bit78] [bit] SPARSE  NULL,
	[bit79] [bit] SPARSE  NULL,
	[bit80] [bit] SPARSE  NULL,
	[bit81] [bit] SPARSE  NULL,
	[bit82] [bit] SPARSE  NULL,
	[bit83] [bit] SPARSE  NULL,
	[bit84] [bit] SPARSE  NULL,
	[bit85] [bit] SPARSE  NULL,
	[bit86] [bit] SPARSE  NULL,
	[bit87] [bit] SPARSE  NULL,
	[bit88] [bit] SPARSE  NULL,
	[bit89] [bit] SPARSE  NULL,
	[bit90] [bit] SPARSE  NULL,
	[bit91] [bit] SPARSE  NULL,
	[bit92] [bit] SPARSE  NULL,
	[bit93] [bit] SPARSE  NULL,
	[bit94] [bit] SPARSE  NULL,
	[bit95] [bit] SPARSE  NULL,
	[bit96] [bit] SPARSE  NULL,
	[bit97] [bit] SPARSE  NULL,
	[bit98] [bit] SPARSE  NULL,
	[bit99] [bit] SPARSE  NULL,
	[bit100] [bit] SPARSE  NULL,
	[bit101] [bit] SPARSE  NULL,
	[bit102] [bit] SPARSE  NULL,
	[bit103] [bit] SPARSE  NULL,
	[bit104] [bit] SPARSE  NULL,
	[bit105] [bit] SPARSE  NULL,
	[bit106] [bit] SPARSE  NULL,
	[bit107] [bit] SPARSE  NULL,
	[bit108] [bit] SPARSE  NULL,
	[bit109] [bit] SPARSE  NULL,
	[bit110] [bit] SPARSE  NULL,
	[bit111] [bit] SPARSE  NULL,
	[bit112] [bit] SPARSE  NULL,
	[bit113] [bit] SPARSE  NULL,
	[bit114] [bit] SPARSE  NULL,
	[bit115] [bit] SPARSE  NULL,
	[bit116] [bit] SPARSE  NULL,
	[bit117] [bit] SPARSE  NULL,
	[bit118] [bit] SPARSE  NULL,
	[bit119] [bit] SPARSE  NULL,
	[bit120] [bit] SPARSE  NULL,
	[bit121] [bit] SPARSE  NULL,
	[bit122] [bit] SPARSE  NULL,
	[bit123] [bit] SPARSE  NULL,
	[bit124] [bit] SPARSE  NULL,
	[bit125] [bit] SPARSE  NULL,
	[bit126] [bit] SPARSE  NULL,
	[bit127] [bit] SPARSE  NULL,
	[bit128] [bit] SPARSE  NULL,
	[bit129] [bit] SPARSE  NULL,
	[bit130] [bit] SPARSE  NULL,
	[bit131] [bit] SPARSE  NULL,
	[bit132] [bit] SPARSE  NULL,
	[bit133] [bit] SPARSE  NULL,
	[bit134] [bit] SPARSE  NULL,
	[bit135] [bit] SPARSE  NULL,
	[bit136] [bit] SPARSE  NULL,
	[bit137] [bit] SPARSE  NULL,
	[bit138] [bit] SPARSE  NULL,
	[bit139] [bit] SPARSE  NULL,
	[bit140] [bit] SPARSE  NULL,
	[bit141] [bit] SPARSE  NULL,
	[bit142] [bit] SPARSE  NULL,
	[bit143] [bit] SPARSE  NULL,
	[bit144] [bit] SPARSE  NULL,
	[bit145] [bit] SPARSE  NULL,
	[bit146] [bit] SPARSE  NULL,
	[bit147] [bit] SPARSE  NULL,
	[bit148] [bit] SPARSE  NULL,
	[bit149] [bit] SPARSE  NULL,
	[bit150] [bit] SPARSE  NULL,
	[bit151] [bit] SPARSE  NULL,
	[bit152] [bit] SPARSE  NULL,
	[bit153] [bit] SPARSE  NULL,
	[bit154] [bit] SPARSE  NULL,
	[bit155] [bit] SPARSE  NULL,
	[bit156] [bit] SPARSE  NULL,
	[bit157] [bit] SPARSE  NULL,
	[bit158] [bit] SPARSE  NULL,
	[bit159] [bit] SPARSE  NULL,
	[bit160] [bit] SPARSE  NULL,
	[bit161] [bit] SPARSE  NULL,
	[bit162] [bit] SPARSE  NULL,
	[bit163] [bit] SPARSE  NULL,
	[bit164] [bit] SPARSE  NULL,
	[bit165] [bit] SPARSE  NULL,
	[bit166] [bit] SPARSE  NULL,
	[bit167] [bit] SPARSE  NULL,
	[bit168] [bit] SPARSE  NULL,
	[bit169] [bit] SPARSE  NULL,
	[bit170] [bit] SPARSE  NULL,
	[bit171] [bit] SPARSE  NULL,
	[bit172] [bit] SPARSE  NULL,
	[bit173] [bit] SPARSE  NULL,
	[bit174] [bit] SPARSE  NULL,
	[bit175] [bit] SPARSE  NULL,
	[bit176] [bit] SPARSE  NULL,
	[bit177] [bit] SPARSE  NULL,
	[bit178] [bit] SPARSE  NULL,
	[bit179] [bit] SPARSE  NULL,
	[bit180] [bit] SPARSE  NULL,
	[bit181] [bit] SPARSE  NULL,
	[bit182] [bit] SPARSE  NULL,
	[bit183] [bit] SPARSE  NULL,
	[bit184] [bit] SPARSE  NULL,
	[bit185] [bit] SPARSE  NULL,
	[bit186] [bit] SPARSE  NULL,
	[bit187] [bit] SPARSE  NULL,
	[bit188] [bit] SPARSE  NULL,
	[bit189] [bit] SPARSE  NULL,
	[bit190] [bit] SPARSE  NULL,
	[bit191] [bit] SPARSE  NULL,
	[bit192] [bit] SPARSE  NULL,
	[bit193] [bit] SPARSE  NULL,
	[bit194] [bit] SPARSE  NULL,
	[bit195] [bit] SPARSE  NULL,
	[bit196] [bit] SPARSE  NULL,
	[bit197] [bit] SPARSE  NULL,
	[bit198] [bit] SPARSE  NULL,
	[bit199] [bit] SPARSE  NULL,
	[bit200] [bit] SPARSE  NULL,
	[bit201] [bit] SPARSE  NULL,
	[bit202] [bit] SPARSE  NULL,
	[bit203] [bit] SPARSE  NULL,
	[bit204] [bit] SPARSE  NULL,
	[bit205] [bit] SPARSE  NULL,
	[bit206] [bit] SPARSE  NULL,
	[bit207] [bit] SPARSE  NULL,
	[bit208] [bit] SPARSE  NULL,
	[bit209] [bit] SPARSE  NULL,
	[bit210] [bit] SPARSE  NULL,
	[bit211] [bit] SPARSE  NULL,
	[bit212] [bit] SPARSE  NULL,
	[bit213] [bit] SPARSE  NULL,
	[bit214] [bit] SPARSE  NULL,
	[bit215] [bit] SPARSE  NULL,
	[bit216] [bit] SPARSE  NULL,
	[bit217] [bit] SPARSE  NULL,
	[bit218] [bit] SPARSE  NULL,
	[bit219] [bit] SPARSE  NULL,
	[bit220] [bit] SPARSE  NULL,
	[bit221] [bit] SPARSE  NULL,
	[bit222] [bit] SPARSE  NULL,
	[bit223] [bit] SPARSE  NULL,
	[bit224] [bit] SPARSE  NULL,
	[bit225] [bit] SPARSE  NULL,
	[bit226] [bit] SPARSE  NULL,
	[bit227] [bit] SPARSE  NULL,
	[bit228] [bit] SPARSE  NULL,
	[bit229] [bit] SPARSE  NULL,
	[bit230] [bit] SPARSE  NULL,
	[bit231] [bit] SPARSE  NULL,
	[bit232] [bit] SPARSE  NULL,
	[bit233] [bit] SPARSE  NULL,
	[bit234] [bit] SPARSE  NULL,
	[bit235] [bit] SPARSE  NULL,
	[bit236] [bit] SPARSE  NULL,
	[bit237] [bit] SPARSE  NULL,
	[bit238] [bit] SPARSE  NULL,
	[bit239] [bit] SPARSE  NULL,
	[bit240] [bit] SPARSE  NULL,
	[bit241] [bit] SPARSE  NULL,
	[bit242] [bit] SPARSE  NULL,
	[bit243] [bit] SPARSE  NULL,
	[bit244] [bit] SPARSE  NULL,
	[bit245] [bit] SPARSE  NULL,
	[bit246] [bit] SPARSE  NULL,
	[bit247] [bit] SPARSE  NULL,
	[bit248] [bit] SPARSE  NULL,
	[bit249] [bit] SPARSE  NULL,
	[bit250] [bit] SPARSE  NULL,
	[bit251] [bit] SPARSE  NULL,
	[bit252] [bit] SPARSE  NULL,
	[bit253] [bit] SPARSE  NULL,
	[bit254] [bit] SPARSE  NULL,
	[bit255] [bit] SPARSE  NULL,
	[bit256] [bit] SPARSE  NULL,
	[bit257] [bit] SPARSE  NULL,
	[bit258] [bit] SPARSE  NULL,
	[bit259] [bit] SPARSE  NULL,
	[bit260] [bit] SPARSE  NULL,
	[bit261] [bit] SPARSE  NULL,
	[bit262] [bit] SPARSE  NULL,
	[bit263] [bit] SPARSE  NULL,
	[bit264] [bit] SPARSE  NULL,
	[bit265] [bit] SPARSE  NULL,
	[bit266] [bit] SPARSE  NULL,
	[bit267] [bit] SPARSE  NULL,
	[bit268] [bit] SPARSE  NULL,
	[bit269] [bit] SPARSE  NULL,
	[bit270] [bit] SPARSE  NULL,
	[bit271] [bit] SPARSE  NULL,
	[bit272] [bit] SPARSE  NULL,
	[bit273] [bit] SPARSE  NULL,
	[bit274] [bit] SPARSE  NULL,
	[bit275] [bit] SPARSE  NULL,
	[bit276] [bit] SPARSE  NULL,
	[bit277] [bit] SPARSE  NULL,
	[bit278] [bit] SPARSE  NULL,
	[bit279] [bit] SPARSE  NULL,
	[bit280] [bit] SPARSE  NULL,
	[bit281] [bit] SPARSE  NULL,
	[bit282] [bit] SPARSE  NULL,
	[bit283] [bit] SPARSE  NULL,
	[bit284] [bit] SPARSE  NULL,
	[bit285] [bit] SPARSE  NULL,
	[bit286] [bit] SPARSE  NULL,
	[bit287] [bit] SPARSE  NULL,
	[bit288] [bit] SPARSE  NULL,
	[bit289] [bit] SPARSE  NULL,
	[bit290] [bit] SPARSE  NULL,
	[bit291] [bit] SPARSE  NULL,
	[bit292] [bit] SPARSE  NULL,
	[bit293] [bit] SPARSE  NULL,
	[bit294] [bit] SPARSE  NULL,
	[bit295] [bit] SPARSE  NULL,
	[bit296] [bit] SPARSE  NULL,
	[bit297] [bit] SPARSE  NULL,
	[bit298] [bit] SPARSE  NULL,
	[bit299] [bit] SPARSE  NULL,
	[bit300] [bit] SPARSE  NULL,
	[bit301] [bit] SPARSE  NULL,
	[bit302] [bit] SPARSE  NULL,
	[bit303] [bit] SPARSE  NULL,
	[bit304] [bit] SPARSE  NULL,
	[bit305] [bit] SPARSE  NULL,
	[bit306] [bit] SPARSE  NULL,
	[bit307] [bit] SPARSE  NULL,
	[bit308] [bit] SPARSE  NULL,
	[bit309] [bit] SPARSE  NULL,
	[bit310] [bit] SPARSE  NULL,
	[bit311] [bit] SPARSE  NULL,
	[bit312] [bit] SPARSE  NULL,
	[bit313] [bit] SPARSE  NULL,
	[bit314] [bit] SPARSE  NULL,
	[bit315] [bit] SPARSE  NULL,
	[bit316] [bit] SPARSE  NULL,
	[bit317] [bit] SPARSE  NULL,
	[bit318] [bit] SPARSE  NULL,
	[bit319] [bit] SPARSE  NULL,
	[bit320] [bit] SPARSE  NULL,
	[bit321] [bit] SPARSE  NULL,
	[bit322] [bit] SPARSE  NULL,
	[bit323] [bit] SPARSE  NULL,
	[bit324] [bit] SPARSE  NULL,
	[bit325] [bit] SPARSE  NULL,
	[bit326] [bit] SPARSE  NULL,
	[bit327] [bit] SPARSE  NULL,
	[bit328] [bit] SPARSE  NULL,
	[bit329] [bit] SPARSE  NULL,
	[bit330] [bit] SPARSE  NULL,
	[bit331] [bit] SPARSE  NULL,
	[bit332] [bit] SPARSE  NULL,
	[bit333] [bit] SPARSE  NULL,
	[bit334] [bit] SPARSE  NULL,
	[bit335] [bit] SPARSE  NULL,
	[bit336] [bit] SPARSE  NULL,
	[bit337] [bit] SPARSE  NULL,
	[bit338] [bit] SPARSE  NULL,
	[bit339] [bit] SPARSE  NULL,
	[bit340] [bit] SPARSE  NULL,
	[bit341] [bit] SPARSE  NULL,
	[bit342] [bit] SPARSE  NULL,
	[bit343] [bit] SPARSE  NULL,
	[bit344] [bit] SPARSE  NULL,
	[bit345] [bit] SPARSE  NULL,
	[bit346] [bit] SPARSE  NULL,
	[bit347] [bit] SPARSE  NULL,
	[bit348] [bit] SPARSE  NULL,
	[bit349] [bit] SPARSE  NULL,
	[bit350] [bit] SPARSE  NULL,
	[bit351] [bit] SPARSE  NULL,
	[bit352] [bit] SPARSE  NULL,
	[bit353] [bit] SPARSE  NULL,
	[bit354] [bit] SPARSE  NULL,
	[bit355] [bit] SPARSE  NULL,
	[bit356] [bit] SPARSE  NULL,
	[bit357] [bit] SPARSE  NULL,
	[bit358] [bit] SPARSE  NULL,
	[bit359] [bit] SPARSE  NULL,
	[bit360] [bit] SPARSE  NULL,
	[bit361] [bit] SPARSE  NULL,
	[bit362] [bit] SPARSE  NULL,
	[bit363] [bit] SPARSE  NULL,
	[bit364] [bit] SPARSE  NULL,
	[bit365] [bit] SPARSE  NULL,
	[bit366] [bit] SPARSE  NULL,
	[bit367] [bit] SPARSE  NULL,
	[bit368] [bit] SPARSE  NULL,
	[bit369] [bit] SPARSE  NULL,
	[bit370] [bit] SPARSE  NULL,
	[bit371] [bit] SPARSE  NULL,
	[bit372] [bit] SPARSE  NULL,
	[bit373] [bit] SPARSE  NULL,
	[bit374] [bit] SPARSE  NULL,
	[bit375] [bit] SPARSE  NULL,
	[bit376] [bit] SPARSE  NULL,
	[bit377] [bit] SPARSE  NULL,
	[bit378] [bit] SPARSE  NULL,
	[bit379] [bit] SPARSE  NULL,
	[bit380] [bit] SPARSE  NULL,
	[bit381] [bit] SPARSE  NULL,
	[bit382] [bit] SPARSE  NULL,
	[bit383] [bit] SPARSE  NULL,
	[bit384] [bit] SPARSE  NULL,
	[bit385] [bit] SPARSE  NULL,
	[bit386] [bit] SPARSE  NULL,
	[bit387] [bit] SPARSE  NULL,
	[bit388] [bit] SPARSE  NULL,
	[bit389] [bit] SPARSE  NULL,
	[bit390] [bit] SPARSE  NULL,
	[bit391] [bit] SPARSE  NULL,
	[bit392] [bit] SPARSE  NULL,
	[bit393] [bit] SPARSE  NULL,
	[bit394] [bit] SPARSE  NULL,
	[bit395] [bit] SPARSE  NULL,
	[bit396] [bit] SPARSE  NULL,
	[bit397] [bit] SPARSE  NULL,
	[bit398] [bit] SPARSE  NULL,
	[bit399] [bit] SPARSE  NULL,
	[bit400] [bit] SPARSE  NULL,
	[bit401] [bit] SPARSE  NULL,
	[bit402] [bit] SPARSE  NULL,
	[bit403] [bit] SPARSE  NULL,
	[bit404] [bit] SPARSE  NULL,
	[bit405] [bit] SPARSE  NULL,
	[bit406] [bit] SPARSE  NULL,
	[bit407] [bit] SPARSE  NULL,
	[bit408] [bit] SPARSE  NULL,
	[bit409] [bit] SPARSE  NULL,
	[bit410] [bit] SPARSE  NULL,
	[bit411] [bit] SPARSE  NULL,
	[bit412] [bit] SPARSE  NULL,
	[bit413] [bit] SPARSE  NULL,
	[bit414] [bit] SPARSE  NULL,
	[bit415] [bit] SPARSE  NULL,
	[bit416] [bit] SPARSE  NULL,
	[bit417] [bit] SPARSE  NULL,
	[bit418] [bit] SPARSE  NULL,
	[bit419] [bit] SPARSE  NULL,
	[bit420] [bit] SPARSE  NULL,
	[bit421] [bit] SPARSE  NULL,
	[bit422] [bit] SPARSE  NULL,
	[bit423] [bit] SPARSE  NULL,
	[bit424] [bit] SPARSE  NULL,
	[bit425] [bit] SPARSE  NULL,
	[bit426] [bit] SPARSE  NULL,
	[bit427] [bit] SPARSE  NULL,
	[bit428] [bit] SPARSE  NULL,
	[bit429] [bit] SPARSE  NULL,
	[bit430] [bit] SPARSE  NULL,
	[bit431] [bit] SPARSE  NULL,
	[bit432] [bit] SPARSE  NULL,
	[bit433] [bit] SPARSE  NULL,
	[bit434] [bit] SPARSE  NULL,
	[bit435] [bit] SPARSE  NULL,
	[bit436] [bit] SPARSE  NULL,
	[bit437] [bit] SPARSE  NULL,
	[bit438] [bit] SPARSE  NULL,
	[bit439] [bit] SPARSE  NULL,
	[bit440] [bit] SPARSE  NULL,
	[bit441] [bit] SPARSE  NULL,
	[bit442] [bit] SPARSE  NULL,
	[bit443] [bit] SPARSE  NULL,
	[bit444] [bit] SPARSE  NULL,
	[bit445] [bit] SPARSE  NULL,
	[bit446] [bit] SPARSE  NULL,
	[bit447] [bit] SPARSE  NULL,
	[bit448] [bit] SPARSE  NULL,
	[bit449] [bit] SPARSE  NULL,
	[bit450] [bit] SPARSE  NULL,
	[bit451] [bit] SPARSE  NULL,
	[bit452] [bit] SPARSE  NULL,
	[bit453] [bit] SPARSE  NULL,
	[bit454] [bit] SPARSE  NULL,
	[bit455] [bit] SPARSE  NULL,
	[bit456] [bit] SPARSE  NULL,
	[bit457] [bit] SPARSE  NULL,
	[bit458] [bit] SPARSE  NULL,
	[bit459] [bit] SPARSE  NULL,
	[bit460] [bit] SPARSE  NULL,
	[bit461] [bit] SPARSE  NULL,
	[bit462] [bit] SPARSE  NULL,
	[bit463] [bit] SPARSE  NULL,
	[bit464] [bit] SPARSE  NULL,
	[bit465] [bit] SPARSE  NULL,
	[bit466] [bit] SPARSE  NULL,
	[bit467] [bit] SPARSE  NULL,
	[bit468] [bit] SPARSE  NULL,
	[bit469] [bit] SPARSE  NULL,
	[bit470] [bit] SPARSE  NULL,
	[bit471] [bit] SPARSE  NULL,
	[bit472] [bit] SPARSE  NULL,
	[bit473] [bit] SPARSE  NULL,
	[bit474] [bit] SPARSE  NULL,
	[bit475] [bit] SPARSE  NULL,
	[bit476] [bit] SPARSE  NULL,
	[bit477] [bit] SPARSE  NULL,
	[bit478] [bit] SPARSE  NULL,
	[bit479] [bit] SPARSE  NULL,
	[bit480] [bit] SPARSE  NULL,
	[bit481] [bit] SPARSE  NULL,
	[bit482] [bit] SPARSE  NULL,
	[bit483] [bit] SPARSE  NULL,
	[bit484] [bit] SPARSE  NULL,
	[bit485] [bit] SPARSE  NULL,
	[bit486] [bit] SPARSE  NULL,
	[bit487] [bit] SPARSE  NULL,
	[bit488] [bit] SPARSE  NULL,
	[bit489] [bit] SPARSE  NULL,
	[bit490] [bit] SPARSE  NULL,
	[bit491] [bit] SPARSE  NULL,
	[bit492] [bit] SPARSE  NULL,
	[bit493] [bit] SPARSE  NULL,
	[bit494] [bit] SPARSE  NULL,
	[bit495] [bit] SPARSE  NULL,
	[bit496] [bit] SPARSE  NULL,
	[bit497] [bit] SPARSE  NULL,
	[bit498] [bit] SPARSE  NULL,
	[bit499] [bit] SPARSE  NULL,
	[bit500] [bit] SPARSE  NULL,
	[bit501] [bit] SPARSE  NULL,
	[bit502] [bit] SPARSE  NULL,
	[bit503] [bit] SPARSE  NULL,
	[bit504] [bit] SPARSE  NULL,
	[bit505] [bit] SPARSE  NULL,
	[bit506] [bit] SPARSE  NULL,
	[bit507] [bit] SPARSE  NULL,
	[bit508] [bit] SPARSE  NULL,
	[bit509] [bit] SPARSE  NULL,
	[bit510] [bit] SPARSE  NULL,
	[bit511] [bit] SPARSE  NULL,
	[bit512] [bit] SPARSE  NULL,
	[bit513] [bit] SPARSE  NULL,
	[bit514] [bit] SPARSE  NULL,
	[bit515] [bit] SPARSE  NULL,
	[bit516] [bit] SPARSE  NULL,
	[bit517] [bit] SPARSE  NULL,
	[bit518] [bit] SPARSE  NULL,
	[bit519] [bit] SPARSE  NULL,
	[bit520] [bit] SPARSE  NULL,
	[bit521] [bit] SPARSE  NULL,
	[bit522] [bit] SPARSE  NULL,
	[bit523] [bit] SPARSE  NULL,
	[bit524] [bit] SPARSE  NULL,
	[bit525] [bit] SPARSE  NULL,
	[bit526] [bit] SPARSE  NULL,
	[bit527] [bit] SPARSE  NULL,
	[bit528] [bit] SPARSE  NULL,
	[bit529] [bit] SPARSE  NULL,
	[bit530] [bit] SPARSE  NULL,
	[bit531] [bit] SPARSE  NULL,
	[bit532] [bit] SPARSE  NULL,
	[bit533] [bit] SPARSE  NULL,
	[bit534] [bit] SPARSE  NULL,
	[bit535] [bit] SPARSE  NULL,
	[bit536] [bit] SPARSE  NULL,
	[bit537] [bit] SPARSE  NULL,
	[bit538] [bit] SPARSE  NULL,
	[bit539] [bit] SPARSE  NULL,
	[bit540] [bit] SPARSE  NULL,
	[bit541] [bit] SPARSE  NULL,
	[bit542] [bit] SPARSE  NULL,
	[bit543] [bit] SPARSE  NULL,
	[bit544] [bit] SPARSE  NULL,
	[bit545] [bit] SPARSE  NULL,
	[bit546] [bit] SPARSE  NULL,
	[bit547] [bit] SPARSE  NULL,
	[bit548] [bit] SPARSE  NULL,
	[bit549] [bit] SPARSE  NULL,
	[bit550] [bit] SPARSE  NULL,
	[bit551] [bit] SPARSE  NULL,
	[bit552] [bit] SPARSE  NULL,
	[bit553] [bit] SPARSE  NULL,
	[bit554] [bit] SPARSE  NULL,
	[bit555] [bit] SPARSE  NULL,
	[bit556] [bit] SPARSE  NULL,
	[bit557] [bit] SPARSE  NULL,
	[bit558] [bit] SPARSE  NULL,
	[bit559] [bit] SPARSE  NULL,
	[bit560] [bit] SPARSE  NULL,
	[bit561] [bit] SPARSE  NULL,
	[bit562] [bit] SPARSE  NULL,
	[bit563] [bit] SPARSE  NULL,
	[bit564] [bit] SPARSE  NULL,
	[bit565] [bit] SPARSE  NULL,
	[bit566] [bit] SPARSE  NULL,
	[bit567] [bit] SPARSE  NULL,
	[bit568] [bit] SPARSE  NULL,
	[bit569] [bit] SPARSE  NULL,
	[bit570] [bit] SPARSE  NULL,
	[bit571] [bit] SPARSE  NULL,
	[bit572] [bit] SPARSE  NULL,
	[bit573] [bit] SPARSE  NULL,
	[bit574] [bit] SPARSE  NULL,
	[bit575] [bit] SPARSE  NULL,
	[bit576] [bit] SPARSE  NULL,
	[bit577] [bit] SPARSE  NULL,
	[bit578] [bit] SPARSE  NULL,
	[bit579] [bit] SPARSE  NULL,
	[bit580] [bit] SPARSE  NULL,
	[bit581] [bit] SPARSE  NULL,
	[bit582] [bit] SPARSE  NULL,
	[bit583] [bit] SPARSE  NULL,
	[bit584] [bit] SPARSE  NULL,
	[bit585] [bit] SPARSE  NULL,
	[bit586] [bit] SPARSE  NULL,
	[bit587] [bit] SPARSE  NULL,
	[bit588] [bit] SPARSE  NULL,
	[bit589] [bit] SPARSE  NULL,
	[bit590] [bit] SPARSE  NULL,
	[bit591] [bit] SPARSE  NULL,
	[bit592] [bit] SPARSE  NULL,
	[bit593] [bit] SPARSE  NULL,
	[bit594] [bit] SPARSE  NULL,
	[bit595] [bit] SPARSE  NULL,
	[bit596] [bit] SPARSE  NULL,
	[bit597] [bit] SPARSE  NULL,
	[bit598] [bit] SPARSE  NULL,
	[bit599] [bit] SPARSE  NULL,
	[bit600] [bit] SPARSE  NULL,
	[bit601] [bit] SPARSE  NULL,
	[bit602] [bit] SPARSE  NULL,
	[bit603] [bit] SPARSE  NULL,
	[bit604] [bit] SPARSE  NULL,
	[bit605] [bit] SPARSE  NULL,
	[bit606] [bit] SPARSE  NULL,
	[bit607] [bit] SPARSE  NULL,
	[bit608] [bit] SPARSE  NULL,
	[bit609] [bit] SPARSE  NULL,
	[bit610] [bit] SPARSE  NULL,
	[bit611] [bit] SPARSE  NULL,
	[bit612] [bit] SPARSE  NULL,
	[bit613] [bit] SPARSE  NULL,
	[bit614] [bit] SPARSE  NULL,
	[bit615] [bit] SPARSE  NULL,
	[bit616] [bit] SPARSE  NULL,
	[bit617] [bit] SPARSE  NULL,
	[bit618] [bit] SPARSE  NULL,
	[bit619] [bit] SPARSE  NULL,
	[bit620] [bit] SPARSE  NULL,
	[bit621] [bit] SPARSE  NULL,
	[bit622] [bit] SPARSE  NULL,
	[bit623] [bit] SPARSE  NULL,
	[bit624] [bit] SPARSE  NULL,
	[bit625] [bit] SPARSE  NULL,
	[bit626] [bit] SPARSE  NULL,
	[bit627] [bit] SPARSE  NULL,
	[bit628] [bit] SPARSE  NULL,
	[bit629] [bit] SPARSE  NULL,
	[bit630] [bit] SPARSE  NULL,
	[bit631] [bit] SPARSE  NULL,
	[bit632] [bit] SPARSE  NULL,
	[bit633] [bit] SPARSE  NULL,
	[bit634] [bit] SPARSE  NULL,
	[bit635] [bit] SPARSE  NULL,
	[bit636] [bit] SPARSE  NULL,
	[bit637] [bit] SPARSE  NULL,
	[bit638] [bit] SPARSE  NULL,
	[bit639] [bit] SPARSE  NULL,
	[bit640] [bit] SPARSE  NULL,
	[bit641] [bit] SPARSE  NULL,
	[bit642] [bit] SPARSE  NULL,
	[bit643] [bit] SPARSE  NULL,
	[bit644] [bit] SPARSE  NULL,
	[bit645] [bit] SPARSE  NULL,
	[bit646] [bit] SPARSE  NULL,
	[bit647] [bit] SPARSE  NULL,
	[bit648] [bit] SPARSE  NULL,
	[bit649] [bit] SPARSE  NULL,
	[bit650] [bit] SPARSE  NULL,
	[bit651] [bit] SPARSE  NULL,
	[bit652] [bit] SPARSE  NULL,
	[bit653] [bit] SPARSE  NULL,
	[bit654] [bit] SPARSE  NULL,
	[bit655] [bit] SPARSE  NULL,
	[bit656] [bit] SPARSE  NULL,
	[bit657] [bit] SPARSE  NULL,
	[bit658] [bit] SPARSE  NULL,
	[bit659] [bit] SPARSE  NULL,
	[bit660] [bit] SPARSE  NULL,
	[bit661] [bit] SPARSE  NULL,
	[bit662] [bit] SPARSE  NULL,
	[bit663] [bit] SPARSE  NULL,
	[bit664] [bit] SPARSE  NULL,
	[bit665] [bit] SPARSE  NULL,
	[bit666] [bit] SPARSE  NULL,
	[bit667] [bit] SPARSE  NULL,
	[bit668] [bit] SPARSE  NULL,
	[bit669] [bit] SPARSE  NULL,
	[bit670] [bit] SPARSE  NULL,
	[bit671] [bit] SPARSE  NULL,
	[bit672] [bit] SPARSE  NULL,
	[bit673] [bit] SPARSE  NULL,
	[bit674] [bit] SPARSE  NULL,
	[bit675] [bit] SPARSE  NULL,
	[bit676] [bit] SPARSE  NULL,
	[bit677] [bit] SPARSE  NULL,
	[bit678] [bit] SPARSE  NULL,
	[bit679] [bit] SPARSE  NULL,
	[bit680] [bit] SPARSE  NULL,
	[bit681] [bit] SPARSE  NULL,
	[bit682] [bit] SPARSE  NULL,
	[bit683] [bit] SPARSE  NULL,
	[bit684] [bit] SPARSE  NULL,
	[bit685] [bit] SPARSE  NULL,
	[bit686] [bit] SPARSE  NULL,
	[bit687] [bit] SPARSE  NULL,
	[bit688] [bit] SPARSE  NULL,
	[bit689] [bit] SPARSE  NULL,
	[bit690] [bit] SPARSE  NULL,
	[bit691] [bit] SPARSE  NULL,
	[bit692] [bit] SPARSE  NULL,
	[bit693] [bit] SPARSE  NULL,
	[bit694] [bit] SPARSE  NULL,
	[bit695] [bit] SPARSE  NULL,
	[bit696] [bit] SPARSE  NULL,
	[bit697] [bit] SPARSE  NULL,
	[bit698] [bit] SPARSE  NULL,
	[bit699] [bit] SPARSE  NULL,
	[bit700] [bit] SPARSE  NULL,
	[bit701] [bit] SPARSE  NULL,
	[bit702] [bit] SPARSE  NULL,
	[bit703] [bit] SPARSE  NULL,
	[bit704] [bit] SPARSE  NULL,
	[bit705] [bit] SPARSE  NULL,
	[bit706] [bit] SPARSE  NULL,
	[bit707] [bit] SPARSE  NULL,
	[bit708] [bit] SPARSE  NULL,
	[bit709] [bit] SPARSE  NULL,
	[bit710] [bit] SPARSE  NULL,
	[bit711] [bit] SPARSE  NULL,
	[bit712] [bit] SPARSE  NULL,
	[bit713] [bit] SPARSE  NULL,
	[bit714] [bit] SPARSE  NULL,
	[bit715] [bit] SPARSE  NULL,
	[bit716] [bit] SPARSE  NULL,
	[bit717] [bit] SPARSE  NULL,
	[bit718] [bit] SPARSE  NULL,
	[bit719] [bit] SPARSE  NULL,
	[bit720] [bit] SPARSE  NULL,
	[bit721] [bit] SPARSE  NULL,
	[bit722] [bit] SPARSE  NULL,
	[bit723] [bit] SPARSE  NULL,
	[bit724] [bit] SPARSE  NULL,
	[bit725] [bit] SPARSE  NULL,
	[bit726] [bit] SPARSE  NULL,
	[bit727] [bit] SPARSE  NULL,
	[bit728] [bit] SPARSE  NULL,
	[bit729] [bit] SPARSE  NULL,
	[bit730] [bit] SPARSE  NULL,
	[bit731] [bit] SPARSE  NULL,
	[bit732] [bit] SPARSE  NULL,
	[bit733] [bit] SPARSE  NULL,
	[bit734] [bit] SPARSE  NULL,
	[bit735] [bit] SPARSE  NULL,
	[bit736] [bit] SPARSE  NULL,
	[bit737] [bit] SPARSE  NULL,
	[bit738] [bit] SPARSE  NULL,
	[bit739] [bit] SPARSE  NULL,
	[bit740] [bit] SPARSE  NULL,
	[bit741] [bit] SPARSE  NULL,
	[bit742] [bit] SPARSE  NULL,
	[bit743] [bit] SPARSE  NULL,
	[bit744] [bit] SPARSE  NULL,
	[bit745] [bit] SPARSE  NULL,
	[bit746] [bit] SPARSE  NULL,
	[bit747] [bit] SPARSE  NULL,
	[bit748] [bit] SPARSE  NULL,
	[bit749] [bit] SPARSE  NULL,
	[bit750] [bit] SPARSE  NULL,
	[bit751] [bit] SPARSE  NULL,
	[bit752] [bit] SPARSE  NULL,
	[bit753] [bit] SPARSE  NULL,
	[bit754] [bit] SPARSE  NULL,
	[bit755] [bit] SPARSE  NULL,
	[bit756] [bit] SPARSE  NULL,
	[bit757] [bit] SPARSE  NULL,
	[bit758] [bit] SPARSE  NULL,
	[bit759] [bit] SPARSE  NULL,
	[bit760] [bit] SPARSE  NULL,
	[bit761] [bit] SPARSE  NULL,
	[bit762] [bit] SPARSE  NULL,
	[bit763] [bit] SPARSE  NULL,
	[bit764] [bit] SPARSE  NULL,
	[bit765] [bit] SPARSE  NULL,
	[bit766] [bit] SPARSE  NULL,
	[bit767] [bit] SPARSE  NULL,
	[bit768] [bit] SPARSE  NULL,
	[bit769] [bit] SPARSE  NULL,
	[bit770] [bit] SPARSE  NULL,
	[bit771] [bit] SPARSE  NULL,
	[bit772] [bit] SPARSE  NULL,
	[bit773] [bit] SPARSE  NULL,
	[bit774] [bit] SPARSE  NULL,
	[bit775] [bit] SPARSE  NULL,
	[bit776] [bit] SPARSE  NULL,
	[bit777] [bit] SPARSE  NULL,
	[bit778] [bit] SPARSE  NULL,
	[bit779] [bit] SPARSE  NULL,
	[bit780] [bit] SPARSE  NULL,
	[bit781] [bit] SPARSE  NULL,
	[bit782] [bit] SPARSE  NULL,
	[bit783] [bit] SPARSE  NULL,
	[bit784] [bit] SPARSE  NULL,
	[bit785] [bit] SPARSE  NULL,
	[bit786] [bit] SPARSE  NULL,
	[bit787] [bit] SPARSE  NULL,
	[bit788] [bit] SPARSE  NULL,
	[bit789] [bit] SPARSE  NULL,
	[bit790] [bit] SPARSE  NULL,
	[bit791] [bit] SPARSE  NULL,
	[bit792] [bit] SPARSE  NULL,
	[bit793] [bit] SPARSE  NULL,
	[bit794] [bit] SPARSE  NULL,
	[bit795] [bit] SPARSE  NULL,
	[bit796] [bit] SPARSE  NULL,
	[bit797] [bit] SPARSE  NULL,
	[bit798] [bit] SPARSE  NULL,
	[bit799] [bit] SPARSE  NULL,
	[bit800] [bit] SPARSE  NULL,
	[bit801] [bit] SPARSE  NULL,
	[bit802] [bit] SPARSE  NULL,
	[bit803] [bit] SPARSE  NULL,
	[bit804] [bit] SPARSE  NULL,
	[bit805] [bit] SPARSE  NULL,
	[bit806] [bit] SPARSE  NULL,
	[bit807] [bit] SPARSE  NULL,
	[bit808] [bit] SPARSE  NULL,
	[bit809] [bit] SPARSE  NULL,
	[bit810] [bit] SPARSE  NULL,
	[bit811] [bit] SPARSE  NULL,
	[bit812] [bit] SPARSE  NULL,
	[bit813] [bit] SPARSE  NULL,
	[bit814] [bit] SPARSE  NULL,
	[bit815] [bit] SPARSE  NULL,
	[bit816] [bit] SPARSE  NULL,
	[bit817] [bit] SPARSE  NULL,
	[bit818] [bit] SPARSE  NULL,
	[bit819] [bit] SPARSE  NULL,
	[bit820] [bit] SPARSE  NULL,
	[bit821] [bit] SPARSE  NULL,
	[bit822] [bit] SPARSE  NULL,
	[bit823] [bit] SPARSE  NULL,
	[bit824] [bit] SPARSE  NULL,
	[bit825] [bit] SPARSE  NULL,
	[bit826] [bit] SPARSE  NULL,
	[bit827] [bit] SPARSE  NULL,
	[bit828] [bit] SPARSE  NULL,
	[bit829] [bit] SPARSE  NULL,
	[bit830] [bit] SPARSE  NULL,
	[bit831] [bit] SPARSE  NULL,
	[bit832] [bit] SPARSE  NULL,
	[bit833] [bit] SPARSE  NULL,
	[bit834] [bit] SPARSE  NULL,
	[bit835] [bit] SPARSE  NULL,
	[bit836] [bit] SPARSE  NULL,
	[bit837] [bit] SPARSE  NULL,
	[bit838] [bit] SPARSE  NULL,
	[bit839] [bit] SPARSE  NULL,
	[bit840] [bit] SPARSE  NULL,
	[bit841] [bit] SPARSE  NULL,
	[bit842] [bit] SPARSE  NULL,
	[bit843] [bit] SPARSE  NULL,
	[bit844] [bit] SPARSE  NULL,
	[bit845] [bit] SPARSE  NULL,
	[bit846] [bit] SPARSE  NULL,
	[bit847] [bit] SPARSE  NULL,
	[bit848] [bit] SPARSE  NULL,
	[bit849] [bit] SPARSE  NULL,
	[bit850] [bit] SPARSE  NULL,
	[bit851] [bit] SPARSE  NULL,
	[bit852] [bit] SPARSE  NULL,
	[bit853] [bit] SPARSE  NULL,
	[bit854] [bit] SPARSE  NULL,
	[bit855] [bit] SPARSE  NULL,
	[bit856] [bit] SPARSE  NULL,
	[bit857] [bit] SPARSE  NULL,
	[bit858] [bit] SPARSE  NULL,
	[bit859] [bit] SPARSE  NULL,
	[bit860] [bit] SPARSE  NULL,
	[bit861] [bit] SPARSE  NULL,
	[bit862] [bit] SPARSE  NULL,
	[bit863] [bit] SPARSE  NULL,
	[bit864] [bit] SPARSE  NULL,
	[bit865] [bit] SPARSE  NULL,
	[bit866] [bit] SPARSE  NULL,
	[bit867] [bit] SPARSE  NULL,
	[bit868] [bit] SPARSE  NULL,
	[bit869] [bit] SPARSE  NULL,
	[bit870] [bit] SPARSE  NULL,
	[bit871] [bit] SPARSE  NULL,
	[bit872] [bit] SPARSE  NULL,
	[bit873] [bit] SPARSE  NULL,
	[bit874] [bit] SPARSE  NULL,
	[bit875] [bit] SPARSE  NULL,
	[bit876] [bit] SPARSE  NULL,
	[bit877] [bit] SPARSE  NULL,
	[bit878] [bit] SPARSE  NULL,
	[bit879] [bit] SPARSE  NULL,
	[bit880] [bit] SPARSE  NULL,
	[bit881] [bit] SPARSE  NULL,
	[bit882] [bit] SPARSE  NULL,
	[bit883] [bit] SPARSE  NULL,
	[bit884] [bit] SPARSE  NULL,
	[bit885] [bit] SPARSE  NULL,
	[bit886] [bit] SPARSE  NULL,
	[bit887] [bit] SPARSE  NULL,
	[bit888] [bit] SPARSE  NULL,
	[bit889] [bit] SPARSE  NULL,
	[bit890] [bit] SPARSE  NULL,
	[bit891] [bit] SPARSE  NULL,
	[bit892] [bit] SPARSE  NULL,
	[bit893] [bit] SPARSE  NULL,
	[bit894] [bit] SPARSE  NULL,
	[bit895] [bit] SPARSE  NULL,
	[bit896] [bit] SPARSE  NULL,
	[bit897] [bit] SPARSE  NULL,
	[bit898] [bit] SPARSE  NULL,
	[bit899] [bit] SPARSE  NULL,
	[bit900] [bit] SPARSE  NULL,
	[bit901] [bit] SPARSE  NULL,
	[bit902] [bit] SPARSE  NULL,
	[bit903] [bit] SPARSE  NULL,
	[bit904] [bit] SPARSE  NULL,
	[bit905] [bit] SPARSE  NULL,
	[bit906] [bit] SPARSE  NULL,
	[bit907] [bit] SPARSE  NULL,
	[bit908] [bit] SPARSE  NULL,
	[bit909] [bit] SPARSE  NULL,
	[bit910] [bit] SPARSE  NULL,
	[bit911] [bit] SPARSE  NULL,
	[bit912] [bit] SPARSE  NULL,
	[bit913] [bit] SPARSE  NULL,
	[bit914] [bit] SPARSE  NULL,
	[bit915] [bit] SPARSE  NULL,
	[bit916] [bit] SPARSE  NULL,
	[bit917] [bit] SPARSE  NULL,
	[bit918] [bit] SPARSE  NULL,
	[bit919] [bit] SPARSE  NULL,
	[bit920] [bit] SPARSE  NULL,
	[bit921] [bit] SPARSE  NULL,
	[bit922] [bit] SPARSE  NULL,
	[bit923] [bit] SPARSE  NULL,
	[bit924] [bit] SPARSE  NULL,
	[bit925] [bit] SPARSE  NULL,
	[bit926] [bit] SPARSE  NULL,
	[bit927] [bit] SPARSE  NULL,
	[bit928] [bit] SPARSE  NULL,
	[bit929] [bit] SPARSE  NULL,
	[bit930] [bit] SPARSE  NULL,
	[bit931] [bit] SPARSE  NULL,
	[bit932] [bit] SPARSE  NULL,
	[bit933] [bit] SPARSE  NULL,
	[bit934] [bit] SPARSE  NULL,
	[bit935] [bit] SPARSE  NULL,
	[bit936] [bit] SPARSE  NULL,
	[bit937] [bit] SPARSE  NULL,
	[bit938] [bit] SPARSE  NULL,
	[bit939] [bit] SPARSE  NULL,
	[bit940] [bit] SPARSE  NULL,
	[bit941] [bit] SPARSE  NULL,
	[bit942] [bit] SPARSE  NULL,
	[bit943] [bit] SPARSE  NULL,
	[bit944] [bit] SPARSE  NULL,
	[bit945] [bit] SPARSE  NULL,
	[bit946] [bit] SPARSE  NULL,
	[bit947] [bit] SPARSE  NULL,
	[bit948] [bit] SPARSE  NULL,
	[bit949] [bit] SPARSE  NULL,
	[bit950] [bit] SPARSE  NULL,
	[bit951] [bit] SPARSE  NULL,
	[bit952] [bit] SPARSE  NULL,
	[bit953] [bit] SPARSE  NULL,
	[bit954] [bit] SPARSE  NULL,
	[bit955] [bit] SPARSE  NULL,
	[bit956] [bit] SPARSE  NULL,
	[bit957] [bit] SPARSE  NULL,
	[bit958] [bit] SPARSE  NULL,
	[bit959] [bit] SPARSE  NULL,
	[bit960] [bit] SPARSE  NULL,
	[bit961] [bit] SPARSE  NULL,
	[bit962] [bit] SPARSE  NULL,
	[bit963] [bit] SPARSE  NULL,
	[bit964] [bit] SPARSE  NULL,
	[bit965] [bit] SPARSE  NULL,
	[bit966] [bit] SPARSE  NULL,
	[bit967] [bit] SPARSE  NULL,
	[bit968] [bit] SPARSE  NULL,
	[bit969] [bit] SPARSE  NULL,
	[bit970] [bit] SPARSE  NULL,
	[bit971] [bit] SPARSE  NULL,
	[bit972] [bit] SPARSE  NULL,
	[bit973] [bit] SPARSE  NULL,
	[bit974] [bit] SPARSE  NULL,
	[bit975] [bit] SPARSE  NULL,
	[bit976] [bit] SPARSE  NULL,
	[bit977] [bit] SPARSE  NULL,
	[bit978] [bit] SPARSE  NULL,
	[bit979] [bit] SPARSE  NULL,
	[bit980] [bit] SPARSE  NULL,
	[bit981] [bit] SPARSE  NULL,
	[bit982] [bit] SPARSE  NULL,
	[bit983] [bit] SPARSE  NULL,
	[bit984] [bit] SPARSE  NULL,
	[bit985] [bit] SPARSE  NULL,
	[bit986] [bit] SPARSE  NULL,
	[bit987] [bit] SPARSE  NULL,
	[bit988] [bit] SPARSE  NULL,
	[bit989] [bit] SPARSE  NULL,
	[bit990] [bit] SPARSE  NULL,
	[bit991] [bit] SPARSE  NULL,
	[bit992] [bit] SPARSE  NULL,
	[bit993] [bit] SPARSE  NULL,
	[bit994] [bit] SPARSE  NULL,
	[bit995] [bit] SPARSE  NULL,
	[bit996] [bit] SPARSE  NULL,
	[bit997] [bit] SPARSE  NULL,
	[bit998] [bit] SPARSE  NULL,
	[bit999] [bit] SPARSE  NULL,
	[bit1000] [bit] SPARSE  NULL,
	[datetime1] [datetime] SPARSE  NULL,
	[datetime2] [datetime] SPARSE  NULL,
	[datetime3] [datetime] SPARSE  NULL,
	[datetime4] [datetime] SPARSE  NULL,
	[datetime5] [datetime] SPARSE  NULL,
	[datetime6] [datetime] SPARSE  NULL,
	[datetime7] [datetime] SPARSE  NULL,
	[datetime8] [datetime] SPARSE  NULL,
	[datetime9] [datetime] SPARSE  NULL,
	[datetime10] [datetime] SPARSE  NULL,
	[datetime11] [datetime] SPARSE  NULL,
	[datetime12] [datetime] SPARSE  NULL,
	[datetime13] [datetime] SPARSE  NULL,
	[datetime14] [datetime] SPARSE  NULL,
	[datetime15] [datetime] SPARSE  NULL,
	[datetime16] [datetime] SPARSE  NULL,
	[datetime17] [datetime] SPARSE  NULL,
	[datetime18] [datetime] SPARSE  NULL,
	[datetime19] [datetime] SPARSE  NULL,
	[datetime20] [datetime] SPARSE  NULL,
	[datetime21] [datetime] SPARSE  NULL,
	[datetime22] [datetime] SPARSE  NULL,
	[datetime23] [datetime] SPARSE  NULL,
	[datetime24] [datetime] SPARSE  NULL,
	[datetime25] [datetime] SPARSE  NULL,
	[datetime26] [datetime] SPARSE  NULL,
	[datetime27] [datetime] SPARSE  NULL,
	[datetime28] [datetime] SPARSE  NULL,
	[datetime29] [datetime] SPARSE  NULL,
	[datetime30] [datetime] SPARSE  NULL,
	[datetime31] [datetime] SPARSE  NULL,
	[datetime32] [datetime] SPARSE  NULL,
	[datetime33] [datetime] SPARSE  NULL,
	[datetime34] [datetime] SPARSE  NULL,
	[datetime35] [datetime] SPARSE  NULL,
	[datetime36] [datetime] SPARSE  NULL,
	[datetime37] [datetime] SPARSE  NULL,
	[datetime38] [datetime] SPARSE  NULL,
	[datetime39] [datetime] SPARSE  NULL,
	[datetime40] [datetime] SPARSE  NULL,
	[datetime41] [datetime] SPARSE  NULL,
	[datetime42] [datetime] SPARSE  NULL,
	[datetime43] [datetime] SPARSE  NULL,
	[datetime44] [datetime] SPARSE  NULL,
	[datetime45] [datetime] SPARSE  NULL,
	[datetime46] [datetime] SPARSE  NULL,
	[datetime47] [datetime] SPARSE  NULL,
	[datetime48] [datetime] SPARSE  NULL,
	[datetime49] [datetime] SPARSE  NULL,
	[datetime50] [datetime] SPARSE  NULL,
	[datetime51] [datetime] SPARSE  NULL,
	[datetime52] [datetime] SPARSE  NULL,
	[datetime53] [datetime] SPARSE  NULL,
	[datetime54] [datetime] SPARSE  NULL,
	[datetime55] [datetime] SPARSE  NULL,
	[datetime56] [datetime] SPARSE  NULL,
	[datetime57] [datetime] SPARSE  NULL,
	[datetime58] [datetime] SPARSE  NULL,
	[datetime59] [datetime] SPARSE  NULL,
	[datetime60] [datetime] SPARSE  NULL,
	[datetime61] [datetime] SPARSE  NULL,
	[datetime62] [datetime] SPARSE  NULL,
	[datetime63] [datetime] SPARSE  NULL,
	[datetime64] [datetime] SPARSE  NULL,
	[datetime65] [datetime] SPARSE  NULL,
	[datetime66] [datetime] SPARSE  NULL,
	[datetime67] [datetime] SPARSE  NULL,
	[datetime68] [datetime] SPARSE  NULL,
	[datetime69] [datetime] SPARSE  NULL,
	[datetime70] [datetime] SPARSE  NULL,
	[datetime71] [datetime] SPARSE  NULL,
	[datetime72] [datetime] SPARSE  NULL,
	[datetime73] [datetime] SPARSE  NULL,
	[datetime74] [datetime] SPARSE  NULL,
	[datetime75] [datetime] SPARSE  NULL,
	[datetime76] [datetime] SPARSE  NULL,
	[datetime77] [datetime] SPARSE  NULL,
	[datetime78] [datetime] SPARSE  NULL,
	[datetime79] [datetime] SPARSE  NULL,
	[datetime80] [datetime] SPARSE  NULL,
	[datetime81] [datetime] SPARSE  NULL,
	[datetime82] [datetime] SPARSE  NULL,
	[datetime83] [datetime] SPARSE  NULL,
	[datetime84] [datetime] SPARSE  NULL,
	[datetime85] [datetime] SPARSE  NULL,
	[datetime86] [datetime] SPARSE  NULL,
	[datetime87] [datetime] SPARSE  NULL,
	[datetime88] [datetime] SPARSE  NULL,
	[datetime89] [datetime] SPARSE  NULL,
	[datetime90] [datetime] SPARSE  NULL,
	[datetime91] [datetime] SPARSE  NULL,
	[datetime92] [datetime] SPARSE  NULL,
	[datetime93] [datetime] SPARSE  NULL,
	[datetime94] [datetime] SPARSE  NULL,
	[datetime95] [datetime] SPARSE  NULL,
	[datetime96] [datetime] SPARSE  NULL,
	[datetime97] [datetime] SPARSE  NULL,
	[datetime98] [datetime] SPARSE  NULL,
	[datetime99] [datetime] SPARSE  NULL,
	[datetime100] [datetime] SPARSE  NULL,
	[datetime101] [datetime] SPARSE  NULL,
	[datetime102] [datetime] SPARSE  NULL,
	[datetime103] [datetime] SPARSE  NULL,
	[datetime104] [datetime] SPARSE  NULL,
	[datetime105] [datetime] SPARSE  NULL,
	[datetime106] [datetime] SPARSE  NULL,
	[datetime107] [datetime] SPARSE  NULL,
	[datetime108] [datetime] SPARSE  NULL,
	[datetime109] [datetime] SPARSE  NULL,
	[datetime110] [datetime] SPARSE  NULL,
	[datetime111] [datetime] SPARSE  NULL,
	[datetime112] [datetime] SPARSE  NULL,
	[datetime113] [datetime] SPARSE  NULL,
	[datetime114] [datetime] SPARSE  NULL,
	[datetime115] [datetime] SPARSE  NULL,
	[datetime116] [datetime] SPARSE  NULL,
	[datetime117] [datetime] SPARSE  NULL,
	[datetime118] [datetime] SPARSE  NULL,
	[datetime119] [datetime] SPARSE  NULL,
	[datetime120] [datetime] SPARSE  NULL,
	[datetime121] [datetime] SPARSE  NULL,
	[datetime122] [datetime] SPARSE  NULL,
	[datetime123] [datetime] SPARSE  NULL,
	[datetime124] [datetime] SPARSE  NULL,
	[datetime125] [datetime] SPARSE  NULL,
	[datetime126] [datetime] SPARSE  NULL,
	[datetime127] [datetime] SPARSE  NULL,
	[datetime128] [datetime] SPARSE  NULL,
	[datetime129] [datetime] SPARSE  NULL,
	[datetime130] [datetime] SPARSE  NULL,
	[datetime131] [datetime] SPARSE  NULL,
	[datetime132] [datetime] SPARSE  NULL,
	[datetime133] [datetime] SPARSE  NULL,
	[datetime134] [datetime] SPARSE  NULL,
	[datetime135] [datetime] SPARSE  NULL,
	[datetime136] [datetime] SPARSE  NULL,
	[datetime137] [datetime] SPARSE  NULL,
	[datetime138] [datetime] SPARSE  NULL,
	[datetime139] [datetime] SPARSE  NULL,
	[datetime140] [datetime] SPARSE  NULL,
	[datetime141] [datetime] SPARSE  NULL,
	[datetime142] [datetime] SPARSE  NULL,
	[datetime143] [datetime] SPARSE  NULL,
	[datetime144] [datetime] SPARSE  NULL,
	[datetime145] [datetime] SPARSE  NULL,
	[datetime146] [datetime] SPARSE  NULL,
	[datetime147] [datetime] SPARSE  NULL,
	[datetime148] [datetime] SPARSE  NULL,
	[datetime149] [datetime] SPARSE  NULL,
	[datetime150] [datetime] SPARSE  NULL,
	[datetime151] [datetime] SPARSE  NULL,
	[datetime152] [datetime] SPARSE  NULL,
	[datetime153] [datetime] SPARSE  NULL,
	[datetime154] [datetime] SPARSE  NULL,
	[datetime155] [datetime] SPARSE  NULL,
	[datetime156] [datetime] SPARSE  NULL,
	[datetime157] [datetime] SPARSE  NULL,
	[datetime158] [datetime] SPARSE  NULL,
	[datetime159] [datetime] SPARSE  NULL,
	[datetime160] [datetime] SPARSE  NULL,
	[datetime161] [datetime] SPARSE  NULL,
	[datetime162] [datetime] SPARSE  NULL,
	[datetime163] [datetime] SPARSE  NULL,
	[datetime164] [datetime] SPARSE  NULL,
	[datetime165] [datetime] SPARSE  NULL,
	[datetime166] [datetime] SPARSE  NULL,
	[datetime167] [datetime] SPARSE  NULL,
	[datetime168] [datetime] SPARSE  NULL,
	[datetime169] [datetime] SPARSE  NULL,
	[datetime170] [datetime] SPARSE  NULL,
	[datetime171] [datetime] SPARSE  NULL,
	[datetime172] [datetime] SPARSE  NULL,
	[datetime173] [datetime] SPARSE  NULL,
	[datetime174] [datetime] SPARSE  NULL,
	[datetime175] [datetime] SPARSE  NULL,
	[datetime176] [datetime] SPARSE  NULL,
	[datetime177] [datetime] SPARSE  NULL,
	[datetime178] [datetime] SPARSE  NULL,
	[datetime179] [datetime] SPARSE  NULL,
	[datetime180] [datetime] SPARSE  NULL,
	[datetime181] [datetime] SPARSE  NULL,
	[datetime182] [datetime] SPARSE  NULL,
	[datetime183] [datetime] SPARSE  NULL,
	[datetime184] [datetime] SPARSE  NULL,
	[datetime185] [datetime] SPARSE  NULL,
	[datetime186] [datetime] SPARSE  NULL,
	[datetime187] [datetime] SPARSE  NULL,
	[datetime188] [datetime] SPARSE  NULL,
	[datetime189] [datetime] SPARSE  NULL,
	[datetime190] [datetime] SPARSE  NULL,
	[datetime191] [datetime] SPARSE  NULL,
	[datetime192] [datetime] SPARSE  NULL,
	[datetime193] [datetime] SPARSE  NULL,
	[datetime194] [datetime] SPARSE  NULL,
	[datetime195] [datetime] SPARSE  NULL,
	[datetime196] [datetime] SPARSE  NULL,
	[datetime197] [datetime] SPARSE  NULL,
	[datetime198] [datetime] SPARSE  NULL,
	[datetime199] [datetime] SPARSE  NULL,
	[datetime200] [datetime] SPARSE  NULL,
	[datetime201] [datetime] SPARSE  NULL,
	[datetime202] [datetime] SPARSE  NULL,
	[datetime203] [datetime] SPARSE  NULL,
	[datetime204] [datetime] SPARSE  NULL,
	[datetime205] [datetime] SPARSE  NULL,
	[datetime206] [datetime] SPARSE  NULL,
	[datetime207] [datetime] SPARSE  NULL,
	[datetime208] [datetime] SPARSE  NULL,
	[datetime209] [datetime] SPARSE  NULL,
	[datetime210] [datetime] SPARSE  NULL,
	[datetime211] [datetime] SPARSE  NULL,
	[datetime212] [datetime] SPARSE  NULL,
	[datetime213] [datetime] SPARSE  NULL,
	[datetime214] [datetime] SPARSE  NULL,
	[datetime215] [datetime] SPARSE  NULL,
	[datetime216] [datetime] SPARSE  NULL,
	[datetime217] [datetime] SPARSE  NULL,
	[datetime218] [datetime] SPARSE  NULL,
	[datetime219] [datetime] SPARSE  NULL,
	[datetime220] [datetime] SPARSE  NULL,
	[datetime221] [datetime] SPARSE  NULL,
	[datetime222] [datetime] SPARSE  NULL,
	[datetime223] [datetime] SPARSE  NULL,
	[datetime224] [datetime] SPARSE  NULL,
	[datetime225] [datetime] SPARSE  NULL,
	[datetime226] [datetime] SPARSE  NULL,
	[datetime227] [datetime] SPARSE  NULL,
	[datetime228] [datetime] SPARSE  NULL,
	[datetime229] [datetime] SPARSE  NULL,
	[datetime230] [datetime] SPARSE  NULL,
	[datetime231] [datetime] SPARSE  NULL,
	[datetime232] [datetime] SPARSE  NULL,
	[datetime233] [datetime] SPARSE  NULL,
	[datetime234] [datetime] SPARSE  NULL,
	[datetime235] [datetime] SPARSE  NULL,
	[datetime236] [datetime] SPARSE  NULL,
	[datetime237] [datetime] SPARSE  NULL,
	[datetime238] [datetime] SPARSE  NULL,
	[datetime239] [datetime] SPARSE  NULL,
	[datetime240] [datetime] SPARSE  NULL,
	[datetime241] [datetime] SPARSE  NULL,
	[datetime242] [datetime] SPARSE  NULL,
	[datetime243] [datetime] SPARSE  NULL,
	[datetime244] [datetime] SPARSE  NULL,
	[datetime245] [datetime] SPARSE  NULL,
	[datetime246] [datetime] SPARSE  NULL,
	[datetime247] [datetime] SPARSE  NULL,
	[datetime248] [datetime] SPARSE  NULL,
	[datetime249] [datetime] SPARSE  NULL,
	[datetime250] [datetime] SPARSE  NULL,
	[datetime251] [datetime] SPARSE  NULL,
	[datetime252] [datetime] SPARSE  NULL,
	[datetime253] [datetime] SPARSE  NULL,
	[datetime254] [datetime] SPARSE  NULL,
	[datetime255] [datetime] SPARSE  NULL,
	[datetime256] [datetime] SPARSE  NULL,
	[datetime257] [datetime] SPARSE  NULL,
	[datetime258] [datetime] SPARSE  NULL,
	[datetime259] [datetime] SPARSE  NULL,
	[datetime260] [datetime] SPARSE  NULL,
	[datetime261] [datetime] SPARSE  NULL,
	[datetime262] [datetime] SPARSE  NULL,
	[datetime263] [datetime] SPARSE  NULL,
	[datetime264] [datetime] SPARSE  NULL,
	[datetime265] [datetime] SPARSE  NULL,
	[datetime266] [datetime] SPARSE  NULL,
	[datetime267] [datetime] SPARSE  NULL,
	[datetime268] [datetime] SPARSE  NULL,
	[datetime269] [datetime] SPARSE  NULL,
	[datetime270] [datetime] SPARSE  NULL,
	[datetime271] [datetime] SPARSE  NULL,
	[datetime272] [datetime] SPARSE  NULL,
	[datetime273] [datetime] SPARSE  NULL,
	[datetime274] [datetime] SPARSE  NULL,
	[datetime275] [datetime] SPARSE  NULL,
	[datetime276] [datetime] SPARSE  NULL,
	[datetime277] [datetime] SPARSE  NULL,
	[datetime278] [datetime] SPARSE  NULL,
	[datetime279] [datetime] SPARSE  NULL,
	[datetime280] [datetime] SPARSE  NULL,
	[datetime281] [datetime] SPARSE  NULL,
	[datetime282] [datetime] SPARSE  NULL,
	[datetime283] [datetime] SPARSE  NULL,
	[datetime284] [datetime] SPARSE  NULL,
	[datetime285] [datetime] SPARSE  NULL,
	[datetime286] [datetime] SPARSE  NULL,
	[datetime287] [datetime] SPARSE  NULL,
	[datetime288] [datetime] SPARSE  NULL,
	[datetime289] [datetime] SPARSE  NULL,
	[datetime290] [datetime] SPARSE  NULL,
	[datetime291] [datetime] SPARSE  NULL,
	[datetime292] [datetime] SPARSE  NULL,
	[datetime293] [datetime] SPARSE  NULL,
	[datetime294] [datetime] SPARSE  NULL,
	[datetime295] [datetime] SPARSE  NULL,
	[datetime296] [datetime] SPARSE  NULL,
	[datetime297] [datetime] SPARSE  NULL,
	[datetime298] [datetime] SPARSE  NULL,
	[datetime299] [datetime] SPARSE  NULL,
	[datetime300] [datetime] SPARSE  NULL,
	[datetime301] [datetime] SPARSE  NULL,
	[datetime302] [datetime] SPARSE  NULL,
	[datetime303] [datetime] SPARSE  NULL,
	[datetime304] [datetime] SPARSE  NULL,
	[datetime305] [datetime] SPARSE  NULL,
	[datetime306] [datetime] SPARSE  NULL,
	[datetime307] [datetime] SPARSE  NULL,
	[datetime308] [datetime] SPARSE  NULL,
	[datetime309] [datetime] SPARSE  NULL,
	[datetime310] [datetime] SPARSE  NULL,
	[datetime311] [datetime] SPARSE  NULL,
	[datetime312] [datetime] SPARSE  NULL,
	[datetime313] [datetime] SPARSE  NULL,
	[datetime314] [datetime] SPARSE  NULL,
	[datetime315] [datetime] SPARSE  NULL,
	[datetime316] [datetime] SPARSE  NULL,
	[datetime317] [datetime] SPARSE  NULL,
	[datetime318] [datetime] SPARSE  NULL,
	[datetime319] [datetime] SPARSE  NULL,
	[datetime320] [datetime] SPARSE  NULL,
	[datetime321] [datetime] SPARSE  NULL,
	[datetime322] [datetime] SPARSE  NULL,
	[datetime323] [datetime] SPARSE  NULL,
	[datetime324] [datetime] SPARSE  NULL,
	[datetime325] [datetime] SPARSE  NULL,
	[datetime326] [datetime] SPARSE  NULL,
	[datetime327] [datetime] SPARSE  NULL,
	[datetime328] [datetime] SPARSE  NULL,
	[datetime329] [datetime] SPARSE  NULL,
	[datetime330] [datetime] SPARSE  NULL,
	[datetime331] [datetime] SPARSE  NULL,
	[datetime332] [datetime] SPARSE  NULL,
	[datetime333] [datetime] SPARSE  NULL,
	[datetime334] [datetime] SPARSE  NULL,
	[datetime335] [datetime] SPARSE  NULL,
	[datetime336] [datetime] SPARSE  NULL,
	[datetime337] [datetime] SPARSE  NULL,
	[datetime338] [datetime] SPARSE  NULL,
	[datetime339] [datetime] SPARSE  NULL,
	[datetime340] [datetime] SPARSE  NULL,
	[datetime341] [datetime] SPARSE  NULL,
	[datetime342] [datetime] SPARSE  NULL,
	[datetime343] [datetime] SPARSE  NULL,
	[datetime344] [datetime] SPARSE  NULL,
	[datetime345] [datetime] SPARSE  NULL,
	[datetime346] [datetime] SPARSE  NULL,
	[datetime347] [datetime] SPARSE  NULL,
	[datetime348] [datetime] SPARSE  NULL,
	[datetime349] [datetime] SPARSE  NULL,
	[datetime350] [datetime] SPARSE  NULL,
	[datetime351] [datetime] SPARSE  NULL,
	[datetime352] [datetime] SPARSE  NULL,
	[datetime353] [datetime] SPARSE  NULL,
	[datetime354] [datetime] SPARSE  NULL,
	[datetime355] [datetime] SPARSE  NULL,
	[datetime356] [datetime] SPARSE  NULL,
	[datetime357] [datetime] SPARSE  NULL,
	[datetime358] [datetime] SPARSE  NULL,
	[datetime359] [datetime] SPARSE  NULL,
	[datetime360] [datetime] SPARSE  NULL,
	[datetime361] [datetime] SPARSE  NULL,
	[datetime362] [datetime] SPARSE  NULL,
	[datetime363] [datetime] SPARSE  NULL,
	[datetime364] [datetime] SPARSE  NULL,
	[datetime365] [datetime] SPARSE  NULL,
	[datetime366] [datetime] SPARSE  NULL,
	[datetime367] [datetime] SPARSE  NULL,
	[datetime368] [datetime] SPARSE  NULL,
	[datetime369] [datetime] SPARSE  NULL,
	[datetime370] [datetime] SPARSE  NULL,
	[datetime371] [datetime] SPARSE  NULL,
	[datetime372] [datetime] SPARSE  NULL,
	[datetime373] [datetime] SPARSE  NULL,
	[datetime374] [datetime] SPARSE  NULL,
	[datetime375] [datetime] SPARSE  NULL,
	[datetime376] [datetime] SPARSE  NULL,
	[datetime377] [datetime] SPARSE  NULL,
	[datetime378] [datetime] SPARSE  NULL,
	[datetime379] [datetime] SPARSE  NULL,
	[datetime380] [datetime] SPARSE  NULL,
	[datetime381] [datetime] SPARSE  NULL,
	[datetime382] [datetime] SPARSE  NULL,
	[datetime383] [datetime] SPARSE  NULL,
	[datetime384] [datetime] SPARSE  NULL,
	[datetime385] [datetime] SPARSE  NULL,
	[datetime386] [datetime] SPARSE  NULL,
	[datetime387] [datetime] SPARSE  NULL,
	[datetime388] [datetime] SPARSE  NULL,
	[datetime389] [datetime] SPARSE  NULL,
	[datetime390] [datetime] SPARSE  NULL,
	[datetime391] [datetime] SPARSE  NULL,
	[datetime392] [datetime] SPARSE  NULL,
	[datetime393] [datetime] SPARSE  NULL,
	[datetime394] [datetime] SPARSE  NULL,
	[datetime395] [datetime] SPARSE  NULL,
	[datetime396] [datetime] SPARSE  NULL,
	[datetime397] [datetime] SPARSE  NULL,
	[datetime398] [datetime] SPARSE  NULL,
	[datetime399] [datetime] SPARSE  NULL,
	[datetime400] [datetime] SPARSE  NULL,
	[datetime401] [datetime] SPARSE  NULL,
	[datetime402] [datetime] SPARSE  NULL,
	[datetime403] [datetime] SPARSE  NULL,
	[datetime404] [datetime] SPARSE  NULL,
	[datetime405] [datetime] SPARSE  NULL,
	[datetime406] [datetime] SPARSE  NULL,
	[datetime407] [datetime] SPARSE  NULL,
	[datetime408] [datetime] SPARSE  NULL,
	[datetime409] [datetime] SPARSE  NULL,
	[datetime410] [datetime] SPARSE  NULL,
	[datetime411] [datetime] SPARSE  NULL,
	[datetime412] [datetime] SPARSE  NULL,
	[datetime413] [datetime] SPARSE  NULL,
	[datetime414] [datetime] SPARSE  NULL,
	[datetime415] [datetime] SPARSE  NULL,
	[datetime416] [datetime] SPARSE  NULL,
	[datetime417] [datetime] SPARSE  NULL,
	[datetime418] [datetime] SPARSE  NULL,
	[datetime419] [datetime] SPARSE  NULL,
	[datetime420] [datetime] SPARSE  NULL,
	[datetime421] [datetime] SPARSE  NULL,
	[datetime422] [datetime] SPARSE  NULL,
	[datetime423] [datetime] SPARSE  NULL,
	[datetime424] [datetime] SPARSE  NULL,
	[datetime425] [datetime] SPARSE  NULL,
	[datetime426] [datetime] SPARSE  NULL,
	[datetime427] [datetime] SPARSE  NULL,
	[datetime428] [datetime] SPARSE  NULL,
	[datetime429] [datetime] SPARSE  NULL,
	[datetime430] [datetime] SPARSE  NULL,
	[datetime431] [datetime] SPARSE  NULL,
	[datetime432] [datetime] SPARSE  NULL,
	[datetime433] [datetime] SPARSE  NULL,
	[datetime434] [datetime] SPARSE  NULL,
	[datetime435] [datetime] SPARSE  NULL,
	[datetime436] [datetime] SPARSE  NULL,
	[datetime437] [datetime] SPARSE  NULL,
	[datetime438] [datetime] SPARSE  NULL,
	[datetime439] [datetime] SPARSE  NULL,
	[datetime440] [datetime] SPARSE  NULL,
	[datetime441] [datetime] SPARSE  NULL,
	[datetime442] [datetime] SPARSE  NULL,
	[datetime443] [datetime] SPARSE  NULL,
	[datetime444] [datetime] SPARSE  NULL,
	[datetime445] [datetime] SPARSE  NULL,
	[datetime446] [datetime] SPARSE  NULL,
	[datetime447] [datetime] SPARSE  NULL,
	[datetime448] [datetime] SPARSE  NULL,
	[datetime449] [datetime] SPARSE  NULL,
	[datetime450] [datetime] SPARSE  NULL,
	[datetime451] [datetime] SPARSE  NULL,
	[datetime452] [datetime] SPARSE  NULL,
	[datetime453] [datetime] SPARSE  NULL,
	[datetime454] [datetime] SPARSE  NULL,
	[datetime455] [datetime] SPARSE  NULL,
	[datetime456] [datetime] SPARSE  NULL,
	[datetime457] [datetime] SPARSE  NULL,
	[datetime458] [datetime] SPARSE  NULL,
	[datetime459] [datetime] SPARSE  NULL,
	[datetime460] [datetime] SPARSE  NULL,
	[datetime461] [datetime] SPARSE  NULL,
	[datetime462] [datetime] SPARSE  NULL,
	[datetime463] [datetime] SPARSE  NULL,
	[datetime464] [datetime] SPARSE  NULL,
	[datetime465] [datetime] SPARSE  NULL,
	[datetime466] [datetime] SPARSE  NULL,
	[datetime467] [datetime] SPARSE  NULL,
	[datetime468] [datetime] SPARSE  NULL,
	[datetime469] [datetime] SPARSE  NULL,
	[datetime470] [datetime] SPARSE  NULL,
	[datetime471] [datetime] SPARSE  NULL,
	[datetime472] [datetime] SPARSE  NULL,
	[datetime473] [datetime] SPARSE  NULL,
	[datetime474] [datetime] SPARSE  NULL,
	[datetime475] [datetime] SPARSE  NULL,
	[datetime476] [datetime] SPARSE  NULL,
	[datetime477] [datetime] SPARSE  NULL,
	[datetime478] [datetime] SPARSE  NULL,
	[datetime479] [datetime] SPARSE  NULL,
	[datetime480] [datetime] SPARSE  NULL,
	[datetime481] [datetime] SPARSE  NULL,
	[datetime482] [datetime] SPARSE  NULL,
	[datetime483] [datetime] SPARSE  NULL,
	[datetime484] [datetime] SPARSE  NULL,
	[datetime485] [datetime] SPARSE  NULL,
	[datetime486] [datetime] SPARSE  NULL,
	[datetime487] [datetime] SPARSE  NULL,
	[datetime488] [datetime] SPARSE  NULL,
	[datetime489] [datetime] SPARSE  NULL,
	[datetime490] [datetime] SPARSE  NULL,
	[datetime491] [datetime] SPARSE  NULL,
	[datetime492] [datetime] SPARSE  NULL,
	[datetime493] [datetime] SPARSE  NULL,
	[datetime494] [datetime] SPARSE  NULL,
	[datetime495] [datetime] SPARSE  NULL,
	[datetime496] [datetime] SPARSE  NULL,
	[datetime497] [datetime] SPARSE  NULL,
	[datetime498] [datetime] SPARSE  NULL,
	[datetime499] [datetime] SPARSE  NULL,
	[datetime500] [datetime] SPARSE  NULL,
	[datetime501] [datetime] SPARSE  NULL,
	[datetime502] [datetime] SPARSE  NULL,
	[datetime503] [datetime] SPARSE  NULL,
	[datetime504] [datetime] SPARSE  NULL,
	[datetime505] [datetime] SPARSE  NULL,
	[datetime506] [datetime] SPARSE  NULL,
	[datetime507] [datetime] SPARSE  NULL,
	[datetime508] [datetime] SPARSE  NULL,
	[datetime509] [datetime] SPARSE  NULL,
	[datetime510] [datetime] SPARSE  NULL,
	[datetime511] [datetime] SPARSE  NULL,
	[datetime512] [datetime] SPARSE  NULL,
	[datetime513] [datetime] SPARSE  NULL,
	[datetime514] [datetime] SPARSE  NULL,
	[datetime515] [datetime] SPARSE  NULL,
	[datetime516] [datetime] SPARSE  NULL,
	[datetime517] [datetime] SPARSE  NULL,
	[datetime518] [datetime] SPARSE  NULL,
	[datetime519] [datetime] SPARSE  NULL,
	[datetime520] [datetime] SPARSE  NULL,
	[datetime521] [datetime] SPARSE  NULL,
	[datetime522] [datetime] SPARSE  NULL,
	[datetime523] [datetime] SPARSE  NULL,
	[datetime524] [datetime] SPARSE  NULL,
	[datetime525] [datetime] SPARSE  NULL,
	[datetime526] [datetime] SPARSE  NULL,
	[datetime527] [datetime] SPARSE  NULL,
	[datetime528] [datetime] SPARSE  NULL,
	[datetime529] [datetime] SPARSE  NULL,
	[datetime530] [datetime] SPARSE  NULL,
	[datetime531] [datetime] SPARSE  NULL,
	[datetime532] [datetime] SPARSE  NULL,
	[datetime533] [datetime] SPARSE  NULL,
	[datetime534] [datetime] SPARSE  NULL,
	[datetime535] [datetime] SPARSE  NULL,
	[datetime536] [datetime] SPARSE  NULL,
	[datetime537] [datetime] SPARSE  NULL,
	[datetime538] [datetime] SPARSE  NULL,
	[datetime539] [datetime] SPARSE  NULL,
	[datetime540] [datetime] SPARSE  NULL,
	[datetime541] [datetime] SPARSE  NULL,
	[datetime542] [datetime] SPARSE  NULL,
	[datetime543] [datetime] SPARSE  NULL,
	[datetime544] [datetime] SPARSE  NULL,
	[datetime545] [datetime] SPARSE  NULL,
	[datetime546] [datetime] SPARSE  NULL,
	[datetime547] [datetime] SPARSE  NULL,
	[datetime548] [datetime] SPARSE  NULL,
	[datetime549] [datetime] SPARSE  NULL,
	[datetime550] [datetime] SPARSE  NULL,
	[float1] [float] SPARSE  NULL,
	[float2] [float] SPARSE  NULL,
	[float3] [float] SPARSE  NULL,
	[float4] [float] SPARSE  NULL,
	[float5] [float] SPARSE  NULL,
	[float6] [float] SPARSE  NULL,
	[float7] [float] SPARSE  NULL,
	[float8] [float] SPARSE  NULL,
	[float9] [float] SPARSE  NULL,
	[float10] [float] SPARSE  NULL,
	[float11] [float] SPARSE  NULL,
	[float12] [float] SPARSE  NULL,
	[float13] [float] SPARSE  NULL,
	[float14] [float] SPARSE  NULL,
	[float15] [float] SPARSE  NULL,
	[float16] [float] SPARSE  NULL,
	[float17] [float] SPARSE  NULL,
	[float18] [float] SPARSE  NULL,
	[float19] [float] SPARSE  NULL,
	[float20] [float] SPARSE  NULL,
	[float21] [float] SPARSE  NULL,
	[float22] [float] SPARSE  NULL,
	[float23] [float] SPARSE  NULL,
	[float24] [float] SPARSE  NULL,
	[float25] [float] SPARSE  NULL,
	[float26] [float] SPARSE  NULL,
	[float27] [float] SPARSE  NULL,
	[float28] [float] SPARSE  NULL,
	[float29] [float] SPARSE  NULL,
	[float30] [float] SPARSE  NULL,
	[float31] [float] SPARSE  NULL,
	[float32] [float] SPARSE  NULL,
	[float33] [float] SPARSE  NULL,
	[float34] [float] SPARSE  NULL,
	[float35] [float] SPARSE  NULL,
	[float36] [float] SPARSE  NULL,
	[float37] [float] SPARSE  NULL,
	[float38] [float] SPARSE  NULL,
	[float39] [float] SPARSE  NULL,
	[float40] [float] SPARSE  NULL,
	[float41] [float] SPARSE  NULL,
	[float42] [float] SPARSE  NULL,
	[float43] [float] SPARSE  NULL,
	[float44] [float] SPARSE  NULL,
	[float45] [float] SPARSE  NULL,
	[float46] [float] SPARSE  NULL,
	[float47] [float] SPARSE  NULL,
	[float48] [float] SPARSE  NULL,
	[float49] [float] SPARSE  NULL,
	[float50] [float] SPARSE  NULL,
	[float51] [float] SPARSE  NULL,
	[float52] [float] SPARSE  NULL,
	[float53] [float] SPARSE  NULL,
	[float54] [float] SPARSE  NULL,
	[float55] [float] SPARSE  NULL,
	[float56] [float] SPARSE  NULL,
	[float57] [float] SPARSE  NULL,
	[float58] [float] SPARSE  NULL,
	[float59] [float] SPARSE  NULL,
	[float60] [float] SPARSE  NULL,
	[float61] [float] SPARSE  NULL,
	[float62] [float] SPARSE  NULL,
	[float63] [float] SPARSE  NULL,
	[float64] [float] SPARSE  NULL,
	[float65] [float] SPARSE  NULL,
	[float66] [float] SPARSE  NULL,
	[float67] [float] SPARSE  NULL,
	[float68] [float] SPARSE  NULL,
	[float69] [float] SPARSE  NULL,
	[float70] [float] SPARSE  NULL,
	[float71] [float] SPARSE  NULL,
	[float72] [float] SPARSE  NULL,
	[float73] [float] SPARSE  NULL,
	[float74] [float] SPARSE  NULL,
	[float75] [float] SPARSE  NULL,
	[float76] [float] SPARSE  NULL,
	[float77] [float] SPARSE  NULL,
	[float78] [float] SPARSE  NULL,
	[float79] [float] SPARSE  NULL,
	[float80] [float] SPARSE  NULL,
	[float81] [float] SPARSE  NULL,
	[float82] [float] SPARSE  NULL,
	[float83] [float] SPARSE  NULL,
	[float84] [float] SPARSE  NULL,
	[float85] [float] SPARSE  NULL,
	[float86] [float] SPARSE  NULL,
	[float87] [float] SPARSE  NULL,
	[float88] [float] SPARSE  NULL,
	[float89] [float] SPARSE  NULL,
	[float90] [float] SPARSE  NULL,
	[float91] [float] SPARSE  NULL,
	[float92] [float] SPARSE  NULL,
	[float93] [float] SPARSE  NULL,
	[float94] [float] SPARSE  NULL,
	[float95] [float] SPARSE  NULL,
	[float96] [float] SPARSE  NULL,
	[float97] [float] SPARSE  NULL,
	[float98] [float] SPARSE  NULL,
	[float99] [float] SPARSE  NULL,
	[float100] [float] SPARSE  NULL,
	[float101] [float] SPARSE  NULL,
	[float102] [float] SPARSE  NULL,
	[float103] [float] SPARSE  NULL,
	[float104] [float] SPARSE  NULL,
	[float105] [float] SPARSE  NULL,
	[float106] [float] SPARSE  NULL,
	[float107] [float] SPARSE  NULL,
	[float108] [float] SPARSE  NULL,
	[float109] [float] SPARSE  NULL,
	[float110] [float] SPARSE  NULL,
	[float111] [float] SPARSE  NULL,
	[float112] [float] SPARSE  NULL,
	[float113] [float] SPARSE  NULL,
	[float114] [float] SPARSE  NULL,
	[float115] [float] SPARSE  NULL,
	[float116] [float] SPARSE  NULL,
	[float117] [float] SPARSE  NULL,
	[float118] [float] SPARSE  NULL,
	[float119] [float] SPARSE  NULL,
	[float120] [float] SPARSE  NULL,
	[float121] [float] SPARSE  NULL,
	[float122] [float] SPARSE  NULL,
	[float123] [float] SPARSE  NULL,
	[float124] [float] SPARSE  NULL,
	[float125] [float] SPARSE  NULL,
	[float126] [float] SPARSE  NULL,
	[float127] [float] SPARSE  NULL,
	[float128] [float] SPARSE  NULL,
	[float129] [float] SPARSE  NULL,
	[float130] [float] SPARSE  NULL,
	[float131] [float] SPARSE  NULL,
	[float132] [float] SPARSE  NULL,
	[float133] [float] SPARSE  NULL,
	[float134] [float] SPARSE  NULL,
	[float135] [float] SPARSE  NULL,
	[float136] [float] SPARSE  NULL,
	[float137] [float] SPARSE  NULL,
	[float138] [float] SPARSE  NULL,
	[float139] [float] SPARSE  NULL,
	[float140] [float] SPARSE  NULL,
	[float141] [float] SPARSE  NULL,
	[float142] [float] SPARSE  NULL,
	[float143] [float] SPARSE  NULL,
	[float144] [float] SPARSE  NULL,
	[float145] [float] SPARSE  NULL,
	[float146] [float] SPARSE  NULL,
	[float147] [float] SPARSE  NULL,
	[float148] [float] SPARSE  NULL,
	[float149] [float] SPARSE  NULL,
	[float150] [float] SPARSE  NULL,
	[float151] [float] SPARSE  NULL,
	[float152] [float] SPARSE  NULL,
	[float153] [float] SPARSE  NULL,
	[float154] [float] SPARSE  NULL,
	[float155] [float] SPARSE  NULL,
	[float156] [float] SPARSE  NULL,
	[float157] [float] SPARSE  NULL,
	[float158] [float] SPARSE  NULL,
	[float159] [float] SPARSE  NULL,
	[float160] [float] SPARSE  NULL,
	[float161] [float] SPARSE  NULL,
	[float162] [float] SPARSE  NULL,
	[float163] [float] SPARSE  NULL,
	[float164] [float] SPARSE  NULL,
	[float165] [float] SPARSE  NULL,
	[float166] [float] SPARSE  NULL,
	[float167] [float] SPARSE  NULL,
	[float168] [float] SPARSE  NULL,
	[float169] [float] SPARSE  NULL,
	[float170] [float] SPARSE  NULL,
	[float171] [float] SPARSE  NULL,
	[float172] [float] SPARSE  NULL,
	[float173] [float] SPARSE  NULL,
	[float174] [float] SPARSE  NULL,
	[float175] [float] SPARSE  NULL,
	[float176] [float] SPARSE  NULL,
	[float177] [float] SPARSE  NULL,
	[float178] [float] SPARSE  NULL,
	[float179] [float] SPARSE  NULL,
	[float180] [float] SPARSE  NULL,
	[float181] [float] SPARSE  NULL,
	[float182] [float] SPARSE  NULL,
	[float183] [float] SPARSE  NULL,
	[float184] [float] SPARSE  NULL,
	[float185] [float] SPARSE  NULL,
	[float186] [float] SPARSE  NULL,
	[float187] [float] SPARSE  NULL,
	[float188] [float] SPARSE  NULL,
	[float189] [float] SPARSE  NULL,
	[float190] [float] SPARSE  NULL,
	[float191] [float] SPARSE  NULL,
	[float192] [float] SPARSE  NULL,
	[float193] [float] SPARSE  NULL,
	[float194] [float] SPARSE  NULL,
	[float195] [float] SPARSE  NULL,
	[float196] [float] SPARSE  NULL,
	[float197] [float] SPARSE  NULL,
	[float198] [float] SPARSE  NULL,
	[float199] [float] SPARSE  NULL,
	[float200] [float] SPARSE  NULL,
	[float201] [float] SPARSE  NULL,
	[float202] [float] SPARSE  NULL,
	[float203] [float] SPARSE  NULL,
	[float204] [float] SPARSE  NULL,
	[float205] [float] SPARSE  NULL,
	[float206] [float] SPARSE  NULL,
	[float207] [float] SPARSE  NULL,
	[float208] [float] SPARSE  NULL,
	[float209] [float] SPARSE  NULL,
	[float210] [float] SPARSE  NULL,
	[float211] [float] SPARSE  NULL,
	[float212] [float] SPARSE  NULL,
	[float213] [float] SPARSE  NULL,
	[float214] [float] SPARSE  NULL,
	[float215] [float] SPARSE  NULL,
	[float216] [float] SPARSE  NULL,
	[float217] [float] SPARSE  NULL,
	[float218] [float] SPARSE  NULL,
	[float219] [float] SPARSE  NULL,
	[float220] [float] SPARSE  NULL,
	[float221] [float] SPARSE  NULL,
	[float222] [float] SPARSE  NULL,
	[float223] [float] SPARSE  NULL,
	[float224] [float] SPARSE  NULL,
	[float225] [float] SPARSE  NULL,
	[float226] [float] SPARSE  NULL,
	[float227] [float] SPARSE  NULL,
	[float228] [float] SPARSE  NULL,
	[float229] [float] SPARSE  NULL,
	[float230] [float] SPARSE  NULL,
	[float231] [float] SPARSE  NULL,
	[float232] [float] SPARSE  NULL,
	[float233] [float] SPARSE  NULL,
	[float234] [float] SPARSE  NULL,
	[float235] [float] SPARSE  NULL,
	[float236] [float] SPARSE  NULL,
	[float237] [float] SPARSE  NULL,
	[float238] [float] SPARSE  NULL,
	[float239] [float] SPARSE  NULL,
	[float240] [float] SPARSE  NULL,
	[float241] [float] SPARSE  NULL,
	[float242] [float] SPARSE  NULL,
	[float243] [float] SPARSE  NULL,
	[float244] [float] SPARSE  NULL,
	[float245] [float] SPARSE  NULL,
	[float246] [float] SPARSE  NULL,
	[float247] [float] SPARSE  NULL,
	[float248] [float] SPARSE  NULL,
	[float249] [float] SPARSE  NULL,
	[float250] [float] SPARSE  NULL,
	[float251] [float] SPARSE  NULL,
	[float252] [float] SPARSE  NULL,
	[float253] [float] SPARSE  NULL,
	[float254] [float] SPARSE  NULL,
	[float255] [float] SPARSE  NULL,
	[float256] [float] SPARSE  NULL,
	[float257] [float] SPARSE  NULL,
	[float258] [float] SPARSE  NULL,
	[float259] [float] SPARSE  NULL,
	[float260] [float] SPARSE  NULL,
	[float261] [float] SPARSE  NULL,
	[float262] [float] SPARSE  NULL,
	[float263] [float] SPARSE  NULL,
	[float264] [float] SPARSE  NULL,
	[float265] [float] SPARSE  NULL,
	[float266] [float] SPARSE  NULL,
	[float267] [float] SPARSE  NULL,
	[float268] [float] SPARSE  NULL,
	[float269] [float] SPARSE  NULL,
	[float270] [float] SPARSE  NULL,
	[float271] [float] SPARSE  NULL,
	[float272] [float] SPARSE  NULL,
	[float273] [float] SPARSE  NULL,
	[float274] [float] SPARSE  NULL,
	[float275] [float] SPARSE  NULL,
	[float276] [float] SPARSE  NULL,
	[float277] [float] SPARSE  NULL,
	[float278] [float] SPARSE  NULL,
	[float279] [float] SPARSE  NULL,
	[float280] [float] SPARSE  NULL,
	[float281] [float] SPARSE  NULL,
	[float282] [float] SPARSE  NULL,
	[float283] [float] SPARSE  NULL,
	[float284] [float] SPARSE  NULL,
	[float285] [float] SPARSE  NULL,
	[float286] [float] SPARSE  NULL,
	[float287] [float] SPARSE  NULL,
	[float288] [float] SPARSE  NULL,
	[float289] [float] SPARSE  NULL,
	[float290] [float] SPARSE  NULL,
	[float291] [float] SPARSE  NULL,
	[float292] [float] SPARSE  NULL,
	[float293] [float] SPARSE  NULL,
	[float294] [float] SPARSE  NULL,
	[float295] [float] SPARSE  NULL,
	[float296] [float] SPARSE  NULL,
	[float297] [float] SPARSE  NULL,
	[float298] [float] SPARSE  NULL,
	[float299] [float] SPARSE  NULL,
	[float300] [float] SPARSE  NULL,
	[float301] [float] SPARSE  NULL,
	[float302] [float] SPARSE  NULL,
	[float303] [float] SPARSE  NULL,
	[float304] [float] SPARSE  NULL,
	[float305] [float] SPARSE  NULL,
	[float306] [float] SPARSE  NULL,
	[float307] [float] SPARSE  NULL,
	[float308] [float] SPARSE  NULL,
	[float309] [float] SPARSE  NULL,
	[float310] [float] SPARSE  NULL,
	[float311] [float] SPARSE  NULL,
	[float312] [float] SPARSE  NULL,
	[float313] [float] SPARSE  NULL,
	[float314] [float] SPARSE  NULL,
	[float315] [float] SPARSE  NULL,
	[float316] [float] SPARSE  NULL,
	[float317] [float] SPARSE  NULL,
	[float318] [float] SPARSE  NULL,
	[float319] [float] SPARSE  NULL,
	[float320] [float] SPARSE  NULL,
	[float321] [float] SPARSE  NULL,
	[float322] [float] SPARSE  NULL,
	[float323] [float] SPARSE  NULL,
	[float324] [float] SPARSE  NULL,
	[float325] [float] SPARSE  NULL,
	[float326] [float] SPARSE  NULL,
	[float327] [float] SPARSE  NULL,
	[float328] [float] SPARSE  NULL,
	[float329] [float] SPARSE  NULL,
	[float330] [float] SPARSE  NULL,
	[float331] [float] SPARSE  NULL,
	[float332] [float] SPARSE  NULL,
	[float333] [float] SPARSE  NULL,
	[float334] [float] SPARSE  NULL,
	[float335] [float] SPARSE  NULL,
	[float336] [float] SPARSE  NULL,
	[float337] [float] SPARSE  NULL,
	[float338] [float] SPARSE  NULL,
	[float339] [float] SPARSE  NULL,
	[float340] [float] SPARSE  NULL,
	[float341] [float] SPARSE  NULL,
	[float342] [float] SPARSE  NULL,
	[float343] [float] SPARSE  NULL,
	[float344] [float] SPARSE  NULL,
	[float345] [float] SPARSE  NULL,
	[float346] [float] SPARSE  NULL,
	[float347] [float] SPARSE  NULL,
	[float348] [float] SPARSE  NULL,
	[float349] [float] SPARSE  NULL,
	[float350] [float] SPARSE  NULL,
	[float351] [float] SPARSE  NULL,
	[float352] [float] SPARSE  NULL,
	[float353] [float] SPARSE  NULL,
	[float354] [float] SPARSE  NULL,
	[float355] [float] SPARSE  NULL,
	[float356] [float] SPARSE  NULL,
	[float357] [float] SPARSE  NULL,
	[float358] [float] SPARSE  NULL,
	[float359] [float] SPARSE  NULL,
	[float360] [float] SPARSE  NULL,
	[float361] [float] SPARSE  NULL,
	[float362] [float] SPARSE  NULL,
	[float363] [float] SPARSE  NULL,
	[float364] [float] SPARSE  NULL,
	[float365] [float] SPARSE  NULL,
	[float366] [float] SPARSE  NULL,
	[float367] [float] SPARSE  NULL,
	[float368] [float] SPARSE  NULL,
	[float369] [float] SPARSE  NULL,
	[float370] [float] SPARSE  NULL,
	[float371] [float] SPARSE  NULL,
	[float372] [float] SPARSE  NULL,
	[float373] [float] SPARSE  NULL,
	[float374] [float] SPARSE  NULL,
	[float375] [float] SPARSE  NULL,
	[float376] [float] SPARSE  NULL,
	[float377] [float] SPARSE  NULL,
	[float378] [float] SPARSE  NULL,
	[float379] [float] SPARSE  NULL,
	[float380] [float] SPARSE  NULL,
	[float381] [float] SPARSE  NULL,
	[float382] [float] SPARSE  NULL,
	[float383] [float] SPARSE  NULL,
	[float384] [float] SPARSE  NULL,
	[float385] [float] SPARSE  NULL,
	[float386] [float] SPARSE  NULL,
	[float387] [float] SPARSE  NULL,
	[float388] [float] SPARSE  NULL,
	[float389] [float] SPARSE  NULL,
	[float390] [float] SPARSE  NULL,
	[float391] [float] SPARSE  NULL,
	[float392] [float] SPARSE  NULL,
	[float393] [float] SPARSE  NULL,
	[float394] [float] SPARSE  NULL,
	[float395] [float] SPARSE  NULL,
	[float396] [float] SPARSE  NULL,
	[float397] [float] SPARSE  NULL,
	[float398] [float] SPARSE  NULL,
	[float399] [float] SPARSE  NULL,
	[float400] [float] SPARSE  NULL,
	[float401] [float] SPARSE  NULL,
	[float402] [float] SPARSE  NULL,
	[float403] [float] SPARSE  NULL,
	[float404] [float] SPARSE  NULL,
	[float405] [float] SPARSE  NULL,
	[float406] [float] SPARSE  NULL,
	[float407] [float] SPARSE  NULL,
	[float408] [float] SPARSE  NULL,
	[float409] [float] SPARSE  NULL,
	[float410] [float] SPARSE  NULL,
	[float411] [float] SPARSE  NULL,
	[float412] [float] SPARSE  NULL,
	[float413] [float] SPARSE  NULL,
	[float414] [float] SPARSE  NULL,
	[float415] [float] SPARSE  NULL,
	[float416] [float] SPARSE  NULL,
	[float417] [float] SPARSE  NULL,
	[float418] [float] SPARSE  NULL,
	[float419] [float] SPARSE  NULL,
	[float420] [float] SPARSE  NULL,
	[float421] [float] SPARSE  NULL,
	[float422] [float] SPARSE  NULL,
	[float423] [float] SPARSE  NULL,
	[float424] [float] SPARSE  NULL,
	[float425] [float] SPARSE  NULL,
	[float426] [float] SPARSE  NULL,
	[float427] [float] SPARSE  NULL,
	[float428] [float] SPARSE  NULL,
	[float429] [float] SPARSE  NULL,
	[float430] [float] SPARSE  NULL,
	[float431] [float] SPARSE  NULL,
	[float432] [float] SPARSE  NULL,
	[float433] [float] SPARSE  NULL,
	[float434] [float] SPARSE  NULL,
	[float435] [float] SPARSE  NULL,
	[float436] [float] SPARSE  NULL,
	[float437] [float] SPARSE  NULL,
	[float438] [float] SPARSE  NULL,
	[float439] [float] SPARSE  NULL,
	[float440] [float] SPARSE  NULL,
	[float441] [float] SPARSE  NULL,
	[float442] [float] SPARSE  NULL,
	[float443] [float] SPARSE  NULL,
	[float444] [float] SPARSE  NULL,
	[float445] [float] SPARSE  NULL,
	[float446] [float] SPARSE  NULL,
	[float447] [float] SPARSE  NULL,
	[float448] [float] SPARSE  NULL,
	[float449] [float] SPARSE  NULL,
	[float450] [float] SPARSE  NULL,
	[float451] [float] SPARSE  NULL,
	[float452] [float] SPARSE  NULL,
	[float453] [float] SPARSE  NULL,
	[float454] [float] SPARSE  NULL,
	[float455] [float] SPARSE  NULL,
	[float456] [float] SPARSE  NULL,
	[float457] [float] SPARSE  NULL,
	[float458] [float] SPARSE  NULL,
	[float459] [float] SPARSE  NULL,
	[float460] [float] SPARSE  NULL,
	[float461] [float] SPARSE  NULL,
	[float462] [float] SPARSE  NULL,
	[float463] [float] SPARSE  NULL,
	[float464] [float] SPARSE  NULL,
	[float465] [float] SPARSE  NULL,
	[float466] [float] SPARSE  NULL,
	[float467] [float] SPARSE  NULL,
	[float468] [float] SPARSE  NULL,
	[float469] [float] SPARSE  NULL,
	[float470] [float] SPARSE  NULL,
	[float471] [float] SPARSE  NULL,
	[float472] [float] SPARSE  NULL,
	[float473] [float] SPARSE  NULL,
	[float474] [float] SPARSE  NULL,
	[float475] [float] SPARSE  NULL,
	[float476] [float] SPARSE  NULL,
	[float477] [float] SPARSE  NULL,
	[float478] [float] SPARSE  NULL,
	[float479] [float] SPARSE  NULL,
	[float480] [float] SPARSE  NULL,
	[float481] [float] SPARSE  NULL,
	[float482] [float] SPARSE  NULL,
	[float483] [float] SPARSE  NULL,
	[float484] [float] SPARSE  NULL,
	[float485] [float] SPARSE  NULL,
	[float486] [float] SPARSE  NULL,
	[float487] [float] SPARSE  NULL,
	[float488] [float] SPARSE  NULL,
	[float489] [float] SPARSE  NULL,
	[float490] [float] SPARSE  NULL,
	[float491] [float] SPARSE  NULL,
	[float492] [float] SPARSE  NULL,
	[float493] [float] SPARSE  NULL,
	[float494] [float] SPARSE  NULL,
	[float495] [float] SPARSE  NULL,
	[float496] [float] SPARSE  NULL,
	[float497] [float] SPARSE  NULL,
	[float498] [float] SPARSE  NULL,
	[float499] [float] SPARSE  NULL,
	[float500] [float] SPARSE  NULL,
	[float501] [float] SPARSE  NULL,
	[float502] [float] SPARSE  NULL,
	[float503] [float] SPARSE  NULL,
	[float504] [float] SPARSE  NULL,
	[float505] [float] SPARSE  NULL,
	[float506] [float] SPARSE  NULL,
	[float507] [float] SPARSE  NULL,
	[float508] [float] SPARSE  NULL,
	[float509] [float] SPARSE  NULL,
	[float510] [float] SPARSE  NULL,
	[float511] [float] SPARSE  NULL,
	[float512] [float] SPARSE  NULL,
	[float513] [float] SPARSE  NULL,
	[float514] [float] SPARSE  NULL,
	[float515] [float] SPARSE  NULL,
	[float516] [float] SPARSE  NULL,
	[float517] [float] SPARSE  NULL,
	[float518] [float] SPARSE  NULL,
	[float519] [float] SPARSE  NULL,
	[float520] [float] SPARSE  NULL,
	[float521] [float] SPARSE  NULL,
	[float522] [float] SPARSE  NULL,
	[float523] [float] SPARSE  NULL,
	[float524] [float] SPARSE  NULL,
	[float525] [float] SPARSE  NULL,
	[float526] [float] SPARSE  NULL,
	[float527] [float] SPARSE  NULL,
	[float528] [float] SPARSE  NULL,
	[float529] [float] SPARSE  NULL,
	[float530] [float] SPARSE  NULL,
	[float531] [float] SPARSE  NULL,
	[float532] [float] SPARSE  NULL,
	[float533] [float] SPARSE  NULL,
	[float534] [float] SPARSE  NULL,
	[float535] [float] SPARSE  NULL,
	[float536] [float] SPARSE  NULL,
	[float537] [float] SPARSE  NULL,
	[float538] [float] SPARSE  NULL,
	[float539] [float] SPARSE  NULL,
	[float540] [float] SPARSE  NULL,
	[float541] [float] SPARSE  NULL,
	[float542] [float] SPARSE  NULL,
	[float543] [float] SPARSE  NULL,
	[float544] [float] SPARSE  NULL,
	[float545] [float] SPARSE  NULL,
	[float546] [float] SPARSE  NULL,
	[float547] [float] SPARSE  NULL,
	[float548] [float] SPARSE  NULL,
	[float549] [float] SPARSE  NULL,
	[float550] [float] SPARSE  NULL,
	[int1] [int] SPARSE  NULL,
	[int2] [int] SPARSE  NULL,
	[int3] [int] SPARSE  NULL,
	[int4] [int] SPARSE  NULL,
	[int5] [int] SPARSE  NULL,
	[int6] [int] SPARSE  NULL,
	[int7] [int] SPARSE  NULL,
	[int8] [int] SPARSE  NULL,
	[int9] [int] SPARSE  NULL,
	[int10] [int] SPARSE  NULL,
	[int11] [int] SPARSE  NULL,
	[int12] [int] SPARSE  NULL,
	[int13] [int] SPARSE  NULL,
	[int14] [int] SPARSE  NULL,
	[int15] [int] SPARSE  NULL,
	[int16] [int] SPARSE  NULL,
	[int17] [int] SPARSE  NULL,
	[int18] [int] SPARSE  NULL,
	[int19] [int] SPARSE  NULL,
	[int20] [int] SPARSE  NULL,
	[int21] [int] SPARSE  NULL,
	[int22] [int] SPARSE  NULL,
	[int23] [int] SPARSE  NULL,
	[int24] [int] SPARSE  NULL,
	[int25] [int] SPARSE  NULL,
	[int26] [int] SPARSE  NULL,
	[int27] [int] SPARSE  NULL,
	[int28] [int] SPARSE  NULL,
	[int29] [int] SPARSE  NULL,
	[int30] [int] SPARSE  NULL,
	[int31] [int] SPARSE  NULL,
	[int32] [int] SPARSE  NULL,
	[int33] [int] SPARSE  NULL,
	[int34] [int] SPARSE  NULL,
	[int35] [int] SPARSE  NULL,
	[int36] [int] SPARSE  NULL,
	[int37] [int] SPARSE  NULL,
	[int38] [int] SPARSE  NULL,
	[int39] [int] SPARSE  NULL,
	[int40] [int] SPARSE  NULL,
	[int41] [int] SPARSE  NULL,
	[int42] [int] SPARSE  NULL,
	[int43] [int] SPARSE  NULL,
	[int44] [int] SPARSE  NULL,
	[int45] [int] SPARSE  NULL,
	[int46] [int] SPARSE  NULL,
	[int47] [int] SPARSE  NULL,
	[int48] [int] SPARSE  NULL,
	[int49] [int] SPARSE  NULL,
	[int50] [int] SPARSE  NULL,
	[int51] [int] SPARSE  NULL,
	[int52] [int] SPARSE  NULL,
	[int53] [int] SPARSE  NULL,
	[int54] [int] SPARSE  NULL,
	[int55] [int] SPARSE  NULL,
	[int56] [int] SPARSE  NULL,
	[int57] [int] SPARSE  NULL,
	[int58] [int] SPARSE  NULL,
	[int59] [int] SPARSE  NULL,
	[int60] [int] SPARSE  NULL,
	[int61] [int] SPARSE  NULL,
	[int62] [int] SPARSE  NULL,
	[int63] [int] SPARSE  NULL,
	[int64] [int] SPARSE  NULL,
	[int65] [int] SPARSE  NULL,
	[int66] [int] SPARSE  NULL,
	[int67] [int] SPARSE  NULL,
	[int68] [int] SPARSE  NULL,
	[int69] [int] SPARSE  NULL,
	[int70] [int] SPARSE  NULL,
	[int71] [int] SPARSE  NULL,
	[int72] [int] SPARSE  NULL,
	[int73] [int] SPARSE  NULL,
	[int74] [int] SPARSE  NULL,
	[int75] [int] SPARSE  NULL,
	[int76] [int] SPARSE  NULL,
	[int77] [int] SPARSE  NULL,
	[int78] [int] SPARSE  NULL,
	[int79] [int] SPARSE  NULL,
	[int80] [int] SPARSE  NULL,
	[int81] [int] SPARSE  NULL,
	[int82] [int] SPARSE  NULL,
	[int83] [int] SPARSE  NULL,
	[int84] [int] SPARSE  NULL,
	[int85] [int] SPARSE  NULL,
	[int86] [int] SPARSE  NULL,
	[int87] [int] SPARSE  NULL,
	[int88] [int] SPARSE  NULL,
	[int89] [int] SPARSE  NULL,
	[int90] [int] SPARSE  NULL,
	[int91] [int] SPARSE  NULL,
	[int92] [int] SPARSE  NULL,
	[int93] [int] SPARSE  NULL,
	[int94] [int] SPARSE  NULL,
	[int95] [int] SPARSE  NULL,
	[int96] [int] SPARSE  NULL,
	[int97] [int] SPARSE  NULL,
	[int98] [int] SPARSE  NULL,
	[int99] [int] SPARSE  NULL,
	[int100] [int] SPARSE  NULL,
	[int101] [int] SPARSE  NULL,
	[int102] [int] SPARSE  NULL,
	[int103] [int] SPARSE  NULL,
	[int104] [int] SPARSE  NULL,
	[int105] [int] SPARSE  NULL,
	[int106] [int] SPARSE  NULL,
	[int107] [int] SPARSE  NULL,
	[int108] [int] SPARSE  NULL,
	[int109] [int] SPARSE  NULL,
	[int110] [int] SPARSE  NULL,
	[int111] [int] SPARSE  NULL,
	[int112] [int] SPARSE  NULL,
	[int113] [int] SPARSE  NULL,
	[int114] [int] SPARSE  NULL,
	[int115] [int] SPARSE  NULL,
	[int116] [int] SPARSE  NULL,
	[int117] [int] SPARSE  NULL,
	[int118] [int] SPARSE  NULL,
	[int119] [int] SPARSE  NULL,
	[int120] [int] SPARSE  NULL,
	[int121] [int] SPARSE  NULL,
	[int122] [int] SPARSE  NULL,
	[int123] [int] SPARSE  NULL,
	[int124] [int] SPARSE  NULL,
	[int125] [int] SPARSE  NULL,
	[int126] [int] SPARSE  NULL,
	[int127] [int] SPARSE  NULL,
	[int128] [int] SPARSE  NULL,
	[int129] [int] SPARSE  NULL,
	[int130] [int] SPARSE  NULL,
	[int131] [int] SPARSE  NULL,
	[int132] [int] SPARSE  NULL,
	[int133] [int] SPARSE  NULL,
	[int134] [int] SPARSE  NULL,
	[int135] [int] SPARSE  NULL,
	[int136] [int] SPARSE  NULL,
	[int137] [int] SPARSE  NULL,
	[int138] [int] SPARSE  NULL,
	[int139] [int] SPARSE  NULL,
	[int140] [int] SPARSE  NULL,
	[int141] [int] SPARSE  NULL,
	[int142] [int] SPARSE  NULL,
	[int143] [int] SPARSE  NULL,
	[int144] [int] SPARSE  NULL,
	[int145] [int] SPARSE  NULL,
	[int146] [int] SPARSE  NULL,
	[int147] [int] SPARSE  NULL,
	[int148] [int] SPARSE  NULL,
	[int149] [int] SPARSE  NULL,
	[int150] [int] SPARSE  NULL,
	[int151] [int] SPARSE  NULL,
	[int152] [int] SPARSE  NULL,
	[int153] [int] SPARSE  NULL,
	[int154] [int] SPARSE  NULL,
	[int155] [int] SPARSE  NULL,
	[int156] [int] SPARSE  NULL,
	[int157] [int] SPARSE  NULL,
	[int158] [int] SPARSE  NULL,
	[int159] [int] SPARSE  NULL,
	[int160] [int] SPARSE  NULL,
	[int161] [int] SPARSE  NULL,
	[int162] [int] SPARSE  NULL,
	[int163] [int] SPARSE  NULL,
	[int164] [int] SPARSE  NULL,
	[int165] [int] SPARSE  NULL,
	[int166] [int] SPARSE  NULL,
	[int167] [int] SPARSE  NULL,
	[int168] [int] SPARSE  NULL,
	[int169] [int] SPARSE  NULL,
	[int170] [int] SPARSE  NULL,
	[int171] [int] SPARSE  NULL,
	[int172] [int] SPARSE  NULL,
	[int173] [int] SPARSE  NULL,
	[int174] [int] SPARSE  NULL,
	[int175] [int] SPARSE  NULL,
	[int176] [int] SPARSE  NULL,
	[int177] [int] SPARSE  NULL,
	[int178] [int] SPARSE  NULL,
	[int179] [int] SPARSE  NULL,
	[int180] [int] SPARSE  NULL,
	[int181] [int] SPARSE  NULL,
	[int182] [int] SPARSE  NULL,
	[int183] [int] SPARSE  NULL,
	[int184] [int] SPARSE  NULL,
	[int185] [int] SPARSE  NULL,
	[int186] [int] SPARSE  NULL,
	[int187] [int] SPARSE  NULL,
	[int188] [int] SPARSE  NULL,
	[int189] [int] SPARSE  NULL,
	[int190] [int] SPARSE  NULL,
	[int191] [int] SPARSE  NULL,
	[int192] [int] SPARSE  NULL,
	[int193] [int] SPARSE  NULL,
	[int194] [int] SPARSE  NULL,
	[int195] [int] SPARSE  NULL,
	[int196] [int] SPARSE  NULL,
	[int197] [int] SPARSE  NULL,
	[int198] [int] SPARSE  NULL,
	[int199] [int] SPARSE  NULL,
	[int200] [int] SPARSE  NULL,
	[int201] [int] SPARSE  NULL,
	[int202] [int] SPARSE  NULL,
	[int203] [int] SPARSE  NULL,
	[int204] [int] SPARSE  NULL,
	[int205] [int] SPARSE  NULL,
	[int206] [int] SPARSE  NULL,
	[int207] [int] SPARSE  NULL,
	[int208] [int] SPARSE  NULL,
	[int209] [int] SPARSE  NULL,
	[int210] [int] SPARSE  NULL,
	[int211] [int] SPARSE  NULL,
	[int212] [int] SPARSE  NULL,
	[int213] [int] SPARSE  NULL,
	[int214] [int] SPARSE  NULL,
	[int215] [int] SPARSE  NULL,
	[int216] [int] SPARSE  NULL,
	[int217] [int] SPARSE  NULL,
	[int218] [int] SPARSE  NULL,
	[int219] [int] SPARSE  NULL,
	[int220] [int] SPARSE  NULL,
	[int221] [int] SPARSE  NULL,
	[int222] [int] SPARSE  NULL,
	[int223] [int] SPARSE  NULL,
	[int224] [int] SPARSE  NULL,
	[int225] [int] SPARSE  NULL,
	[int226] [int] SPARSE  NULL,
	[int227] [int] SPARSE  NULL,
	[int228] [int] SPARSE  NULL,
	[int229] [int] SPARSE  NULL,
	[int230] [int] SPARSE  NULL,
	[int231] [int] SPARSE  NULL,
	[int232] [int] SPARSE  NULL,
	[int233] [int] SPARSE  NULL,
	[int234] [int] SPARSE  NULL,
	[int235] [int] SPARSE  NULL,
	[int236] [int] SPARSE  NULL,
	[int237] [int] SPARSE  NULL,
	[int238] [int] SPARSE  NULL,
	[int239] [int] SPARSE  NULL,
	[int240] [int] SPARSE  NULL,
	[int241] [int] SPARSE  NULL,
	[int242] [int] SPARSE  NULL,
	[int243] [int] SPARSE  NULL,
	[int244] [int] SPARSE  NULL,
	[int245] [int] SPARSE  NULL,
	[int246] [int] SPARSE  NULL,
	[int247] [int] SPARSE  NULL,
	[int248] [int] SPARSE  NULL,
	[int249] [int] SPARSE  NULL,
	[int250] [int] SPARSE  NULL,
	[int251] [int] SPARSE  NULL,
	[int252] [int] SPARSE  NULL,
	[int253] [int] SPARSE  NULL,
	[int254] [int] SPARSE  NULL,
	[int255] [int] SPARSE  NULL,
	[int256] [int] SPARSE  NULL,
	[int257] [int] SPARSE  NULL,
	[int258] [int] SPARSE  NULL,
	[int259] [int] SPARSE  NULL,
	[int260] [int] SPARSE  NULL,
	[int261] [int] SPARSE  NULL,
	[int262] [int] SPARSE  NULL,
	[int263] [int] SPARSE  NULL,
	[int264] [int] SPARSE  NULL,
	[int265] [int] SPARSE  NULL,
	[int266] [int] SPARSE  NULL,
	[int267] [int] SPARSE  NULL,
	[int268] [int] SPARSE  NULL,
	[int269] [int] SPARSE  NULL,
	[int270] [int] SPARSE  NULL,
	[int271] [int] SPARSE  NULL,
	[int272] [int] SPARSE  NULL,
	[int273] [int] SPARSE  NULL,
	[int274] [int] SPARSE  NULL,
	[int275] [int] SPARSE  NULL,
	[int276] [int] SPARSE  NULL,
	[int277] [int] SPARSE  NULL,
	[int278] [int] SPARSE  NULL,
	[int279] [int] SPARSE  NULL,
	[int280] [int] SPARSE  NULL,
	[int281] [int] SPARSE  NULL,
	[int282] [int] SPARSE  NULL,
	[int283] [int] SPARSE  NULL,
	[int284] [int] SPARSE  NULL,
	[int285] [int] SPARSE  NULL,
	[int286] [int] SPARSE  NULL,
	[int287] [int] SPARSE  NULL,
	[int288] [int] SPARSE  NULL,
	[int289] [int] SPARSE  NULL,
	[int290] [int] SPARSE  NULL,
	[int291] [int] SPARSE  NULL,
	[int292] [int] SPARSE  NULL,
	[int293] [int] SPARSE  NULL,
	[int294] [int] SPARSE  NULL,
	[int295] [int] SPARSE  NULL,
	[int296] [int] SPARSE  NULL,
	[int297] [int] SPARSE  NULL,
	[int298] [int] SPARSE  NULL,
	[int299] [int] SPARSE  NULL,
	[int300] [int] SPARSE  NULL,
	[int301] [int] SPARSE  NULL,
	[int302] [int] SPARSE  NULL,
	[int303] [int] SPARSE  NULL,
	[int304] [int] SPARSE  NULL,
	[int305] [int] SPARSE  NULL,
	[int306] [int] SPARSE  NULL,
	[int307] [int] SPARSE  NULL,
	[int308] [int] SPARSE  NULL,
	[int309] [int] SPARSE  NULL,
	[int310] [int] SPARSE  NULL,
	[int311] [int] SPARSE  NULL,
	[int312] [int] SPARSE  NULL,
	[int313] [int] SPARSE  NULL,
	[int314] [int] SPARSE  NULL,
	[int315] [int] SPARSE  NULL,
	[int316] [int] SPARSE  NULL,
	[int317] [int] SPARSE  NULL,
	[int318] [int] SPARSE  NULL,
	[int319] [int] SPARSE  NULL,
	[int320] [int] SPARSE  NULL,
	[int321] [int] SPARSE  NULL,
	[int322] [int] SPARSE  NULL,
	[int323] [int] SPARSE  NULL,
	[int324] [int] SPARSE  NULL,
	[int325] [int] SPARSE  NULL,
	[int326] [int] SPARSE  NULL,
	[int327] [int] SPARSE  NULL,
	[int328] [int] SPARSE  NULL,
	[int329] [int] SPARSE  NULL,
	[int330] [int] SPARSE  NULL,
	[int331] [int] SPARSE  NULL,
	[int332] [int] SPARSE  NULL,
	[int333] [int] SPARSE  NULL,
	[int334] [int] SPARSE  NULL,
	[int335] [int] SPARSE  NULL,
	[int336] [int] SPARSE  NULL,
	[int337] [int] SPARSE  NULL,
	[int338] [int] SPARSE  NULL,
	[int339] [int] SPARSE  NULL,
	[int340] [int] SPARSE  NULL,
	[int341] [int] SPARSE  NULL,
	[int342] [int] SPARSE  NULL,
	[int343] [int] SPARSE  NULL,
	[int344] [int] SPARSE  NULL,
	[int345] [int] SPARSE  NULL,
	[int346] [int] SPARSE  NULL,
	[int347] [int] SPARSE  NULL,
	[int348] [int] SPARSE  NULL,
	[int349] [int] SPARSE  NULL,
	[int350] [int] SPARSE  NULL,
	[int351] [int] SPARSE  NULL,
	[int352] [int] SPARSE  NULL,
	[int353] [int] SPARSE  NULL,
	[int354] [int] SPARSE  NULL,
	[int355] [int] SPARSE  NULL,
	[int356] [int] SPARSE  NULL,
	[int357] [int] SPARSE  NULL,
	[int358] [int] SPARSE  NULL,
	[int359] [int] SPARSE  NULL,
	[int360] [int] SPARSE  NULL,
	[int361] [int] SPARSE  NULL,
	[int362] [int] SPARSE  NULL,
	[int363] [int] SPARSE  NULL,
	[int364] [int] SPARSE  NULL,
	[int365] [int] SPARSE  NULL,
	[int366] [int] SPARSE  NULL,
	[int367] [int] SPARSE  NULL,
	[int368] [int] SPARSE  NULL,
	[int369] [int] SPARSE  NULL,
	[int370] [int] SPARSE  NULL,
	[int371] [int] SPARSE  NULL,
	[int372] [int] SPARSE  NULL,
	[int373] [int] SPARSE  NULL,
	[int374] [int] SPARSE  NULL,
	[int375] [int] SPARSE  NULL,
	[int376] [int] SPARSE  NULL,
	[int377] [int] SPARSE  NULL,
	[int378] [int] SPARSE  NULL,
	[int379] [int] SPARSE  NULL,
	[int380] [int] SPARSE  NULL,
	[int381] [int] SPARSE  NULL,
	[int382] [int] SPARSE  NULL,
	[int383] [int] SPARSE  NULL,
	[int384] [int] SPARSE  NULL,
	[int385] [int] SPARSE  NULL,
	[int386] [int] SPARSE  NULL,
	[int387] [int] SPARSE  NULL,
	[int388] [int] SPARSE  NULL,
	[int389] [int] SPARSE  NULL,
	[int390] [int] SPARSE  NULL,
	[int391] [int] SPARSE  NULL,
	[int392] [int] SPARSE  NULL,
	[int393] [int] SPARSE  NULL,
	[int394] [int] SPARSE  NULL,
	[int395] [int] SPARSE  NULL,
	[int396] [int] SPARSE  NULL,
	[int397] [int] SPARSE  NULL,
	[int398] [int] SPARSE  NULL,
	[int399] [int] SPARSE  NULL,
	[int400] [int] SPARSE  NULL,
	[int401] [int] SPARSE  NULL,
	[int402] [int] SPARSE  NULL,
	[int403] [int] SPARSE  NULL,
	[int404] [int] SPARSE  NULL,
	[int405] [int] SPARSE  NULL,
	[int406] [int] SPARSE  NULL,
	[int407] [int] SPARSE  NULL,
	[int408] [int] SPARSE  NULL,
	[int409] [int] SPARSE  NULL,
	[int410] [int] SPARSE  NULL,
	[int411] [int] SPARSE  NULL,
	[int412] [int] SPARSE  NULL,
	[int413] [int] SPARSE  NULL,
	[int414] [int] SPARSE  NULL,
	[int415] [int] SPARSE  NULL,
	[int416] [int] SPARSE  NULL,
	[int417] [int] SPARSE  NULL,
	[int418] [int] SPARSE  NULL,
	[int419] [int] SPARSE  NULL,
	[int420] [int] SPARSE  NULL,
	[int421] [int] SPARSE  NULL,
	[int422] [int] SPARSE  NULL,
	[int423] [int] SPARSE  NULL,
	[int424] [int] SPARSE  NULL,
	[int425] [int] SPARSE  NULL,
	[int426] [int] SPARSE  NULL,
	[int427] [int] SPARSE  NULL,
	[int428] [int] SPARSE  NULL,
	[int429] [int] SPARSE  NULL,
	[int430] [int] SPARSE  NULL,
	[int431] [int] SPARSE  NULL,
	[int432] [int] SPARSE  NULL,
	[int433] [int] SPARSE  NULL,
	[int434] [int] SPARSE  NULL,
	[int435] [int] SPARSE  NULL,
	[int436] [int] SPARSE  NULL,
	[int437] [int] SPARSE  NULL,
	[int438] [int] SPARSE  NULL,
	[int439] [int] SPARSE  NULL,
	[int440] [int] SPARSE  NULL,
	[int441] [int] SPARSE  NULL,
	[int442] [int] SPARSE  NULL,
	[int443] [int] SPARSE  NULL,
	[int444] [int] SPARSE  NULL,
	[int445] [int] SPARSE  NULL,
	[int446] [int] SPARSE  NULL,
	[int447] [int] SPARSE  NULL,
	[int448] [int] SPARSE  NULL,
	[int449] [int] SPARSE  NULL,
	[int450] [int] SPARSE  NULL,
	[int451] [int] SPARSE  NULL,
	[int452] [int] SPARSE  NULL,
	[int453] [int] SPARSE  NULL,
	[int454] [int] SPARSE  NULL,
	[int455] [int] SPARSE  NULL,
	[int456] [int] SPARSE  NULL,
	[int457] [int] SPARSE  NULL,
	[int458] [int] SPARSE  NULL,
	[int459] [int] SPARSE  NULL,
	[int460] [int] SPARSE  NULL,
	[int461] [int] SPARSE  NULL,
	[int462] [int] SPARSE  NULL,
	[int463] [int] SPARSE  NULL,
	[int464] [int] SPARSE  NULL,
	[int465] [int] SPARSE  NULL,
	[int466] [int] SPARSE  NULL,
	[int467] [int] SPARSE  NULL,
	[int468] [int] SPARSE  NULL,
	[int469] [int] SPARSE  NULL,
	[int470] [int] SPARSE  NULL,
	[int471] [int] SPARSE  NULL,
	[int472] [int] SPARSE  NULL,
	[int473] [int] SPARSE  NULL,
	[int474] [int] SPARSE  NULL,
	[int475] [int] SPARSE  NULL,
	[int476] [int] SPARSE  NULL,
	[int477] [int] SPARSE  NULL,
	[int478] [int] SPARSE  NULL,
	[int479] [int] SPARSE  NULL,
	[int480] [int] SPARSE  NULL,
	[int481] [int] SPARSE  NULL,
	[int482] [int] SPARSE  NULL,
	[int483] [int] SPARSE  NULL,
	[int484] [int] SPARSE  NULL,
	[int485] [int] SPARSE  NULL,
	[int486] [int] SPARSE  NULL,
	[int487] [int] SPARSE  NULL,
	[int488] [int] SPARSE  NULL,
	[int489] [int] SPARSE  NULL,
	[int490] [int] SPARSE  NULL,
	[int491] [int] SPARSE  NULL,
	[int492] [int] SPARSE  NULL,
	[int493] [int] SPARSE  NULL,
	[int494] [int] SPARSE  NULL,
	[int495] [int] SPARSE  NULL,
	[int496] [int] SPARSE  NULL,
	[int497] [int] SPARSE  NULL,
	[int498] [int] SPARSE  NULL,
	[int499] [int] SPARSE  NULL,
	[int500] [int] SPARSE  NULL,
	[int501] [int] SPARSE  NULL,
	[int502] [int] SPARSE  NULL,
	[int503] [int] SPARSE  NULL,
	[int504] [int] SPARSE  NULL,
	[int505] [int] SPARSE  NULL,
	[int506] [int] SPARSE  NULL,
	[int507] [int] SPARSE  NULL,
	[int508] [int] SPARSE  NULL,
	[int509] [int] SPARSE  NULL,
	[int510] [int] SPARSE  NULL,
	[int511] [int] SPARSE  NULL,
	[int512] [int] SPARSE  NULL,
	[int513] [int] SPARSE  NULL,
	[int514] [int] SPARSE  NULL,
	[int515] [int] SPARSE  NULL,
	[int516] [int] SPARSE  NULL,
	[int517] [int] SPARSE  NULL,
	[int518] [int] SPARSE  NULL,
	[int519] [int] SPARSE  NULL,
	[int520] [int] SPARSE  NULL,
	[int521] [int] SPARSE  NULL,
	[int522] [int] SPARSE  NULL,
	[int523] [int] SPARSE  NULL,
	[int524] [int] SPARSE  NULL,
	[int525] [int] SPARSE  NULL,
	[int526] [int] SPARSE  NULL,
	[int527] [int] SPARSE  NULL,
	[int528] [int] SPARSE  NULL,
	[int529] [int] SPARSE  NULL,
	[int530] [int] SPARSE  NULL,
	[int531] [int] SPARSE  NULL,
	[int532] [int] SPARSE  NULL,
	[int533] [int] SPARSE  NULL,
	[int534] [int] SPARSE  NULL,
	[int535] [int] SPARSE  NULL,
	[int536] [int] SPARSE  NULL,
	[int537] [int] SPARSE  NULL,
	[int538] [int] SPARSE  NULL,
	[int539] [int] SPARSE  NULL,
	[int540] [int] SPARSE  NULL,
	[int541] [int] SPARSE  NULL,
	[int542] [int] SPARSE  NULL,
	[int543] [int] SPARSE  NULL,
	[int544] [int] SPARSE  NULL,
	[int545] [int] SPARSE  NULL,
	[int546] [int] SPARSE  NULL,
	[int547] [int] SPARSE  NULL,
	[int548] [int] SPARSE  NULL,
	[int549] [int] SPARSE  NULL,
	[int550] [int] SPARSE  NULL,
	[int551] [int] SPARSE  NULL,
	[int552] [int] SPARSE  NULL,
	[int553] [int] SPARSE  NULL,
	[int554] [int] SPARSE  NULL,
	[int555] [int] SPARSE  NULL,
	[int556] [int] SPARSE  NULL,
	[int557] [int] SPARSE  NULL,
	[int558] [int] SPARSE  NULL,
	[int559] [int] SPARSE  NULL,
	[int560] [int] SPARSE  NULL,
	[int561] [int] SPARSE  NULL,
	[int562] [int] SPARSE  NULL,
	[int563] [int] SPARSE  NULL,
	[int564] [int] SPARSE  NULL,
	[int565] [int] SPARSE  NULL,
	[int566] [int] SPARSE  NULL,
	[int567] [int] SPARSE  NULL,
	[int568] [int] SPARSE  NULL,
	[int569] [int] SPARSE  NULL,
	[int570] [int] SPARSE  NULL,
	[int571] [int] SPARSE  NULL,
	[int572] [int] SPARSE  NULL,
	[int573] [int] SPARSE  NULL,
	[int574] [int] SPARSE  NULL,
	[int575] [int] SPARSE  NULL,
	[int576] [int] SPARSE  NULL,
	[int577] [int] SPARSE  NULL,
	[int578] [int] SPARSE  NULL,
	[int579] [int] SPARSE  NULL,
	[int580] [int] SPARSE  NULL,
	[int581] [int] SPARSE  NULL,
	[int582] [int] SPARSE  NULL,
	[int583] [int] SPARSE  NULL,
	[int584] [int] SPARSE  NULL,
	[int585] [int] SPARSE  NULL,
	[int586] [int] SPARSE  NULL,
	[int587] [int] SPARSE  NULL,
	[int588] [int] SPARSE  NULL,
	[int589] [int] SPARSE  NULL,
	[int590] [int] SPARSE  NULL,
	[int591] [int] SPARSE  NULL,
	[int592] [int] SPARSE  NULL,
	[int593] [int] SPARSE  NULL,
	[int594] [int] SPARSE  NULL,
	[int595] [int] SPARSE  NULL,
	[int596] [int] SPARSE  NULL,
	[int597] [int] SPARSE  NULL,
	[int598] [int] SPARSE  NULL,
	[int599] [int] SPARSE  NULL,
	[int600] [int] SPARSE  NULL,
	[int601] [int] SPARSE  NULL,
	[int602] [int] SPARSE  NULL,
	[int603] [int] SPARSE  NULL,
	[int604] [int] SPARSE  NULL,
	[int605] [int] SPARSE  NULL,
	[int606] [int] SPARSE  NULL,
	[int607] [int] SPARSE  NULL,
	[int608] [int] SPARSE  NULL,
	[int609] [int] SPARSE  NULL,
	[int610] [int] SPARSE  NULL,
	[int611] [int] SPARSE  NULL,
	[int612] [int] SPARSE  NULL,
	[int613] [int] SPARSE  NULL,
	[int614] [int] SPARSE  NULL,
	[int615] [int] SPARSE  NULL,
	[int616] [int] SPARSE  NULL,
	[int617] [int] SPARSE  NULL,
	[int618] [int] SPARSE  NULL,
	[int619] [int] SPARSE  NULL,
	[int620] [int] SPARSE  NULL,
	[int621] [int] SPARSE  NULL,
	[int622] [int] SPARSE  NULL,
	[int623] [int] SPARSE  NULL,
	[int624] [int] SPARSE  NULL,
	[int625] [int] SPARSE  NULL,
	[int626] [int] SPARSE  NULL,
	[int627] [int] SPARSE  NULL,
	[int628] [int] SPARSE  NULL,
	[int629] [int] SPARSE  NULL,
	[int630] [int] SPARSE  NULL,
	[int631] [int] SPARSE  NULL,
	[int632] [int] SPARSE  NULL,
	[int633] [int] SPARSE  NULL,
	[int634] [int] SPARSE  NULL,
	[int635] [int] SPARSE  NULL,
	[int636] [int] SPARSE  NULL,
	[int637] [int] SPARSE  NULL,
	[int638] [int] SPARSE  NULL,
	[int639] [int] SPARSE  NULL,
	[int640] [int] SPARSE  NULL,
	[int641] [int] SPARSE  NULL,
	[int642] [int] SPARSE  NULL,
	[int643] [int] SPARSE  NULL,
	[int644] [int] SPARSE  NULL,
	[int645] [int] SPARSE  NULL,
	[int646] [int] SPARSE  NULL,
	[int647] [int] SPARSE  NULL,
	[int648] [int] SPARSE  NULL,
	[int649] [int] SPARSE  NULL,
	[int650] [int] SPARSE  NULL,
	[int651] [int] SPARSE  NULL,
	[int652] [int] SPARSE  NULL,
	[int653] [int] SPARSE  NULL,
	[int654] [int] SPARSE  NULL,
	[int655] [int] SPARSE  NULL,
	[int656] [int] SPARSE  NULL,
	[int657] [int] SPARSE  NULL,
	[int658] [int] SPARSE  NULL,
	[int659] [int] SPARSE  NULL,
	[int660] [int] SPARSE  NULL,
	[int661] [int] SPARSE  NULL,
	[int662] [int] SPARSE  NULL,
	[int663] [int] SPARSE  NULL,
	[int664] [int] SPARSE  NULL,
	[int665] [int] SPARSE  NULL,
	[int666] [int] SPARSE  NULL,
	[int667] [int] SPARSE  NULL,
	[int668] [int] SPARSE  NULL,
	[int669] [int] SPARSE  NULL,
	[int670] [int] SPARSE  NULL,
	[int671] [int] SPARSE  NULL,
	[int672] [int] SPARSE  NULL,
	[int673] [int] SPARSE  NULL,
	[int674] [int] SPARSE  NULL,
	[int675] [int] SPARSE  NULL,
	[int676] [int] SPARSE  NULL,
	[int677] [int] SPARSE  NULL,
	[int678] [int] SPARSE  NULL,
	[int679] [int] SPARSE  NULL,
	[int680] [int] SPARSE  NULL,
	[int681] [int] SPARSE  NULL,
	[int682] [int] SPARSE  NULL,
	[int683] [int] SPARSE  NULL,
	[int684] [int] SPARSE  NULL,
	[int685] [int] SPARSE  NULL,
	[int686] [int] SPARSE  NULL,
	[int687] [int] SPARSE  NULL,
	[int688] [int] SPARSE  NULL,
	[int689] [int] SPARSE  NULL,
	[int690] [int] SPARSE  NULL,
	[int691] [int] SPARSE  NULL,
	[int692] [int] SPARSE  NULL,
	[int693] [int] SPARSE  NULL,
	[int694] [int] SPARSE  NULL,
	[int695] [int] SPARSE  NULL,
	[int696] [int] SPARSE  NULL,
	[int697] [int] SPARSE  NULL,
	[int698] [int] SPARSE  NULL,
	[int699] [int] SPARSE  NULL,
	[int700] [int] SPARSE  NULL,
	[int701] [int] SPARSE  NULL,
	[int702] [int] SPARSE  NULL,
	[int703] [int] SPARSE  NULL,
	[int704] [int] SPARSE  NULL,
	[int705] [int] SPARSE  NULL,
	[int706] [int] SPARSE  NULL,
	[int707] [int] SPARSE  NULL,
	[int708] [int] SPARSE  NULL,
	[int709] [int] SPARSE  NULL,
	[int710] [int] SPARSE  NULL,
	[int711] [int] SPARSE  NULL,
	[int712] [int] SPARSE  NULL,
	[int713] [int] SPARSE  NULL,
	[int714] [int] SPARSE  NULL,
	[int715] [int] SPARSE  NULL,
	[int716] [int] SPARSE  NULL,
	[int717] [int] SPARSE  NULL,
	[int718] [int] SPARSE  NULL,
	[int719] [int] SPARSE  NULL,
	[int720] [int] SPARSE  NULL,
	[int721] [int] SPARSE  NULL,
	[int722] [int] SPARSE  NULL,
	[int723] [int] SPARSE  NULL,
	[int724] [int] SPARSE  NULL,
	[int725] [int] SPARSE  NULL,
	[int726] [int] SPARSE  NULL,
	[int727] [int] SPARSE  NULL,
	[int728] [int] SPARSE  NULL,
	[int729] [int] SPARSE  NULL,
	[int730] [int] SPARSE  NULL,
	[int731] [int] SPARSE  NULL,
	[int732] [int] SPARSE  NULL,
	[int733] [int] SPARSE  NULL,
	[int734] [int] SPARSE  NULL,
	[int735] [int] SPARSE  NULL,
	[int736] [int] SPARSE  NULL,
	[int737] [int] SPARSE  NULL,
	[int738] [int] SPARSE  NULL,
	[int739] [int] SPARSE  NULL,
	[int740] [int] SPARSE  NULL,
	[int741] [int] SPARSE  NULL,
	[int742] [int] SPARSE  NULL,
	[int743] [int] SPARSE  NULL,
	[int744] [int] SPARSE  NULL,
	[int745] [int] SPARSE  NULL,
	[int746] [int] SPARSE  NULL,
	[int747] [int] SPARSE  NULL,
	[int748] [int] SPARSE  NULL,
	[int749] [int] SPARSE  NULL,
	[int750] [int] SPARSE  NULL,
	[ntext1] [nvarchar](max) SPARSE  NULL,
	[ntext2] [nvarchar](max) SPARSE  NULL,
	[ntext3] [nvarchar](max) SPARSE  NULL,
	[ntext4] [nvarchar](max) SPARSE  NULL,
	[ntext5] [nvarchar](max) SPARSE  NULL,
	[ntext6] [nvarchar](max) SPARSE  NULL,
	[ntext7] [nvarchar](max) SPARSE  NULL,
	[ntext8] [nvarchar](max) SPARSE  NULL,
	[ntext9] [nvarchar](max) SPARSE  NULL,
	[ntext10] [nvarchar](max) SPARSE  NULL,
	[ntext11] [nvarchar](max) SPARSE  NULL,
	[ntext12] [nvarchar](max) SPARSE  NULL,
	[ntext13] [nvarchar](max) SPARSE  NULL,
	[ntext14] [nvarchar](max) SPARSE  NULL,
	[ntext15] [nvarchar](max) SPARSE  NULL,
	[ntext16] [nvarchar](max) SPARSE  NULL,
	[ntext17] [nvarchar](max) SPARSE  NULL,
	[ntext18] [nvarchar](max) SPARSE  NULL,
	[ntext19] [nvarchar](max) SPARSE  NULL,
	[ntext20] [nvarchar](max) SPARSE  NULL,
	[ntext21] [nvarchar](max) SPARSE  NULL,
	[ntext22] [nvarchar](max) SPARSE  NULL,
	[ntext23] [nvarchar](max) SPARSE  NULL,
	[ntext24] [nvarchar](max) SPARSE  NULL,
	[ntext25] [nvarchar](max) SPARSE  NULL,
	[ntext26] [nvarchar](max) SPARSE  NULL,
	[ntext27] [nvarchar](max) SPARSE  NULL,
	[ntext28] [nvarchar](max) SPARSE  NULL,
	[ntext29] [nvarchar](max) SPARSE  NULL,
	[ntext30] [nvarchar](max) SPARSE  NULL,
	[ntext31] [nvarchar](max) SPARSE  NULL,
	[ntext32] [nvarchar](max) SPARSE  NULL,
	[ntext33] [nvarchar](max) SPARSE  NULL,
	[ntext34] [nvarchar](max) SPARSE  NULL,
	[ntext35] [nvarchar](max) SPARSE  NULL,
	[ntext36] [nvarchar](max) SPARSE  NULL,
	[ntext37] [nvarchar](max) SPARSE  NULL,
	[ntext38] [nvarchar](max) SPARSE  NULL,
	[ntext39] [nvarchar](max) SPARSE  NULL,
	[ntext40] [nvarchar](max) SPARSE  NULL,
	[ntext41] [nvarchar](max) SPARSE  NULL,
	[ntext42] [nvarchar](max) SPARSE  NULL,
	[ntext43] [nvarchar](max) SPARSE  NULL,
	[ntext44] [nvarchar](max) SPARSE  NULL,
	[ntext45] [nvarchar](max) SPARSE  NULL,
	[ntext46] [nvarchar](max) SPARSE  NULL,
	[ntext47] [nvarchar](max) SPARSE  NULL,
	[ntext48] [nvarchar](max) SPARSE  NULL,
	[ntext49] [nvarchar](max) SPARSE  NULL,
	[ntext50] [nvarchar](max) SPARSE  NULL,
	[ntext51] [nvarchar](max) SPARSE  NULL,
	[ntext52] [nvarchar](max) SPARSE  NULL,
	[ntext53] [nvarchar](max) SPARSE  NULL,
	[ntext54] [nvarchar](max) SPARSE  NULL,
	[ntext55] [nvarchar](max) SPARSE  NULL,
	[ntext56] [nvarchar](max) SPARSE  NULL,
	[ntext57] [nvarchar](max) SPARSE  NULL,
	[ntext58] [nvarchar](max) SPARSE  NULL,
	[ntext59] [nvarchar](max) SPARSE  NULL,
	[ntext60] [nvarchar](max) SPARSE  NULL,
	[ntext61] [nvarchar](max) SPARSE  NULL,
	[ntext62] [nvarchar](max) SPARSE  NULL,
	[ntext63] [nvarchar](max) SPARSE  NULL,
	[ntext64] [nvarchar](max) SPARSE  NULL,
	[ntext65] [nvarchar](max) SPARSE  NULL,
	[ntext66] [nvarchar](max) SPARSE  NULL,
	[ntext67] [nvarchar](max) SPARSE  NULL,
	[ntext68] [nvarchar](max) SPARSE  NULL,
	[ntext69] [nvarchar](max) SPARSE  NULL,
	[ntext70] [nvarchar](max) SPARSE  NULL,
	[ntext71] [nvarchar](max) SPARSE  NULL,
	[ntext72] [nvarchar](max) SPARSE  NULL,
	[ntext73] [nvarchar](max) SPARSE  NULL,
	[ntext74] [nvarchar](max) SPARSE  NULL,
	[ntext75] [nvarchar](max) SPARSE  NULL,
	[ntext76] [nvarchar](max) SPARSE  NULL,
	[ntext77] [nvarchar](max) SPARSE  NULL,
	[ntext78] [nvarchar](max) SPARSE  NULL,
	[ntext79] [nvarchar](max) SPARSE  NULL,
	[ntext80] [nvarchar](max) SPARSE  NULL,
	[ntext81] [nvarchar](max) SPARSE  NULL,
	[ntext82] [nvarchar](max) SPARSE  NULL,
	[ntext83] [nvarchar](max) SPARSE  NULL,
	[ntext84] [nvarchar](max) SPARSE  NULL,
	[ntext85] [nvarchar](max) SPARSE  NULL,
	[ntext86] [nvarchar](max) SPARSE  NULL,
	[ntext87] [nvarchar](max) SPARSE  NULL,
	[ntext88] [nvarchar](max) SPARSE  NULL,
	[ntext89] [nvarchar](max) SPARSE  NULL,
	[ntext90] [nvarchar](max) SPARSE  NULL,
	[ntext91] [nvarchar](max) SPARSE  NULL,
	[ntext92] [nvarchar](max) SPARSE  NULL,
	[ntext93] [nvarchar](max) SPARSE  NULL,
	[ntext94] [nvarchar](max) SPARSE  NULL,
	[ntext95] [nvarchar](max) SPARSE  NULL,
	[ntext96] [nvarchar](max) SPARSE  NULL,
	[ntext97] [nvarchar](max) SPARSE  NULL,
	[ntext98] [nvarchar](max) SPARSE  NULL,
	[ntext99] [nvarchar](max) SPARSE  NULL,
	[ntext100] [nvarchar](max) SPARSE  NULL,
	[ntext101] [nvarchar](max) SPARSE  NULL,
	[ntext102] [nvarchar](max) SPARSE  NULL,
	[ntext103] [nvarchar](max) SPARSE  NULL,
	[ntext104] [nvarchar](max) SPARSE  NULL,
	[ntext105] [nvarchar](max) SPARSE  NULL,
	[ntext106] [nvarchar](max) SPARSE  NULL,
	[ntext107] [nvarchar](max) SPARSE  NULL,
	[ntext108] [nvarchar](max) SPARSE  NULL,
	[ntext109] [nvarchar](max) SPARSE  NULL,
	[ntext110] [nvarchar](max) SPARSE  NULL,
	[ntext111] [nvarchar](max) SPARSE  NULL,
	[ntext112] [nvarchar](max) SPARSE  NULL,
	[ntext113] [nvarchar](max) SPARSE  NULL,
	[ntext114] [nvarchar](max) SPARSE  NULL,
	[ntext115] [nvarchar](max) SPARSE  NULL,
	[ntext116] [nvarchar](max) SPARSE  NULL,
	[ntext117] [nvarchar](max) SPARSE  NULL,
	[ntext118] [nvarchar](max) SPARSE  NULL,
	[ntext119] [nvarchar](max) SPARSE  NULL,
	[ntext120] [nvarchar](max) SPARSE  NULL,
	[ntext121] [nvarchar](max) SPARSE  NULL,
	[ntext122] [nvarchar](max) SPARSE  NULL,
	[ntext123] [nvarchar](max) SPARSE  NULL,
	[ntext124] [nvarchar](max) SPARSE  NULL,
	[ntext125] [nvarchar](max) SPARSE  NULL,
	[ntext126] [nvarchar](max) SPARSE  NULL,
	[ntext127] [nvarchar](max) SPARSE  NULL,
	[ntext128] [nvarchar](max) SPARSE  NULL,
	[ntext129] [nvarchar](max) SPARSE  NULL,
	[ntext130] [nvarchar](max) SPARSE  NULL,
	[ntext131] [nvarchar](max) SPARSE  NULL,
	[ntext132] [nvarchar](max) SPARSE  NULL,
	[ntext133] [nvarchar](max) SPARSE  NULL,
	[ntext134] [nvarchar](max) SPARSE  NULL,
	[ntext135] [nvarchar](max) SPARSE  NULL,
	[ntext136] [nvarchar](max) SPARSE  NULL,
	[ntext137] [nvarchar](max) SPARSE  NULL,
	[ntext138] [nvarchar](max) SPARSE  NULL,
	[ntext139] [nvarchar](max) SPARSE  NULL,
	[ntext140] [nvarchar](max) SPARSE  NULL,
	[ntext141] [nvarchar](max) SPARSE  NULL,
	[ntext142] [nvarchar](max) SPARSE  NULL,
	[ntext143] [nvarchar](max) SPARSE  NULL,
	[ntext144] [nvarchar](max) SPARSE  NULL,
	[ntext145] [nvarchar](max) SPARSE  NULL,
	[ntext146] [nvarchar](max) SPARSE  NULL,
	[ntext147] [nvarchar](max) SPARSE  NULL,
	[ntext148] [nvarchar](max) SPARSE  NULL,
	[ntext149] [nvarchar](max) SPARSE  NULL,
	[ntext150] [nvarchar](max) SPARSE  NULL,
	[ntext151] [nvarchar](max) SPARSE  NULL,
	[ntext152] [nvarchar](max) SPARSE  NULL,
	[ntext153] [nvarchar](max) SPARSE  NULL,
	[ntext154] [nvarchar](max) SPARSE  NULL,
	[ntext155] [nvarchar](max) SPARSE  NULL,
	[ntext156] [nvarchar](max) SPARSE  NULL,
	[ntext157] [nvarchar](max) SPARSE  NULL,
	[ntext158] [nvarchar](max) SPARSE  NULL,
	[ntext159] [nvarchar](max) SPARSE  NULL,
	[ntext160] [nvarchar](max) SPARSE  NULL,
	[ntext161] [nvarchar](max) SPARSE  NULL,
	[ntext162] [nvarchar](max) SPARSE  NULL,
	[ntext163] [nvarchar](max) SPARSE  NULL,
	[ntext164] [nvarchar](max) SPARSE  NULL,
	[ntext165] [nvarchar](max) SPARSE  NULL,
	[ntext166] [nvarchar](max) SPARSE  NULL,
	[ntext167] [nvarchar](max) SPARSE  NULL,
	[ntext168] [nvarchar](max) SPARSE  NULL,
	[ntext169] [nvarchar](max) SPARSE  NULL,
	[ntext170] [nvarchar](max) SPARSE  NULL,
	[ntext171] [nvarchar](max) SPARSE  NULL,
	[ntext172] [nvarchar](max) SPARSE  NULL,
	[ntext173] [nvarchar](max) SPARSE  NULL,
	[ntext174] [nvarchar](max) SPARSE  NULL,
	[ntext175] [nvarchar](max) SPARSE  NULL,
	[ntext176] [nvarchar](max) SPARSE  NULL,
	[ntext177] [nvarchar](max) SPARSE  NULL,
	[ntext178] [nvarchar](max) SPARSE  NULL,
	[ntext179] [nvarchar](max) SPARSE  NULL,
	[ntext180] [nvarchar](max) SPARSE  NULL,
	[ntext181] [nvarchar](max) SPARSE  NULL,
	[ntext182] [nvarchar](max) SPARSE  NULL,
	[ntext183] [nvarchar](max) SPARSE  NULL,
	[ntext184] [nvarchar](max) SPARSE  NULL,
	[ntext185] [nvarchar](max) SPARSE  NULL,
	[ntext186] [nvarchar](max) SPARSE  NULL,
	[ntext187] [nvarchar](max) SPARSE  NULL,
	[ntext188] [nvarchar](max) SPARSE  NULL,
	[ntext189] [nvarchar](max) SPARSE  NULL,
	[ntext190] [nvarchar](max) SPARSE  NULL,
	[ntext191] [nvarchar](max) SPARSE  NULL,
	[ntext192] [nvarchar](max) SPARSE  NULL,
	[ntext193] [nvarchar](max) SPARSE  NULL,
	[ntext194] [nvarchar](max) SPARSE  NULL,
	[ntext195] [nvarchar](max) SPARSE  NULL,
	[ntext196] [nvarchar](max) SPARSE  NULL,
	[ntext197] [nvarchar](max) SPARSE  NULL,
	[ntext198] [nvarchar](max) SPARSE  NULL,
	[ntext199] [nvarchar](max) SPARSE  NULL,
	[ntext200] [nvarchar](max) SPARSE  NULL,
	[ntext201] [nvarchar](max) SPARSE  NULL,
	[ntext202] [nvarchar](max) SPARSE  NULL,
	[ntext203] [nvarchar](max) SPARSE  NULL,
	[ntext204] [nvarchar](max) SPARSE  NULL,
	[ntext205] [nvarchar](max) SPARSE  NULL,
	[ntext206] [nvarchar](max) SPARSE  NULL,
	[ntext207] [nvarchar](max) SPARSE  NULL,
	[ntext208] [nvarchar](max) SPARSE  NULL,
	[ntext209] [nvarchar](max) SPARSE  NULL,
	[ntext210] [nvarchar](max) SPARSE  NULL,
	[ntext211] [nvarchar](max) SPARSE  NULL,
	[ntext212] [nvarchar](max) SPARSE  NULL,
	[ntext213] [nvarchar](max) SPARSE  NULL,
	[ntext214] [nvarchar](max) SPARSE  NULL,
	[ntext215] [nvarchar](max) SPARSE  NULL,
	[ntext216] [nvarchar](max) SPARSE  NULL,
	[ntext217] [nvarchar](max) SPARSE  NULL,
	[ntext218] [nvarchar](max) SPARSE  NULL,
	[ntext219] [nvarchar](max) SPARSE  NULL,
	[ntext220] [nvarchar](max) SPARSE  NULL,
	[ntext221] [nvarchar](max) SPARSE  NULL,
	[ntext222] [nvarchar](max) SPARSE  NULL,
	[ntext223] [nvarchar](max) SPARSE  NULL,
	[ntext224] [nvarchar](max) SPARSE  NULL,
	[ntext225] [nvarchar](max) SPARSE  NULL,
	[ntext226] [nvarchar](max) SPARSE  NULL,
	[ntext227] [nvarchar](max) SPARSE  NULL,
	[ntext228] [nvarchar](max) SPARSE  NULL,
	[ntext229] [nvarchar](max) SPARSE  NULL,
	[ntext230] [nvarchar](max) SPARSE  NULL,
	[ntext231] [nvarchar](max) SPARSE  NULL,
	[ntext232] [nvarchar](max) SPARSE  NULL,
	[ntext233] [nvarchar](max) SPARSE  NULL,
	[ntext234] [nvarchar](max) SPARSE  NULL,
	[ntext235] [nvarchar](max) SPARSE  NULL,
	[ntext236] [nvarchar](max) SPARSE  NULL,
	[ntext237] [nvarchar](max) SPARSE  NULL,
	[ntext238] [nvarchar](max) SPARSE  NULL,
	[ntext239] [nvarchar](max) SPARSE  NULL,
	[ntext240] [nvarchar](max) SPARSE  NULL,
	[ntext241] [nvarchar](max) SPARSE  NULL,
	[ntext242] [nvarchar](max) SPARSE  NULL,
	[ntext243] [nvarchar](max) SPARSE  NULL,
	[ntext244] [nvarchar](max) SPARSE  NULL,
	[ntext245] [nvarchar](max) SPARSE  NULL,
	[ntext246] [nvarchar](max) SPARSE  NULL,
	[ntext247] [nvarchar](max) SPARSE  NULL,
	[ntext248] [nvarchar](max) SPARSE  NULL,
	[ntext249] [nvarchar](max) SPARSE  NULL,
	[ntext250] [nvarchar](max) SPARSE  NULL,
	[ntext251] [nvarchar](max) SPARSE  NULL,
	[ntext252] [nvarchar](max) SPARSE  NULL,
	[ntext253] [nvarchar](max) SPARSE  NULL,
	[ntext254] [nvarchar](max) SPARSE  NULL,
	[ntext255] [nvarchar](max) SPARSE  NULL,
	[ntext256] [nvarchar](max) SPARSE  NULL,
	[ntext257] [nvarchar](max) SPARSE  NULL,
	[ntext258] [nvarchar](max) SPARSE  NULL,
	[ntext259] [nvarchar](max) SPARSE  NULL,
	[ntext260] [nvarchar](max) SPARSE  NULL,
	[ntext261] [nvarchar](max) SPARSE  NULL,
	[ntext262] [nvarchar](max) SPARSE  NULL,
	[nvarchar1] [nvarchar](255) SPARSE  NULL,
	[nvarchar2] [nvarchar](255) SPARSE  NULL,
	[nvarchar3] [nvarchar](255) SPARSE  NULL,
	[nvarchar4] [nvarchar](255) SPARSE  NULL,
	[nvarchar5] [nvarchar](255) SPARSE  NULL,
	[nvarchar6] [nvarchar](255) SPARSE  NULL,
	[nvarchar7] [nvarchar](255) SPARSE  NULL,
	[nvarchar8] [nvarchar](255) SPARSE  NULL,
	[nvarchar9] [nvarchar](255) SPARSE  NULL,
	[nvarchar10] [nvarchar](255) SPARSE  NULL,
	[nvarchar11] [nvarchar](255) SPARSE  NULL,
	[nvarchar12] [nvarchar](255) SPARSE  NULL,
	[nvarchar13] [nvarchar](255) SPARSE  NULL,
	[nvarchar14] [nvarchar](255) SPARSE  NULL,
	[nvarchar15] [nvarchar](255) SPARSE  NULL,
	[nvarchar16] [nvarchar](255) SPARSE  NULL,
	[nvarchar17] [nvarchar](255) SPARSE  NULL,
	[nvarchar18] [nvarchar](255) SPARSE  NULL,
	[nvarchar19] [nvarchar](255) SPARSE  NULL,
	[nvarchar20] [nvarchar](255) SPARSE  NULL,
	[nvarchar21] [nvarchar](255) SPARSE  NULL,
	[nvarchar22] [nvarchar](255) SPARSE  NULL,
	[nvarchar23] [nvarchar](255) SPARSE  NULL,
	[nvarchar24] [nvarchar](255) SPARSE  NULL,
	[nvarchar25] [nvarchar](255) SPARSE  NULL,
	[nvarchar26] [nvarchar](255) SPARSE  NULL,
	[nvarchar27] [nvarchar](255) SPARSE  NULL,
	[nvarchar28] [nvarchar](255) SPARSE  NULL,
	[nvarchar29] [nvarchar](255) SPARSE  NULL,
	[nvarchar30] [nvarchar](255) SPARSE  NULL,
	[nvarchar31] [nvarchar](255) SPARSE  NULL,
	[nvarchar32] [nvarchar](255) SPARSE  NULL,
	[nvarchar33] [nvarchar](255) SPARSE  NULL,
	[nvarchar34] [nvarchar](255) SPARSE  NULL,
	[nvarchar35] [nvarchar](255) SPARSE  NULL,
	[nvarchar36] [nvarchar](255) SPARSE  NULL,
	[nvarchar37] [nvarchar](255) SPARSE  NULL,
	[nvarchar38] [nvarchar](255) SPARSE  NULL,
	[nvarchar39] [nvarchar](255) SPARSE  NULL,
	[nvarchar40] [nvarchar](255) SPARSE  NULL,
	[nvarchar41] [nvarchar](255) SPARSE  NULL,
	[nvarchar42] [nvarchar](255) SPARSE  NULL,
	[nvarchar43] [nvarchar](255) SPARSE  NULL,
	[nvarchar44] [nvarchar](255) SPARSE  NULL,
	[nvarchar45] [nvarchar](255) SPARSE  NULL,
	[nvarchar46] [nvarchar](255) SPARSE  NULL,
	[nvarchar47] [nvarchar](255) SPARSE  NULL,
	[nvarchar48] [nvarchar](255) SPARSE  NULL,
	[nvarchar49] [nvarchar](255) SPARSE  NULL,
	[nvarchar50] [nvarchar](255) SPARSE  NULL,
	[nvarchar51] [nvarchar](255) SPARSE  NULL,
	[nvarchar52] [nvarchar](255) SPARSE  NULL,
	[nvarchar53] [nvarchar](255) SPARSE  NULL,
	[nvarchar54] [nvarchar](255) SPARSE  NULL,
	[nvarchar55] [nvarchar](255) SPARSE  NULL,
	[nvarchar56] [nvarchar](255) SPARSE  NULL,
	[nvarchar57] [nvarchar](255) SPARSE  NULL,
	[nvarchar58] [nvarchar](255) SPARSE  NULL,
	[nvarchar59] [nvarchar](255) SPARSE  NULL,
	[nvarchar60] [nvarchar](255) SPARSE  NULL,
	[nvarchar61] [nvarchar](255) SPARSE  NULL,
	[nvarchar62] [nvarchar](255) SPARSE  NULL,
	[nvarchar63] [nvarchar](255) SPARSE  NULL,
	[nvarchar64] [nvarchar](255) SPARSE  NULL,
	[nvarchar65] [nvarchar](255) SPARSE  NULL,
	[nvarchar66] [nvarchar](255) SPARSE  NULL,
	[nvarchar67] [nvarchar](255) SPARSE  NULL,
	[nvarchar68] [nvarchar](255) SPARSE  NULL,
	[nvarchar69] [nvarchar](255) SPARSE  NULL,
	[nvarchar70] [nvarchar](255) SPARSE  NULL,
	[nvarchar71] [nvarchar](255) SPARSE  NULL,
	[nvarchar72] [nvarchar](255) SPARSE  NULL,
	[nvarchar73] [nvarchar](255) SPARSE  NULL,
	[nvarchar74] [nvarchar](255) SPARSE  NULL,
	[nvarchar75] [nvarchar](255) SPARSE  NULL,
	[nvarchar76] [nvarchar](255) SPARSE  NULL,
	[nvarchar77] [nvarchar](255) SPARSE  NULL,
	[nvarchar78] [nvarchar](255) SPARSE  NULL,
	[nvarchar79] [nvarchar](255) SPARSE  NULL,
	[nvarchar80] [nvarchar](255) SPARSE  NULL,
	[nvarchar81] [nvarchar](255) SPARSE  NULL,
	[nvarchar82] [nvarchar](255) SPARSE  NULL,
	[nvarchar83] [nvarchar](255) SPARSE  NULL,
	[nvarchar84] [nvarchar](255) SPARSE  NULL,
	[nvarchar85] [nvarchar](255) SPARSE  NULL,
	[nvarchar86] [nvarchar](255) SPARSE  NULL,
	[nvarchar87] [nvarchar](255) SPARSE  NULL,
	[nvarchar88] [nvarchar](255) SPARSE  NULL,
	[nvarchar89] [nvarchar](255) SPARSE  NULL,
	[nvarchar90] [nvarchar](255) SPARSE  NULL,
	[nvarchar91] [nvarchar](255) SPARSE  NULL,
	[nvarchar92] [nvarchar](255) SPARSE  NULL,
	[nvarchar93] [nvarchar](255) SPARSE  NULL,
	[nvarchar94] [nvarchar](255) SPARSE  NULL,
	[nvarchar95] [nvarchar](255) SPARSE  NULL,
	[nvarchar96] [nvarchar](255) SPARSE  NULL,
	[nvarchar97] [nvarchar](255) SPARSE  NULL,
	[nvarchar98] [nvarchar](255) SPARSE  NULL,
	[nvarchar99] [nvarchar](255) SPARSE  NULL,
	[nvarchar100] [nvarchar](255) SPARSE  NULL,
	[nvarchar101] [nvarchar](255) SPARSE  NULL,
	[nvarchar102] [nvarchar](255) SPARSE  NULL,
	[nvarchar103] [nvarchar](255) SPARSE  NULL,
	[nvarchar104] [nvarchar](255) SPARSE  NULL,
	[nvarchar105] [nvarchar](255) SPARSE  NULL,
	[nvarchar106] [nvarchar](255) SPARSE  NULL,
	[nvarchar107] [nvarchar](255) SPARSE  NULL,
	[nvarchar108] [nvarchar](255) SPARSE  NULL,
	[nvarchar109] [nvarchar](255) SPARSE  NULL,
	[nvarchar110] [nvarchar](255) SPARSE  NULL,
	[nvarchar111] [nvarchar](255) SPARSE  NULL,
	[nvarchar112] [nvarchar](255) SPARSE  NULL,
	[nvarchar113] [nvarchar](255) SPARSE  NULL,
	[nvarchar114] [nvarchar](255) SPARSE  NULL,
	[nvarchar115] [nvarchar](255) SPARSE  NULL,
	[nvarchar116] [nvarchar](255) SPARSE  NULL,
	[nvarchar117] [nvarchar](255) SPARSE  NULL,
	[nvarchar118] [nvarchar](255) SPARSE  NULL,
	[nvarchar119] [nvarchar](255) SPARSE  NULL,
	[nvarchar120] [nvarchar](255) SPARSE  NULL,
	[nvarchar121] [nvarchar](255) SPARSE  NULL,
	[nvarchar122] [nvarchar](255) SPARSE  NULL,
	[nvarchar123] [nvarchar](255) SPARSE  NULL,
	[nvarchar124] [nvarchar](255) SPARSE  NULL,
	[nvarchar125] [nvarchar](255) SPARSE  NULL,
	[nvarchar126] [nvarchar](255) SPARSE  NULL,
	[nvarchar127] [nvarchar](255) SPARSE  NULL,
	[nvarchar128] [nvarchar](255) SPARSE  NULL,
	[nvarchar129] [nvarchar](255) SPARSE  NULL,
	[nvarchar130] [nvarchar](255) SPARSE  NULL,
	[nvarchar131] [nvarchar](255) SPARSE  NULL,
	[nvarchar132] [nvarchar](255) SPARSE  NULL,
	[nvarchar133] [nvarchar](255) SPARSE  NULL,
	[nvarchar134] [nvarchar](255) SPARSE  NULL,
	[nvarchar135] [nvarchar](255) SPARSE  NULL,
	[nvarchar136] [nvarchar](255) SPARSE  NULL,
	[nvarchar137] [nvarchar](255) SPARSE  NULL,
	[nvarchar138] [nvarchar](255) SPARSE  NULL,
	[nvarchar139] [nvarchar](255) SPARSE  NULL,
	[nvarchar140] [nvarchar](255) SPARSE  NULL,
	[nvarchar141] [nvarchar](255) SPARSE  NULL,
	[nvarchar142] [nvarchar](255) SPARSE  NULL,
	[nvarchar143] [nvarchar](255) SPARSE  NULL,
	[nvarchar144] [nvarchar](255) SPARSE  NULL,
	[nvarchar145] [nvarchar](255) SPARSE  NULL,
	[nvarchar146] [nvarchar](255) SPARSE  NULL,
	[nvarchar147] [nvarchar](255) SPARSE  NULL,
	[nvarchar148] [nvarchar](255) SPARSE  NULL,
	[nvarchar149] [nvarchar](255) SPARSE  NULL,
	[nvarchar150] [nvarchar](255) SPARSE  NULL,
	[nvarchar151] [nvarchar](255) SPARSE  NULL,
	[nvarchar152] [nvarchar](255) SPARSE  NULL,
	[nvarchar153] [nvarchar](255) SPARSE  NULL,
	[nvarchar154] [nvarchar](255) SPARSE  NULL,
	[nvarchar155] [nvarchar](255) SPARSE  NULL,
	[nvarchar156] [nvarchar](255) SPARSE  NULL,
	[nvarchar157] [nvarchar](255) SPARSE  NULL,
	[nvarchar158] [nvarchar](255) SPARSE  NULL,
	[nvarchar159] [nvarchar](255) SPARSE  NULL,
	[nvarchar160] [nvarchar](255) SPARSE  NULL,
	[nvarchar161] [nvarchar](255) SPARSE  NULL,
	[nvarchar162] [nvarchar](255) SPARSE  NULL,
	[nvarchar163] [nvarchar](255) SPARSE  NULL,
	[nvarchar164] [nvarchar](255) SPARSE  NULL,
	[nvarchar165] [nvarchar](255) SPARSE  NULL,
	[nvarchar166] [nvarchar](255) SPARSE  NULL,
	[nvarchar167] [nvarchar](255) SPARSE  NULL,
	[nvarchar168] [nvarchar](255) SPARSE  NULL,
	[nvarchar169] [nvarchar](255) SPARSE  NULL,
	[nvarchar170] [nvarchar](255) SPARSE  NULL,
	[nvarchar171] [nvarchar](255) SPARSE  NULL,
	[nvarchar172] [nvarchar](255) SPARSE  NULL,
	[nvarchar173] [nvarchar](255) SPARSE  NULL,
	[nvarchar174] [nvarchar](255) SPARSE  NULL,
	[nvarchar175] [nvarchar](255) SPARSE  NULL,
	[nvarchar176] [nvarchar](255) SPARSE  NULL,
	[nvarchar177] [nvarchar](255) SPARSE  NULL,
	[nvarchar178] [nvarchar](255) SPARSE  NULL,
	[nvarchar179] [nvarchar](255) SPARSE  NULL,
	[nvarchar180] [nvarchar](255) SPARSE  NULL,
	[nvarchar181] [nvarchar](255) SPARSE  NULL,
	[nvarchar182] [nvarchar](255) SPARSE  NULL,
	[nvarchar183] [nvarchar](255) SPARSE  NULL,
	[nvarchar184] [nvarchar](255) SPARSE  NULL,
	[nvarchar185] [nvarchar](255) SPARSE  NULL,
	[nvarchar186] [nvarchar](255) SPARSE  NULL,
	[nvarchar187] [nvarchar](255) SPARSE  NULL,
	[nvarchar188] [nvarchar](255) SPARSE  NULL,
	[nvarchar189] [nvarchar](255) SPARSE  NULL,
	[nvarchar190] [nvarchar](255) SPARSE  NULL,
	[nvarchar191] [nvarchar](255) SPARSE  NULL,
	[nvarchar192] [nvarchar](255) SPARSE  NULL,
	[nvarchar193] [nvarchar](255) SPARSE  NULL,
	[nvarchar194] [nvarchar](255) SPARSE  NULL,
	[nvarchar195] [nvarchar](255) SPARSE  NULL,
	[nvarchar196] [nvarchar](255) SPARSE  NULL,
	[nvarchar197] [nvarchar](255) SPARSE  NULL,
	[nvarchar198] [nvarchar](255) SPARSE  NULL,
	[nvarchar199] [nvarchar](255) SPARSE  NULL,
	[nvarchar200] [nvarchar](255) SPARSE  NULL,
	[nvarchar201] [nvarchar](255) SPARSE  NULL,
	[nvarchar202] [nvarchar](255) SPARSE  NULL,
	[nvarchar203] [nvarchar](255) SPARSE  NULL,
	[nvarchar204] [nvarchar](255) SPARSE  NULL,
	[nvarchar205] [nvarchar](255) SPARSE  NULL,
	[nvarchar206] [nvarchar](255) SPARSE  NULL,
	[nvarchar207] [nvarchar](255) SPARSE  NULL,
	[nvarchar208] [nvarchar](255) SPARSE  NULL,
	[nvarchar209] [nvarchar](255) SPARSE  NULL,
	[nvarchar210] [nvarchar](255) SPARSE  NULL,
	[nvarchar211] [nvarchar](255) SPARSE  NULL,
	[nvarchar212] [nvarchar](255) SPARSE  NULL,
	[nvarchar213] [nvarchar](255) SPARSE  NULL,
	[nvarchar214] [nvarchar](255) SPARSE  NULL,
	[nvarchar215] [nvarchar](255) SPARSE  NULL,
	[nvarchar216] [nvarchar](255) SPARSE  NULL,
	[nvarchar217] [nvarchar](255) SPARSE  NULL,
	[nvarchar218] [nvarchar](255) SPARSE  NULL,
	[nvarchar219] [nvarchar](255) SPARSE  NULL,
	[nvarchar220] [nvarchar](255) SPARSE  NULL,
	[nvarchar221] [nvarchar](255) SPARSE  NULL,
	[nvarchar222] [nvarchar](255) SPARSE  NULL,
	[nvarchar223] [nvarchar](255) SPARSE  NULL,
	[nvarchar224] [nvarchar](255) SPARSE  NULL,
	[nvarchar225] [nvarchar](255) SPARSE  NULL,
	[nvarchar226] [nvarchar](255) SPARSE  NULL,
	[nvarchar227] [nvarchar](255) SPARSE  NULL,
	[nvarchar228] [nvarchar](255) SPARSE  NULL,
	[nvarchar229] [nvarchar](255) SPARSE  NULL,
	[nvarchar230] [nvarchar](255) SPARSE  NULL,
	[nvarchar231] [nvarchar](255) SPARSE  NULL,
	[nvarchar232] [nvarchar](255) SPARSE  NULL,
	[nvarchar233] [nvarchar](255) SPARSE  NULL,
	[nvarchar234] [nvarchar](255) SPARSE  NULL,
	[nvarchar235] [nvarchar](255) SPARSE  NULL,
	[nvarchar236] [nvarchar](255) SPARSE  NULL,
	[nvarchar237] [nvarchar](255) SPARSE  NULL,
	[nvarchar238] [nvarchar](255) SPARSE  NULL,
	[nvarchar239] [nvarchar](255) SPARSE  NULL,
	[nvarchar240] [nvarchar](255) SPARSE  NULL,
	[nvarchar241] [nvarchar](255) SPARSE  NULL,
	[nvarchar242] [nvarchar](255) SPARSE  NULL,
	[nvarchar243] [nvarchar](255) SPARSE  NULL,
	[nvarchar244] [nvarchar](255) SPARSE  NULL,
	[nvarchar245] [nvarchar](255) SPARSE  NULL,
	[nvarchar246] [nvarchar](255) SPARSE  NULL,
	[nvarchar247] [nvarchar](255) SPARSE  NULL,
	[nvarchar248] [nvarchar](255) SPARSE  NULL,
	[nvarchar249] [nvarchar](255) SPARSE  NULL,
	[nvarchar250] [nvarchar](255) SPARSE  NULL,
	[nvarchar251] [nvarchar](255) SPARSE  NULL,
	[nvarchar252] [nvarchar](255) SPARSE  NULL,
	[nvarchar253] [nvarchar](255) SPARSE  NULL,
	[nvarchar254] [nvarchar](255) SPARSE  NULL,
	[nvarchar255] [nvarchar](255) SPARSE  NULL,
	[nvarchar256] [nvarchar](255) SPARSE  NULL,
	[nvarchar257] [nvarchar](255) SPARSE  NULL,
	[nvarchar258] [nvarchar](255) SPARSE  NULL,
	[nvarchar259] [nvarchar](255) SPARSE  NULL,
	[nvarchar260] [nvarchar](255) SPARSE  NULL,
	[nvarchar261] [nvarchar](255) SPARSE  NULL,
	[nvarchar262] [nvarchar](255) SPARSE  NULL,
	[sql_variant1] [sql_variant] SPARSE  NULL,
	[sql_variant2] [sql_variant] SPARSE  NULL,
	[sql_variant3] [sql_variant] SPARSE  NULL,
	[sql_variant4] [sql_variant] SPARSE  NULL,
	[sql_variant5] [sql_variant] SPARSE  NULL,
	[sql_variant6] [sql_variant] SPARSE  NULL,
	[sql_variant7] [sql_variant] SPARSE  NULL,
	[sql_variant8] [sql_variant] SPARSE  NULL,
	[sql_variant9] [sql_variant] SPARSE  NULL,
	[sql_variant10] [sql_variant] SPARSE  NULL,
	[sql_variant11] [sql_variant] SPARSE  NULL,
	[sql_variant12] [sql_variant] SPARSE  NULL,
	[sql_variant13] [sql_variant] SPARSE  NULL,
	[sql_variant14] [sql_variant] SPARSE  NULL,
	[sql_variant15] [sql_variant] SPARSE  NULL,
	[sql_variant16] [sql_variant] SPARSE  NULL,
	[sql_variant17] [sql_variant] SPARSE  NULL,
	[sql_variant18] [sql_variant] SPARSE  NULL,
	[sql_variant19] [sql_variant] SPARSE  NULL,
	[sql_variant20] [sql_variant] SPARSE  NULL,
	[sql_variant21] [sql_variant] SPARSE  NULL,
	[sql_variant22] [sql_variant] SPARSE  NULL,
	[sql_variant23] [sql_variant] SPARSE  NULL,
	[sql_variant24] [sql_variant] SPARSE  NULL,
	[sql_variant25] [sql_variant] SPARSE  NULL,
	[sql_variant26] [sql_variant] SPARSE  NULL,
	[sql_variant27] [sql_variant] SPARSE  NULL,
	[sql_variant28] [sql_variant] SPARSE  NULL,
	[sql_variant29] [sql_variant] SPARSE  NULL,
	[sql_variant30] [sql_variant] SPARSE  NULL,
	[sql_variant31] [sql_variant] SPARSE  NULL,
	[sql_variant32] [sql_variant] SPARSE  NULL,
	[sql_variant33] [sql_variant] SPARSE  NULL,
	[sql_variant34] [sql_variant] SPARSE  NULL,
	[sql_variant35] [sql_variant] SPARSE  NULL,
	[sql_variant36] [sql_variant] SPARSE  NULL,
	[sql_variant37] [sql_variant] SPARSE  NULL,
	[sql_variant38] [sql_variant] SPARSE  NULL,
	[sql_variant39] [sql_variant] SPARSE  NULL,
	[sql_variant40] [sql_variant] SPARSE  NULL,
	[sql_variant41] [sql_variant] SPARSE  NULL,
	[sql_variant42] [sql_variant] SPARSE  NULL,
	[sql_variant43] [sql_variant] SPARSE  NULL,
	[sql_variant44] [sql_variant] SPARSE  NULL,
	[sql_variant45] [sql_variant] SPARSE  NULL,
	[sql_variant46] [sql_variant] SPARSE  NULL,
	[sql_variant47] [sql_variant] SPARSE  NULL,
	[sql_variant48] [sql_variant] SPARSE  NULL,
	[sql_variant49] [sql_variant] SPARSE  NULL,
	[sql_variant50] [sql_variant] SPARSE  NULL,
	[sql_variant51] [sql_variant] SPARSE  NULL,
	[sql_variant52] [sql_variant] SPARSE  NULL,
	[sql_variant53] [sql_variant] SPARSE  NULL,
	[sql_variant54] [sql_variant] SPARSE  NULL,
	[sql_variant55] [sql_variant] SPARSE  NULL,
	[sql_variant56] [sql_variant] SPARSE  NULL,
	[sql_variant57] [sql_variant] SPARSE  NULL,
	[sql_variant58] [sql_variant] SPARSE  NULL,
	[sql_variant59] [sql_variant] SPARSE  NULL,
	[sql_variant60] [sql_variant] SPARSE  NULL,
	[sql_variant61] [sql_variant] SPARSE  NULL,
	[sql_variant62] [sql_variant] SPARSE  NULL,
	[sql_variant63] [sql_variant] SPARSE  NULL,
	[sql_variant64] [sql_variant] SPARSE  NULL,
	[sql_variant65] [sql_variant] SPARSE  NULL,
	[sql_variant66] [sql_variant] SPARSE  NULL,
	[sql_variant67] [sql_variant] SPARSE  NULL,
	[sql_variant68] [sql_variant] SPARSE  NULL,
	[sql_variant69] [sql_variant] SPARSE  NULL,
	[sql_variant70] [sql_variant] SPARSE  NULL,
	[sql_variant71] [sql_variant] SPARSE  NULL,
	[sql_variant72] [sql_variant] SPARSE  NULL,
	[sql_variant73] [sql_variant] SPARSE  NULL,
	[sql_variant74] [sql_variant] SPARSE  NULL,
	[sql_variant75] [sql_variant] SPARSE  NULL,
	[sql_variant76] [sql_variant] SPARSE  NULL,
	[sql_variant77] [sql_variant] SPARSE  NULL,
	[sql_variant78] [sql_variant] SPARSE  NULL,
	[sql_variant79] [sql_variant] SPARSE  NULL,
	[sql_variant80] [sql_variant] SPARSE  NULL,
	[sql_variant81] [sql_variant] SPARSE  NULL,
	[sql_variant82] [sql_variant] SPARSE  NULL,
	[sql_variant83] [sql_variant] SPARSE  NULL,
	[sql_variant84] [sql_variant] SPARSE  NULL,
	[sql_variant85] [sql_variant] SPARSE  NULL,
	[sql_variant86] [sql_variant] SPARSE  NULL,
	[sql_variant87] [sql_variant] SPARSE  NULL,
	[sql_variant88] [sql_variant] SPARSE  NULL,
	[sql_variant89] [sql_variant] SPARSE  NULL,
	[sql_variant90] [sql_variant] SPARSE  NULL,
	[sql_variant91] [sql_variant] SPARSE  NULL,
	[sql_variant92] [sql_variant] SPARSE  NULL,
	[sql_variant93] [sql_variant] SPARSE  NULL,
	[sql_variant94] [sql_variant] SPARSE  NULL,
	[sql_variant95] [sql_variant] SPARSE  NULL,
	[sql_variant96] [sql_variant] SPARSE  NULL,
	[sql_variant97] [sql_variant] SPARSE  NULL,
	[sql_variant98] [sql_variant] SPARSE  NULL,
	[sql_variant99] [sql_variant] SPARSE  NULL,
	[sql_variant100] [sql_variant] SPARSE  NULL,
	[sql_variant101] [sql_variant] SPARSE  NULL,
	[sql_variant102] [sql_variant] SPARSE  NULL,
	[sql_variant103] [sql_variant] SPARSE  NULL,
	[sql_variant104] [sql_variant] SPARSE  NULL,
	[sql_variant105] [sql_variant] SPARSE  NULL,
	[sql_variant106] [sql_variant] SPARSE  NULL,
	[sql_variant107] [sql_variant] SPARSE  NULL,
	[sql_variant108] [sql_variant] SPARSE  NULL,
	[sql_variant109] [sql_variant] SPARSE  NULL,
	[sql_variant110] [sql_variant] SPARSE  NULL,
	[sql_variant111] [sql_variant] SPARSE  NULL,
	[sql_variant112] [sql_variant] SPARSE  NULL,
	[sql_variant113] [sql_variant] SPARSE  NULL,
	[sql_variant114] [sql_variant] SPARSE  NULL,
	[sql_variant115] [sql_variant] SPARSE  NULL,
	[sql_variant116] [sql_variant] SPARSE  NULL,
	[sql_variant117] [sql_variant] SPARSE  NULL,
	[sql_variant118] [sql_variant] SPARSE  NULL,
	[sql_variant119] [sql_variant] SPARSE  NULL,
	[sql_variant120] [sql_variant] SPARSE  NULL,
	[sql_variant121] [sql_variant] SPARSE  NULL,
	[sql_variant122] [sql_variant] SPARSE  NULL,
	[sql_variant123] [sql_variant] SPARSE  NULL,
	[sql_variant124] [sql_variant] SPARSE  NULL,
	[sql_variant125] [sql_variant] SPARSE  NULL,
	[sql_variant126] [sql_variant] SPARSE  NULL,
	[sql_variant127] [sql_variant] SPARSE  NULL,
	[sql_variant128] [sql_variant] SPARSE  NULL,
	[sql_variant129] [sql_variant] SPARSE  NULL,
	[sql_variant130] [sql_variant] SPARSE  NULL,
	[sql_variant131] [sql_variant] SPARSE  NULL,
	[sql_variant132] [sql_variant] SPARSE  NULL,
	[sql_variant133] [sql_variant] SPARSE  NULL,
	[sql_variant134] [sql_variant] SPARSE  NULL,
	[sql_variant135] [sql_variant] SPARSE  NULL,
	[sql_variant136] [sql_variant] SPARSE  NULL,
	[sql_variant137] [sql_variant] SPARSE  NULL,
	[sql_variant138] [sql_variant] SPARSE  NULL,
	[sql_variant139] [sql_variant] SPARSE  NULL,
	[sql_variant140] [sql_variant] SPARSE  NULL,
	[sql_variant141] [sql_variant] SPARSE  NULL,
	[sql_variant142] [sql_variant] SPARSE  NULL,
	[sql_variant143] [sql_variant] SPARSE  NULL,
	[sql_variant144] [sql_variant] SPARSE  NULL,
	[sql_variant145] [sql_variant] SPARSE  NULL,
	[sql_variant146] [sql_variant] SPARSE  NULL,
	[sql_variant147] [sql_variant] SPARSE  NULL,
	[sql_variant148] [sql_variant] SPARSE  NULL,
	[sql_variant149] [sql_variant] SPARSE  NULL,
	[sql_variant150] [sql_variant] SPARSE  NULL,
	[sql_variant151] [sql_variant] SPARSE  NULL,
	[sql_variant152] [sql_variant] SPARSE  NULL,
	[sql_variant153] [sql_variant] SPARSE  NULL,
	[sql_variant154] [sql_variant] SPARSE  NULL,
	[sql_variant155] [sql_variant] SPARSE  NULL,
	[sql_variant156] [sql_variant] SPARSE  NULL,
	[sql_variant157] [sql_variant] SPARSE  NULL,
	[sql_variant158] [sql_variant] SPARSE  NULL,
	[sql_variant159] [sql_variant] SPARSE  NULL,
	[sql_variant160] [sql_variant] SPARSE  NULL,
	[sql_variant161] [sql_variant] SPARSE  NULL,
	[sql_variant162] [sql_variant] SPARSE  NULL,
	[sql_variant163] [sql_variant] SPARSE  NULL,
	[sql_variant164] [sql_variant] SPARSE  NULL,
	[sql_variant165] [sql_variant] SPARSE  NULL,
	[sql_variant166] [sql_variant] SPARSE  NULL,
	[sql_variant167] [sql_variant] SPARSE  NULL,
	[sql_variant168] [sql_variant] SPARSE  NULL,
	[sql_variant169] [sql_variant] SPARSE  NULL,
	[sql_variant170] [sql_variant] SPARSE  NULL,
	[sql_variant171] [sql_variant] SPARSE  NULL,
	[sql_variant172] [sql_variant] SPARSE  NULL,
	[sql_variant173] [sql_variant] SPARSE  NULL,
	[sql_variant174] [sql_variant] SPARSE  NULL,
	[sql_variant175] [sql_variant] SPARSE  NULL,
	[sql_variant176] [sql_variant] SPARSE  NULL,
	[sql_variant177] [sql_variant] SPARSE  NULL,
	[sql_variant178] [sql_variant] SPARSE  NULL,
	[sql_variant179] [sql_variant] SPARSE  NULL,
	[sql_variant180] [sql_variant] SPARSE  NULL,
	[sql_variant181] [sql_variant] SPARSE  NULL,
	[sql_variant182] [sql_variant] SPARSE  NULL,
	[sql_variant183] [sql_variant] SPARSE  NULL,
	[sql_variant184] [sql_variant] SPARSE  NULL,
	[sql_variant185] [sql_variant] SPARSE  NULL,
	[sql_variant186] [sql_variant] SPARSE  NULL,
	[sql_variant187] [sql_variant] SPARSE  NULL,
	[sql_variant188] [sql_variant] SPARSE  NULL,
	[sql_variant189] [sql_variant] SPARSE  NULL,
	[sql_variant190] [sql_variant] SPARSE  NULL,
	[sql_variant191] [sql_variant] SPARSE  NULL,
	[sql_variant192] [sql_variant] SPARSE  NULL,
	[sql_variant193] [sql_variant] SPARSE  NULL,
	[sql_variant194] [sql_variant] SPARSE  NULL,
	[sql_variant195] [sql_variant] SPARSE  NULL,
	[sql_variant196] [sql_variant] SPARSE  NULL,
	[sql_variant197] [sql_variant] SPARSE  NULL,
	[sql_variant198] [sql_variant] SPARSE  NULL,
	[sql_variant199] [sql_variant] SPARSE  NULL,
	[sql_variant200] [sql_variant] SPARSE  NULL,
	[sql_variant201] [sql_variant] SPARSE  NULL,
	[sql_variant202] [sql_variant] SPARSE  NULL,
	[sql_variant203] [sql_variant] SPARSE  NULL,
	[sql_variant204] [sql_variant] SPARSE  NULL,
	[sql_variant205] [sql_variant] SPARSE  NULL,
	[sql_variant206] [sql_variant] SPARSE  NULL,
	[sql_variant207] [sql_variant] SPARSE  NULL,
	[sql_variant208] [sql_variant] SPARSE  NULL,
	[sql_variant209] [sql_variant] SPARSE  NULL,
	[sql_variant210] [sql_variant] SPARSE  NULL,
	[sql_variant211] [sql_variant] SPARSE  NULL,
	[sql_variant212] [sql_variant] SPARSE  NULL,
	[sql_variant213] [sql_variant] SPARSE  NULL,
	[sql_variant214] [sql_variant] SPARSE  NULL,
	[sql_variant215] [sql_variant] SPARSE  NULL,
	[sql_variant216] [sql_variant] SPARSE  NULL,
	[sql_variant217] [sql_variant] SPARSE  NULL,
	[sql_variant218] [sql_variant] SPARSE  NULL,
	[sql_variant219] [sql_variant] SPARSE  NULL,
	[sql_variant220] [sql_variant] SPARSE  NULL,
	[sql_variant221] [sql_variant] SPARSE  NULL,
	[sql_variant222] [sql_variant] SPARSE  NULL,
	[sql_variant223] [sql_variant] SPARSE  NULL,
	[sql_variant224] [sql_variant] SPARSE  NULL,
	[sql_variant225] [sql_variant] SPARSE  NULL,
	[sql_variant226] [sql_variant] SPARSE  NULL,
	[sql_variant227] [sql_variant] SPARSE  NULL,
	[sql_variant228] [sql_variant] SPARSE  NULL,
	[sql_variant229] [sql_variant] SPARSE  NULL,
	[sql_variant230] [sql_variant] SPARSE  NULL,
	[sql_variant231] [sql_variant] SPARSE  NULL,
	[sql_variant232] [sql_variant] SPARSE  NULL,
	[sql_variant233] [sql_variant] SPARSE  NULL,
	[sql_variant234] [sql_variant] SPARSE  NULL,
	[sql_variant235] [sql_variant] SPARSE  NULL,
	[sql_variant236] [sql_variant] SPARSE  NULL,
	[sql_variant237] [sql_variant] SPARSE  NULL,
	[sql_variant238] [sql_variant] SPARSE  NULL,
	[sql_variant239] [sql_variant] SPARSE  NULL,
	[sql_variant240] [sql_variant] SPARSE  NULL,
	[sql_variant241] [sql_variant] SPARSE  NULL,
	[sql_variant242] [sql_variant] SPARSE  NULL,
	[sql_variant243] [sql_variant] SPARSE  NULL,
	[sql_variant244] [sql_variant] SPARSE  NULL,
	[sql_variant245] [sql_variant] SPARSE  NULL,
	[sql_variant246] [sql_variant] SPARSE  NULL,
	[sql_variant247] [sql_variant] SPARSE  NULL,
	[sql_variant248] [sql_variant] SPARSE  NULL,
	[sql_variant249] [sql_variant] SPARSE  NULL,
	[sql_variant250] [sql_variant] SPARSE  NULL,
	[sql_variant251] [sql_variant] SPARSE  NULL,
	[sql_variant252] [sql_variant] SPARSE  NULL,
	[sql_variant253] [sql_variant] SPARSE  NULL,
	[sql_variant254] [sql_variant] SPARSE  NULL,
	[sql_variant255] [sql_variant] SPARSE  NULL,
	[sql_variant256] [sql_variant] SPARSE  NULL,
	[sql_variant257] [sql_variant] SPARSE  NULL,
	[sql_variant258] [sql_variant] SPARSE  NULL,
	[sql_variant259] [sql_variant] SPARSE  NULL,
	[sql_variant260] [sql_variant] SPARSE  NULL,
	[sql_variant261] [sql_variant] SPARSE  NULL,
	[sql_variant262] [sql_variant] SPARSE  NULL,
	[uniqueidentifier1] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier2] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier3] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier4] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier5] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier6] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier7] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier8] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier9] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier10] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier11] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier12] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier13] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier14] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier15] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier16] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier17] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier18] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier19] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier20] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier21] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier22] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier23] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier24] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier25] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier26] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier27] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier28] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier29] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier30] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier31] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier32] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier33] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier34] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier35] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier36] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier37] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier38] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier39] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier40] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier41] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier42] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier43] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier44] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier45] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier46] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier47] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier48] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier49] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier50] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier51] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier52] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier53] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier54] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier55] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier56] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier57] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier58] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier59] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier60] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier61] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier62] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier63] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier64] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier65] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier66] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier67] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier68] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier69] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier70] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier71] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier72] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier73] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier74] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier75] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier76] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier77] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier78] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier79] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier80] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier81] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier82] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier83] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier84] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier85] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier86] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier87] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier88] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier89] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier90] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier91] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier92] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier93] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier94] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier95] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier96] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier97] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier98] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier99] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier100] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier101] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier102] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier103] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier104] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier105] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier106] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier107] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier108] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier109] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier110] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier111] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier112] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier113] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier114] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier115] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier116] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier117] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier118] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier119] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier120] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier121] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier122] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier123] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier124] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier125] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier126] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier127] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier128] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier129] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier130] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier131] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier132] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier133] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier134] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier135] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier136] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier137] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier138] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier139] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier140] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier141] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier142] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier143] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier144] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier145] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier146] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier147] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier148] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier149] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier150] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier151] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier152] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier153] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier154] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier155] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier156] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier157] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier158] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier159] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier160] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier161] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier162] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier163] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier164] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier165] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier166] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier167] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier168] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier169] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier170] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier171] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier172] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier173] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier174] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier175] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier176] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier177] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier178] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier179] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier180] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier181] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier182] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier183] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier184] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier185] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier186] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier187] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier188] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier189] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier190] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier191] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier192] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier193] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier194] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier195] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier196] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier197] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier198] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier199] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier200] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier201] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier202] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier203] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier204] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier205] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier206] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier207] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier208] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier209] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier210] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier211] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier212] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier213] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier214] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier215] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier216] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier217] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier218] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier219] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier220] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier221] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier222] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier223] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier224] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier225] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier226] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier227] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier228] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier229] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier230] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier231] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier232] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier233] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier234] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier235] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier236] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier237] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier238] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier239] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier240] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier241] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier242] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier243] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier244] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier245] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier246] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier247] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier248] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier249] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier250] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier251] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier252] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier253] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier254] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier255] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier256] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier257] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier258] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier259] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier260] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier261] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier262] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier263] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier264] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier265] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier266] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier267] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier268] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier269] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier270] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier271] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier272] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier273] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier274] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier275] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier276] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier277] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier278] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier279] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier280] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier281] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier282] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier283] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier284] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier285] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier286] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier287] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier288] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier289] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier290] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier291] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier292] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier293] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier294] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier295] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier296] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier297] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier298] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier299] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier300] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier301] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier302] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier303] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier304] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier305] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier306] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier307] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier308] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier309] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier310] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier311] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier312] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier313] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier314] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier315] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier316] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier317] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier318] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier319] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier320] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier321] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier322] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier323] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier324] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier325] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier326] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier327] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier328] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier329] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier330] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier331] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier332] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier333] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier334] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier335] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier336] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier337] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier338] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier339] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier340] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier341] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier342] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier343] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier344] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier345] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier346] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier347] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier348] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier349] [uniqueidentifier] SPARSE  NULL,
	[uniqueidentifier350] [uniqueidentifier] SPARSE  NULL,
	[geography1] [varbinary](8000) SPARSE  NULL,
	[geography2] [varbinary](8000) SPARSE  NULL,
	[tp_ColumnSet] [xml] COLUMN_SET FOR ALL_SPARSE_COLUMNS  NULL,
 CONSTRAINT [AllUserData_PK] PRIMARY KEY NONCLUSTERED 
(
	[tp_SiteId] ASC,
	[tp_ListId] ASC,
	[tp_DeleteTransactionId] ASC,
	[tp_IsCurrentVersion] ASC,
	[tp_ID] ASC,
	[tp_CalculatedVersion] ASC,
	[tp_Level] ASC,
	[tp_RowOrdinal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllUserData] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllLists](
	[tp_SiteId] [uniqueidentifier] NOT NULL,
	[tp_WebId] [uniqueidentifier] NOT NULL,
	[tp_ID] [uniqueidentifier] NOT NULL,
	[tp_Title] [nvarchar](255) NOT NULL,
	[tp_Created] [datetime] NOT NULL,
	[tp_LastSecurityChange] [datetime] NOT NULL,
	[tp_Version] [int] NOT NULL,
	[tp_Author] [int] NULL,
	[tp_BaseType] [int] NOT NULL,
	[tp_FeatureId] [uniqueidentifier] NULL,
	[tp_ServerTemplate] [int] NOT NULL,
	[tp_RootFolder] [uniqueidentifier] NOT NULL,
	[tp_Template] [uniqueidentifier] NULL,
	[tp_ImageUrl] [nvarchar](255) NOT NULL,
	[tp_ReadSecurity] [int] NOT NULL,
	[tp_WriteSecurity] [int] NOT NULL,
	[tp_Subscribed] [bit] NOT NULL,
	[tp_Direction] [int] NULL,
	[tp_Flags] [bigint] NOT NULL,
	[tp_ThumbnailSize] [int] NULL,
	[tp_WebImageWidth] [int] NULL,
	[tp_WebImageHeight] [int] NULL,
	[tp_Description] [nvarchar](max) NOT NULL,
	[tp_EmailAlias] [nvarchar](128) NULL,
	[tp_DeleteTransactionId] [varbinary](16) NOT NULL,
	[tp_ScopeId] [uniqueidentifier] NOT NULL,
	[tp_HasFGP] [bit] NOT NULL,
	[tp_HasInternalFGP] [bit] NOT NULL,
	[tp_EventSinkAssembly] [nvarchar](255) NULL,
	[tp_EventSinkClass] [nvarchar](255) NULL,
	[tp_EventSinkData] [nvarchar](255) NULL,
	[tp_MaxRowOrdinal] [tinyint] NOT NULL,
	[tp_Fields] [dbo].[tCompressedString] NULL,
	[tp_ContentTypes] [dbo].[tCompressedString] NULL,
	[tp_AuditFlags] [int] NULL,
	[tp_InheritAuditFlags] [int] NULL,
	[tp_SendToLocation] [nvarchar](512) NULL,
	[tp_ListDataDirty] [int] NOT NULL,
	[tp_CacheParseId] [uniqueidentifier] NULL,
	[tp_MaxMajorVersionCount] [int] NULL,
	[tp_MaxMajorwithMinorVersionCount] [int] NULL,
	[tp_DefaultWorkflowId] [uniqueidentifier] NULL,
	[tp_NoThrottleListOperations] [bit] NOT NULL,
	[tp_ListSchemaVersion] [int] NOT NULL,
 CONSTRAINT [AllLists_PK] PRIMARY KEY CLUSTERED 
(
	[tp_SiteId] ASC,
	[tp_WebId] ASC,
	[tp_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllLists] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllDocVersions](
	[SiteId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UIVersion] [int] NOT NULL,
	[InternalVersion] [int] NULL,
	[TimeCreated] [datetime] NULL,
	[DocFlags] [int] NOT NULL,
	[MetaInfoSize] [int] NULL,
	[Size] [int] NULL,
	[MetaInfo] [dbo].[tCompressedBinary] NULL,
	[CheckinComment] [nvarchar](1023) NULL,
	[Level] [tinyint] NOT NULL,
	[DraftOwnerId] [int] NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL,
	[VirusVendorID] [int] NULL,
	[VirusStatus] [tinyint] NULL,
	[VirusInfo] [nvarchar](255) NULL,
	[StreamSchema] [tinyint] NULL,
	[HasStream]  AS (case when ([DocFlags]&(64))=(64) then CONVERT([bit],(1),0) else CONVERT([bit],(0),0) end),
 CONSTRAINT [AllDocVersions_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC,
	[UIVersion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllDocVersions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteHealthCheckResults](
	[SiteId] [uniqueidentifier] NOT NULL,
	[RuleId] [uniqueidentifier] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
 CONSTRAINT [SiteHealthCheckResults_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[RuleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SiteHealthCheckResults] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteDeletion](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[DeletionTime] [datetime] NOT NULL,
	[InDeletion] [bit] NOT NULL,
	[Restorable] [bit] NOT NULL,
	[DeleteIsForMigration] [bit] NOT NULL,
	[LockTime] [datetime] NULL,
 CONSTRAINT [SiteDeletion_TimeId] PRIMARY KEY CLUSTERED 
(
	[DeletionTime] ASC,
	[Id] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [SiteDeletion] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ScheduledWorkItems](
	[SiteId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[DeliveryDate] [datetime] NOT NULL,
	[Type] [uniqueidentifier] NOT NULL,
	[ParentId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ItemGuid] [varbinary](16) NULL,
	[BatchId] [varbinary](16) NULL,
	[WebId] [varbinary](16) NULL,
	[UserId] [int] NOT NULL,
	[Created] [datetime] NULL,
	[BinaryPayload] [varbinary](max) NULL,
	[TextPayload] [nvarchar](max) NULL,
	[ProcessingId] [uniqueidentifier] NULL,
	[ProcessMachineId] [uniqueidentifier] NULL,
	[ProcessMachinePID] [int] NULL,
	[InternalState] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [ScheduledWorkItems] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SchedSubscriptions](
	[Id] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[NotifyFreq] [int] NOT NULL,
	[NotifyTime] [datetime] NULL,
	[NotifyTimeUTC] [datetime] NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NULL,
	[EventType] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[UserEmail] [nvarchar](255) NOT NULL,
	[SiteUrl] [nvarchar](136) NOT NULL,
	[WebUrl] [nvarchar](256) NOT NULL,
	[WebTitle] [nvarchar](255) NULL,
	[WebLanguage] [int] NOT NULL,
	[WebLocale] [int] NOT NULL,
	[WebTimeZone] [smallint] NOT NULL,
	[WebTime24] [bit] NULL,
	[WebCalendarType] [smallint] NULL,
	[WebAdjustHijriDays] [smallint] NULL,
	[ListUrl] [nvarchar](256) NOT NULL,
	[ListTitle] [nvarchar](255) NOT NULL,
	[ListBaseType] [int] NOT NULL,
	[ListServerTemplate] [int] NOT NULL,
	[AlertTitle] [nvarchar](1000) NULL,
	[AlertType] [tinyint] NULL,
	[AlwaysNotifyBit] [bit] NULL,
	[SystemBit] [bit] NULL,
	[AlertTemplateName] [nvarchar](255) NULL,
	[Filter] [nvarchar](4000) NULL,
	[BinaryFilter] [varbinary](2048) NULL,
	[Properties] [nvarchar](max) NULL,
	[Status] [tinyint] NOT NULL,
	[ItemDocId] [uniqueidentifier] NULL,
	[Deleted] [bit] NOT NULL,
	[DeliveryChannel] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [SchedSubscriptions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CollationNames](
	[CollationName] [nvarchar](48) NOT NULL,
	[Collation] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [CollationNames] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BuildDependencies](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DirName] [nvarchar](256) NOT NULL,
	[LeafName] [nvarchar](128) NOT NULL,
	[TargetDirName] [nvarchar](256) NOT NULL,
	[TargetLeafName] [nvarchar](128) NOT NULL,
	[DirectDependency] [bit] NOT NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [BuildDependencies] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AuditData](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ItemId] [uniqueidentifier] NOT NULL,
	[ItemType] [smallint] NOT NULL,
	[UserId] [int] NULL,
	[AppPrincipalId] [int] NULL,
	[MachineName] [nvarchar](128) NULL,
	[MachineIp] [nvarchar](20) NULL,
	[DocLocation] [nvarchar](260) NULL,
	[LocationType] [tinyint] NULL,
	[Occurred] [datetime] NOT NULL,
	[Event] [int] NOT NULL,
	[EventName] [nvarchar](128) NULL,
	[EventSource] [tinyint] NOT NULL,
	[SourceName] [nvarchar](256) NULL,
	[EventData] [nvarchar](max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [AuditData] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppTasks](
	[JobId] [uniqueidentifier] NOT NULL,
	[TaskId] [uniqueidentifier] NOT NULL,
	[TaskType] [nvarchar](600) NOT NULL,
	[TaskData] [varbinary](max) NOT NULL,
	[PulledTime] [datetime] NULL,
	[FinishedTime] [datetime] NULL,
	[Retries] [int] NOT NULL,
	[TaskCloneId] [uniqueidentifier] NULL,
	[EstimatedDurationMinutes] [int] NOT NULL,
	[RegisteredTime] [datetime] NOT NULL,
	[TimeoutTime] [datetime] NULL,
	[IsRollback] [bit] NOT NULL,
	[TaskOperation] [int] NOT NULL,
	[CancelledWhileInProgress] [bit] NOT NULL,
	[LastPullerHostName] [nvarchar](255) NULL,
	[IsolationKey] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppTasks_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[TaskId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppTasks] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppTaskDependencies](
	[TaskId] [uniqueidentifier] NOT NULL,
	[DependsOnTaskId] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppTaskDependencies_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[TaskId] ASC,
	[DependsOnTaskId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppTaskDependencies] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppSubscriptionCosts](
	[SubscriptionId] [uniqueidentifier] NOT NULL,
	[Cost] [bigint] NOT NULL,
 CONSTRAINT [AppSubscriptionCosts_PK] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppSubscriptionCosts] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppSourceInfo](
	[SourceInfoId] [uniqueidentifier] NOT NULL,
	[AppSource] [tinyint] NOT NULL,
	[PackageFingerprint] [binary](64) NOT NULL,
	[UpdateAvailable] [bit] NOT NULL,
	[IsDisabled] [bit] NOT NULL,
	[SourceState] [tinyint] NOT NULL,
	[ContentMarket] [nvarchar](10) NULL,
	[AssetId] [nvarchar](16) NULL,
	[TempIconUrl] [nvarchar](2080) NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppSourceInfo_SourceInfoId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[SourceInfoId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppSourceInfo] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppRuntimeSubstitutionDictionary](
	[AppInstanceId] [uniqueidentifier] NOT NULL,
	[ValueKey] [nvarchar](50) NOT NULL,
	[ValueString] [nvarchar](2080) NULL,
	[ValueWebId] [uniqueidentifier] NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppRuntimeSubstitutionDictionary_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[AppInstanceId] ASC,
	[ValueKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppRuntimeSubstitutionDictionary] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppRuntimeMetadata](
	[AppInstanceId] [uniqueidentifier] NOT NULL,
	[IsUpgrading] [bit] NOT NULL,
	[IsInstalled] [bit] NOT NULL,
	[IsKilled] [bit] NOT NULL,
	[OAuthAppId] [nvarchar](256) NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppRuntimeMetadata_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[AppInstanceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppRuntimeMetadata] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppRuntimeIcons](
	[AppInstanceId] [uniqueidentifier] NOT NULL,
	[IconId] [uniqueidentifier] NOT NULL,
	[Icon] [varbinary](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IconFormat] [tinyint] NOT NULL,
	[PackageFingerprint] [varbinary](64) NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppRuntimeIcons_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[AppInstanceId] ASC,
	[IconId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppRuntimeIcons] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppResources](
	[PackageFingerprint] [binary](64) NOT NULL,
	[LanguageCultureId] [int] NOT NULL,
	[Name] [nvarchar](520) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppResources_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[PackageFingerprint] ASC,
	[LanguageCultureId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppResources] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppPrincipals](
	[SiteId] [uniqueidentifier] NOT NULL,
	[Id] [int] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Flag] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AppPrincipals] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppPrincipalPerms](
	[SiteId] [uniqueidentifier] NOT NULL,
	[Id] [int] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[Perm] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AppPrincipalPerms] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppPackages](
	[PackageFingerprint] [binary](64) NOT NULL,
	[ProductId] [uniqueidentifier] NOT NULL,
	[Package] [varbinary](max) NULL,
	[VersionMajor] [int] NOT NULL,
	[VersionMinor] [int] NOT NULL,
	[VersionBuild] [int] NOT NULL,
	[VersionRevision] [int] NOT NULL,
	[Title] [nvarchar](512) NULL,
	[TitleToken] [nvarchar](520) NULL,
	[IsDownloadInvalidated] [bit] NOT NULL,
	[DownloadProgress] [float] NOT NULL,
	[IsDownloadComplete] [bit] NOT NULL,
	[LastDownloadProgressUpdate] [datetime] NOT NULL,
	[Manifest] [varbinary](max) NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppPackages_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[PackageFingerprint] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppPackages] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppLifecycleErrors](
	[InstallationId] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[ErrorDetails] [nvarchar](max) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AppLifecycleErrors] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppJobs](
	[Id] [uniqueidentifier] NOT NULL,
	[InstallationId] [uniqueidentifier] NOT NULL,
	[Operation] [int] NOT NULL,
	[IsCancelled] [bit] NOT NULL,
	[IsManuallyCancelled] [bit] NOT NULL,
	[IsCommitted] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[JobCreatorId] [int] NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppJobs_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppJobs] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppInstallations](
	[Id] [uniqueidentifier] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[InError] [bit] NOT NULL,
	[SourceInfoId] [uniqueidentifier] NOT NULL,
	[PreviousSourceInfoId] [uniqueidentifier] NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[OAuthAppId] [nvarchar](256) NULL,
	[LaunchUrl] [nvarchar](2080) NULL,
	[AppWebId] [uniqueidentifier] NULL,
	[RemoteAppUrl] [nvarchar](2080) NULL,
	[CreationTime] [datetime] NOT NULL,
	[TenantAppDataUpdateTime] [datetime] NULL,
	[TenantAppData] [nvarchar](max) NULL,
	[SiteSubscriptionId] [uniqueidentifier] NOT NULL,
	[LastJobOperation] [int] NOT NULL,
	[WasLastJobCancelled] [bit] NOT NULL,
	[WasLastJobManuallyCancelled] [bit] NOT NULL,
	[IsIconHosted] [bit] NOT NULL,
	[CreatorId] [int] NOT NULL,
	[DisableAuthority] [tinyint] NOT NULL,
	[AsyncDownloadAppSourceInfoId] [uniqueidentifier] NULL,
	[InstallationLocale] [int] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[QuotaCounterState] [tinyint] NULL,
	[SettingsPageUrl] [nvarchar](2080) NULL,
 CONSTRAINT [AppInstallations_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppInstallations] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppInstallationProperty](
	[InstallationId] [uniqueidentifier] NOT NULL,
	[TaskType] [nvarchar](256) NOT NULL,
	[ValueKey] [nvarchar](2080) NOT NULL,
	[Value] [nvarchar](2080) NULL,
	[IsolationKey] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AppInstallationProperty] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AppDatabaseMetadata](
	[AppInstallationId] [uniqueidentifier] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[ReferenceId] [uniqueidentifier] NOT NULL,
	[TargetAppId] [nvarchar](256) NULL,
	[AppSource] [tinyint] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AppDatabaseMetadata_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[AppInstallationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AppDatabaseMetadata] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllWebs](
	[Id] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[FullUrl] [nvarchar](256) NOT NULL,
	[ParentWebId] [uniqueidentifier] NULL,
	[ProductVersion] [smallint] NOT NULL,
	[TemplateVersion] [smallint] NOT NULL,
	[FirstUniqueAncestorWebId] [uniqueidentifier] NOT NULL,
	[Author] [int] NOT NULL,
	[Title] [nvarchar](255) NULL,
	[TimeCreated] [datetime] NOT NULL,
	[CachedNavDirty] [int] NOT NULL,
	[CachedNav] [varbinary](max) NULL,
	[CachedInheritedNav] [varbinary](max) NULL,
	[CachedNavScope] [nvarchar](max) NULL,
	[CachedDataVersion] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL,
	[ScopeId] [uniqueidentifier] NOT NULL,
	[SecurityProvider] [uniqueidentifier] NULL,
	[MetaInfo] [varbinary](max) NULL,
	[MetaInfoVersion] [int] NOT NULL,
	[LastMetadataChange] [datetime] NOT NULL,
	[NavStructNextEid] [int] NOT NULL,
	[NavParentWebId] [uniqueidentifier] NULL,
	[NextWebGroupId] [int] NOT NULL,
	[DefTheme] [nvarchar](64) NULL,
	[AlternateCSSUrl] [nvarchar](260) NULL,
	[CustomizedCss] [nvarchar](260) NULL,
	[CustomJSUrl] [nvarchar](260) NULL,
	[AlternateHeaderUrl] [nvarchar](260) NULL,
	[DailyUsageData] [varbinary](max) NULL,
	[DailyUsageDataVersion] [int] NOT NULL,
	[MonthlyUsageData] [varbinary](max) NULL,
	[MonthlyUsageDataVersion] [int] NOT NULL,
	[DayLastAccessed] [smallint] NOT NULL,
	[WebTemplate] [int] NOT NULL,
	[Language] [int] NOT NULL,
	[Locale] [int] NOT NULL,
	[TimeZone] [smallint] NOT NULL,
	[Time24] [bit] NULL,
	[CalendarType] [smallint] NULL,
	[AdjustHijriDays] [smallint] NULL,
	[MeetingCount] [smallint] NOT NULL,
	[ProvisionConfig] [smallint] NOT NULL,
	[Flags] [int] NOT NULL,
	[Collation] [smallint] NOT NULL,
	[RequestAccessEmail] [nvarchar](255) NULL,
	[MasterUrl] [nvarchar](260) NULL,
	[CustomMasterUrl] [nvarchar](260) NULL,
	[SiteLogoUrl] [nvarchar](260) NULL,
	[SiteLogoDescription] [nvarchar](255) NULL,
	[AuditFlags] [int] NULL,
	[InheritAuditFlags] [int] NULL,
	[Ancestry] [varbinary](max) NULL,
	[AltCalendarType] [tinyint] NULL,
	[CalendarViewOptions] [tinyint] NULL,
	[WorkDays] [smallint] NULL,
	[WorkDayStartHour] [smallint] NULL,
	[WorkDayEndHour] [smallint] NULL,
	[UIVersion] [tinyint] NULL,
	[ClientTag] [smallint] NOT NULL,
	[AllowMUI] [bit] NOT NULL,
	[AppInstanceId] [uniqueidentifier] NOT NULL,
	[AppWebDomainId] [varchar](8) NULL,
 CONSTRAINT [Webs_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllWebs] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllLookupRelationships](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[LookupListId] [uniqueidentifier] NOT NULL,
	[DeleteBehavior] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AllLookupRelationships] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllListUniqueFields](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AllListUniqueFields_Forward] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[ListId] ASC,
	[FieldId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllListUniqueFields] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllListsPlus](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[TitleResource] [nvarchar](520) NULL,
	[DescriptionResource] [nvarchar](520) NULL,
	[DataSource] [nvarchar](max) NULL,
	[EntityId] [int] NULL,
	[ValidationFormula] [nvarchar](1024) NULL,
	[ValidationMessage] [nvarchar](1024) NULL,
 CONSTRAINT [AllListsPlus_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[ListId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllListsPlus] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllListsItemCount](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ListID] [uniqueidentifier] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[BumpLastDeleted] [bit] NOT NULL,
	[SessionId] [smallint] NOT NULL,
 CONSTRAINT [AllListsItemCount_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[SessionId] ASC,
	[ListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllListsItemCount] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllListsAux](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ListID] [uniqueidentifier] NOT NULL,
	[Modified] [datetime] NOT NULL,
	[LastDeleted] [datetime] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[NextAvailableId] [int] NOT NULL,
	[Followable] [bit] NOT NULL,
 CONSTRAINT [AllListsAux_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[ListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllListsAux] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllLinks](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL,
	[ParentId] [uniqueidentifier] NOT NULL,
	[DocId] [uniqueidentifier] NOT NULL,
	[WebPartId] [uniqueidentifier] NULL,
	[FieldId] [uniqueidentifier] NULL,
	[LinkNumber] [int] NOT NULL,
	[TargetDirName] [nvarchar](256) NOT NULL,
	[TargetLeafName] [nvarchar](128) NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Security] [tinyint] NOT NULL,
	[Dynamic] [tinyint] NOT NULL,
	[ServerRel] [bit] NOT NULL,
	[PointsToDir] [bit] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Search] [nvarchar](max) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AllLinks] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllFileFragments](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DocId] [uniqueidentifier] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Partition] [tinyint] NOT NULL,
	[Tag] [varbinary](40) NULL,
	[BlobData] [varbinary](max) NULL,
	[BlobSize] [int] NOT NULL,
 CONSTRAINT [AllFileFragments_PartId_UCI] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DocId] ASC,
	[Partition] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AllFileFragments] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EventBatches](
	[EventTime] [datetime] NOT NULL,
	[Id] [bigint] NOT NULL,
 CONSTRAINT [EventBatches_PK] PRIMARY KEY CLUSTERED 
(
	[EventTime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [EventBatches] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DocStreams](
	[DocId] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[Partition] [tinyint] NOT NULL,
	[BSN] [bigint] NOT NULL,
	[Size] [int] NOT NULL,
	[Content] [varbinary](max) NULL,
	[RbsId] [varbinary](64) NULL,
	[Type] [tinyint] NOT NULL,
	[ExpirationUTC] [datetime] SPARSE  NULL,
 CONSTRAINT [DocStreams_CI] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DocId] ASC,
	[Partition] ASC,
	[BSN] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DocStreams] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DocsToStreams](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DocId] [uniqueidentifier] NOT NULL,
	[HistVersion] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Partition] [tinyint] NOT NULL,
	[BSN] [bigint] NOT NULL,
	[StreamId] [bigint] NOT NULL,
 CONSTRAINT [DocsToStreams_CI] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DocId] ASC,
	[HistVersion] ASC,
	[Level] ASC,
	[Partition] ASC,
	[BSN] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DocsToStreams] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DiskWarningDate](
	[lastDiskWarningDate] [datetime] NOT NULL,
 CONSTRAINT [DiskWarningDate_PK] PRIMARY KEY CLUSTERED 
(
	[lastDiskWarningDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DiskWarningDate] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deps](
	[SiteId] [uniqueidentifier] NOT NULL,
	[DeleteTransactionId] [varbinary](16) NOT NULL,
	[FullUrl] [nvarchar](260) NOT NULL,
	[DepType] [tinyint] NOT NULL,
	[DepDesc] [nvarchar](270) NOT NULL,
	[Level] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Deps] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DatabaseInformation](
	[Name] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatabaseInformation] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CustomActions](
	[Id] [uniqueidentifier] NOT NULL,
	[ScopeId] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[FeatureId] [uniqueidentifier] NULL,
	[ScopeType] [int] NOT NULL,
	[Properties] [nvarchar](max) NOT NULL,
	[Version] [nvarchar](64) NOT NULL,
	[SolutionId] [uniqueidentifier] NULL,
	[SolutionWebId] [uniqueidentifier] NULL,
	[SolutionLevel] [int] NOT NULL,
 CONSTRAINT [CustomActions_SiteWebScopeLevelId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC,
	[ScopeId] ASC,
	[SolutionLevel] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [CustomActions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Vietnamese_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Vietnamese_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Uzbek_Latin_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Uzbek_Latin_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Ukrainian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Ukrainian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Turkish_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Turkish_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Traditional_Spanish_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Traditional_Spanish_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Thai_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Thai_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Tatar_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Tatar_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Syriac_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Syriac_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Slovenian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Slovenian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Slovak_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Slovak_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Romanian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Romanian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Polish_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Polish_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Modern_Spanish_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Modern_Spanish_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Macedonian_FYROM_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Macedonian_FYROM_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Lithuanian_Classic_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Lithuanian_Classic_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Lithuanian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Lithuanian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Latvian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Latvian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Latin1_General_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Latin1_General_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Korean_Wansung_Unicode_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Korean_Wansung_Unicode_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Korean_Wansung_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Korean_Wansung_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Kazakh_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Kazakh_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Japanese_Unicode_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Japanese_Unicode_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Japanese_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Japanese_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Indic_General_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Indic_General_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Icelandic_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Icelandic_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Hungarian_Technical_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Hungarian_Technical_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Hungarian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Hungarian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Hindi_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Hindi_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Hebrew_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Hebrew_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Greek_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Greek_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_German_PhoneBook_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_German_PhoneBook_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Georgian_Modern_Sort_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Georgian_Modern_Sort_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_French_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_French_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Finnish_Swedish_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Finnish_Swedish_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Estonian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Estonian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Divehi_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Divehi_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Danish_Norwegian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Danish_Norwegian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Czech_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Czech_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Cyrillic_General_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Cyrillic_General_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Croatian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Croatian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Chinese_Taiwan_Stroke_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Chinese_Taiwan_Stroke_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Chinese_Taiwan_Bopomofo_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Chinese_Taiwan_Bopomofo_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Chinese_Simplified_Pinyin_100_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Chinese_Simplified_Pinyin_100_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Chinese_PRC_Stroke_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Chinese_PRC_Stroke_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Chinese_Hong_Kong_Stroke_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Chinese_Hong_Kong_Stroke_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Azeri_Latin_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Azeri_Latin_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Azeri_Cyrillic_90_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Azeri_Cyrillic_90_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Arabic_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Arabic_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair_Albanian_CI_AS](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair_Albanian_CI_AS] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NameValuePair](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [sql_variant] NULL,
	[ItemId] [int] NOT NULL,
	[Level] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [NameValuePair] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ImmedSubscriptions](
	[Id] [uniqueidentifier] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[ItemId] [int] NULL,
	[EventType] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[UserEmail] [nvarchar](255) NOT NULL,
	[SiteUrl] [nvarchar](136) NOT NULL,
	[WebUrl] [nvarchar](256) NOT NULL,
	[WebTitle] [nvarchar](255) NULL,
	[WebLanguage] [int] NOT NULL,
	[WebLocale] [int] NOT NULL,
	[WebTimeZone] [smallint] NOT NULL,
	[WebTime24] [bit] NULL,
	[WebCalendarType] [smallint] NULL,
	[WebAdjustHijriDays] [smallint] NULL,
	[ListUrl] [nvarchar](256) NOT NULL,
	[ListTitle] [nvarchar](255) NOT NULL,
	[ListBaseType] [int] NOT NULL,
	[ListServerTemplate] [int] NOT NULL,
	[AlertTitle] [nvarchar](1000) NULL,
	[AlertType] [tinyint] NULL,
	[AlwaysNotifyBit] [bit] NULL,
	[SystemBit] [bit] NULL,
	[AlertTemplateName] [nvarchar](255) NULL,
	[Filter] [nvarchar](4000) NULL,
	[BinaryFilter] [varbinary](2048) NULL,
	[Properties] [nvarchar](max) NULL,
	[Status] [tinyint] NOT NULL,
	[ItemDocId] [uniqueidentifier] NULL,
	[Deleted] [bit] NOT NULL,
	[DeliveryChannel] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ImmedSubscriptions] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HT_Settings](
	[key] [nchar](10) NOT NULL,
	[value] [bigint] NULL,
 CONSTRAINT [HT_Setting_PK] PRIMARY KEY CLUSTERED 
(
	[key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [HT_Settings] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HT_Cache](
	[TimeStamp] [smalldatetime] NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[DirName] [nvarchar](256) NOT NULL,
	[LeafName] [nvarchar](128) NOT NULL,
	[TransName] [nvarchar](128) NOT NULL,
	[JobType] [tinyint] NOT NULL,
	[STSDocVersion] [datetime] NOT NULL,
	[File] [varbinary](max) NULL,
	[FileSize] [int] NOT NULL,
	[MainFile] [bit] NOT NULL,
 CONSTRAINT [HT_Cache_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DirName] ASC,
	[LeafName] ASC,
	[TransName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [HT_Cache] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Groups](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ID] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[Owner] [int] NOT NULL,
	[OwnerIsUser] [bit] NOT NULL,
	[DLAlias] [nvarchar](128) NULL,
	[DLErrorMessage] [nvarchar](512) NULL,
	[DLFlags] [int] NULL,
	[DLJobId] [int] NULL,
	[DLArchives] [varchar](4000) NULL,
	[RequestEmail] [nvarchar](255) NULL,
	[Flags] [int] NOT NULL,
	[DeletionWebId] [uniqueidentifier] NULL,
 CONSTRAINT [Groups_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Groups] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GroupMembership](
	[SiteId] [uniqueidentifier] NOT NULL,
	[GroupId] [int] NOT NULL,
	[MemberId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [GroupMembership] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FeatureTracking](
	[SiteId] [uniqueidentifier] NOT NULL,
	[FeatureId] [uniqueidentifier] NOT NULL,
	[SolutionId] [uniqueidentifier] NULL,
	[FirstActivated] [datetime] NOT NULL,
	[LastActivated] [datetime] NOT NULL,
	[FeatureTitle] [nvarchar](max) NULL,
	[FeatureDescription] [nvarchar](max) NULL,
	[FolderName] [nvarchar](max) NULL,
 CONSTRAINT [FeatureTracking_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[FeatureId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [FeatureTracking] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Features](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[FeatureId] [uniqueidentifier] NOT NULL,
	[Version] [nvarchar](64) NOT NULL,
	[TimeActivated] [datetime] NOT NULL,
	[Flags] [int] NOT NULL,
	[Properties] [nvarchar](max) NULL,
	[PropertiesModified] [datetime] NOT NULL,
	[SolutionId] [uniqueidentifier] NULL,
	[SolutionWebId] [uniqueidentifier] NULL,
	[SolutionLevel] [int] NOT NULL,
 CONSTRAINT [Features_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC,
	[SolutionLevel] ASC,
	[FeatureId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Features] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EventSubsMatches](
	[SiteId] [uniqueidentifier] NOT NULL,
	[SubId] [uniqueidentifier] NOT NULL,
	[EventId] [bigint] NOT NULL,
	[LookupFieldPermissionResults] [varbinary](max) NULL,
 CONSTRAINT [EventSubsMatches_EventIdSubId] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[SubId] ASC,
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [EventSubsMatches] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WorkflowAssociation](
	[Id] [uniqueidentifier] NOT NULL,
	[BaseId] [uniqueidentifier] NOT NULL,
	[ParentId] [varbinary](16) NULL,
	[Name] [nvarchar](255) NULL,
	[Description] [nvarchar](1023) NULL,
	[StatusFieldName] [nvarchar](64) NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [varbinary](16) NULL,
	[ListId] [varbinary](16) NULL,
	[ContentTypeId] [dbo].[tContentTypeId] NULL,
	[InstanceCount] [int] NULL,
	[InstanceCountDirty] [bit] NULL,
	[TaskListId] [varbinary](16) NULL,
	[HistoryListId] [varbinary](16) NULL,
	[TaskListTitle] [nvarchar](255) NULL,
	[HistoryListTitle] [nvarchar](255) NULL,
	[Configuration] [int] NULL,
	[AutoCleanupDays] [int] NULL,
	[Author] [int] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[InstantiationParams] [nvarchar](max) NULL,
	[PermissionsManual] [dbo].[tPermMask] NULL,
	[Version] [int] NULL,
 CONSTRAINT [WorkflowAssociation_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [WorkflowAssociation] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EventReceivers](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[HostId] [uniqueidentifier] NOT NULL,
	[HostType] [int] NOT NULL,
	[ItemId] [int] NULL,
	[DirName] [nvarchar](256) NULL,
	[LeafName] [nvarchar](128) NULL,
	[Synchronization] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
	[SolutionId] [uniqueidentifier] NULL,
	[RemoteUrl] [nvarchar](4000) NULL,
	[Assembly] [nvarchar](256) NULL,
	[Class] [nvarchar](256) NULL,
	[Data] [nvarchar](256) NULL,
	[Filter] [nvarchar](256) NULL,
	[SourceId] [dbo].[tContentTypeId] NULL,
	[SourceType] [int] NOT NULL,
	[Credential] [int] NOT NULL,
	[ContextType] [varbinary](16) NULL,
	[ContextEventType] [varbinary](16) NULL,
	[ContextId] [varbinary](16) NULL,
	[ContextObjectId] [varbinary](16) NULL,
	[ContextCollectionId] [varbinary](16) NULL,
 CONSTRAINT [EventReceivers_PK] PRIMARY KEY NONCLUSTERED 
(
	[SiteId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [EventReceivers] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EventCache](
	[EventTime] [datetime] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NULL,
	[ListId] [uniqueidentifier] NULL,
	[ItemId] [int] NULL,
	[DocId] [uniqueidentifier] NULL,
	[Guid0] [uniqueidentifier] NULL,
	[Int0] [int] NULL,
	[Int1] [int] NULL,
	[ContentTypeId] [dbo].[tContentTypeId] NULL,
	[ItemName] [nvarchar](255) NULL,
	[ItemFullUrl] [nvarchar](260) NULL,
	[EventType] [int] NOT NULL,
	[ObjectType] [int] NOT NULL,
	[ModifiedBy] [nvarchar](255) NULL,
	[TimeLastModified] [datetime] NOT NULL,
	[EventData] [varbinary](max) NULL,
	[ACL] [varbinary](max) NULL,
	[DocClientId] [varbinary](16) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
 CONSTRAINT [EventCache_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [EventCache] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ContentTypeUsage](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ContentTypeId] [dbo].[tContentTypeId] NOT NULL,
	[WebId] [uniqueidentifier] NULL,
	[ListId] [uniqueidentifier] NOT NULL,
	[IsFieldId] [bit] NULL,
	[Class] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ContentTypeUsage] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Roles](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[RoleId] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[PermMask] [dbo].[tPermMask] NULL,
	[PermMaskDeny] [dbo].[tPermMask] NULL,
	[Hidden] [bit] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[WebGroupId] [int] NOT NULL,
	[RoleOrder] [int] NOT NULL,
 CONSTRAINT [Roles_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[WebId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Roles] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserInfo](
	[tp_SiteID] [uniqueidentifier] NOT NULL,
	[tp_ID] [int] NOT NULL,
	[tp_DomainGroup] [bit] NOT NULL,
	[tp_SystemID] [dbo].[tSystemID] NOT NULL,
	[tp_Deleted] [int] NOT NULL,
	[tp_SiteAdmin] [bit] NOT NULL,
	[tp_IsActive] [bit] NOT NULL,
	[tp_Login] [nvarchar](255) NOT NULL,
	[tp_Title] [nvarchar](255) NOT NULL,
	[tp_Email] [nvarchar](255) NOT NULL,
	[tp_Notes] [nvarchar](1023) NOT NULL,
	[tp_Token] [varbinary](max) NULL,
	[tp_ExternalToken] [varbinary](max) NULL,
	[tp_ExternalTokenLastUpdated] [datetime] NULL,
	[tp_Locale] [int] NULL,
	[tp_CalendarType] [smallint] NULL,
	[tp_AdjustHijriDays] [smallint] NULL,
	[tp_TimeZone] [smallint] NULL,
	[tp_Time24] [bit] NULL,
	[tp_AltCalendarType] [tinyint] NULL,
	[tp_CalendarViewOptions] [tinyint] NULL,
	[tp_WorkDays] [smallint] NULL,
	[tp_WorkDayStartHour] [smallint] NULL,
	[tp_WorkDayEndHour] [smallint] NULL,
	[tp_Mobile] [nvarchar](127) NULL,
	[tp_MUILanguages] [varchar](64) NULL,
	[tp_ContentLanguages] [varchar](64) NULL,
	[tp_Flags] [int] NOT NULL,
 CONSTRAINT [UserInfo_PK] PRIMARY KEY CLUSTERED 
(
	[tp_SiteID] ASC,
	[tp_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [UserInfo] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllWebParts](
	[tp_SiteId] [uniqueidentifier] NOT NULL,
	[tp_ID] [uniqueidentifier] NOT NULL,
	[tp_ListId] [uniqueidentifier] NULL,
	[tp_Type] [tinyint] NULL,
	[tp_Flags] [int] NULL,
	[tp_BaseViewID] [tinyint] NULL,
	[tp_DisplayName] [nvarchar](255) NULL,
	[tp_Version] [int] NULL,
	[tp_PageUrlID] [uniqueidentifier] NOT NULL,
	[tp_PartOrder] [int] NULL,
	[tp_ZoneID] [nvarchar](64) NULL,
	[tp_IsIncluded] [bit] NOT NULL,
	[tp_FrameState] [tinyint] NOT NULL,
	[tp_View] [dbo].[tCompressedString] NULL,
	[tp_WebPartTypeId] [uniqueidentifier] NULL,
	[tp_AllUsersProperties] [varbinary](max) NULL,
	[tp_PerUserProperties] [varbinary](max) NULL,
	[tp_Cache] [varbinary](max) NULL,
	[tp_UserID] [int] NULL,
	[tp_Source] [nvarchar](max) NULL,
	[tp_CreationTime] [datetime] NOT NULL,
	[tp_Size] [bigint] NOT NULL,
	[tp_Level] [tinyint] NOT NULL,
	[tp_Deleted] [bit] NOT NULL,
	[tp_HasFGP] [bit] NOT NULL,
	[tp_ContentTypeId] [dbo].[tContentTypeId] NOT NULL,
	[tp_PageVersion] [int] NOT NULL,
	[tp_SolutionId] [uniqueidentifier] NULL,
	[tp_IsCurrentVersion] [bit] NOT NULL,
	[tp_Assembly] [nvarchar](255) NULL,
	[tp_Class] [nvarchar](255) NULL,
	[tp_WebPartIdProperty] [nvarchar](255) NULL,
	[tp_SolutionWebId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [AllWebParts] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AllSites](
	[FullUrl] [nvarchar](260) NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[RootWebId] [uniqueidentifier] NULL,
	[ClientTag] [smallint] NOT NULL,
	[NextUserOrGroupId] [int] NOT NULL,
	[NextAppPrincipalId] [int] NOT NULL,
	[OwnerID] [int] NOT NULL,
	[SecondaryContactID] [int] NULL,
	[Subscribed] [bit] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[UsersCount] [int] NULL,
	[BWUsed] [bigint] NULL,
	[DiskUsed] [bigint] NULL,
	[SecondStageDiskUsed] [bigint] NULL,
	[QuotaTemplateID] [smallint] NULL,
	[DiskQuota] [bigint] NULL,
	[UserQuota] [int] NULL,
	[DiskWarning] [bigint] NULL,
	[DiskWarned] [datetime] NULL,
	[CurrentResourceUsage] [float] NOT NULL,
	[AverageResourceUsage] [float] NOT NULL,
	[ResourceUsageWarning] [float] NOT NULL,
	[ResourceUsageMaximum] [float] NOT NULL,
	[BitFlags] [int] NULL,
	[SecurityVersion] [bigint] NULL,
	[DenyPermMask] [dbo].[tPermMask] NOT NULL,
	[CertificationDate] [datetime] NULL,
	[DeadWebNotifyCount] [smallint] NOT NULL,
	[PortalURL] [nvarchar](260) NULL,
	[PortalName] [nvarchar](255) NULL,
	[LastContentChange] [datetime] NOT NULL,
	[LastSecurityChange] [datetime] NOT NULL,
	[AuditFlags] [int] NULL,
	[InheritAuditFlags] [int] NULL,
	[UserInfoListId] [uniqueidentifier] NULL,
	[UserIsActiveFieldRowOrdinal] [int] NULL,
	[UserIsActiveFieldColumnName] [nvarchar](64) NULL,
	[UserAccountDirectoryPath] [nvarchar](512) NULL,
	[HashKey] [binary](16) NULL,
	[DomainGroupMapVersion] [bigint] NOT NULL,
	[DomainGroupMapCacheVersion] [bigint] NOT NULL,
	[DomainGroupMapCache] [varbinary](max) NULL,
	[HostHeader] [nvarchar](128) NULL,
	[SiteUrls] [nvarchar](max) NULL,
	[SubscriptionId] [varbinary](16) NULL,
	[RbsCollectionId] [int] NOT NULL,
	[LastSMRequest] [datetime] NULL,
	[PlatformVersion] [nvarchar](64) NULL,
	[LifeCycleFlags] [int] NOT NULL,
	[SourceSiteId] [uniqueidentifier] SPARSE  NULL,
	[ExpirationDate] [datetime] SPARSE  NULL,
	[EvalSiteId] [uniqueidentifier] SPARSE  NULL,
	[UpgradeReminderDate] [datetime] SPARSE  NULL,
	[SubscriptionName] [nvarchar](48) NULL,
	[AppSiteDomainId] [varchar](6) NULL,
	[NextAppWebDomainId] [binary](4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [AllSites] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Perms](
	[SiteId] [uniqueidentifier] NOT NULL,
	[ScopeId] [uniqueidentifier] NOT NULL,
	[RoleDefWebId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[DelTransId] [varbinary](16) NOT NULL,
	[ScopeUrl] [nvarchar](260) NOT NULL,
	[AnonymousPermMask] [dbo].[tPermMask] NOT NULL,
	[Acl] [varbinary](max) NULL,
 CONSTRAINT [Perms_PK] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[DelTransId] ASC,
	[ScopeUrl] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Perms] SET (LOCK_ESCALATION = DISABLE)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NavNodes](
	[SiteId] [uniqueidentifier] NOT NULL,
	[WebId] [uniqueidentifier] NOT NULL,
	[Eid] [int] NOT NULL,
	[EidParent] [int] NOT NULL,
	[NumChildren] [int] NOT NULL,
	[RankChild] [int] NOT NULL,
	[ElementType] [tinyint] NOT NULL,
	[Url] [nvarchar](260) NULL,
	[DocId] [uniqueidentifier] NULL,
	[Name] [nvarchar](256) NOT NULL,
	[NameResource] [nvarchar](520) NULL,
	[DateLastModified] [datetime] NOT NULL,
	[NodeMetainfo] [varbinary](max) NULL,
	[NonNavPage] [bit] NOT NULL,
	[NavSequence] [bit] NOT NULL,
	[ChildOfSequence] [bit] NOT NULL,
	[IsDocLib] [bit] NOT NULL,
	[QueryString] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
ALTER TABLE [NavNodes] SET (LOCK_ESCALATION = DISABLE)
GO
