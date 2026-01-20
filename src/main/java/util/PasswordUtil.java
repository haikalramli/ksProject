package util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Password Utility for secure password hashing using BCrypt
 */
public class PasswordUtil {
    
    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    
    /**
     * Hash a plain text password using BCrypt
     * @param plainPassword The plain text password to hash
     * @return BCrypt hashed password
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return encoder.encode(plainPassword);
    }
    
    /**
     * Verify a plain password against a hashed password
     * @param plainPassword The plain text password to verify
     * @param hashedPassword The BCrypt hashed password from database
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return encoder.matches(plainPassword, hashedPassword);
        } catch (Exception e) {
            // If hash is invalid format, return false
            return false;
        }
    }
}
