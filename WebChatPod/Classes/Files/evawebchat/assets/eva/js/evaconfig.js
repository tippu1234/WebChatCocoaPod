var evaConfiguration = {
  "isEvaMobileApp": true,
  "vaserver": "https://eva-cdb1.cue-me.com",
  "evaBotConfig": {
    "evaSpeechEnabled": true,
    "disableTTS": false,
    "isActivelyAwaitingUserResponse": false,
    "connectionOptions": {
      "botappid": "75582.56726710792", // "75582.56726710792" -- Lucid-Multimodal, "63264.26655690474" -- lucidcustcare
      // "bottoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJldmFjYWZlLmFpIiwiYXVkIjoiZXZhY2FmZS5haSIsInByb2plY3RJZCI6IjE2Mjc5Ljc5MzgzOTAxMjMwMiIsInR5cGUiOiJTIiwiaWF0IjoxNjk4ODY3NjU4LCJleHAiOjIzNjE1NzcyNTh9.w0f2ESVTY1cW0a5bB1GaltO5LNahzWTV81OZdpWXCt4",
      "webSocket": true,
      "domain": "https://eva-cdb1.cue-me.com/evadirectline/v3/directline",
      "user": "lucidcustomercare",
      "tokengeneratorserver": "https://eva-cdb1.cue-me.com/bottokenserver/generatetoken"
    },
    "styleOptions": {
      "botAvatarInitials": "",
      "botAvatarImage": "assets/images/eva_chatboticon.svg",
      "botAvatarBackgroundColor": "transparent",
      "backgroundColor": "#1E1E1E",
      "bubbleBackground": "#0439D9",
      "bubbleBorderColor": "#0439D9",
      "bubbleTextColor": "white",
      "bubbleFromUserBackground": "#2B2930",
      "bubbleFromUserBorderColor": "#2B2930",
      "bubbleFromUserTextColor": "white",
      "suggestedActionLayout": "stacked",
      "hideUploadButton": true,
      "sendTimeout": 30000,
      "primaryFont": "-apple-system, BlinkMacSystemFont, \"Segoe UI\", Helvetica, Roboto, Arial, sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\"",
      "timestampColor": "#5F646D",
      "bubbleNubOffset": "bottom",
      "bubbleNubSize": 2,
      "bubbleFromUserNubOffset": "bottom",
      "bubbleFromUserNubSize": 2,
      "bubbleBorderRadius": 10,
      "bubbleFromUserBorderRadius": 10,
      "sendBoxTextWrap": true,
      "suggestedActionHeight": 0,
      "suggestedActionBorderColor": "transparent",
      "sendBoxButtonColor": "white"
    },
    "supportedLanguages": [
      { "name": "English", "code": "en-US", "lang_code": "en", "voice_type": "en-US-JennyNeural", "tts_voicename": "JennyNeural" },
      { "name": "Arabic", "code": "ar-AE", "lang_code": "ar", "voice_type": "ar-AE-FatimaNeural", "tts_voicename": "FatimaNeural" }
    ],
    "userSettings": [
      {
        "id": "speech",
        "label": "Speech",
        "checked": false,
        "type": "toggle",
        "options": [
          { "id": "speech", "label": "Speech", "value": "speech" }
        ]
      },
      // {
      //   "id": "avatar",
      //   "label": "Avatar",
      //   "checked": false,
      //   "type": "toggle",
      //   "options": [
      //     { "id": "avatar", "label": "Avatar", "value": "avatar" }
      //   ]
      // },
      // {
      //   "id": "botdomain",
      //   "label": "Bot Domain",
      //   "selected": null,
      //   "type": "dropdown",
      //   "options": [
      //     { "id": "development", "label": "Development", "value": "https://eva-cdbdev.cue-me.com/evadirectline/v3/directline" },
      //     { "id": "staging", "label": "Staging", "value": "https://eva-cdb1.cue-me.com/evadirectline/v3/directline" },
      //     { "id": "production", "label": "Production", "value": "https://eva-cdb.cue-me.com/evadirectline/v3/directline" }
      //   ]
      // }
    ]
  },
  "evaTTSConfig": {
    "enabled": false,
    "domain": "https://dev-avatargpu.cue-me.com",
    "tts_client": "deepgram_tts",
    "voice_name": "aura-asteria-en"
  },
  "evalogin": {
    // Messages for Biometrics feature (touchid) configuration
    "message_biometricconfig_touchidreadtitle": {
      "en": "Touch ID for EVA Application",
      "es": "Touch ID para la aplicación EVA"
    },
    "message_biometricconfig_touchidreaddescription": {
      "en": "Sign in the User",
      "es": "Inicia sesión en el usuario"
    },
    "message_biometricconfig_touchidsavetitle": {
      "en": "Save Touch ID for EVA Application",
      "es": "Guardar Touch ID para la aplicación EVA"
    },
    "message_biometricconfig_touchidsavedescription": {
      "en": "Saving the User",
      "es": "Guardar el usuario"
    },
    "message_biometricconfig_touchidfallbackbuttontitle": {
      "en": "Normal Login",
      "es": "Inicio de sesión normal"
    },

    // Messages for touch/face and voice selector (Example: Alert Header for Touch ID / Face and Voice ID)
    "message_biometrics_enrollment": {
      "en": "Biometrics Enrollment",
      "es": "Inscripción biométrica"
    },
    "message_biometrics_enrollment_confirmation": {
      "en": "Do you want to perform biometrics authentication?",
      "es": "¿Quieres realizar la autenticación biométrica?"
    },
    "message_biometrics_enrollment_confirmation_ok": {
      "en": "Yes",
      "es": "Sí"
    },
    "message_biometrics_enrollment_confirmation_cancel": {
      "en": "No",
      "es": "No"
    },
    "message_alert_ok": {
      "en": "Ok",
      "es": "De acuerdo"
    },
    "message_biometrics_touchid": {
      "en": "Touch ID",
      "es": "identifición de toque"
    },
    "message_biometrics_faceid": {
      "en": "Face ID",
      "es": "identificación facial"
    },
    // "message_enroll_touch_id_title": {
    //   "en": "Enable Touch ID for EVA Application",
    //   "es": "Habilitar Touch ID para la aplicación EVA"
    // },
    // "message_disable_touch_id_title": {
    //   "en": "Disable Touch ID for EVA Application",
    //   "es": "Deshabilitar Touch ID para la aplicación EVA"
    // },
    // "message_enroll_biometrics_title": {
    //   "en": "Enable Face and Voice ID for EVA Application",
    //   "es": "Habilite Face and Voice ID para la aplicación EVA"
    // },
    // "message_disable_biometrics_title": {
    //   "en": "Disable Face and Voice ID for EVA Application",
    //   "es": "Deshabilite Face and Voice ID para la aplicación EVA"
    // },
    // "message_enroll_face_id_title": {
    //   "en": "Enable Face ID for EVA Application",
    //   "es": "Habilitar Face ID para la aplicación EVA"
    // },
    // "message_disable_face_id_title": {
    //   "en": "Disable Face ID for EVA Application",
    //   "es": "Deshabilitar Face ID para la aplicación EVA"
    // },
    // "message_touch_id_signin": {
    //   "en": "Touch ID Sign-in",
    //   "es": "Inicio de sesión de identificación táctil"
    // },
    // "message_biometrics_signin": {
    //   "en": "Face and Voice ID Sign-in",
    //   "es": "Inicio de sesión con ID de rostro y voz"
    // },
    // "message_face_id_signin": {
    //   "en": "Face ID Sign-in",
    //   "es": "Inicio de sesión con Face ID"
    // },
    // "message_touch_id_login": {
    //   "en": "Touch ID login",
    //   "es": "Inicio de sesión con identificación táctil"
    // },
    // "message_voice_id_login": {
    //   "en": "Voice ID login",
    //   "es": "Inicio de sesión de ID de voz"
    // },
    // "message_face_id_login": {
    //   "en": "Face ID login",
    //   "es": "Inicio de sesión con identificación facial"
    // },
    "message_touch_id_error": {
      "en": "Touch ID Error",
      "es": "Error de identificación táctil"
    },
    "message_face_id_error": {
      "en": "Face ID Error",
      "es": "Error de identificación facial"
    },
    "message_biometrics_error": {
      "en": "Biometrics Error",
      "es": "Error biométrico"
    },

    // Error Messages
    // "error_message_userid_changed_please_reinstall": {
    //   "en": "User Id change detected. Please reinstall the app.",
    //   "es": "Cambio de ID de usuario detectado. Vuelva a instalar la aplicación."
    // },
    "error_message_fingerprint_save_failed": {
      "en": "Too many Touch ID validation attempts. Try again?",
      "es": "Demasiados intentos de validación de Touch ID. ¿Intentar otra vez?"
    },
    "error_message_fingerprint_save_failed_lockout": {
      "en": "Touch ID has been locked. Try again later.",
      "es": "Touch ID ha sido bloqueado. Vuelva a intentarlo más tarde."
    },
    "error_message_face_save_failed_lockout": {
      "en": "Face ID has been locked. Try again later.",
      "es": "Face ID ha sido bloqueado. Vuelva a intentarlo más tarde."
    },
    "error_message_biometric_enrollment_error": {
      "en": "Face and Voice ID Enrollment Error. Do you want to try again?",
      "es": "Error de registro de Face ID y Voice ID. ¿Quieres intentarlo de nuevo?"
    },
    "error_message_biometric_authentication_error": {
      "en": "Face and Voice ID Authentication Error. Please try again later.",
      "es": "Error de autenticación de identificación de rostro y voz. Por favor, inténtelo de nuevo más tarde."
    },
    "error_message_fingerprint_scan_fail": {
      "en": "Touch scan failed. Please login with your username and password.",
      "es": "El escaneo táctil falló. Por favor inicie sesión con su nombre de usuario y contraseña."
    },
    "error_message_face_scan_fail": {
      "en": "Face scan failed. Please login with your username and password.",
      "es": "El escaneo facial falló. Por favor inicie sesión con su nombre de usuario y contraseña."
    },
    "error_message_disable_touch": {
      "en": "For security, Touch ID has been disabled.",
      "es": "Por seguridad, Touch ID ha sido deshabilitado."
    },
    "error_message_disable_face": {
      "en": "For security, Face ID has been disabled.",
      "es": "Por seguridad, Face ID ha sido deshabilitado."
    },
    "error_message_fingerprint_not_setup": {
      "en": "Touch ID is not set up on your device. Please go to your device settings and set up Touch ID.",
      "es": "Touch ID no está configurado en su dispositivo. Vaya a la configuración de su dispositivo y configure Touch ID."
    },
    "error_message_face_not_setup": {
      "en": "Face ID is not set up on your device. Please go to your device settings and set up Face ID.",
      "es": "Face ID no está configurado en su dispositivo. Vaya a la configuración de su dispositivo y configure Face ID."
    },
    "error_message_fingerprint_disabled": {
      "en": "We've detected a change to your Touch ID settings on this device. For your security, please sign in with your username and password.",
      "es": "Hemos detectado un cambio en la configuración de tu Touch ID en este dispositivo. Para su seguridad, inicie sesión con su nombre de usuario y contraseña."
    },
    "error_message_face_disabled": {
      "en": "We've detected a change to your Face ID settings on this device. For your security, please sign in with your username and password.",
      "es": "Hemos detectado un cambio en la configuración de Face ID en este dispositivo. Para su seguridad, inicie sesión con su nombre de usuario y contraseña."
    },
    "error_message_login_with_password": {
      "en": "For enhanced security, please log in with your online credentials to reset your biometric preferences.",
      "es": "Para mayor seguridad, inicie sesión con sus credenciales en línea para restablecer sus preferencias biométricas."
    },
    "error_message_fingerprint_hardware_not_detected": {
      "en": "Fingerprint Hardware not detected on your device",
      "es": "Hardware de huellas dactilares no detectado en su dispositivo"
    },
    "error_message_lock_screen_not_secured": {
      "en": "The lock screen is not secured on your device",
      "es": "La pantalla de bloqueo no está protegida en su dispositivo"
    },
    "error_message_suffix_biometrics_not_setup": {
      "en": " is not set up on your device. Please go to your device settings and set up.",
      "es": " no está configurado en su dispositivo. Vaya a la configuración de su dispositivo y configúrelo."
    },

    // Analytics Event Names
    "analytics_event_prefix_platform_event": {
      "en": "EvaAppPlatform/"
    },
    "analytics_event_prefix_app_event": {
      "en": "EvaApp/"
    },
    "analytics_event_authorizeToken": {
      "en": "authorizeToken"
    },
    "analytics_event_onAuthorizationFail": {
      "en": "onAuthorizationFail"
    },
    "analytics_event_refreshAccessToken": {
      "en": "refreshAccessToken"
    },
    "analytics_event_logout": {
      "en": "logout"
    },
    "analytics_event_savetouchbiodata": {
      "en": "saveTouchBiodata"
    },
    "analytics_event_touchidenabled": {
      "en": "TouchIDEnabled"
    },
    "analytics_event_savetouchidfailed": {
      "en": "saveTouchIdFailed"
    },
    "analytics_event_touchloginclicked": {
      "en": "TouchLoginClicked"
    },
    "analytics_event_touchloginfailed": {
      "en": "TouchLoginFailed"
    },
    "analytics_event_deletetouchbiodatakey": {
      "en": "deleteTouchBiodataKey"
    },
    "analytics_event_touchiddisabled": {
      "en": "TouchIDDisabled"
    },
    "analytics_event_enrollbiometrics": {
      "en": "enrollBiometrics"
    },
    "analytics_event_voiceidenabled": {
      "en": "VoiceIDEnabled"
    },
    "analytics_event_biometricenrollerror": {
      "en": "biometricEnrollError"
    },
    "analytics_event_biometricloginclicked": {
      "en": "BiometricLoginClicked"
    },
    "analytics_event_biometricloginfailed": {
      "en": "BiometricLoginFailed"
    },
    "analytics_event_deleteBiometric": {
      "en": "deleteBiometric"
    },
    "analytics_event_voiceiddisabled": {
      "en": "VoiceIDDisabled"
    }
  }
};