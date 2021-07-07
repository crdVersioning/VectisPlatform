package com.dps.tt.vesit;

import com.dps.dbi.DbResult;
import com.dps.dbi.DbResult.Record;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VesitServlet extends HttpServlet 
{
    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");
    private final String NULLDATE = "1900-01-01";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        Date fromDate = new Date(Long.parseLong(request.getParameter("fromDate")));
        Date toDate = new Date(Long.parseLong(request.getParameter("toDate")));
        String region = request.getParameter("region");
        
        TrackingData td = DAO.readTrackingData(fromDate, toDate, region);

        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-disposition","attachment; filename=spedizioni.csv");
        try(PrintWriter out = response.getWriter())
        {
            out.print("RIF_CLIENTE;");
            out.print("NUMERO BOLLA;");
            out.print("DATA PRESA IN CARICO;");
            out.print("DATA VIAGGIO;");
            out.print("DATA DI CONSEGNA;");
            out.print("DESTINATARIO;");
            out.print("INDIRIZZO;");
            out.print("PROVINCIA;");
            out.print("STATO;");
            out.print("DATA;");
            out.print("ULTIMO STORICO;");
            out.print("APPUNTAMENTO;");
            out.println();            

            for(Record delivery : td.deliveries_dbr)
            {
                Integer delivery_key = delivery.getInteger("delivery_key");
                
                out.print(delivery.getString("customerRef")+";");
                
                out.print(delivery.getString("shipmentDocNumber")+";");
                out.print((delivery.getDate("chargeDate")!=null ? SDF.format(delivery.getDate("chargeDate")) : "-")+";");
                out.print((delivery.getDate("travelDate")!=null ? SDF.format(delivery.getDate("travelDate")) : "-")+";");
                out.print((delivery.getDate("deliveryDate")!=null && !NULLDATE.equals(SDF.format(delivery.getDate("deliveryDate"))) ? SDF.format(delivery.getDate("deliveryDate")) : "-")+";");
                
                out.print(
                    (delivery.getString("deliveryDenomination").trim()).replaceAll(";",",")+";");
                
                out.print(
                    (delivery.getString("deliveryAddress").trim()+" "+
                    delivery.getString("deliveryCity").trim()).replaceAll(";",",")+";");
                
                out.print(delivery.getString("deliveryProvince").replaceAll(";",",")+";");
                
                String status_label = td.states.get(delivery_key);
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
                
                try
                {
                    String[] tmp = status_date.split("-");
                    status_date = tmp[2]+"/"+tmp[1]+"/"+tmp[0];
                }
                catch(Exception ex){}

                out.print(status_label+";");
                out.print(status_date+";");
                
                DbResult anomalies = delivery.getDbr("anomalies");
                
                if(anomalies!=null&&!anomalies.isEmpty())
                {
                    Record record = anomalies.record(anomalies.rowsCount()-1);
                    out.print(record.getString("label").trim());
                    out.print(" / ");
                    out.print(record.getDate("date")!= null ? SDF.format(record.getDate("date")) : "-");
                    out.print(" / ");
                    out.print(record.getString("description1")+(record.getString("description2")!=null ? ", "+record.getString("description2") : ""));
                    out.print(" / ");
                    out.print(record.getString("note"));
                }
                out.print(";");
                
                if(anomalies!=null&&!anomalies.isEmpty())
                {
                    Record record = anomalies.record(anomalies.rowsCount()-1);
                    boolean addBookingDate = false;
                    
                    addBookingDate |= "VEAPP".equals(record.getString("label").trim());
                    addBookingDate |= record.getString("description1")!=null && record.getString("description1").toLowerCase().contains("appuntamento");
                    addBookingDate |= record.getString("description2")!=null && record.getString("description2").toLowerCase().contains("appuntamento");
                        
                    if(addBookingDate) out.print(record.getDate("date")!= null ? SDF.format(record.getDate("date")) : "-");
                }
                out.print(";");

                out.println();            
            }
            
            out.flush();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    


}
