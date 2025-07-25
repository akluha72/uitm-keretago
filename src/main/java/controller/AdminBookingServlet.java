package controller;

import java.io.IOException;
import java.sql.*;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import utils.DBUtils;

@WebServlet("/admin-booking")
public class AdminBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            int carId = Integer.parseInt(request.getParameter("car_id"));
            String email = request.getParameter("user_email");
            Date pickupDate = Date.valueOf(request.getParameter("pickup_date"));
            Date returnDate = Date.valueOf(request.getParameter("return_date"));
            String status = request.getParameter("status");

            // Calculate total_amount based on duration * car daily_rate
            double dailyRate = 0.0;
            long days = ChronoUnit.DAYS.between(pickupDate.toLocalDate(), returnDate.toLocalDate());
            if (days <= 0) {
                days = 1;
            }

            try (Connection conn = DBUtils.getConnection()) {

                // Get daily_rate from cars table
                String rateQuery = "SELECT daily_rate FROM cars WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(rateQuery)) {
                    ps.setInt(1, carId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        dailyRate = rs.getDouble("daily_rate");
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found.");
                        return;
                    }
                }

                double totalAmount = dailyRate * days;

                // Insert new booking
                String insertSql = "INSERT INTO bookings (car_id, user_email, pickup_date, return_date, status, created_at, total_amount) "
                        + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, carId);
                    insertStmt.setString(2, email);
                    insertStmt.setDate(3, pickupDate);
                    insertStmt.setDate(4, returnDate);
                    insertStmt.setString(5, status);
                    insertStmt.setDouble(6, totalAmount);
                    insertStmt.executeUpdate();
                }

                response.setStatus(HttpServletResponse.SC_OK);

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Failed to create booking.");
        }
    }
}
