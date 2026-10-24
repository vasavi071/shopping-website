package com.shop.servlet;

import com.shop.dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = val(req.getParameter("name"));
        String email = val(req.getParameter("email"));
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        String confirm = req.getParameter("confirm") == null ? "" : req.getParameter("confirm");

        String error = null;
        if (name.length() < 2) error = "Please enter your name.";
        else if (!EMAIL.matcher(email).matches()) error = "Please enter a valid email address.";
        else if (password.length() < 6) error = "Password must be at least 6 characters.";
        else if (!password.equals(confirm)) error = "Passwords do not match.";

        try {
            if (error == null && !dao.register(name, email, password)) {
                error = "An account with this email already exists.";
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }
        CartServlet.flash(req.getSession(), "success", "Account created! Please log in.");
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    private static String val(String s) { return s == null ? "" : s.trim(); }
}
