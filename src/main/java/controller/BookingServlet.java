package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;

import model.Car;



@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getParameter("car_id"));
        String email = request.getParameter("user_email");
        Date pickupDate = Date.valueOf(request.getParameter("pickup_date"));
        Date returnDate = Date.valueOf(request.getParameter("return_date"));
        Time pickupTime = Time.valueOf(request.getParameter("pickup_time"));

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO bookings (car_id, user_email, pickup_date, return_date, pickup_time) VALUES (?, ?, ?, ?, ?)")) {

            stmt.setInt(1, carId);
            stmt.setString(2, email);
            stmt.setDate(3, pickupDate);
            stmt.setDate(4, returnDate);
            stmt.setTime(5, pickupTime);

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("my-booking?email=" + email);
    }
}
