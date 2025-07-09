package dao;

import model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    private Connection conn;

    public BookingDAO(Connection conn) {
        this.conn = conn;
    }

    // Add a new booking
    public void addBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (car_id, user_email, pickup_date, return_date, pickup_time, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, booking.getCarId());
            stmt.setString(2, booking.getUserEmail());
            stmt.setDate(3, booking.getPickupDate());
            stmt.setDate(4, booking.getReturnDate());
            stmt.setTime(5, booking.getPickupTime());
            stmt.setString(6, booking.getStatus());

            stmt.executeUpdate();
        }
    }

    // Get all bookings by user's email
    public List<Booking> getBookingsByEmail(String email) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_email = ? ORDER BY created_at DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        }

        return bookings;
    }

    // Get all bookings (admin view)
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY created_at DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }
        }

        return bookings;
    }

    // Update booking status (e.g. to complete, cancel)
    public void updateBookingStatus(int id, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
    }

    // Delete a booking
    public void deleteBooking(int id) throws SQLException {
        String sql = "DELETE FROM bookings WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // Helper: Map ResultSet to Booking object
    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setCarId(rs.getInt("car_id"));
        booking.setUserEmail(rs.getString("user_email"));
        booking.setPickupDate(rs.getDate("pickup_date"));
        booking.setReturnDate(rs.getDate("return_date"));
        booking.setPickupTime(rs.getTime("pickup_time"));
        booking.setStatus(rs.getString("status"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        return booking;
    }
}
