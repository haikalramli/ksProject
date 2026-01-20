package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutController", urlPatterns = {"/LogoutController", "/logout"})
public class LogoutController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userType = null;
        
        if (session != null) {
            userType = (String) session.getAttribute("userType");
            session.invalidate();
        }
        
        // Redirect based on user type
        if ("client".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/jsp/client/SignIn.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
