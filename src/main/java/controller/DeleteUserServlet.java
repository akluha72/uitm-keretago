package controller;

import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        try {
            String userIdParam = request.getParameter("user_id");


            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameter: user_id.");
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

            try (Connection conn = DBUtils.getConnection()) {
    
                String checkSql = "SELECT id, roles FROM users WHERE id = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, userId);
                    ResultSet rs = checkStmt.executeQuery();

                    if (!rs.next()) {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("User not found.");
                        return;
                    }

                }

         
                String checkBookingsSql = "SELECT COUNT(*) FROM bookings WHERE user_email = (SELECT email FROM users WHERE id = ?)";
                try (PreparedStatement checkBookingsStmt = conn.prepareStatement(checkBookingsSql)) {
                    checkBookingsStmt.setInt(1, userId);
                    ResultSet bookingsRs = checkBookingsStmt.executeQuery();
                    bookingsRs.next();

                    int bookingCount = bookingsRs.getInt(1);
                    if (bookingCount > 0) {
                        response.setStatus(HttpServletResponse.SC_CONFLICT);
                        response.getWriter().write("Cannot delete user with existing bookings. Please handle the bookings first.");
                        return;
                    }
                }

                // Delete the user
                String deleteSql = "DELETE FROM users WHERE id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                    deleteStmt.setInt(1, userId);

                    int rowsAffected = deleteStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("User deleted successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("User not found or already deleted.");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            // Handle foreign key constraint violations
            String errorMessage = e.getMessage().toLowerCase();
            if (errorMessage.contains("foreign key") || errorMessage.contains("constraint")) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Cannot delete user due to related records in the system.");
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
