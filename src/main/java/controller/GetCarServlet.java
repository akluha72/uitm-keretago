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

@WebServlet("/get-car")
public class GetCarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Car ID is required");
            return;
        }

        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM cars WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idStr));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Car car = new Car();
                car.setId(rs.getInt("id"));
                car.setMake(rs.getString("make"));
                car.setModel(rs.getString("model"));
                car.setYearMade(rs.getInt("year_made"));
                car.setLicensePlate(rs.getString("license_plate"));
                car.setDailyRate(rs.getDouble("daily_rate"));
                car.setMileage(rs.getInt("mileage"));
                car.setTransmission(rs.getString("transmission"));
                car.setSeats(rs.getInt("seats"));
                car.setLuggage(rs.getInt("luggage"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setStatus(rs.getString("status"));
                car.setImageUrl("images/" + rs.getString("image_url"));

                // Convert to JSON
                String json = new Gson().toJson(car);
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(json);
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}
