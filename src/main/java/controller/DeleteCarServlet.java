package controller;

import utils.DBUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/delete-car")
public class DeleteCarServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        System.out.println("DELETING CAR:" + idStr);
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Car ID is missing.");
            return;
        }

        try {
            int carId = Integer.parseInt(idStr);
            try (Connection conn = DBUtils.getConnection()) {
                String sql = "DELETE FROM cars WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, carId);
                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error deleting car.");
        }
    }
}
