package com.shop.servlet;

import com.shop.dao.OrderDAO;
import com.shop.model.User;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {
    private final OrderDAO dao = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        try {
            req.setAttribute("orders", dao.findByUser(user.getId()));
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
        req.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(req, resp);
    }
}
