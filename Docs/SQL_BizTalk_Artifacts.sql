USE [BizTalkMgmtDb]
go


SELECT HT.Name AS [Host Name], APP.nvcName AS [Application Name], OQ.nvcFullName AS [Artifact Name], 'Orchestration' AS [Artifact Type], SS.nvcFullName AS [URI]
FROM bts_orchestration AS OQ INNER JOIN
 adm_Host AS HT ON OQ.nAdminHostID = HT.Id INNER JOIN
 bts_assembly AS SS ON OQ.nAssemblyID = SS.nID LEFT OUTER JOIN
 bts_application AS APP ON SS.nApplicationID = APP.nID
--WHERE APP.nvcName IN ('GlobalBank.ESB')

UNION  

SELECT adm_Host.Name  AS [Host Name], APP.nvcName AS [Application Name], bts_sendport.nvcName AS [Artifact Name], 'SendPort' AS [Artifact Type], bts_sendport_transport.nvcAddress AS [URI]--, bts_sendport_transport.nTransportTypeId, bts_sendport.bDynamic
FROM bts_application AS APP INNER JOIN
 bts_sendport ON APP.nID = bts_sendport.nApplicationID INNER JOIN
 bts_sendport_transport ON bts_sendport.nID = bts_sendport_transport.nSendPortID INNER JOIN
 adm_SendHandler ON bts_sendport_transport.nSendHandlerID = adm_SendHandler.Id INNER JOIN
 adm_Host ON adm_SendHandler.HostId = adm_Host.Id
--WHERE APP.nvcName IN ('GlobalBank.ESB')

UNION   

SELECT HN.Name AS [Host Name], APP.nvcName AS [Application Name], RL.Name AS [Artifact Name], 'ReceiveLocation' AS [Artifact Type], RL.InboundTransportURL AS URI--, RP.nvcName AS [ReceivePort Name], RL.InboundAddressableURL AS URL
FROM bts_application AS APP INNER JOIN
 bts_receiveport AS RP ON APP.nID = RP.nApplicationID INNER JOIN
 adm_ReceiveLocation AS RL ON RP.nID = RL.ReceivePortId INNER JOIN
 adm_ReceiveHandler AS RH ON RH.Id = RL.ReceiveHandlerId INNER JOIN
 adm_Host AS HN ON HN.Id = RH.HostId
--WHERE APP.nvcName IN ('GlobalBank.ESB')

UNION   

SELECT'' AS [Host Name], APP.nvcName AS [Application Name], bt_DocumentSpec.docspec_name AS [Artifact Name], 'Schema' AS [Artifact Type], SS.nvcFullName AS URI
FROM bt_DocumentSpec INNER JOIN
 bts_assembly AS SS ON bt_DocumentSpec.assemblyid = SS.nID LEFT OUTER JOIN bts_application AS APP ON SS.nApplicationID = APP.nID 
--WHERE APP.nvcName IN ('GlobalBank.ESB')

UNION   

SELECT '' AS [Host Name], APP.nvcName AS [Application Name], bts_item.FullName AS [Artifact Name], 'Map' AS [Artifact Type], SS.nvcFullName AS URI
FROM bts_application AS APP INNER JOIN
 bts_assembly AS SS ON APP.nID = SS.nApplicationID INNER JOIN
 bt_MapSpec ON SS.nID = bt_MapSpec.assemblyid INNER JOIN
 bts_item ON SS.nID = bts_item.AssemblyId AND bt_MapSpec.itemid = bts_item.id
--WHERE APP.nvcName IN ('GlobalBank.ESB')

UNION  

SELECT '' AS [Host Name], APP.nvcName AS [Application Name], bts_pipeline.Name AS [Artifact Name], 'Pipeline' AS [Artifact Type], SS.nvcFullName AS URI
FROM bts_application AS APP INNER JOIN
 bts_assembly AS SS ON APP.nID = SS.nApplicationID INNER JOIN
 bts_pipeline ON SS.nID = bts_pipeline.nAssemblyID
--WHERE APP.nvcName IN ('GlobalBank.ESB')

ORDER BY [Application Name], [Artifact Type], [Artifact Name]
