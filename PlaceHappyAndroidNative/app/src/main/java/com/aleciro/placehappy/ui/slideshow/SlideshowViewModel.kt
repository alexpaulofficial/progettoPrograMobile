package com.aleciro.placehappy.ui.slideshow

import android.content.ContentValues.TAG
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.ktx.Firebase

// In questo caso si usa anche il database Firestore per scrivere il Nome e Cognome
class SlideshowViewModel : ViewModel() {
    val db: FirebaseFirestore = FirebaseFirestore.getInstance()

    private val _text = MutableLiveData<String>().apply {

        val utente = db.collection("utenti").document(Firebase.auth.currentUser!!.uid.toString())
        var nomeUtente = ""
        var cognomeUtente = ""

        utente.get()
            .addOnSuccessListener { document ->
                if (document != null) {
                    Log.d(TAG, "DocumentSnapshot data: ${document.data}")
                    nomeUtente = document.data!!.get("nome") as String
                    cognomeUtente = document.data!!.get("cognome") as String

                    value =
                        "Nome: " + nomeUtente + "\n" + "Cognome: " + cognomeUtente + "\n" + "Email: " + Firebase.auth.currentUser!!.email
                } else {
                    Log.d(TAG, "No such document")
                }
            }
            .addOnFailureListener { exception ->
                Log.d(TAG, "get failed with ", exception)
            }
    }
    val text: LiveData<String> = _text
}