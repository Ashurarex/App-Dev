package com.example.authappkotlin

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

class HomeActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)
        auth = FirebaseAuth.getInstance()

        val welcomeTv = findViewById<android.widget.TextView>(R.id.welcomeTv)
        val signoutBtn = findViewById<android.widget.Button>(R.id.signoutBtn)

        val user = auth.currentUser
        welcomeTv.text = "Hello, ${'$'}{user?.email ?: user?.phoneNumber ?: "User"}"

        signoutBtn.setOnClickListener {
            auth.signOut()
            finish()
        }
    }
}
