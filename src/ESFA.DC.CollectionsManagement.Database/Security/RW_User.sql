CREATE USER [CollectionsManagement_RW_User]
    WITH PASSWORD = N'$(RWUserPassword)';
GO
	GRANT CONNECT TO [CollectionsManagement_RW_User]
GO


