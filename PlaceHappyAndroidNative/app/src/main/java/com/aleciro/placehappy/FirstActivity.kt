package com.aleciro.placehappy

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

// Questa è l'activity che parte come principale
// Eventualmente se l'utente fosse loggato istanzia FirebaseAuth
// altrimenti si passa a LoginActivity
class FirstActivity : AppCompatActivity() {
    private var mAuth: FirebaseAuth? = null
    val LOGIN_REQUEST = 101

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_first)
        val preferences = getSharedPreferences("login", MODE_PRIVATE)
        if (preferences.getBoolean("firstrun", true)) {
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)
        } else {
            mAuth = FirebaseAuth.getInstance()
            val currentUser = mAuth!!.currentUser
            // supportActionBar!!.setTitle(currentUser!!.displayName)
        }
    }

    public override fun onPause() {
        super.onPause()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
        super.onActivityResult(requestCode, resultCode, intent)
        if (requestCode == LOGIN_REQUEST) {
            if (resultCode == RESULT_OK) {
                val nome = intent!!.extras!!.getString("nome")
                val cognome = intent.extras!!.getString("cognome")
                supportActionBar!!.setTitle("$nome $cognome")
                val preferences = getSharedPreferences("login", MODE_PRIVATE)
                val editor = preferences.edit()
                editor.putBoolean("firstrun", false)
                editor.apply()
            }
        }
    }
}