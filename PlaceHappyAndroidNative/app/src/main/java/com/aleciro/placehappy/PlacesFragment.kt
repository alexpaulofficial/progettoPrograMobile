package com.aleciro.placehappy

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.recycler.ItemDecorationX
import com.aleciro.placehappy.recycler.PlacesAdapter
import com.aleciro.placehappy.viewmodel.TouristViewModel
import kotlinx.coroutines.launch

// Lista di tutti i luoghi
// Quando si tocca un luogo, entra nel PlaceFragment
class PlacesFragment : Fragment() {

    val viewModel: TouristViewModel by viewModels()

    val args: PlacesFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_places, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val tag = args.nomeTag
        if (tag != "default") {
            var titolo = view.findViewById<TextView>(R.id.textView)
            titolo.text = "Lista dei luoghi con tag #$tag"

        }

        lifecycleScope.launch {
            var listaluoghi: MutableList<Place> = mutableListOf()
            if (tag != "default") {
                viewModel.viewPlacesByTag(tag)
                listaluoghi = viewModel.placesByTag

            } else {
                viewModel.getAllPlaces()
                listaluoghi = viewModel.placesList
            }


            val rv: RecyclerView = view.findViewById(R.id.recyclerView)
            rv.layoutManager = LinearLayoutManager(activity?.applicationContext)
            rv.addItemDecoration(
                ItemDecorationX(
                    activity?.applicationContext!!,
                    R.drawable.line_divider
                )
            )

            rv.adapter = PlacesAdapter(listaluoghi)
        }


    }
}
