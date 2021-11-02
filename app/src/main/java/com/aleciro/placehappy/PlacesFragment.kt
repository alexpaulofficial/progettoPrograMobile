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






        lifecycleScope.launch{
            val listaluoghi: MutableList<Place> = viewModel.getAllPlaces()
            if (listaluoghi.size==0) {
                val piazza_repubblica = getString(R.string.piazza_repubblica)
                val hemingway = getString(R.string.hemingway)
                val corso_matteotti =  getString(R.string.corso_matteotti)
                val casa_mia = getString(R.string.casa_mia)
                val pizzeria_da_ciro= getString(R.string.pizzeria_da_ciro)
                viewModel.addPlace(
                    arrayOf(
                        Place("Piazza della Repubblica", "una bellissima piazza, veramente bella puoi" +
                                " farci tutto quello che vuoi, oggi ci hanno anche messo l'obelisco che" +
                                " prima stava dall'altra parte", "Piazza bellissima ora anche con l'obelisco che prima stava in Piazza Pergolesi", "via saffi", 332.1, 2132.42,piazza_repubblica ),

                        Place("Bar Hemingway", "drink ti ubriachi", "Drink buoni di vari gusti, tavolini" +
                                "con possibilità di sedersi","via bella", 3322.41, 21.23, hemingway),

                        Place("Corso Matteotti", "qualche vasca per sgranchire le gambe","passeggiate in questo" +
                                " bellissimo corso, ora sta venendo rinnovato e per fine anno sarà bellissimo", "corso matteotti", 32.1, 21.24,
                            corso_matteotti),

                        Place("Casa mia", "siete tutti i benvenuti","casa molto accogliente, musica e tutto" +
                                " quello che volete completamente gratis, levatevi le scarpe prima di entrare però" ,"via saffi 8", 332.13, 21.254, casa_mia),

                        Place("Pizzeria da Ciro", "la vera pizza napoletana","pizza napoletana come piace" +
                                " al padrone di casa, Ciro, ormai ottantenne ma ancora con molta voglia e passione" ,"via bellissima", 32.134, 21.3242, pizzeria_da_ciro)))


            }


            val rv: RecyclerView = view.findViewById(R.id.recyclerView)
            rv.layoutManager = LinearLayoutManager(activity?.applicationContext)
            rv.addItemDecoration(ItemDecorationX(activity?.applicationContext!!, R.drawable.line_divider))



                    rv.adapter = PlacesAdapter(listaluoghi)




        }
    }
}