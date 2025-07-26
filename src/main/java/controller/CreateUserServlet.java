package controller;

import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/create-user")
public class CreateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        try {
            // Get parameters from request
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roles = request.getParameter("roles");
            String password = request.getParameter("password");

            // Validate required parameters
            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || roles == null || roles.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameters: full_name, email, roles, and password are required.");
                return;
            }

            // Validate email format
            String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
            if (!email.trim().matches(emailRegex)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid email format.");
                return;
            }

            // Validate password length
            if (password.trim().length() < 6) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Password must be at least 6 characters long.");
                return;
            }

            // Validate role
            String[] validRoles = {"admin", "staff"};
            boolean isValidRole = false;
            for (String validRole : validRoles) {
                if (validRole.equals(roles.trim().toLowerCase())) {
                    isValidRole = true;
                    break;
                }
            }
            if (!isValidRole) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid role. Must be 'admin' or 'staff'.");
                return;
            }

            // Hash the password
            String hashedPassword = hashPassword(password.trim());

            try (Connection conn = DBUtils.getConnection()) {
                // Check if email already exists
                String checkEmailSql = "SELECT COUNT(*) FROM users WHERE email = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql)) {
                    checkStmt.setString(1, email.trim().toLowerCase());
                    ResultSet rs = checkStmt.executeQuery();
                    rs.next();

                    if (rs.getInt(1) > 0) {
                        response.setStatus(HttpServletResponse.SC_CONFLICT);
                        response.getWriter().write("Email address already exists.");
                        return;
                    }
                }

                // Insert new user
                String insertSql = "INSERT INTO users (full_name, email, phone, password, roles) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setString(1, fullName.trim());
                    insertStmt.setString(2, email.trim().toLowerCase());
                    insertStmt.setString(3, phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
                    insertStmt.setString(4, hashedPassword);
                    insertStmt.setString(5, roles.trim().toLowerCase());

                    int rowsAffected = insertStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("User created successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().write("Failed to create user.");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            // Handle specific SQL errors
            String errorMessage = e.getMessage().toLowerCase();
            if (errorMessage.contains("unique") || errorMessage.contains("duplicate")) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Email address already exists.");
            } else if (errorMessage.contains("check constraint")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid role value.");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Database error occurred.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An unexpected error occurred.");
        }
    }

    // Method to hash password using SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());

            // Convert bytes to hexadecimal string
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }
}
