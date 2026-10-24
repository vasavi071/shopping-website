package com.shop.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/** PBKDF2 password hashing. Stored format: base64(salt):base64(hash) */
public class PasswordUtil {

    private static final int ITERATIONS = 65536;
    private static final int KEY_BITS = 256;

    public static String hash(String password) {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        byte[] h = pbkdf2(password.toCharArray(), salt);
        return Base64.getEncoder().encodeToString(salt) + ":" + Base64.getEncoder().encodeToString(h);
    }

    public static boolean verify(String password, String stored) {
        String[] parts = stored.split(":");
        if (parts.length != 2) return false;
        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] expected = Base64.getDecoder().decode(parts[1]);
        byte[] actual = pbkdf2(password.toCharArray(), salt);
        int diff = expected.length ^ actual.length;
        for (int i = 0; i < expected.length && i < actual.length; i++) diff |= expected[i] ^ actual[i];
        return diff == 0;
    }

    private static byte[] pbkdf2(char[] pw, byte[] salt) {
        try {
            SecretKeyFactory f = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            return f.generateSecret(new PBEKeySpec(pw, salt, ITERATIONS, KEY_BITS)).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException(e);
        }
    }
}
