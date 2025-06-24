--Sending Index Metadata via Email in HTML Format
--Write a SQL Server query to retrieve metadata about indexes and send it via email in a well-formatted HTML table.

--Requirements:

--Extract metadata related to indexes, including:

--Table Name
--Index Name
--Index Type
--Column Type
--Format the results as an HTML table with proper styling.

--Use Database Mail to send the email containing the formatted index metadata.

select distinct 
	t.name as TableName,
	i.name as IndexName,
	i.type_desc as IndexType,
	c.name as ColumnName,
	typ.name as ColumnType
from sys.tables t
	join sys.index_columns ic
		on t.object_id=ic.object_id 
	join sys.indexes as i
		on t.object_id=i.object_id and ic.index_id=i.index_id
	join sys.columns as c
		on c.object_id=i.object_id and c.column_id=ic.column_id
	join sys.types as typ 
		on typ.user_type_id=c.user_type_id
where i.name is not null 
order by t.name,i.name

DECLARE @HTML NVARCHAR(MAX)

-- Begin the HTML Table
SET @HTML = 
    '<html>
    <head>
        <style>
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
        </style>
    </head>
    <body>
    <h3>Index Metadata Report</h3>
    <table>
        <tr>
            <th>Table Name</th>
            <th>Index Name</th>
            <th>Index Type</th>
            <th>Column Name</th>
            <th>Column Type</th>
        </tr>'

-- Append the data rows
SELECT @HTML = @HTML +
    '<tr><td>' + t.name + '</td>' +
    '<td>' + i.name + '</td>' +
    '<td>' + i.type_desc + '</td>' +
    '<td>' + c.name + '</td>' +
    '<td>' + typ.name + '</td></tr>'
FROM sys.tables t
JOIN sys.index_columns ic ON t.object_id = ic.object_id
JOIN sys.indexes i ON t.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns c ON c.object_id = i.object_id AND c.column_id = ic.column_id
JOIN sys.types typ ON typ.user_type_id = c.user_type_id
WHERE i.name IS NOT NULL

-- Close the HTML tags
SET @HTML = @HTML + '</table></body></html>'

-- Optional: Send via email using Database Mail
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'gmailProfile', -- change this
    @recipients = 'dilnavozsultonova96@gmail.com;d.sultonova@newuu.uz',   -- change this
    @subject = 'SQL Server Index Metadata',
    @body = @HTML,
    @body_format = 'HTML';



