package com.shop.dao;

import com.shop.model.Product;
import com.shop.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> search(String query, String category) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        List<String> params = new ArrayList<>();
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            String like = "%" + query.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ?");
            params.add(category.trim());
        }
        sql.append(" ORDER BY id DESC");

        List<Product> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setString(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public Product findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM products WHERE id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<String> categories() throws SQLException {
        List<String> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT DISTINCT category FROM products ORDER BY category")) {
            while (rs.next()) list.add(rs.getString(1));
        }
        return list;
    }

    private Product map(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStock(rs.getInt("stock"));
        p.setCategory(rs.getString("category"));
        p.setImageUrl(rs.getString("image_url"));
        return p;
    }
}
