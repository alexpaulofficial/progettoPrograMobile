package com.aleciro.placehappy

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.database.Tag
import com.aleciro.placehappy.recycler.ItemDecorationX
import com.aleciro.placehappy.recycler.PlacesAdapter
import com.aleciro.placehappy.recycler.TagsAdapter
import com.aleciro.placehappy.viewmodel.TouristViewModel
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
            viewModel.getAllTags()
            val listatag : MutableList<String> = viewModel.tagsList





            val rv: RecyclerView = view.findViewById(R.id.recyclerTag)
            rv.layoutManager = LinearLayoutManager(activity?.applicationContext)




            rv.adapter = TagsAdapter(listatag)




        }
    }


}