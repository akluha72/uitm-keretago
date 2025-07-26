package controller;

import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/update-user")
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        try {
            // Get parameters from request
            String userIdParam = request.getParameter("user_id");
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roles = request.getParameter("roles");
            String password = request.getParameter("password");

            // Validate required parameters
            if (userIdParam == null || userIdParam.trim().isEmpty()
                    || fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || roles == null || roles.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameters: user_id, full_name, email, and roles are required.");
                return;
            }

            int userId;
            try {
                userId = Integer.parseInt(userIdParam.trim());
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid user ID format.");
                return;
            }

            // Validate email format
            String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
            if (!email.trim().matches(emailRegex)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid email format.");
                return;
            }

            // Validate password length if provided
            if (password != null && !password.trim().isEmpty() && password.trim().length() < 6) {
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

            try (Connection conn = DBUtils.getConnection()) {
                String checkUserSql = "SELECT id FROM users WHERE id = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkUserSql)) {
                    checkStmt.setInt(1, userId);
                    ResultSet rs = checkStmt.executeQuery();

                    if (!rs.next()) {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("User not found.");
                        return;
                    }
                }

                String checkEmailSql = "SELECT COUNT(*) FROM users WHERE email = ? AND id != ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql)) {
                    checkStmt.setString(1, email.trim().toLowerCase());
                    checkStmt.setInt(2, userId);
                    ResultSet rs = checkStmt.executeQuery();
                    rs.next();

                    if (rs.getInt(1) > 0) {
                        response.setStatus(HttpServletResponse.SC_CONFLICT);
                        response.getWriter().write("Email address already exists for another user.");
                        return;
                    }
                }

                String updateSql;
                boolean updatePassword = password != null && !password.trim().isEmpty();

                if (updatePassword) {
                    updateSql = "UPDATE users SET full_name = ?, email = ?, phone = ?, password = ?, roles = ? WHERE id = ?";
                } else {
                    updateSql = "UPDATE users SET full_name = ?, email = ?, phone = ?, roles = ? WHERE id = ?";
                }

                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, fullName.trim());
                    updateStmt.setString(2, email.trim().toLowerCase());
                    updateStmt.setString(3, phone != null && !phone.trim().isEmpty() ? phone.trim() : null);

                    if (updatePassword) {
               
                        updateStmt.setString(4, password.trim());
                        updateStmt.setString(5, roles.trim().toLowerCase());
                        updateStmt.setInt(6, userId);
                    } else {
                        updateStmt.setString(4, roles.trim().toLowerCase());
                        updateStmt.setInt(5, userId);
                    }

                    int rowsAffected = updateStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("User updated successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("User not found or no changes made.");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            // Handle specific SQL errors
            String errorMessage = e.getMessage().toLowerCase();
            if (errorMessage.contains("unique") || errorMessage.contains("duplicate")) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Email address already exists for another user.");
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

}
