package com.dps.pods;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Pods extends HttpServlet
{
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        final int DEFAULT_BUFFER_SIZE = 10240;
        byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
        
        BufferedOutputStream output;

        try
        {
            String pathname = request.getPathInfo();

            File file = new File("\\\\nas-qnap\\WebFolder\\filerepository\\archived\\"+pathname);
            System.out.println("opening file "+file.getAbsolutePath()+ " for download..."+(file.exists()?"OK":"NOT FOUND"));

            try(BufferedInputStream input = new BufferedInputStream(new FileInputStream(file), DEFAULT_BUFFER_SIZE))
            {
                System.out.println("resetting response...");

                response.reset();
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment;filename="+pathname);
                response.setBufferSize(DEFAULT_BUFFER_SIZE);

                System.out.println("opening response output stream...");
                
                output = new BufferedOutputStream(response.getOutputStream(), DEFAULT_BUFFER_SIZE);

                System.out.println("writing file to response output stream...");
                int length;
                int totalLength = 0;
                while((length = input.read(buffer)) > 0)
                {
                    output.write(buffer, 0, length);
                    totalLength += length;
                }
                
                System.out.println(totalLength+" bytes written, flushing response output stream...");
                output.flush();
                System.out.println("done.");
            }
            catch(Exception ex)
            {
                System.out.println("exception : "+ex);
                System.out.println("exception : "+ex);
                
                ex.printStackTrace(System.out);
                ex.printStackTrace(System.err);

                StringBuilder sb = new StringBuilder();

                sb
                    .append("<div style='position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%);")
                    .append("font-size: 150%; white-space: nowrap;")
                    .append("border: 1px solid black; border-radius: 2rem;'>")
                    .append("<div style='margin: 2rem; text-align: center;'>WebFolder - Errore</div>")
                    .append("<div style='margin: 2rem;'>exception : ")
                    .append(ex.toString())
                    .append("</div>")
                    .append("<div style='margin: 2rem;'>Vi preghiamo di contattare gli amministratori del sistema.</div>")
                    .append("</div>");

                response.getOutputStream().println(sb.toString());
            }            
        }
        catch(Exception ex)
        {
            System.out.println("exception : "+ex);
            System.out.println("exception : "+ex);

            ex.printStackTrace(System.out);
            ex.printStackTrace(System.err);
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
