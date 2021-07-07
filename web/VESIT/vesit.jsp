<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestione Flusso Spedizioni VESIT</title>
        <link rel="icon" href="/Vectis/RESOURCES/TRANS_LOGO.png" type="image/png" />
    </head>
    <body>
        <h1>Gestione Flusso Spedizioni VESIT</h1>
        <br><input type="button" value="GENERA FILE" onclick="generateFile();">
        <br><div id="display">-</div>
        <br><a id="flowLink" href="http://192.168.0.140/Vectis/VESITFLOW/VESIT_FLOW.dat" target="_blank">VESIT FLOW FILE</a>
    </body>
    
    <script>
        function generateFile()
        {
            document.getElementById("flowLink").classList.add("HIDE");
            document.getElementById("display").innerHTML = "STO GENERANDO IL FILE";
            
            fetch("http://192.168.0.140/Vectis/VectisServlet?&op=generate_vesit_flow_file")
                .then((response)=>response.json())
                .then((json)=>
                {
                    document.getElementById("display").innerHTML = "HO GENERATO IL FILE: "+json.flowFileName;
                    document.getElementById("flowLink").href = "http://192.168.0.140/Vectis/VESITFLOW/"+json.flowFileName;
                    document.getElementById("flowLink").classList.remove("HIDE");
                })
                .catch(err=>
                {
                    document.getElementById("display").innerHTML = "ERRORE GENERANDO IL FILE: "+err;
                });
        }
    </script>
    
    <style>
        #flowLink.HIDE
        {
            display: none;
        }
    </style>
        
</html>
