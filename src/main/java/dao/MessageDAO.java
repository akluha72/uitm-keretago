package dao;

import model.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    private Connection conn;

    public MessageDAO(Connection conn) {
        this.conn = conn;
    }

    // Submit new message (from contact.jsp)
    public void addMessage(Message message) throws SQLException {
        String sql = "INSERT INTO messages (full_name, email, subject, message) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, message.getFullName());
            stmt.setString(2, message.getEmail());
            stmt.setString(3, message.getSubject());
            stmt.setString(4, message.getMessage());
            stmt.executeUpdate();
        }
    }

    // Admin: View all messages
    public List<Message> getAllMessages() throws SQLException {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM messages ORDER BY created_at DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setFullName(rs.getString("full_name"));
                msg.setEmail(rs.getString("email"));
                msg.setSubject(rs.getString("subject"));
                msg.setMessage(rs.getString("message"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(msg);
            }
        }
        return list;
    }
}
