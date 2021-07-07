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
    SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");
    String NULL_DATE = "1900-01-01";
    
    Record delivery = null;
    DbResult anomalies_dbr = null;
    String status = null;
    String errorMessage = null;
    String exceptionMessage = null;

    // PARAMETRI DELLA RICERCA
    String customerRef = request.getParameter("customerRef");
    String ddtNumber = request.getParameter("ddtNumber");
    
    Integer delivery_key = null;
    try{delivery_key = Integer.parseInt(request.getParameter("delivery_key"));}catch(Exception ex){}

    // ACCESSO AL DATABASE
    SqlServerInterface dbi = new SqlServerInterface().name("WebFolder").username("sa").password("4lp4c1n0");
    
    // CARICAMENTO DELLA SPEDIZIONE
    if((customerRef!=null && !customerRef.isEmpty()) || delivery_key!=null) try
    {
        delivery = dbi.read("replica.view_Shipments_CEDI")
            .andIsEqual(ddtNumber!=null&&!ddtNumber.isEmpty(),"shipmentDocNumber",ddtNumber)
            .andIsEqual(customerRef!=null&&!customerRef.isEmpty(),"customerRef",customerRef)
            .andIsEqual(delivery_key!=null,"delivery_key",delivery_key)
            .go().record();
        
        if(delivery==null) errorMessage = "SPEDIZIONE NON TROVATA";
    }
    catch(Exception ex)
    {
        errorMessage = "ERRORE DI SISTEMA";
        exceptionMessage = ex.toString();
    }
    else errorMessage = "SPECIFICARE ALMENO UN PARAMETRO DI RICERCA";
    
    // SE LA SPEDIZIONE é STATA TROVATA
    if(delivery!=null)
    {
        if(customerRef==null||customerRef.isEmpty()) customerRef = delivery.getString("customerRef");
        if(ddtNumber==null||ddtNumber.isEmpty()) ddtNumber = delivery.getString("shipmentDocNumber");
        if(delivery_key==null) delivery_key = delivery.getInteger("delivery_key");
        
        // CARICAMENTO DELLE ANOMALIE
        anomalies_dbr = dbi.read("replica.view_Anomalies")
            .isEqual("delivery_key",delivery.getInteger("delivery_key"))
            .order("date").go();

        // IDENTIFICAZIONE DELLO STATO

        Date travelDate = delivery.getDate("travelDate");
        Date today = new Date();
        long oneDay = 24*60*60*1000;

        if(travelDate==null) status = "IN PROGRAMMAZIONE";
        else
        {
            switch(delivery.getString("deliveryRegion").toString().toUpperCase())
            {
                case "CAMPANIA": break;

                case "SICILIA": case "SARDEGNA":
                    status = (today.getTime()-travelDate.getTime()>=2*oneDay) ?
                        "ARRIVATO IN PIATTAFORMA : "+SDF.format(new Date(travelDate.getTime()+2*oneDay)) :
                        "IN TRANSITO";
                    break;

                default:
                    status = (today.getTime()-travelDate.getTime()>=oneDay) ?
                        "ARRIVATO IN PIATTAFORMA : "+SDF.format(new Date(travelDate.getTime()+oneDay)) :
                        "IN TRANSITO";
            }
        }

        if(delivery.getDate("deliveryDate")!= null  && !NULL_DATE.equals(SDF.format(delivery.getDate("deliveryDate")))) status = "CONSEGNATO";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>NUMERO BOLLA : <%=ddtNumber%> / RIFERIMENTO : <%=customerRef%></title>
        <link rel="stylesheet" href="/Vectis/katana.css">
        <link rel="stylesheet" href="/Vectis/TT/CEDI/common.css">
        <link rel="stylesheet" href="/Vectis/TT/CEDI/singletrack.css">
        <link rel="icon" href="/Vectis/RESOURCES/TRANS_LOGO.png" type="image/png" />
    </head>
    <body>
        <%if(!session.isNew()){%>

        <div id="pageHeader">
            <span id="headerTitle">NUMERO BOLLA : <%=ddtNumber%> / RIFERIMENTO : <%=customerRef%></span>
        </div>

        <%if(delivery!=null){%>
        
        <table id="deliveryData">
            <thead>
                <tr><th colspan="2">DATI SPEDIZIONE</th></tr>
            </thead>
            <tbody>
                <tr><td>NUMERO SPEDIZIONE</td><td><%=delivery.getInteger("shipmentNumber")%>/<%=delivery.getShort("shipmentYear")%></td></tr>
                <tr><td>NUMERO BOLLA</td><td><%=ddtNumber%></td></tr>
                <tr><td>RIFERIMENTO</td><td><%=customerRef%></td></tr>

                <tr><td>DATA PRESA IN CARICO</td><td><%=delivery.getDate("chargeDate")!= null ? SDF.format(delivery.getDate("chargeDate")) : "-"%></td></tr>
                <tr><td>DATA DI CONSEGNA</td><td><%=delivery.getDate("deliveryDate")!= null && !NULL_DATE.equals(SDF.format(delivery.getDate("deliveryDate")))? SDF.format(delivery.getDate("deliveryDate")) : "-"%></td></tr>

                <tr><td>DESTINATARIO</td><td><%=delivery.getString("deliveryDenomination")%></td></tr>
                <tr><td>INDIRIZZO</td><td><%=delivery.getString("deliveryAddress")%></td></tr>
                <tr><td>CITTA'</td><td><%=delivery.getString("deliveryCity")%></td></tr>
                <tr><td>PROVINCIA</td><td><%=delivery.getString("deliveryProvince")%></td></tr>

                <tr><td>DATA VIAGGIO</td><td><%=delivery.getDate("travelDate")!= null ? SDF.format(delivery.getDate("travelDate")) : "-"%></td></tr>
                <tr><td>STATO</td><td><%=status!=null ? status : "-"%></td>

                <tr>
                    <td>DOCUMENTO</td>
                    <td>
                        <%if(delivery.getString("pathname")!=null){%>
                        <a href="/Vectis/pods/<%=delivery.getString("pathname")%>" download="<%=new File(delivery.getString("pathname")).getName()%>">
                            <%=new File(delivery.getString("pathname")).getName()%>
                        </a>
                        <%}else{%>
                        IN ATTESA DI SCANSIONE
                        <%}%>
                    </td>
                </tr>
            </tbody>
        </table>
            
        <table id="historyData">
            <thead>
                <tr><th colspan="4">STORICO</th></tr>
                <tr>
                    <th>CODICE</th>
                    <th>DATA</th>
                    <th>EVENTO</th>
                    <th>NOTE</th>
                </tr>
            </thead>
            <tbody>
                <%for(Record record : anomalies_dbr)
                {
                    String description = record.getString("description1")+(record.getString("description2")!=null ? ", "+record.getString("description2") : "");
                    if("GA".equals(record.getString("label"))) description = "IN GIACENZA";
                %>
                <tr>
                    <td><%=record.getString("label")%></td>
                    <td><%=record.getDate("date")!= null ? SDF.format(record.getDate("date")) : "-"%></td>
                    <td><%=description%></td>
                    <td><%=record.getString("note")%></td>
                </tr>
                <%}%>
            </tbody>
        </table>
        
        <%}else{%>
        <div id="errorBox" title="<%=exceptionMessage%>"><%=errorMessage%></div>
        <%}%>
        
        <%}%>
        
    </body>
    
</html>
