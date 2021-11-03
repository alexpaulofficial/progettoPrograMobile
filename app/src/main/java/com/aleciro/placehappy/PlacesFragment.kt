package com.aleciro.placehappy

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.viewModels
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.database.Tag
import com.aleciro.placehappy.recycler.ItemDecorationX
import com.aleciro.placehappy.recycler.PlacesAdapter
import com.aleciro.placehappy.viewmodel.TouristViewModel
import kotlinx.coroutines.launch


class PlacesFragment : Fragment() {


    val viewModel: TouristViewModel by viewModels()
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_places, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        lifecycleScope.launch {
            viewModel.getAllPlaces()
            val listaluoghi: MutableList<Place> = viewModel.placesList


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
