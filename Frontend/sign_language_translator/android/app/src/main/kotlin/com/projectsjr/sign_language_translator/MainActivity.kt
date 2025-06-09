package com.projectsjr.sign_language_translator

import io.flutter.embedding.android.FlutterActivity

// Navbar
import android.os.Bundle
import android.os.Build
import android.view.Window
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    
    // Navbar
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val window: Window = getWindow()
            window.navigationBarColor = android.graphics.Color.TRANSPARENT
        }

        window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
    }    
}
