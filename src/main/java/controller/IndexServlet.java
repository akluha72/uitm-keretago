package controller;

import dao.CarDAO;
import model.Car;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CarDAO carDAO;
        try {
            carDAO = new CarDAO();
            List<Car> cars = carDAO.getAllCars();
            request.setAttribute("carList", cars);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(IndexServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
}
