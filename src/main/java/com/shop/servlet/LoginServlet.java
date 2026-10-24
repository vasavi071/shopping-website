package com.shop.servlet;

import com.shop.dao.UserDAO;
import com.shop.model.User;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("next", safeNext(req.getParameter("next")));
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String next = safeNext(req.getParameter("next"));
        try {
            User user = (email.isEmpty() || password == null) ? null : dao.login(email, password);
            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.setAttribute("email", email);
                req.setAttribute("next", next);
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }
            req.getSession().setAttribute("user", user);
            req.changeSessionId();   // prevent session fixation, keeps the cart
            resp.sendRedirect(req.getContextPath() + next);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    /** Only allow local redirects, e.g. "/checkout". */
    static String safeNext(String next) {
        if (next != null && next.startsWith("/") && !next.startsWith("//")) return next;
        return "/products";
    }

    private static String trim(String s) { return s == null ? "" : s.trim(); }
}
