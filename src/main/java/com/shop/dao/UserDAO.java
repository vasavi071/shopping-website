package com.shop.dao;

import com.shop.model.User;
import com.shop.util.DBConnection;
import com.shop.util.PasswordUtil;
import java.sql.*;

public class UserDAO {

    /** @return true if created, false if the email already exists */
    public boolean register(String name, String email, String password) throws SQLException {
        String sql = "INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email.toLowerCase());
            ps.setString(3, PasswordUtil.hash(password));
            ps.executeUpdate();
            return true;
        } catch (SQLIntegrityConstraintViolationException dup) {
            return false;
        }
    }

    /** @return the User, or null when credentials are wrong */
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT id, name, email, password_hash FROM users WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && PasswordUtil.verify(password, rs.getString("password_hash"))) {
                    return new User(rs.getInt("id"), rs.getString("name"), rs.getString("email"));
                }
            }
        }
        return null;
    }
}
