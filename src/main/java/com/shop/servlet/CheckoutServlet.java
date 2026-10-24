package com.shop.servlet;

import com.shop.dao.OrderDAO;
import com.shop.model.CartItem;
import com.shop.model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Integer, CartItem> cart = CartServlet.getCart(req.getSession());
        if (cart.isEmpty()) {
            CartServlet.flash(req.getSession(), "warning", "Your cart is empty.");
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem i : cart.values()) total = total.add(i.getSubtotal());
        req.setAttribute("cartTotal", total);
        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = CartServlet.getCart(session);
        User user = (User) session.getAttribute("user");
        String address = req.getParameter("address") == null ? "" : req.getParameter("address").trim();

        if (cart.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/products"); return; }
        if (address.length() < 10) {
            CartServlet.flash(session, "danger", "Please enter a complete delivery address.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }
        try {
            int orderId = orderDAO.placeOrder(user.getId(), cart.values(), address);
            cart.clear();
            CartServlet.updateCount(session, cart);
            CartServlet.flash(session, "success", "Order #" + orderId + " placed successfully. Thank you!");
            resp.sendRedirect(req.getContextPath() + "/orders");
        } catch (SQLException e) {
            CartServlet.flash(session, "danger", "Could not place order: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
