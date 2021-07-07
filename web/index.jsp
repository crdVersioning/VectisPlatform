<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Piattaforma Sistemi Vectis</title>
        <link rel="stylesheet" href="RESOURCES/font-awesome-4.7.0/css/font-awesome.css">
        <link rel="stylesheet" href="katana.css">
        <link rel="stylesheet" href="index.css">
        <link rel="icon" href="/Vectis/RESOURCES/TRANS_LOGO.png" type="image/png" />
    </head>
    <body>
        <div id="header">Servizi Vectis per CRD/LSW</div>
        
        <!--div class="BigButton"-->
        <div class="BigButton" onclick="window.open('http://192.168.0.140/DigInvoice_Backend/','_blank');">
            <span class="Label"><i class="fa fa-money fa-fw" aria-hidden="true"></i> DigInvoice/FlowControl</span>
            <br><br>FATTURAZIONE E CONTROLLO FLUSSO
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <!--span class="Status Inactive"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> IN MANUTENZIONE</span-->
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>

        <div class="BigButton" onclick="window.open('http://192.168.0.140:8084/WebFolder/','_blank');">
            <span class="Label"><i class="fa fa-folder-open-o fa-fw" aria-hidden="true"></i> WebFolder</span>
            <br><br>GESTIONE DOCUMENTALE E TRACKING
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>
        
        <div class="BigButton" onclick="window.open('http://192.168.0.140/WebFolder2021/','_blank');">
            <span class="Label"><i class="fa fa-folder-open-o fa-fw" aria-hidden="true"></i> WebFolder2021</span>
            <br><br>CARICAMENTO SCANSIONI POD
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>
        
        <div class="BigButton" onclick="window.open('http://192.168.0.140:8084/DelMate/','_blank');">
            <span class="Label"><i class="fa fa-truck fa-fw" aria-hidden="true"></i> DeliveryMate</span>
            <br><br>RILEVAZIONE ESITI E TRASMISSIONE P.O.D.
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>

        <div class="BigButton" onclick="window.open('http://192.168.0.140:8080/DeliveryWatch','_blank');">
            <span class="Label"><i class="fa fa-envelope fa-fw" aria-hidden="true"></i> Delivery Watch</span>
            <br><br>MONITORAGGIO CORRISPONDENTI VIA MAIL
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>

        <div class="BigButton" onclick="window.open('http://192.168.0.140:8080/daemonitor/landing.jsp','_blank');">
            <span class="Label"><i class="fa fa-eye fa-fw" aria-hidden="true"></i> FtpDaemonitor</span>
            <br><br>MONITORAGGIO TRASMISSIONE P.O.D. VIA FTP
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>
        
        <div class="BigButton" onclick="window.open('http://192.168.0.140/Vectis/VESIT/vesit.jsp','_blank');">
            <span class="Label"><i class="fa fa-retweet fa-fw" aria-hidden="true"></i> VesitFlow</span>
            <br><br>FLUSSO SPEDIZIONI VESIT
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>

        <div class="BigButton" onclick="window.open('http://192.168.0.140/TravelPlanning/travels.jsp','_blank');">
            <span class="Label"><i class="fa fa-truck fa-fw" aria-hidden="true"></i> TravelPlanning</span>
            <br><br>PIANIFICAZIONE VIAGGI
            <span class="Status Active"><i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i> ATTIVO</span>
            <span class="Run">ACCEDI <i class="fa fa-play fa-fw" aria-hidden="true"></i></span>
        </div>
        
    </body>
</html>
