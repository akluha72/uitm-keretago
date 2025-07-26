package controller;

import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/delete-booking")
public class DeleteBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        try {
            String bookingIdParam = request.getParameter("booking_id");

            // Validate required parameter
            if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameter: booking_id.");
                return;
            }

            int bookingId;
            try {
                bookingId = Integer.parseInt(bookingIdParam.trim());
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid booking ID format.");
                return;
            }

            try (Connection conn = DBUtils.getConnection()) {
                // Check if booking exists before attempting to delete
                String checkSql = "SELECT id FROM bookings WHERE id = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, bookingId);
                    ResultSet rs = checkStmt.executeQuery();

                    if (!rs.next()) {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("Booking not found.");
                        return;
                    }
                }

                // Delete the booking
                String deleteSql = "DELETE FROM bookings WHERE id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                    deleteStmt.setInt(1, bookingId);

                    int rowsAffected = deleteStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("Booking deleted successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("Booking not found or already deleted.");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            // Handle foreign key constraint violations if there are related records
            String errorMessage = e.getMessage().toLowerCase();
            if (errorMessage.contains("foreign key") || errorMessage.contains("constraint")) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("Cannot delete booking due to related records.");
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
