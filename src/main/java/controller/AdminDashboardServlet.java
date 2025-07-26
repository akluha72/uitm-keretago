package controller;

import java.io.IOException;
import java.sql.*;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import utils.DBUtils;
import model.Booking;
import model.Car;
import model.User;  // Add this import

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isAdmin") == null
                || !(Boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        try (Connection conn = DBUtils.getConnection()) {
            // Total cars
            String carCountSql = "SELECT COUNT(*) FROM cars";
            PreparedStatement psCar = conn.prepareStatement(carCountSql);
            ResultSet rsCar = psCar.executeQuery();
            int totalCars = rsCar.next() ? rsCar.getInt(1) : 0;

            // Total bookings
            String bookingCountSql = "SELECT COUNT(*) FROM bookings";
            PreparedStatement psBooking = conn.prepareStatement(bookingCountSql);
            ResultSet rsBooking = psBooking.executeQuery();
            int totalBookings = rsBooking.next() ? rsBooking.getInt(1) : 0;

            // Total users (NEW)
            String userCountSql = "SELECT COUNT(*) FROM users";
            PreparedStatement psUser = conn.prepareStatement(userCountSql);
            ResultSet rsUser = psUser.executeQuery();
            int totalUsers = rsUser.next() ? rsUser.getInt(1) : 0;

            // Bookings this week
            String weeklyBookingSql = "SELECT COUNT(*) FROM bookings WHERE created_at >= {fn TIMESTAMPADD(SQL_TSI_DAY, -7, CURRENT_TIMESTAMP)}";
            PreparedStatement psWeek = conn.prepareStatement(weeklyBookingSql);
            ResultSet rsWeek = psWeek.executeQuery();
            int weeklyBookings = rsWeek.next() ? rsWeek.getInt(1) : 0;

            // Car list
            String carSql = "SELECT * FROM cars";
            PreparedStatement psAllCars = conn.prepareStatement(carSql);
            ResultSet rsCars = psAllCars.executeQuery();
            List<Car> carList = new ArrayList<>();
            while (rsCars.next()) {
                Car car = new Car();
                car.setId(rsCars.getInt("id"));
                car.setMake(rsCars.getString("make"));
                car.setModel(rsCars.getString("model"));
                car.setYearMade(rsCars.getInt("year_made"));
                car.setLicensePlate(rsCars.getString("license_plate"));
                car.setDailyRate(rsCars.getDouble("daily_rate"));
                car.setMileage(rsCars.getInt("mileage"));
                car.setStatus(rsCars.getString("status"));
                car.setImageUrl(rsCars.getString("image_url"));
                carList.add(car);
            }

            // User list (NEW)
            String userSql = "SELECT id, full_name, email, phone, roles, created_at FROM users ORDER BY created_at DESC";
            PreparedStatement psAllUsers = conn.prepareStatement(userSql);
            ResultSet rsUsers = psAllUsers.executeQuery();
            List<User> userList = new ArrayList<>();
            while (rsUsers.next()) {
                User user = new User();
                user.setId(rsUsers.getInt("id"));
                user.setFullName(rsUsers.getString("full_name"));
                user.setEmail(rsUsers.getString("email"));
                user.setPhone(rsUsers.getString("phone"));
                user.setRoles(rsUsers.getString("roles"));
                user.setCreatedAt(rsUsers.getTimestamp("created_at"));
                userList.add(user);
            }

            // Booking list
            List<Booking> bookingList = new ArrayList<>();
            String bookingQuery = "SELECT b.id, b.user_email, c.make, c.model, c.license_plate, c.daily_rate, b.pickup_date, b.return_date,  b.status "
                    + "FROM bookings b "
                    + "JOIN cars c ON b.car_id = c.id";
            PreparedStatement ps = conn.prepareStatement(bookingQuery);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserEmail(rs.getString("user_email"));
                booking.setCarName(rs.getString("make") + " " + rs.getString("model"));
                booking.setLicensePlate(rs.getString("license_plate"));
                booking.setPickupDate(rs.getDate("pickup_date"));
                booking.setReturnDate(rs.getDate("return_date"));

                long days = (rs.getDate("return_date").getTime() - rs.getDate("pickup_date").getTime()) / (1000 * 60 * 60 * 24);
                double dailyRate = rs.getDouble("daily_rate");
                double totalAmount = days * dailyRate;

                booking.setStatus(rs.getString("status"));
                booking.setDurationDays((int) days);
                booking.setTotalAmount(totalAmount);
                bookingList.add(booking);
            }

            // Active Bookings
            String activeSql = "SELECT COUNT(*) FROM bookings WHERE status = 'active'";
            PreparedStatement psActive = conn.prepareStatement(activeSql);
            ResultSet rsActive = psActive.executeQuery();
            int activeBookings = rsActive.next() ? rsActive.getInt(1) : 0;

            // Due Today (Return date = today)
            String dueTodaySql = "SELECT COUNT(*) FROM bookings WHERE return_date = CURRENT_DATE";
            PreparedStatement psDue = conn.prepareStatement(dueTodaySql);
            ResultSet rsDue = psDue.executeQuery();
            int dueTodayBookings = rsDue.next() ? rsDue.getInt(1) : 0;

            // Overdue (Return date < today AND status = 'active')
            String overdueSql = "SELECT COUNT(*) FROM bookings WHERE return_date < CURRENT_DATE AND status = 'active'";
            PreparedStatement psOverdue = conn.prepareStatement(overdueSql);
            ResultSet rsOverdue = psOverdue.executeQuery();
            int overdueBookings = rsOverdue.next() ? rsOverdue.getInt(1) : 0;

            // Revenue this month
            String revenueSql = "SELECT SUM(total_amount) FROM bookings WHERE MONTH(created_at) = MONTH(CURRENT_DATE) AND YEAR(created_at) = YEAR(CURRENT_DATE)";
            PreparedStatement psRevenue = conn.prepareStatement(revenueSql);
            ResultSet rsRevenue = psRevenue.executeQuery();
            double thisMonthRevenue = rsRevenue.next() ? rsRevenue.getDouble(1) : 0.0;

            // Admin users count (NEW - optional)
            String adminCountSql = "SELECT COUNT(*) FROM users WHERE roles = 'admin'";
            PreparedStatement psAdmin = conn.prepareStatement(adminCountSql);
            ResultSet rsAdmin = psAdmin.executeQuery();
            int adminUsers = rsAdmin.next() ? rsAdmin.getInt(1) : 0;

            // Staff users count (NEW - optional)
            String staffCountSql = "SELECT COUNT(*) FROM users WHERE roles = 'staff'";
            PreparedStatement psStaff = conn.prepareStatement(staffCountSql);
            ResultSet rsStaff = psStaff.executeQuery();
            int staffUsers = rsStaff.next() ? rsStaff.getInt(1) : 0;

            // Set existing attributes
            request.setAttribute("totalCars", totalCars);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("weeklyBookings", weeklyBookings);
            request.setAttribute("carList", carList);
            request.setAttribute("bookingList", bookingList);
            request.setAttribute("activeBookings", activeBookings);
            request.setAttribute("dueTodayBookings", dueTodayBookings);
            request.setAttribute("overdueBookings", overdueBookings);
            request.setAttribute("thisMonthRevenue", thisMonthRevenue);

            // Set NEW user attributes
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("userList", userList);
            request.setAttribute("adminUsers", adminUsers);
            request.setAttribute("staffUsers", staffUsers);

            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error loading dashboard");
        }
    }
}
