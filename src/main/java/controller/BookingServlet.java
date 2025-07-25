package controller;

import java.io.IOException;
import java.sql.*;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;

import model.Car;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getParameter("car_id"));
        String email = request.getParameter("user_email");
        Date pickupDate = Date.valueOf(request.getParameter("pickup_date"));
        Date returnDate = Date.valueOf(request.getParameter("return_date"));
        Time pickupTime = Time.valueOf(request.getParameter("pickup_time"));

        double dailyRate = 0.0;
        long durationDays = 0;
        double totalAmount = 0.0;

        try (Connection conn = DBUtils.getConnection()) {

       
            String rateSql = "SELECT daily_rate FROM cars WHERE id = ?";
            try (PreparedStatement rateStmt = conn.prepareStatement(rateSql)) {
                rateStmt.setInt(1, carId);
                ResultSet rs = rateStmt.executeQuery();
                if (rs.next()) {
                    dailyRate = rs.getDouble("daily_rate");
                } else {
                    throw new SQLException("Car not found for ID: " + carId);
                }
            }

       
            durationDays = ChronoUnit.DAYS.between(pickupDate.toLocalDate(), returnDate.toLocalDate());
            if (durationDays <= 0) {
                durationDays = 1;
            }
            totalAmount = dailyRate * durationDays;

   
            String sql = "INSERT INTO bookings (car_id, user_email, pickup_date, return_date, pickup_time, total_amount, status, created_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, carId);
                stmt.setString(2, email);
                stmt.setDate(3, pickupDate);
                stmt.setDate(4, returnDate);
                stmt.setTime(5, pickupTime);
                stmt.setDouble(6, totalAmount);
                stmt.setString(7, "active");
                stmt.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Booking failed.");
            return;
        }

        response.sendRedirect("my-booking?email=" + email);
    }
}
