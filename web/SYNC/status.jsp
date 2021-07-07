<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.dps.dbi.DbResult.Record"%>
<%@page import="com.dps.dbi.DbResult"%>
<%@page import="com.dps.sync.DAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    DbResult log_dbr = DAO.readLog();
    
    List<String> tables = Arrays.asList(    
	"ATRANME0",
	"FQUANMT0",
	"FTRELOV0",
	"FTRSPOR0",
	"FTRVIAT0",
	"FTRVISP0",
	"FTRSPIN0",
	"BANTARTIC",
	"SMGORDRIG",
	"SMGORDTES");


%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Synchronization Status</title>
        <link rel="stylesheet" href="status.css">
    </head>
    <body>
        <h1>Synchronization Status</h1>
        
        <table id="logRecords_Table">
            <tr>
                <th>ID</th>
                <th>OVERALL</th>
                
                <%for(String table : tables){%>
                <th><%=table%></th>
                <%}%>
            </tr>
            <%for(Record log : log_dbr){%>
            <tr>
                <td rowspan="3" class="<%=DAO.resultLabel(tables,log)%>"><%=log.getLong("log_id")%></td>

                <td><%=DAO.startTimestamp(tables,log)%></td>
                <%for(String table : tables){%>
                <td class="<%=DAO.resultLabel(table,log)%>"><%=log.getDate("start_"+table)%></td>
                <%}%>
            </tr>

            <tr>
                <td><%=DAO.stopTimestamp(tables,log)%></td>
                <%for(String table : tables){%>
                <td class="<%=DAO.resultLabel(table,log)%>"><%=log.getDate("stop_"+table)%></td>
                <%}%>
            </tr>
            
            <tr>
                <td><%=DAO.elapsed(tables,log)%></td>
                <%for(String table : tables){%>
                <td class="<%=DAO.resultLabel(table,log)%>"><%=DAO.elapsed(table,log)%></td>
                <%}%>
            </tr>
            <%}%>
        </table>
    </body>
</html>
