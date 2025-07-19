package utils;


import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseInitializer {

    public static void init() throws SQLException {
        try (Connection conn = DBUtils.getConnection()) {
            Statement stmt = conn.createStatement();
            String sql = new String(Files.readAllBytes(Paths.get("src/main/resources/sql/initSchema.sql")));
            stmt.executeUpdate(sql);
            System.out.println("Database initialized.");
        } catch (IOException e) {
            System.out.println("Database already initialized or failed to initialize: " + e.getMessage());
        }
    }
}
