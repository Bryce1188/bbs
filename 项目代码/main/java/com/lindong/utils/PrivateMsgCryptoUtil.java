package com.lindong.utils;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

public class PrivateMsgCryptoUtil {

    private static final String PREFIX = "ENC$";
    private static final int IV_LENGTH = 12;
    private static final int TAG_LENGTH = 128;
    private static final String DEFAULT_KEY = "bbs-msg-2026-sec!";

    private PrivateMsgCryptoUtil() {
    }

    public static String encrypt(String plain) {
        if (plain == null || plain.isEmpty()) {
            return plain;
        }
        if (plain.startsWith(PREFIX)) {
            return plain;
        }
        try {
            byte[] key = normalizeKey(loadKey());
            byte[] iv = new byte[IV_LENGTH];
            new SecureRandom().nextBytes(iv);

            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            SecretKeySpec keySpec = new SecretKeySpec(key, "AES");
            GCMParameterSpec gcm = new GCMParameterSpec(TAG_LENGTH, iv);
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, gcm);
            byte[] encrypted = cipher.doFinal(plain.getBytes(StandardCharsets.UTF_8));

            byte[] merged = new byte[iv.length + encrypted.length];
            System.arraycopy(iv, 0, merged, 0, iv.length);
            System.arraycopy(encrypted, 0, merged, iv.length, encrypted.length);
            return PREFIX + Base64.getEncoder().encodeToString(merged);
        } catch (Exception e) {
            return plain;
        }
    }

    public static String decrypt(String cipherText) {
        if (cipherText == null || cipherText.isEmpty()) {
            return cipherText;
        }
        if (!cipherText.startsWith(PREFIX)) {
            return cipherText;
        }
        try {
            byte[] key = normalizeKey(loadKey());
            byte[] merged = Base64.getDecoder().decode(cipherText.substring(PREFIX.length()));
            if (merged.length <= IV_LENGTH) {
                return cipherText;
            }

            byte[] iv = new byte[IV_LENGTH];
            byte[] encrypted = new byte[merged.length - IV_LENGTH];
            System.arraycopy(merged, 0, iv, 0, IV_LENGTH);
            System.arraycopy(merged, IV_LENGTH, encrypted, 0, encrypted.length);

            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            SecretKeySpec keySpec = new SecretKeySpec(key, "AES");
            GCMParameterSpec gcm = new GCMParameterSpec(TAG_LENGTH, iv);
            cipher.init(Cipher.DECRYPT_MODE, keySpec, gcm);
            byte[] plain = cipher.doFinal(encrypted);
            return new String(plain, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return cipherText;
        }
    }

    private static String loadKey() {
        String key = System.getenv("BBS_MSG_AES_KEY");
        if (key == null || key.trim().isEmpty()) {
            key = System.getProperty("bbs.msg.aes.key");
        }
        if (key == null || key.trim().isEmpty()) {
            key = DEFAULT_KEY;
        }
        return key.trim();
    }

    private static byte[] normalizeKey(String key) {
        byte[] raw = key.getBytes(StandardCharsets.UTF_8);
        byte[] normalized = new byte[16];
        for (int i = 0; i < normalized.length; i++) {
            normalized[i] = i < raw.length ? raw[i] : (byte) '#';
        }
        return normalized;
    }
}

