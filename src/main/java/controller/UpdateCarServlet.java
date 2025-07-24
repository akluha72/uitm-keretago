package controller;

import com.google.gson.Gson;
import java.io.File;
import model.Car;
import utils.DBUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.*;
import javax.servlet.annotation.MultipartConfig;

@WebServlet("/update-car")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024) // 10MB
public class UpdateCarServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        int yearMade = Integer.parseInt(request.getParameter("yearMade"));
        String licensePlate = request.getParameter("licensePlate");
        double dailyRate = Double.parseDouble(request.getParameter("dailyRate"));
        int mileage = Integer.parseInt(request.getParameter("mileage"));
        String transmission = request.getParameter("transmission");
        int seats = Integer.parseInt(request.getParameter("seats"));
        String luggage = request.getParameter("luggage");
        String fuelType = request.getParameter("fuelType");
        String status = request.getParameter("status");

        String imageFileName = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            imageFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + imageFileName);
        }

        try (Connection conn = DBUtils.getConnection()) {
            String sql = "UPDATE cars SET make=?, model=?, year_made=?, license_plate=?, daily_rate=?, mileage=?, transmission=?, seats=?, luggage=?, fuel_type=?, status=?"
                    + (imageFileName != null ? ", image_url=?" : "")
                    + " WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            int idx = 1;
            stmt.setString(idx++, make);
            stmt.setString(idx++, model);
            stmt.setInt(idx++, yearMade);
            stmt.setString(idx++, licensePlate);
            stmt.setDouble(idx++, dailyRate);
            stmt.setInt(idx++, mileage);
            stmt.setString(idx++, transmission);
            stmt.setInt(idx++, seats);
            stmt.setString(idx++, luggage);
            stmt.setString(idx++, fuelType);
            stmt.setString(idx++, status);
            if (imageFileName != null) {
                stmt.setString(idx++, imageFileName);
            }
            stmt.setInt(idx++, id);

            stmt.executeUpdate();
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Update failed");
        }
    }
}
