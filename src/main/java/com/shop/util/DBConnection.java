package com.shop.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Simple JDBC connection provider. Override via env vars DB_URL, DB_USER, DB_PASS. */
public class DBConnection {

    private static final String URL = env("DB_URL",
            "jdbc:mysql://localhost:3306/shop_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
    private static final String USER = env("DB_USER", "root");
    private static final String PASS = env("DB_PASS", "722006");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    private static String env(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isEmpty()) ? def : v;
    }
}
