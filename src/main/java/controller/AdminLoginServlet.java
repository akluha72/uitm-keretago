package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBUtils;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND roles = 'admin'";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, password); // You should hash passwords later for security
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("isAdmin", true);
                    session.setAttribute("adminEmail", email);
                    session.setAttribute("adminName", rs.getString("full_name"));
                    System.out.println("Login successful, redirecting to dashboard");

                    // Use sendRedirect instead of forward to change the URL
                    response.sendRedirect("admin-dashboard");
                } else {
                    request.setAttribute("error", "Invalid credentials or not an admin.");
                    request.getRequestDispatcher("admin-login.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show login form
        request.getRequestDispatcher("admin-login.jsp").forward(request, response);
    }
}
