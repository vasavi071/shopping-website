package com.shop.servlet;

import com.shop.dao.ProductDAO;
import com.shop.model.CartItem;
import com.shop.model.Product;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Session-based shopping cart. GET shows the cart; POST handles add/update/remove/clear. */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Integer, CartItem> cart = getCart(req.getSession());
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem i : cart.values()) total = total.add(i.getSubtotal());
        req.setAttribute("cartTotal", total);
        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = getCart(session);
        String action = req.getParameter("action");
        int id = parse(req.getParameter("id"), -1);
        int qty = parse(req.getParameter("quantity"), 1);

        try {
            if ("add".equals(action)) {
                Product p = dao.findById(id);
                if (p == null || p.getStock() <= 0) {
                    flash(session, "danger", "Sorry, that product is unavailable.");
                } else {
                    CartItem existing = cart.get(id);
                    int newQty = Math.min(p.getStock(), (existing == null ? 0 : existing.getQuantity()) + Math.max(1, qty));
                    cart.put(id, new CartItem(p, newQty));
                    flash(session, "success", "\"" + p.getName() + "\" added to your cart.");
                }
            } else if ("update".equals(action) && cart.containsKey(id)) {
                CartItem item = cart.get(id);
                if (qty <= 0) cart.remove(id);
                else item.setQuantity(Math.min(qty, item.getStock()));
            } else if ("remove".equals(action)) {
                cart.remove(id);
            } else if ("clear".equals(action)) {
                cart.clear();
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }

        updateCount(session, cart);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    @SuppressWarnings("unchecked")
    public static Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    public static void updateCount(HttpSession session, Map<Integer, CartItem> cart) {
        int count = 0;
        for (CartItem i : cart.values()) count += i.getQuantity();
        session.setAttribute("cartCount", count);
    }

    static void flash(HttpSession s, String type, String msg) {
        s.setAttribute("flashType", type);
        s.setAttribute("flash", msg);
    }

    private static int parse(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
