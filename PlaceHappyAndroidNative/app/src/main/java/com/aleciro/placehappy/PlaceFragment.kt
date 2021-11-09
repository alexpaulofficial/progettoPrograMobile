package com.aleciro.placehappy

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.navArgs
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.viewmodel.TouristViewModel
import kotlinx.coroutines.launch

// Fragment del singolo luogo
// Si accede dalla lista luoghi o dall'InfoWindow del marcatore
class PlaceFragment : Fragment() {
    val viewModel: TouristViewModel by viewModels()
    val args: PlaceFragmentArgs by navArgs()
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_place, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val nome: String = args.nomeLuogo
        lifecycleScope.launch {
            val place: Place = viewModel.getplacebyname(nome)
            view.findViewById<TextView>(R.id.nomeLuogo).text = place.name
            view.findViewById<TextView>(R.id.descLong).text = place.description
            val image: String = place.image
            when (image) {
                "giardini_pubblici" -> view.findViewById<ImageView>(R.id.imageView2)
                    .setImageResource(R.drawable.giardini_pubblici)
                "birreria_agostino" -> view.findViewById<ImageView>(R.id.imageView2)
                    .setImageResource(R.drawable.birreria_agostino)
                "circolo_cittadino" -> view.findViewById<ImageView>(R.id.imageView2)
                    .setImageResource(R.drawable.circolo_cittadino)
                "hemingway" -> view.findViewById<ImageView>(R.id.imageView2).setImageResource(R.drawable.hemingway)
                "ciro_pio" -> view.findViewById<ImageView>(R.id.imageView2).setImageResource(R.drawable.ciro_pio)
                else -> view.findViewById<ImageView>(R.id.imageView2).setImageResource(R.drawable.ciro_pio)
            }

        }


    }


}