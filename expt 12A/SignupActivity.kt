package com.example.authappkotlin

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

class SignupActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_signup)
        auth = FirebaseAuth.getInstance()

        val emailEt = findViewById<android.widget.EditText>(R.id.emailEt)
        val passEt = findViewById<android.widget.EditText>(R.id.passEt)
        val signupBtn = findViewById<android.widget.Button>(R.id.signupBtn)

        signupBtn.setOnClickListener {
            val email = emailEt.text.toString().trim()
            val pass = passEt.text.toString().trim()
            if (email.isEmpty() || pass.isEmpty()) {
                android.widget.Toast.makeText(this, "Enter email and password", android.widget.Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            auth.createUserWithEmailAndPassword(email, pass).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    android.widget.Toast.makeText(this, "Account created", android.widget.Toast.LENGTH_SHORT).show()
                    startActivity(Intent(this, LoginActivity::class.java))
                    finish()
                } else {
                    android.widget.Toast.makeText(this, "Signup failed: ${task.exception?.message}", android.widget.Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}
