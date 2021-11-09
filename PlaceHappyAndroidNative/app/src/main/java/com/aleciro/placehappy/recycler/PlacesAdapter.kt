package com.aleciro.placehappy.recycler

import android.app.Application
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.navigation.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.aleciro.placehappy.PlacesFragmentDirections
import com.aleciro.placehappy.R


import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.viewmodel.TouristViewModel

class PlacesAdapter(val data: MutableList<Place>) : RecyclerView.Adapter<PlacesAdapter.MyViewHolder>() {
    class MyViewHolder(val row: View) : RecyclerView.ViewHolder(row) {
        val nome = row.findViewById<TextView>(R.id.nome)
        val descrizioneBreve = row.findViewById<TextView>(R.id.descShort)
        val image = row.findViewById<ImageView>(R.id.imageView)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val layout = LayoutInflater.from(parent.context).inflate(
            R.layout.place_item,
            parent, false
        )
        val holder = MyViewHolder(layout)
        holder.row.setOnClickListener {
            val action =
                PlacesFragmentDirections.actionLuoghiToPlaceFragment(holder.row.findViewById<TextView>(R.id.nome).text.toString())
            parent.findNavController().navigate(action)
        }
        return holder
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        holder.nome.text = data.get(position).name
        holder.descrizioneBreve.text = data.get(position).shortDescr
        var image: String = data.get(position).image
        when (image) {
            "giardini_pubblici" -> holder.image.setImageResource(R.drawable.giardini_pubblici)
            "circolo_cittadino" -> holder.image.setImageResource(R.drawable.circolo_cittadino)
            "birreria_agostino" -> holder.image.setImageResource(R.drawable.birreria_agostino)
            "ciro_pio" -> holder.image.setImageResource(R.drawable.ciro_pio)
            "hemingway" -> holder.image.setImageResource(R.drawable.hemingway)
            else -> holder.image.setImageResource(R.drawable.ciro_pio)
        }

    }

    override fun getItemCount(): Int = data.size
}