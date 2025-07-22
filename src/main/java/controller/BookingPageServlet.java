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
import dao.CarDAO;

@WebServlet("/booking-page")
public class BookingPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String carIdParam = request.getParameter("carId");
        System.out.println(">>> BookingPageServlet: carId = " + carIdParam); // Debug

        if (carIdParam == null) {
            response.sendRedirect("index.jsp"); // redirect if no car ID
            return;
        }

        try {
            int carId = Integer.parseInt(carIdParam);

            try (Connection conn = DBUtils.getConnection();
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cars WHERE id = ?")) {

                stmt.setInt(1, carId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Car car = new Car();
                    car.setId(rs.getInt("id"));
                    car.setMake(rs.getString("make"));
                    car.setModel(rs.getString("model"));
                    car.setSeats(rs.getInt("seats"));
                    car.setTransmission(rs.getString("transmission"));
                    car.setFuelType(rs.getString("fuel_type"));
                    car.setDailyRate(rs.getDouble("daily_rate"));
                    car.setImageUrl(rs.getString("image_url"));

                    request.setAttribute("car", car);
                    System.out.println(">>> BookingPageServlet: car fetched = " + car.getMake() + " " + car.getModel());
                }
            }

        } catch (NumberFormatException e) {
            System.out.println("Invalid carId: " + carIdParam);
            response.sendRedirect("index.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Final forward (only once!)
        request.getRequestDispatcher("booking-page.jsp").forward(request, response);
    }
}
