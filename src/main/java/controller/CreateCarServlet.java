package controller;

import utils.DBUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create-car")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024) // 10MB
public class CreateCarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            // Add null checks and default values
            String make = request.getParameter("make");
            String model = request.getParameter("model");

            String yearParam = request.getParameter("yearMade");
            int yearMade = (yearParam != null && !yearParam.trim().isEmpty())
                    ? Integer.parseInt(yearParam) : 0;

            String licensePlate = request.getParameter("licensePlate");

            String rateParam = request.getParameter("dailyRate");
            double dailyRate = (rateParam != null && !rateParam.trim().isEmpty())
                    ? Double.parseDouble(rateParam) : 0.0;

            String mileageParam = request.getParameter("mileage");
            int mileage = (mileageParam != null && !mileageParam.trim().isEmpty())
                    ? Integer.parseInt(mileageParam) : 0;

            String transmission = request.getParameter("transmission");

            String seatsParam = request.getParameter("seats");
            int seats = (seatsParam != null && !seatsParam.trim().isEmpty())
                    ? Integer.parseInt(seatsParam) : 5; // default to 5 seats

            String luggageParam = request.getParameter("luggage");
            int luggage = (luggageParam != null && !luggageParam.trim().isEmpty())
                    ? Integer.parseInt(luggageParam) : 1; // default to small

            String fuelType = request.getParameter("fuelType");
            String status = request.getParameter("status");

            // Validate required fields
            if (make == null || make.trim().isEmpty()
                    || model == null || model.trim().isEmpty()
                    || licensePlate == null || licensePlate.trim().isEmpty()
                    || yearMade == 0 || dailyRate == 0.0) {
                response.sendError(400, "Missing required fields");
                return;
            }

            try (Connection conn = DBUtils.getConnection()) {
                String sql = "INSERT INTO cars (make, model, year_made, license_plate, daily_rate, mileage, transmission, seats, luggage, fuel_type, status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, make);
                stmt.setString(2, model);
                stmt.setInt(3, yearMade);
                stmt.setString(4, licensePlate);
                stmt.setDouble(5, dailyRate);
                stmt.setInt(6, mileage);
                stmt.setString(7, transmission);
                stmt.setInt(8, seats);
                stmt.setInt(9, luggage);
                stmt.setString(10, fuelType);
                stmt.setString(11, status);

                stmt.executeUpdate();
                response.setStatus(HttpServletResponse.SC_CREATED);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(400, "Invalid number format in form data");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error creating car: " + e.getMessage());
        }
    }
}
