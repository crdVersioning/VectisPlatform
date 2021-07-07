<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.temporal.TemporalUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accessCode = request.getParameter("accessCode");
    boolean accessGranted = false;
    
    List<String> accessCodes = Arrays.asList("SCERNI1019");
    
    if(accessCode!=null && accessCodes.contains(accessCode.toUpperCase())) accessGranted = true;
    else session.invalidate();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SCERNI TRACK&TRACE</title>
        <link rel="stylesheet" href="/Vectis/katana.css">
        <link rel="stylesheet" href="/Vectis/TT/SCERNI/common.css">
        <link rel="stylesheet" href="/Vectis/TT/SCERNI/landing.css">
        <link rel="icon" href="/Vectis/RESOURCES/TRANS_LOGO.png" type="image/png" />
    </head>
    <body>
        <div id="pageHeader">
            <span id="headerTitle">SCERNI TRACK&TRACE</span>
            <img id="customerLogo" src="/Vectis/RESOURCES/SCERNI_LOGO.png">
            <img id="crdLogo" src="/Vectis/RESOURCES/LOGO.png">
        </div>
        
        <%if(!accessGranted){%>
        <div id="accessCodeBox">
            <input id="accessCode" type="password" placeholder="CODICE D'ACCESSO" onkeydown="if(event.keyCode===13)APP.login();">
        </div>
        <%}%>
    </body>
    
    <%if(!accessGranted){%>
    <script>
        if(!APP) var APP = {};
        
        APP.login=()=>
        {
            let accessCode = document.getElementById("accessCode").value;
            window.open("/Vectis/TT/SCERNI/landing.jsp?&accessCode="+accessCode,"_self");
        };
    </script>
    <%}else{%>
    <script>
        window.open("/Vectis/TT/SCERNI/search.jsp","_self");
    </script>
    <%}%>
</html>
