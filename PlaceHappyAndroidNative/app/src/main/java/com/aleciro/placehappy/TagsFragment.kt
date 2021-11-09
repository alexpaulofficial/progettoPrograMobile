package com.aleciro.placehappy

import android.content.ContentValues
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.database.Tag
import com.aleciro.placehappy.recycler.ItemDecorationX
import com.aleciro.placehappy.recycler.PlacesAdapter
import com.aleciro.placehappy.recycler.TagsAdapter
import com.aleciro.placehappy.viewmodel.TouristViewModel
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.launch


class TagsFragment : Fragment() {

    val viewModel: TouristViewModel by viewModels()
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_tags, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)



        lifecycleScope.launch {
            val db: FirebaseFirestore = FirebaseFirestore.getInstance()

                val tagsGet = db.collection("utenti").document(Firebase.auth.currentUser!!.uid.toString())
                var tags = ""

                tagsGet.get()
                    .addOnSuccessListener { document ->
                        if (document != null) {
                            Log.d(ContentValues.TAG, "DocumentSnapshot data: ${document.data}")
                            tags = document.data!!.get("tags") as String
                        } else {
                            Log.d(ContentValues.TAG, "No such document")
                        }
                    }
                    .addOnFailureListener { exception ->
                        Log.d(ContentValues.TAG, "get failed with ", exception)
                    }

            viewModel.getAllTags()
            val listatag : MutableList<String> = viewModel.tagsList

            val rv: RecyclerView = view.findViewById(R.id.recyclerTag)
            rv.layoutManager = LinearLayoutManager(activity?.applicationContext)

            rv.adapter = TagsAdapter(listatag)

        }
    }


}