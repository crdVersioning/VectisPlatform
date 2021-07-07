<%@page import="com.dps.tt.scerni.DAO"%>
<%@page import="com.dps.tt.scerni.TrackingData"%>
<%@page import="java.util.StringJoiner"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.dps.dbi.DbResult.Record"%>
<%@page import="com.dps.dbi.DbResult"%>
<%@page import="com.dps.dbi.impl.SqlServerInterface"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // TODO:
    /*
    
    NOTA: filtro su chargeDate
    NOTA: se manca il documento messaggio: "IN ATTESA DI SCANSIONE" 
    NOTA: dalla lista spedizioni esportare in CSV spedizione + storico
    
    */
    
    SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");
    String NULLDATE = "1900-01-01";
 
    // PARAMETRI DELLA RICERCA
    Date fromDate = new Date(new Date().getTime()-30*24*60*60*1000L);
    Date toDate = new Date();

    try{fromDate = SDF.parse(request.getParameter("fromDate"));}catch(Exception ex){}
    try{toDate = SDF.parse(request.getParameter("toDate"));}catch(Exception ex){}

    String region = request.getParameter("region");

    TrackingData td = DAO.readTrackingData(fromDate,toDate,region);
    
    DbResult deliveries_dbr = td.deliveries_dbr;
    DbResult anomalies_dbr = td.anomalies_dbr;
    Map<Integer,String> states = td.states;
    String errorMessage = td.errorMessage;
    String exceptionMessage = td.exceptionMessage;
    String regionPattern = td.regionPattern;

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SCERNI TRACK&TRACE</title>
        <link rel="stylesheet" href="/Vectis/katana.css">
        <link rel="stylesheet" href="/Vectis/TT/SCERNI/common.css">
        <link rel="stylesheet" href="/Vectis/TT/SCERNI/multitrack.css">
        <link rel="icon" href="/Vectis/RESOURCES/TRANS_LOGO.png" type="image/png" />
    </head>
    <body>
        <%if(!session.isNew()){%>
        
        <div id="pageHeader">
            <span id="headerTitle">
                DAL <%=fromDate!=null ? SDF.format(fromDate) : "-"%>
                AL <%=toDate!=null ? SDF.format(toDate) : "-"%>
                PER <%=region!=null ? region : "TUTTE LE REGIONI"%>
            </span>
            <div class="RightContainer">
                <%=deliveries_dbr.rowsCount()<1000 ? deliveries_dbr.rowsCount() : "1000+"%>
                SPEDIZIONI
            </div>
            <div class="LeftContainer">
                <span class="Button Operation" onclick="APP.downloadCSV();">SCARICA CSV</span>
            </div>                
        </div>

        <table id="deliveries">
            <thead>
                <tr>
                    <th>NUMERO BOLLA</th>

                    <th>DATA PRESA IN CARICO</th>
                    <th>DATA VIAGGIO</th>
                    <th>DATA DI CONSEGNA</th>

                    <th>DESTINATARIO</th>

                    <th>STATO</th>
                    <th>DOCUMENTO</th>
                </tr>
            </thead>
            <tbody>
                <%for(Record delivery : deliveries_dbr)
                {
                    Integer delivery_key = delivery.getInteger("delivery_key");
                    StringJoiner title = new StringJoiner("\n");
                    
                    for(Record anomaly : delivery.getDbr("anomalies"))
                        title.add(anomaly.getString("label")+"\t"+
                            (anomaly.getDate("date")!= null ? SDF.format(anomaly.getDate("date")) : "-")+"\t"+
                            (anomaly.getString("description1")+(anomaly.getString("description2")!=null ? ", "+anomaly.getString("description2") : ""))+"\t"+
                            anomaly.getString("note"));
                %>
                <tr id="delivery_<%=delivery_key%>" title="<%=title%>" onclick="APP.searchSingleTrack(<%=delivery_key%>);">
                    <td class="Minimum"><%=delivery.getString("shipmentDocNumber")%></td>

                    <td class="Minimum"><%=delivery.getDate("chargeDate")!=null ? SDF.format(delivery.getDate("chargeDate")) : "-"%></td>
                    <td class="Minimum"><%=delivery.getDate("travelDate")!=null ? SDF.format(delivery.getDate("travelDate")) : "-"%></td>
                    <td class="Minimum"><%=delivery.getDate("deliveryDate")!=null && !NULLDATE.equals(SDF.format(delivery.getDate("deliveryDate"))) ? SDF.format(delivery.getDate("deliveryDate")) : "-"%></td>

                    <td>
                        <%=delivery.getString("deliveryDenomination")%>,
                        <%=delivery.getString("deliveryAddress")%>
                        <%=delivery.getString("deliveryCity")%>
                        (<%=delivery.getString("deliveryProvince")%>)
                    </td>

                    <td class="Minimum"><%=states.get(delivery_key)%></td>

                    <td onclick="event.stopPropagation();">
                        <%if(delivery.getString("pathname")!=null){%>
                        <a href="/Vectis/pods/<%=delivery.getString("pathname")%>"
                           download="<%=new File(delivery.getString("pathname")).getName()%>">
                            <%=new File(delivery.getString("pathname")).getName()%>
                        </a>
                        <%}else{%>
                        IN ATTESA DI SCANSIONE
                        <%}%>
                    </td>
                </tr>
                <%}%>
            </tbody>
        </table>
        <%}%>
            
    </body>
    
    <script>
        if(!APP) var APP = {};
        
        APP.searchSingleTrack=(delivery_key)=>
        {
            window.open("singletrack.jsp?&delivery_key="+delivery_key,"_blank");
        };
        
        APP.downloadCSV=()=>
        {
            window.open("/Vectis/ScerniServlet/CSV?&toDate=<%=toDate.getTime()%>&fromDate=<%=fromDate.getTime()%>&region=<%=region%>");
        };
    </script>    
    
</html>
