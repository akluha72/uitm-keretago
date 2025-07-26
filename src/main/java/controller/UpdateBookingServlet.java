package controller;

import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/update-booking")
public class UpdateBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        try {
            String bookingIdParam = request.getParameter("booking_id");
            String status = request.getParameter("status");

            // Validate required parameters
            if (bookingIdParam == null || status == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameters: bookingId and status.");
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

            // Validate status
            String[] validStatuses = {"active", "completed", "cancelled"};
            boolean isValidStatus = false;
            for (String validStatus : validStatuses) {
                if (validStatus.equals(status.trim())) {
                    isValidStatus = true;
                    break;
                }
            }
            if (!isValidStatus) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid status value. Must be: active, completed, or cancelled.");
                return;
            }

            try (Connection conn = DBUtils.getConnection()) {
                // Check if booking exists
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

                // Update only the status
                String updateSql = "UPDATE bookings SET status = ? WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, status.trim());
                    updateStmt.setInt(2, bookingId);

                    int rowsAffected = updateStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("Booking status updated successfully.");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("Booking not found or no changes made.");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error occurred.");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An unexpected error occurred.");
        }
    }
}
