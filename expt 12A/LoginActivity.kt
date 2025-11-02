package com.example.authappkotlin

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

class LoginActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        auth = FirebaseAuth.getInstance()

        // if already signed in, go home
        val user = auth.currentUser
        if (user != null) {
            startActivity(Intent(this, HomeActivity::class.java))
            finish()
            return
        }

        val emailEt = findViewById<android.widget.EditText>(R.id.emailEt)
        val passEt = findViewById<android.widget.EditText>(R.id.passEt)
        val loginBtn = findViewById<android.widget.Button>(R.id.loginBtn)
        val googleBtn = findViewById<android.widget.Button>(R.id.googleBtn)
        val phoneBtn = findViewById<android.widget.Button>(R.id.phoneBtn)
        val toSignup = findViewById<android.widget.TextView>(R.id.toSignup)

        loginBtn.setOnClickListener {
            val email = emailEt.text.toString().trim()
            val pass = passEt.text.toString().trim()
            if (email.isEmpty() || pass.isEmpty()) {
                android.widget.Toast.makeText(this, "Enter email and password", android.widget.Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            auth.signInWithEmailAndPassword(email, pass).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    startActivity(Intent(this, HomeActivity::class.java))
                    finish()
                } else {
                    android.widget.Toast.makeText(this, "Login failed: ${task.exception?.message}", android.widget.Toast.LENGTH_LONG).show()
                }
            }
        }

        toSignup.setOnClickListener {
            startActivity(Intent(this, SignupActivity::class.java))
        }

        phoneBtn.setOnClickListener {
            startActivity(Intent(this, PhoneAuthActivity::class.java))
        }

        // Google button handler is placeholder; requires configuration (OAuth + SHA-1)
        googleBtn.setOnClickListener {
            android.widget.Toast.makeText(this, "Google Sign-In configured in README", android.widget.Toast.LENGTH_LONG).show()
        }
    }
}
