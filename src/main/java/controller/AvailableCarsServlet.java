package controller;

import com.google.gson.Gson;
import model.Car;
import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/available-cars")
public class AvailableCarsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");
        String excludeBookingId = request.getParameter("excludeBookingId");

        if (start == null || end == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing date parameters.");
            return;
        }

        List<Car> availableCars = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection()) {
            // Fixed SQL query: A booking overlaps if it starts before the requested end date 
            // AND ends after the requested start date
            String sql = "SELECT * FROM cars WHERE status = 'available' AND id NOT IN ("
                    + "SELECT car_id FROM bookings "
                    + "WHERE pickup_date <= ? AND return_date >= ? "
                    + "AND status IN ('active', 'confirmed', 'pending')";

            // Exclude current booking when editing
            if (excludeBookingId != null) {
                sql += " AND id != ?";
            }
            sql += ")";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(end));   // pickup_date <= end date
            stmt.setDate(2, Date.valueOf(start)); // return_date >= start date

            if (excludeBookingId != null) {
                stmt.setInt(3, Integer.parseInt(excludeBookingId));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Car car = new Car();
                car.setId(rs.getInt("id"));
                car.setMake(rs.getString("make"));
                car.setModel(rs.getString("model"));
                car.setLicensePlate(rs.getString("license_plate"));
                car.setDailyRate(rs.getDouble("daily_rate"));
                availableCars.add(car);
            }

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            String json = new Gson().toJson(availableCars);
            out.print(json);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error fetching available cars");
        }
    }
}
