package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("ContactServlet is working!");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO messages (full_name, email, subject, message) VALUES (?, ?, ?, ?)"
                )) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, subject);
            stmt.setString(4, message);
            stmt.executeUpdate();

            response.sendRedirect("/keretaGo/contact.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/keretaGo/contact.jsp?error=true");
        }
    }
}
