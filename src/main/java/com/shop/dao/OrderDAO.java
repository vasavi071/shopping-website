package com.shop.dao;

import com.shop.model.*;
import com.shop.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class OrderDAO {

    /**
     * Places an order in a single transaction: checks/decrements stock, re-reads
     * the current price from the DB, inserts order + items.
     * @return new order id
     */
    public int placeOrder(int userId, Collection<CartItem> items, String address) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                BigDecimal total = BigDecimal.ZERO;
                Map<Integer, BigDecimal> prices = new HashMap<>();

                for (CartItem item : items) {
                    try (PreparedStatement upd = c.prepareStatement(
                            "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?")) {
                        upd.setInt(1, item.getQuantity());
                        upd.setInt(2, item.getProductId());
                        upd.setInt(3, item.getQuantity());
                        if (upd.executeUpdate() == 0) {
                            throw new SQLException("Not enough stock for \"" + item.getName() + "\".");
                        }
                    }
                    try (PreparedStatement sel = c.prepareStatement("SELECT price FROM products WHERE id = ?")) {
                        sel.setInt(1, item.getProductId());
                        try (ResultSet rs = sel.executeQuery()) {
                            rs.next();
                            BigDecimal price = rs.getBigDecimal(1);
                            prices.put(item.getProductId(), price);
                            total = total.add(price.multiply(BigDecimal.valueOf(item.getQuantity())));
                        }
                    }
                }

                int orderId;
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO orders (user_id, total, address) VALUES (?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ins.setInt(1, userId);
                    ins.setBigDecimal(2, total);
                    ins.setString(3, address);
                    ins.executeUpdate();
                    try (ResultSet keys = ins.getGeneratedKeys()) {
                        keys.next();
                        orderId = keys.getInt(1);
                    }
                }

                try (PreparedStatement li = c.prepareStatement(
                        "INSERT INTO order_items (order_id, product_id, product_name, quantity, price) VALUES (?,?,?,?,?)")) {
                    for (CartItem item : items) {
                        li.setInt(1, orderId);
                        li.setInt(2, item.getProductId());
                        li.setString(3, item.getName());
                        li.setInt(4, item.getQuantity());
                        li.setBigDecimal(5, prices.get(item.getProductId()));
                        li.addBatch();
                    }
                    li.executeBatch();
                }

                c.commit();
                return orderId;
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }

    public List<Order> findByUser(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC, id DESC");
             PreparedStatement items = c.prepareStatement(
                     "SELECT product_name, quantity, price FROM order_items WHERE order_id = ?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setTotal(rs.getBigDecimal("total"));
                    o.setAddress(rs.getString("address"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    orders.add(o);
                }
            }
            for (Order o : orders) {
                items.setInt(1, o.getId());
                try (ResultSet rs = items.executeQuery()) {
                    while (rs.next()) {
                        o.getItems().add(new OrderItem(rs.getString(1), rs.getInt(2), rs.getBigDecimal(3)));
                    }
                }
            }
        }
        return orders;
    }
}
