package dao;

import model.Car;
import java.sql.*;
import java.util.*;
import utils.DBUtils;

public class CarDAO {

    private final Connection conn;

    public CarDAO(Connection conn) {
        this.conn = conn;
    }

    // Get all available cars
    public List<Car> getAllAvailableCars() throws SQLException {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars WHERE status = 'available'";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
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
                car.setFeatures(rs.getString("features"));
                car.setImageUrl(rs.getString("image_url"));
                car.setStatus(rs.getString("status"));
                car.setCreatedAt(rs.getTimestamp("created_at"));
                cars.add(car);
            }
        }

        return cars;
    }

    // search availabl cars
// Search available cars (simplified placeholder logic)
    public List<Car> searchAvailableCars(String pickupLocation, String dropoffLocation, String pickupDate, String dropoffDate, String pickupTime) throws SQLException {
        List<Car> cars = new ArrayList<>();

        // Since we don't store location, this is a placeholder filter — adjust logic once location is implemented
        String sql = "SELECT * FROM cars WHERE status = 'available'";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
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
                car.setFeatures(rs.getString("features"));
                car.setImageUrl(rs.getString("image_url"));
                car.setStatus(rs.getString("status"));
                car.setCreatedAt(rs.getTimestamp("created_at"));
                cars.add(car);
            }
        }
        return cars;
    }

    // Get car by ID
    public Car getCarById(int id) throws SQLException {
        String sql = "SELECT * FROM cars WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
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
                    car.setFeatures(rs.getString("features"));
                    car.setImageUrl(rs.getString("image_url"));
                    car.setStatus(rs.getString("status"));
                    car.setCreatedAt(rs.getTimestamp("created_at"));
                    return car;
                }
            }
        }
        return null;
    }

    // Add new car
    public void addCar(Car car) throws SQLException {
        String sql = "INSERT INTO cars (make, model, year_made, license_plate, daily_rate, mileage, transmission, seats, luggage, fuel_type, features, image_url, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, car.getMake());
            stmt.setString(2, car.getModel());
            stmt.setInt(3, car.getYearMade());
            stmt.setString(4, car.getLicensePlate());
            stmt.setDouble(5, car.getDailyRate());
            stmt.setInt(6, car.getMileage());
            stmt.setString(7, car.getTransmission());
            stmt.setInt(8, car.getSeats());
            stmt.setInt(9, car.getLuggage());
            stmt.setString(10, car.getFuelType());
            stmt.setString(11, car.getFeatures());
            stmt.setString(12, car.getImageUrl());
            stmt.setString(13, car.getStatus());

            stmt.executeUpdate();
        }
    }

    // Update existing car
    public void updateCar(Car car) throws SQLException {
        String sql = "UPDATE cars SET make=?, model=?, year_made=?, license_plate=?, daily_rate=?, mileage=?, transmission=?, seats=?, luggage=?, fuel_type=?, features=?, image_url=?, status=? WHERE id=?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, car.getMake());
            stmt.setString(2, car.getModel());
            stmt.setInt(3, car.getYearMade());
            stmt.setString(4, car.getLicensePlate());
            stmt.setDouble(5, car.getDailyRate());
            stmt.setInt(6, car.getMileage());
            stmt.setString(7, car.getTransmission());
            stmt.setInt(8, car.getSeats());
            stmt.setInt(9, car.getLuggage());
            stmt.setString(10, car.getFuelType());
            stmt.setString(11, car.getFeatures());
            stmt.setString(12, car.getImageUrl());
            stmt.setString(13, car.getStatus());
            stmt.setInt(14, car.getId());

            stmt.executeUpdate();
        }
    }

    // Delete car
    public void deleteCar(int id) throws SQLException {
        String sql = "DELETE FROM cars WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
