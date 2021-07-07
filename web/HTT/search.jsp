<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.temporal.TemporalUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    LocalDate today = LocalDate.now();
    LocalDate monthAgo = today.minus(1,ChronoUnit.MONTHS);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HISENSE TRACK&TRACE</title>
        <link rel="stylesheet" href="/Vectis/katana.css">
        <link rel="stylesheet" href="/Vectis/HTT/common.css">
        <link rel="stylesheet" href="/Vectis/HTT/search.css">
        <link rel="icon" href="/Vectis/RESOURCES/TRANS_LOGO.png" type="image/png" />
    </head>
    <body>
        <%if(!session.isNew()){%>
        <div id="pageHeader">
            <span id="headerTitle">HISENSE TRACK&TRACE</span>
            <img id="customerLogo" src="/Vectis/RESOURCES/HISENSE_LOGO.png">
            <img id="crdLogo" src="/Vectis/RESOURCES/LOGO.png">
        </div>
        
        <div id="searchBox">
            <div id="singleTrack">
                <span>CERCA SPEDIZIONE SINGOLA</span>
                <input id="customerRef" placeholder="RIFERIMENTO" onkeydown="if(event.keyCode===13)APP.searchSingleTrack();">
                <span id="searchMultiTrack" class="Button Operation" onclick="APP.searchSingleTrack();">CERCA</span>
            </div>
            
            <div id="multiTrack">
                <span>SPEDIZIONI MULTIPLE</span>
                <table>
                    <tbody>
                        <tr><td>DAL</td><td><input id="fromDate" type="date" value="<%=monthAgo%>"></td></tr>
                        <tr><td>AL</td><td><input id="toDate" type="date" value="<%=today%>"></td></tr>
                        <tr>
                            <td>REGIONE</td>
                            <td>
                                <select id="region">
                                    <option value="">-- TUTTE --</option>
                                    <option>ABRUZZO</option>
                                    <option>BASILICATA</option>
                                    <option>CALABRIA</option>
                                    <option>CAMPANIA</option>
                                    <option>EMILIA ROMAGNA</option>
                                    <option>FRIULI VENEZIA GIULIA</option>
                                    <option>LAZIO</option>
                                    <option>LIGURIA</option>
                                    <option>LOMBARDIA</option>
                                    <option>MARCHE</option>
                                    <option>MOLISE</option>
                                    <option>PIEMONTE</option>
                                    <option>PUGLIA</option>
                                    <option>SARDEGNA</option>
                                    <option>SICILIA</option>
                                    <option>TRENTINO ALTO ADIGE</option>
                                    <option>VAL D'AOSTA</option>
                                    <option>VENETO</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>                
                </table>
                <span id="searchMultiTrack" class="Button Operation" onclick="APP.searchMultiTrack();">CERCA</span>
            </div>
        </div>
        <%}%>
        
    </body>

    <%if(!session.isNew()){%>
    <script>
        if(!APP) var APP = {};
        
        APP.searchSingleTrack=()=>
        {
            let customerRef = document.getElementById("customerRef").value;
            window.open("singletrack.jsp?&customerRef="+customerRef,"_blank");
        };

        APP.searchMultiTrack=()=>
        {
            let fromDate = document.getElementById("fromDate").value;
            let toDate = document.getElementById("toDate").value;
            let region = document.getElementById("region").value;
            window.open("multitrack.jsp?&fromDate="+fromDate+"&toDate="+toDate+"&region="+region,"_blank");
        };
    </script>
    <%}else{%>
    <script>
        window.open("landing.jsp","_self");
    </script>
    <%}%>    
</html>
