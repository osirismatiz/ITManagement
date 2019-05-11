use [BizTalkMgmtDb]
go

SELECT TOP 5000 
s2h.[Id],s2h.[ServerId],s2h.[HostId],s2h.[IsMapped],
s.[Id] as [Server ID],s.[Name] as [Server Name],
h.[Id] as [Host ID],h.[GroupId],h.[Name] as [Host Name],h.[NTGroupName],h.[LastUsedLogon]

FROM [adm_Server2HostMapping] s2h WITH (NOLOCK)
INNER JOIN [adm_Server] s WITH (NOLOCK)
ON s2h.[ServerId] = s.Id
INNER JOIN [adm_Host] h WITH (NOLOCK)
ON s2h.[HostId] = h.[Id]

WHERE s2h.[IsMapped] = '-1'
