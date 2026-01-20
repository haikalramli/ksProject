package util;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility
 * Shared by both Photographer and Client portals
 */
public class DBConnection {
    
    // ============================================================
    // IMPORTANT: Update these to match your PostgreSQL database
    // ============================================================
    private static final String URL = "jdbc:postgresql://localhost:5432/ksapp"; // Default Postgres DB
    private static final String USERNAME = "postgres";  // Your Postgres username
    private static final String PASSWORD = "postgres123";  // Your Postgres password
    
    static {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("PostgreSQL JDBC Driver loaded");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() {
        try {
            Connection conn = null;
            String jdbcDbUrl = System.getenv("JDBC_DATABASE_URL");
            
            if (jdbcDbUrl != null && !jdbcDbUrl.isEmpty()) {
                // Use Heroku JDBC environment variable if available
                conn = DriverManager.getConnection(jdbcDbUrl);
            } else {
                String herokuUrl = System.getenv("DATABASE_URL");
                if (herokuUrl != null && !herokuUrl.isEmpty()) {
                    // Parse standard Heroku DATABASE_URL: postgres://user:pass@host:port/db
                    try {
                        URI dbUri = new URI(herokuUrl);
                        String username = dbUri.getUserInfo().split(":")[0];
                        String password = dbUri.getUserInfo().split(":")[1];
                        String dbJdbcUrl = "jdbc:postgresql://" + dbUri.getHost() + ':' + dbUri.getPort() + dbUri.getPath() + "?sslmode=require";
                        conn = DriverManager.getConnection(dbJdbcUrl, username, password);
                    } catch (URISyntaxException e) {
                        System.err.println("Invalid DATABASE_URL syntax: " + e.getMessage());
                    }
                }
            }
            
            // Fallback to local configuration if no Heroku variables are found or failed
            if (conn == null) {
                conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            }
            
            if (conn != null) {
                conn.setAutoCommit(true);
            }
            return conn;
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            return null;
        }
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
