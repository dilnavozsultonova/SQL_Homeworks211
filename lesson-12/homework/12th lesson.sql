


DECLARE @DatabaseName SYSNAME;
DECLARE @sql NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
  AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DatabaseName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
    SELECT 
        ''' + @DatabaseName + ''' AS DatabaseName,
        s.name AS SchemaName,
        t.name AS TableName,
        c.name AS ColumnName,
        ty.name AS DataType
    FROM [' + @DatabaseName + '].sys.tables t
    INNER JOIN [' + @DatabaseName + '].sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN [' + @DatabaseName + '].sys.columns c ON t.object_id = c.object_id
    INNER JOIN [' + @DatabaseName + '].sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE t.is_ms_shipped = 0;
    ';
    
    EXEC sp_executesql @sql;

    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;


CREATE OR ALTER PROCEDURE usp_GetRoutineParameters
    @DatabaseName SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @db SYSNAME;

    DECLARE db_cursor CURSOR FOR
    SELECT name
    FROM sys.databases
    WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
      AND state_desc = 'ONLINE'
      AND (@DatabaseName IS NULL OR name = @DatabaseName);

    OPEN db_cursor;
    FETCH NEXT FROM db_cursor INTO @db;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = '
        SELECT 
            ''' + @db + ''' AS DatabaseName,
            s.name AS SchemaName,
            o.name AS RoutineName,
            o.type_desc AS RoutineType,
            p.name AS ParameterName,
            t.name AS DataType,
            p.max_length AS MaxLength,
            p.parameter_id AS ParameterOrder
        FROM [' + @db + '].sys.objects o
        LEFT JOIN [' + @db + '].sys.parameters p ON o.object_id = p.object_id
        LEFT JOIN [' + @db + '].sys.types t ON p.user_type_id = t.user_type_id
        INNER JOIN [' + @db + '].sys.schemas s ON o.schema_id = s.schema_id
        WHERE o.type IN (''P'', ''FN'', ''IF'', ''TF'', ''FS'', ''FT'');
        ';

        EXEC sp_executesql @sql;

        FETCH NEXT FROM db_cursor INTO @db;
    END;

    CLOSE db_cursor;
    DEALLOCATE db_cursor;
END;
