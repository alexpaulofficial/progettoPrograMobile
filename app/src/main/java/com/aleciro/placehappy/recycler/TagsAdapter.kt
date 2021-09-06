package com.aleciro.placehappy.recycler


import android.app.Application
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.aleciro.placehappy.R


import com.aleciro.placehappy.database.Place

class TagsAdapter(val data: MutableList<String>) : RecyclerView.Adapter<TagsAdapter.MyViewHolder>() {
    class MyViewHolder(val row: View) : RecyclerView.ViewHolder(row) {
        val nome = row.findViewById<TextView>(R.id.nomeTag)


    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val layout = LayoutInflater.from(parent.context).inflate(
            R.layout.tag_item,
            parent, false
        )
        val holder = MyViewHolder(layout)
        holder.row.setOnClickListener {

        }
        return holder
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        holder.nome.text =  "#" + data.get(position)


    }

    override fun getItemCount(): Int = data.size
}