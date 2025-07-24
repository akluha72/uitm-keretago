package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;
import model.Booking;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in as admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isAdmin") == null
                || !(Boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        System.out.println("AdminDashboard accessed");
        System.out.println("Session: " + session);
        System.out.println("isAdmin: " + (session != null ? session.getAttribute("isAdmin") : "no session"));

        try (Connection conn = DBUtils.getConnection()) {
            // Total cars available
            String carCountSql = "SELECT COUNT(*) FROM cars";
            PreparedStatement psCar = conn.prepareStatement(carCountSql);
            ResultSet rsCar = psCar.executeQuery();
            int totalCars = rsCar.next() ? rsCar.getInt(1) : 0;

            // Total bookings
            String bookingCountSql = "SELECT COUNT(*) FROM bookings";
            PreparedStatement psBooking = conn.prepareStatement(bookingCountSql);
            ResultSet rsBooking = psBooking.executeQuery();
            int totalBookings = rsBooking.next() ? rsBooking.getInt(1) : 0;

            // Bookings this week
            String weeklyBookingSql = "SELECT COUNT(*) FROM bookings WHERE created_at >= {fn TIMESTAMPADD(SQL_TSI_DAY, -7, CURRENT_TIMESTAMP)}";
            PreparedStatement psWeek = conn.prepareStatement(weeklyBookingSql);
            ResultSet rsWeek = psWeek.executeQuery();
            int weeklyBookings = rsWeek.next() ? rsWeek.getInt(1) : 0;

            // Set attributes
            request.setAttribute("totalCars", totalCars);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("weeklyBookings", weeklyBookings);

            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in AdminDashboardServlet:");
            e.printStackTrace();
            response.sendError(500, "Error loading dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Reuse same logic
    }
}
