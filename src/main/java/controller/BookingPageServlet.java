package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;

import model.Car;
import dao.CarDAO;

@WebServlet("/booking-page")
public class BookingPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String carIdParam = request.getParameter("carId");
        if (carIdParam == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            int carId = Integer.parseInt(carIdParam);

            // Fetch car info
            Car car = null;
            try (Connection conn = DBUtils.getConnection();
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cars WHERE id = ?")) {
                stmt.setInt(1, carId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    car = new Car();
                    car.setId(rs.getInt("id"));
                    car.setMake(rs.getString("make"));
                    car.setModel(rs.getString("model"));
                    car.setSeats(rs.getInt("seats"));
                    car.setTransmission(rs.getString("transmission"));
                    car.setFuelType(rs.getString("fuel_type"));
                    car.setDailyRate(rs.getDouble("daily_rate"));
                    car.setImageUrl(rs.getString("image_url"));
                }
            }

            if (car == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            request.setAttribute("car", car);

            // Fetch existing bookings
            List<Map<String, String>> bookedDates = new ArrayList<>();
            try (Connection conn = DBUtils.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(
                            "SELECT pickup_date, return_date FROM bookings WHERE car_id = ?")) {
                stmt.setInt(1, carId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, String> range = new HashMap<>();
                    range.put("pickup", rs.getDate("pickup_date").toString());
                    range.put("return", rs.getDate("return_date").toString());
                    bookedDates.add(range);
                }
            }

            request.setAttribute("bookedDates", bookedDates);
            request.getRequestDispatcher("booking-page.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("Invalid carId: " + carIdParam);
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}
