package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;

import dao.CarDAO;
import model.Booking;

@WebServlet("/my-booking")
public class MyBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userEmail = request.getParameter("email");

        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        "SELECT b.*, c.make, c.model, c.daily_rate FROM bookings b JOIN cars c ON b.car_id = c.id WHERE b.user_email = ? ORDER BY b.created_at DESC")) {
            stmt.setString(1, userEmail);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCarName(rs.getString("model"));
                booking.setBrand(rs.getString("make"));
                booking.setPickupDate(rs.getDate("pickup_date"));
                booking.setReturnDate(rs.getDate("return_date"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setPricePerDay(rs.getDouble("daily_rate"));
                bookings.add(booking);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("my-booking.jsp").forward(request, response);
    }
}
