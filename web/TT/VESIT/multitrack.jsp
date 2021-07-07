<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.dps.tt.vesit.DAO"%>
<%@page import="com.dps.tt.vesit.TrackingData"%>
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
        <title>VESIT TRACK&TRACE</title>
        <link rel="stylesheet" href="/Vectis/katana.css">
        <link rel="stylesheet" href="/Vectis/TT/VESIT/common.css">
        <link rel="stylesheet" href="/Vectis/TT/VESIT/multitrack.css">
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
                    <th>RIFERIMENTO</th>
                    <th>NUMERO BOLLA</th>

                    <th>DATA PRESA IN CARICO</th>
                    <th>DATA VIAGGIO</th>
                    <th>DATA DI CONSEGNA</th>

                    <th>DESTINATARIO</th>
                    <th>INDIRIZZO</th>
                    <th>PROV.</th>

                    <th>STATO</th>
                    <th>DATA</th>
                    
                    <th>POD</th>
                    <th>APPUNTAMENTO</th>
                </tr>
            </thead>
            <tbody>
                <%for(Record delivery : deliveries_dbr)
                {
                    Integer delivery_key = delivery.getInteger("delivery_key");
                    StringJoiner title = new StringJoiner("\n");
                    
                    DbResult anomalies = delivery.getDbr("anomalies");
                    boolean addBookingDate = false;
                    String bookingDate = "";

                    for(Record anomaly : anomalies)
                        title.add(anomaly.getString("label")+"\t"+
                            (anomaly.getDate("date")!= null ? SDF.format(anomaly.getDate("date")) : "-")+"\t"+
                            (anomaly.getString("description1")+(anomaly.getString("description2")!=null ? ", "+anomaly.getString("description2") : ""))+"\t"+
                            anomaly.getString("note"));
                    
                    if(anomalies!=null&&!anomalies.isEmpty())
                    {
                        Record record = anomalies.record(anomalies.rowsCount()-1);

                        addBookingDate |= "VEAPP".equals(record.getString("label").trim());
                        addBookingDate |= record.getString("description1")!=null && record.getString("description1").toLowerCase().contains("appuntamento");
                        addBookingDate |= record.getString("description2")!=null && record.getString("description2").toLowerCase().contains("appuntamento");

                        if(addBookingDate) bookingDate = record.getDate("date")!= null ? SDF.format(record.getDate("date")) : "-";
                    }
                    
                    String status_label = states.get(delivery_key);
                    String status_date = "-";
                    
                    if(status_label.contains("IL"))
                    {
                        status_date = status_label.split("IL")[1];
                        status_label = status_label.split("IL")[0];
                    }

                    if(status_label.contains(":"))
                    {
                        status_date = status_label.split(":")[1];
                        status_label = status_label.split(":")[0];
                    }
                    
                    // AGGIUNTA CON EMAIL SPIRITO 12/11/20
                    List<String> CAMPANIA = Arrays.asList("SA","NA","CE","AV","BN","CB","IS");

                    String deliveryProvince = delivery.getString("deliveryProvince");
                    Long travelNumber = delivery.getLong("travelNumber");
                    Date travelDate = delivery.getDate("travelDate");
                    String carrier1Code = delivery.getString("carrier1Code");
                    String carrier2Code = delivery.getString("carrier2Code");

                    if(!status_label.contains("CONSEGNATO"))
                    {
                        if(CAMPANIA.contains(deliveryProvince) && travelDate!=null && carrier1Code!=null && !carrier1Code.trim().isEmpty())
                        {
                            status_date = SDF.format(travelDate);
                            status_label = "IN CONSEGNA";
                        }
                        else if(!CAMPANIA.contains(deliveryProvince) && travelDate!=null && carrier1Code!=null  && !carrier1Code.trim().isEmpty() && (carrier2Code==null || carrier2Code.trim().isEmpty()))
                        {
                            long oneDay = 24*60*60*1000;
                            status_date = SDF.format(new Date(travelDate.getTime()+(travelDate.getDay()==5?3:1)*oneDay));
                            status_label = "IN CONSEGNA";
                        }
                    }
                    //-- FINE AGGIUNTA --

                %>
                <tr id="delivery_<%=delivery_key%>" title="<%=title%>" onclick="APP.searchSingleTrack(<%=delivery_key%>);">

                    <td class="Minimum"><%=delivery.getString("customerRef")%></td>
                    <td class="Minimum"><%=delivery.getString("shipmentDocNumber")%></td>

                    <td class="Minimum"><%=delivery.getDate("chargeDate")!=null ? SDF.format(delivery.getDate("chargeDate")) : "-"%></td>
                    <td class="Minimum"><%=delivery.getDate("travelDate")!=null ? SDF.format(delivery.getDate("travelDate")) : "-"%></td>
                    <td class="Minimum"><%=delivery.getDate("deliveryDate")!=null && !NULLDATE.equals(SDF.format(delivery.getDate("deliveryDate"))) ? SDF.format(delivery.getDate("deliveryDate")) : "-"%></td>

                    <td>
                        <%=delivery.getString("deliveryDenomination")%>
                    </td>

                    <td>
                        <%=delivery.getString("deliveryAddress")%>
                        <%=delivery.getString("deliveryCity")%>
                    </td>
                    
                    <td>
                        <%=delivery.getString("deliveryProvince")%>
                    </td>

                    <td class="Minimum">
                        <%=status_label%>
                    </td>

                    <td class="Minimum">
                        <%=status_date%>
                    </td>

                    <td class="POD" onclick="event.stopPropagation();">
                        <%if(delivery.getString("pathname")!=null){%>
                        <a href="/Vectis/pods/<%=delivery.getString("pathname")%>"
                           download="<%=new File(delivery.getString("pathname")).getName()%>">
                           SCARICA
                        </a>
                        <%}else{%>
                        IN_ATTESA
                        <%}%>
                    </td>
                    
                    <td>
                        <%=bookingDate%>
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
            window.open("/Vectis/VesitServlet/CSV?&toDate=<%=toDate.getTime()%>&fromDate=<%=fromDate.getTime()%>&region=<%=region%>");
        };
    </script>    
    
</html>
