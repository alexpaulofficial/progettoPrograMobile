package com.aleciro.placehappy

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.textfield.TextInputEditText
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.ktx.Firebase


class LoginActivity: AppCompatActivity() {
    // [START declare_auth]
    private lateinit var auth: FirebaseAuth
    // [END declare_auth]


    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // [START initialize_auth]
        // Initialize Firebase Auth
        auth = Firebase.auth
        // [END initialize_auth]
        setContentView(R.layout.account_login)
        var btnLogin = findViewById<Button>(R.id.btn_login)
        var btnNuovoUtente = findViewById<Button>(R.id.btn_nuovoUtente)
        var textEmail = findViewById<TextInputEditText>(R.id.text_email)
        var textPassword = findViewById<TextInputEditText>(R.id.text_password)

        btnLogin.setOnClickListener {

            val email = textEmail.text.toString()
            val password = textPassword.text.toString()

            signIn(email, password)
        }
        btnNuovoUtente.setOnClickListener {
            setContentView(R.layout.account_signup)
            var textNome = findViewById<TextInputEditText>(R.id.text_nome)
            var textCognome = findViewById<TextInputEditText>(R.id.text_cognome)
            var btnRegistra = findViewById<Button>(R.id.btn_registra)
            textEmail = findViewById<TextInputEditText>(R.id.text_email)
            textPassword = findViewById<TextInputEditText>(R.id.text_password)

            btnRegistra.setOnClickListener {
                val nome = textNome.text.toString()
                val cognome = textCognome.text.toString()
                val email = textEmail.text.toString()
                val password = textPassword.text.toString()

                createAccount(nome, cognome, email, password)
            }
        }
    }

    // [START on_start_check_user]
    public override fun onStart() {
        super.onStart()
        // Check if user is signed in (non-null) and update UI accordingly.
        val currentUser = auth.currentUser
        if(currentUser != null){
            reload();
        }
    }
    // [END on_start_check_user]

    private fun createAccount(nome: String, cognome: String, email: String, password: String) {
        // [START create_user_with_email]
        auth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    // Sign in success, update UI with the signed-in user's information
                    Log.d(TAG, "createUserWithEmail:success")
                    val user = auth.currentUser
                    writeUserToDb(nome, cognome, user!!.uid)
                    updateUI(user)
                } else {
                    // If sign in fails, display a message to the user.
                    Log.w(TAG, "createUserWithEmail:failure", task.exception)
                    Toast.makeText(baseContext, "Authentication failed.",
                        Toast.LENGTH_SHORT).show()
                    updateUI(null)
                }
            }
        // [END create_user_with_email]
    }

    private fun signIn(email: String, password: String) {
        // [START sign_in_with_email]
        auth.signInWithEmailAndPassword(email, password)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    // Sign in success, update UI with the signed-in user's information
                    Log.d(TAG, "signInWithEmail:success")
                    val user = auth.currentUser
                    updateUI(user)
                } else {
                    // If sign in fails, display a message to the user.
                    Log.w(TAG, "signInWithEmail:failure", task.exception)
                    Toast.makeText(baseContext, "Authentication failed.",
                        Toast.LENGTH_SHORT).show()
                    updateUI(null)
                }
            }
        // [END sign_in_with_email]
    }

    private fun updateUI(user: FirebaseUser?) {
        val intent = Intent(this, MainActivity::class.java)
        val b = Bundle()
        if (user != null) {
            b.putString("userId", user.uid)
            intent.putExtras(b) //Put your id to your next Intent

            startActivity(intent)
            finish()
        } //Your id


    }

    private fun reload() {
        Toast.makeText(baseContext, "Reload",
            Toast.LENGTH_SHORT).show()
        updateUI(Firebase.auth.currentUser)
    }

    companion object {
        private const val TAG = "EmailPassword"
    }

    private fun writeUserToDb(nome: String, cognome: String, uid: String) {
        val user = hashMapOf(
            "nome" to nome,
            "cognome" to cognome
        )

        val db = FirebaseFirestore.getInstance()
        db.collection("utenti").document(uid).set(user)
    }
}