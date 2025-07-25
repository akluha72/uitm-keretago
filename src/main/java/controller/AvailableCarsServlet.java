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

        if (start == null || end == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing date parameters.");
            return;
        }

        List<Car> availableCars = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM cars WHERE status = 'available' AND id NOT IN ("
                    + "SELECT car_id FROM bookings "
                    + "WHERE NOT (return_date <= ? OR pickup_date >= ?) "
                    + "AND status IN ('active', 'confirmed', 'pending'))";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(end));
            stmt.setDate(2, Date.valueOf(start));

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
