package com.shop.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/** Requires a logged-in user for checkout and order history. */
@WebFilter(urlPatterns = {"/checkout", "/orders"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            String next = request.getServletPath();
            response.sendRedirect(request.getContextPath() + "/login?next=" + next);
            return;
        }
        chain.doFilter(req, res);
    }
}
