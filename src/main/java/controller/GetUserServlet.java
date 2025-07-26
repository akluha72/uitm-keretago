package controller;

import utils.DBUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/get-user")
public class GetUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");

        try {
            String userIdParam = request.getParameter("id");

    
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing required parameter: id\"}");
                return;
            }

            int userId;
            try {
                userId = Integer.parseInt(userIdParam.trim());
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid user ID format\"}");
                return;
            }

            try (Connection conn = DBUtils.getConnection()) {
                String selectSql = "SELECT id, full_name, email, phone, roles, created_at FROM users WHERE id = ?";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    selectStmt.setInt(1, userId);
                    ResultSet rs = selectStmt.executeQuery();

                    if (rs.next()) {
    
                        JsonObject userJson = new JsonObject();
                        userJson.addProperty("id", rs.getInt("id"));
                        userJson.addProperty("fullName", rs.getString("full_name"));
                        userJson.addProperty("email", rs.getString("email"));

                        String phone = rs.getString("phone");
                        if (phone != null) {
                            userJson.addProperty("phone", phone);
                        }

                        userJson.addProperty("roles", rs.getString("roles"));
                        userJson.addProperty("createdAt", rs.getTimestamp("created_at").toString());

       
                        Gson gson = new Gson();
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write(gson.toJson(userJson));

                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("{\"error\":\"User not found\"}");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error occurred\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"An unexpected error occurred\"}");
        }
    }
}
