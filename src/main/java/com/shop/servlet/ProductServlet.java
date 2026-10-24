package com.shop.servlet;

import com.shop.dao.ProductDAO;
import com.shop.model.Product;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** /products (list + search + category filter) and /product?id=N (detail). */
@WebServlet(urlPatterns = {"/products", "/product"})
public class ProductServlet extends HttpServlet {
    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if ("/product".equals(req.getServletPath())) {
                int id = parseInt(req.getParameter("id"));
                Product p = dao.findById(id);
                if (p == null) { resp.sendError(404, "Product not found"); return; }
                req.setAttribute("product", p);
                req.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(req, resp);
            } else {
                String q = req.getParameter("q");
                String category = req.getParameter("category");
                req.setAttribute("products", dao.search(q, category));
                req.setAttribute("categories", dao.categories());
                req.setAttribute("q", q == null ? "" : q);
                req.setAttribute("selectedCategory", category == null ? "" : category);
                req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private static int parseInt(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return -1; }
    }
}
