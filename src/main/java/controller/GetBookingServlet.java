package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/get-booking")
public class GetBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingId = request.getParameter("id");

        if (bookingId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing booking ID parameter.");
            return;
        }

        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT b.*, c.make, c.model, c.license_plate, c.daily_rate "
                    + "FROM bookings b "
                    + "JOIN cars c ON b.car_id = c.id "
                    + "WHERE b.id = ?";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(bookingId));

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                JsonObject booking = new JsonObject();
                booking.addProperty("id", rs.getInt("id"));
                booking.addProperty("carId", rs.getInt("car_id"));
                booking.addProperty("userEmail", rs.getString("user_email"));
                booking.addProperty("pickupDate", rs.getDate("pickup_date").toString());
                booking.addProperty("returnDate", rs.getDate("return_date").toString());
                booking.addProperty("status", rs.getString("status"));

                // Add car details
                JsonObject carDetails = new JsonObject();
                carDetails.addProperty("make", rs.getString("make"));
                carDetails.addProperty("model", rs.getString("model"));
                carDetails.addProperty("licensePlate", rs.getString("license_plate"));
                carDetails.addProperty("dailyRate", rs.getDouble("daily_rate"));
                booking.add("carDetails", carDetails);

                response.setContentType("application/json");
                response.getWriter().write(booking.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Booking not found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error fetching booking details");
        }
    }
}
