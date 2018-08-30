CREATE USER [CollectionsManagementUser]
    WITH PASSWORD = N'$(CollectionsManagementUserPassword)';
GO
	GRANT CONNECT TO [CollectionsManagementUser]
GO


