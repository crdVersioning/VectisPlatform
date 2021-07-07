package com.dps.sync;

import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SyncServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        JsonObject jsonResponse = new JsonObject();
        String command = request.getPathInfo();
        
        jsonResponse.addProperty("command",command);
        
        try
        {
            if(command==null) throw new RuntimeException("NULL COMMAND");
            if(command.isEmpty()) throw new RuntimeException("EMPTY COMMAND");
            
            switch(command)
            {
                case "ping":
                    jsonResponse.addProperty("success",true);
                    break;
                    
                default:
                    throw new RuntimeException("UNKNOWN COMMAND : "+command);
            }
        }
        catch(RuntimeException ex)
        {
            jsonResponse.addProperty("success",false);
            jsonResponse.addProperty("exception",ex.toString());
            jsonResponse.addProperty("message",ex.getMessage());
        }
        
        response.setContentType("text/html;charset=UTF-8");
        try(PrintWriter out = response.getWriter()) 
        {
            out.print(jsonResponse);
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
