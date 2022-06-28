package com.lapakprogrammer.biometric.biometric_fingerprint

data class BiometricPromptInfo(
    val title: String,
    val subtitle: String? = null,
    val description: String? = null,
    val negativeButtonText: String,
    val confirmationRequired: Boolean = false,
    val deviceCredentialAllowed: Boolean = false
)