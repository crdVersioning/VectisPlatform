package com.dss.vectis;

import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vesit_outflows.Vesit_OutFlows;

@WebServlet(name = "VectisServlet", urlPatterns = {"/VectisServlet"})
public class VectisServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        JsonObject jsonResponse = new JsonObject();

        String operation = request.getParameter("op")!=null ? request.getParameter("op") : "NULL";
        
        jsonResponse.addProperty("operation",operation);
        
        switch(operation)
        {
            case "generate_vesit_flow_file":
            {
                System.out.println(new Date()+" GENERATING VESIT FLOW");
                Vesit_OutFlows vof = new Vesit_OutFlows();
                vof.run();
                jsonResponse.addProperty("success",true);
                jsonResponse.addProperty("flowFileName",vof.flowFileName);
                System.out.println(new Date()+" VESIT FLOW GENERATED");
            } break;
            
            default:
            {
                jsonResponse.addProperty("success",false);
                jsonResponse.addProperty("message","UNKNOWN OPERATION : "+operation);
            }
        }
        
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter())
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
