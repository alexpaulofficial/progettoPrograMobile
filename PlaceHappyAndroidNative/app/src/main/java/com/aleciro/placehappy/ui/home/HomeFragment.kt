package com.aleciro.placehappy.ui.home

import android.Manifest
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.aleciro.placehappy.R
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.database.Tag
import com.aleciro.placehappy.notifications.AlertReceiver
import com.aleciro.placehappy.viewmodel.TouristViewModel
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import com.google.android.gms.maps.model.MarkerOptions
import kotlinx.coroutines.launch

// Fragment Home con la mappa dove vengono anche inseriti i dati nel DB
class HomeFragment : Fragment(), OnMapReadyCallback, GoogleMap.OnMyLocationButtonClickListener,
    GoogleMap.OnMyLocationClickListener, ActivityCompat.OnRequestPermissionsResultCallback,
    GoogleMap.OnMarkerClickListener,
    GoogleMap.OnInfoWindowClickListener {

    // Permessi per la localizzazione
    private val MY_PERMISSION_FINE_LOCATION = 101
    val viewModel: TouristViewModel by viewModels()

    private var permissionDenied = false
    private lateinit var mMap: GoogleMap
    private var mapReady = false
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_home, container, false)
        val mapFragment = childFragmentManager.findFragmentById(R.id.mapFragment) as SupportMapFragment
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this.requireContext().applicationContext)

        // Mappa di Google Maps
        mapFragment.getMapAsync(this)
        mapFragment.getMapAsync { googleMap ->
            mMap = googleMap
            mapReady = true
        }

        // Aggiunta luoghi DB
        viewModel.addPlace(
            arrayOf(
                Place(
                    "Giardini Pubblici",
                    "I Giardini Pubblici di Jesi sono da sempre un luogo di incontro per persone di ogni et??. Ci sono infatti giochi per bambini, come ad esempio scivoli,  altalene, una pista da pattinaggio, ma si possono trovare anche tavoli da ping pong, scacchi e molto altro. All'interno ?? situato anche un bar denominato 'Lo Sbarello', che offre pizza, gelati, ma anche drink e aperitivi, sempre con musica annessa.",
                    "Parco con giochi, bar e pineta.",
                    " ",
                    43.51839320285577,
                    13.229754169318705,
                    "giardini_pubblici"
                ),

                Place(
                    "Birreria Sant'Agostino",
                    "La Birreria Sant'Agostino, situata nel cuore del centro di Jesi, ?? specializzata nelle birre artigianali. Qui si possono trovare infatti birre di ogni tipologia e nazionalit??. Ci sono molte birre speciali belghe, tedesche, irlandesi, ma sicuramente anche le pi?? classiche, come la Weiss e la Guinness. Il luogo ?? fornito  di tavoli sia all'aperto, sia sotto un loggiato, con riscaldamento per l'inverno. Possibilit?? di aperitivi.",
                    "Birreria fornita di varie birre artigianali.",
                    " ",
                    43.522838388573014,
                    13.244360149177467,
                    "birreria_agostino"
                ),

                Place(
                    "Circolo Cittadino",
                    "Il Circolo Cittadino di Jesi ?? una struttura ormai storica di questa citt??, che mette al centro la socialit?? e l'interazione fra i suoi soci. E' dotato di molti campi da tennis, ma anche di un ristorante e di una sala convegni. Spesso inoltre sono organizzati tornei di biliardo o di giochi di carte, come ad esempio poker, bridge. ",
                    "Centro sportivo, ricreativo e con ristorante.",
                    " ",
                    43.5186092800265,
                    13.23958652517758,
                    "circolo_cittadino"
                ),

                Place(
                    "Ciro e Pio",
                    "Ciro e Pio ?? una gelateria storica di Jesi, presente nella citt?? dal 1952. Qui si possono trovare gelati artigianali con una grande variet?? di gusti.  Molto frequentata anche d'inverno, grazie al suo spazio al coperto.",
                    "Gelati artigianali e altre specialit??, dal 1952.",
                    " ",
                    43.522261352097956,
                    13.240193713598416,
                    "ciro_pio"
                ),

                Place(
                    "Hemingway Caf??",
                    "Locale nel centro di Jesi, specializzato in drink e cocktails di ogni genere. Soprattutto nel weekend risulta frequentato da moltissimi giovani, in quanto si trova in un luogo molto centrale, comodo per ritrovarsi, e crea una bella atmosfera mettendo musica.",
                    "Musica, drink e cocktails di ogni tipo.",
                    " ",
                    43.522817250948364,
                    13.244443942364535,
                    "hemingway"
                )
            )
        )
        viewModel.addTag(
            arrayOf(
                Tag("Drink", "Giardini Pubblici"),
                Tag("Musica", "Giardini Pubblici"),
                Tag("Svago", "Giardini Pubblici"),
                Tag("Cibo", "Giardini Pubblici"),
                Tag("Drink", "Birreria Sant'Agostino"),
                Tag("Cibo", "Birreria Sant'Agostino"),
                Tag("Cibo", "Circolo Cittadino"),
                Tag("Svago", "Circolo Cittadino"),
                Tag("Cibo", "Ciro e Pio"),
                Tag("Drink", "Hemingway Caf??"),
                Tag("Musica", "Hemingway Caf??"),


                )
        )

        return root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Tempo in cui viene eseguito l'Alert (non corretto al 100% perch??
        // Android gestisce gli Alarm un po' come vuole ogni tanto...)
        val minutes = 5

        // Inizializzazione Alarm Manager (sostanzialmente setta una sveglia
        // che dopo un certo periodo fa partire il PrimaryIntent che viene
        // poi ricevuto dall'AlertReceiver)
        var alarmMgr: AlarmManager?
        alarmMgr = this.context!!.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        var primaryIntent = Intent(this.context, AlertReceiver::class.java)

        // Bundle da passare all'AlertReceiver
        var luoghiNotifica = Bundle()

        var listaluoghi = mutableListOf<Place>()
        lifecycleScope.launch {
            viewModel.getAllPlaces()
            listaluoghi = viewModel.placesList
            var i = 0
            // I luoghi vengono passsati con un formato specifico:
            // id luogo+NAME+nomeLuogo
            // id luogo+LAT+latitudineLuogo
            // id luogo+LONG+longitudineLuogo
            // Ci?? ?? stato fato dato che i luoghi vengono trattati in modo "asincrono"
            for (luogo in listaluoghi) {
                luoghiNotifica.putString(i.toString() + "NAME", luogo.name)
                luoghiNotifica.putDouble(i.toString() + "LAT", luogo.latitude)
                luoghiNotifica.putDouble(i.toString() + "LONG", luogo.longitude)
                i++
            }
            Log.d("BUNDLE", "BundleLuoghi = " + luoghiNotifica.toString())
            primaryIntent.putExtra("Luoghi", luoghiNotifica)
            // L'intent che viene lanciato
            var pendingIntent = primaryIntent.let { intent ->
                PendingIntent.getBroadcast(context, 0, intent.putExtra("Luoghi", luoghiNotifica), 0)
            }
            alarmMgr?.setInexactRepeating(
                AlarmManager.ELAPSED_REALTIME,
                SystemClock.elapsedRealtime() + minutes * 60 * 1000,
                (minutes * 60 * 1000).toLong(),
                pendingIntent

            )
        }
    }

    // Una volta caricata la mappa si aggiungono i marcatori
    override fun onMapReady(p0: GoogleMap) {
        // val xxx: MainActivity = activity as MainActivity
        p0.setOnInfoWindowClickListener(this)
        lifecycleScope.launch {
            viewModel.getAllPlaces()
            val listaluoghi: MutableList<Place> = viewModel.placesList
            for (luogo in listaluoghi) {
                p0.addMarker(
                    MarkerOptions().position(LatLng(luogo.latitude, luogo.longitude)).title(luogo.name)
                )
            }

        }
        p0.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(43.5250291, 13.231723), 14f))
        p0.setOnMyLocationButtonClickListener(this)
        p0.setOnMyLocationClickListener(this)
        enableMyLocation()

        if (ActivityCompat.checkSelfPermission(
                this.requireContext().applicationContext,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            p0.isMyLocationEnabled = true
        } else {//condition for Marshmello and above
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), MY_PERMISSION_FINE_LOCATION)
            }
        }
        p0.setOnMarkerClickListener(this)
    }

    override fun onMarkerClick(p0: Marker?) = false

    // Quando si clicca nell'infoWindow del marcatore si accede alla pagina del singolo luogo
    override fun onInfoWindowClick(marker: Marker) {
        val action = HomeFragmentDirections.actionNavigationHomeToPlaceFragment(marker.title)
        this.findNavController().navigate(action)
    }

    // Controlli vari per la richiesta
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            MY_PERMISSION_FINE_LOCATION -> if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {//permission to access location grant
                if (ActivityCompat.checkSelfPermission(
                        this.requireContext().applicationContext,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    mMap.isMyLocationEnabled = true
                }
            }
            //permission to access location denied
            else {
                Toast.makeText(
                    this.requireContext().applicationContext,
                    "This app requires location permissions to be granted",
                    Toast.LENGTH_LONG
                ).show()
            }
        }
    }

    /**
     * Enables the My Location layer if the fine location permission has been granted.
     */
    private fun enableMyLocation() {
        if (!::mMap.isInitialized) return
        if (ContextCompat.checkSelfPermission(
                this.requireContext().applicationContext,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
            == PackageManager.PERMISSION_GRANTED
        ) {
            mMap.isMyLocationEnabled = true
        } else {
            // Permission to access the location is missing. Show rationale and request permission
            ActivityCompat.requestPermissions(
                this.requireActivity().parent, Array<String>(1) { Manifest.permission.ACCESS_FINE_LOCATION },
                LOCATION_PERMISSION_REQUEST_CODE
            )

        }
    }

    // Non fa nulla
    override fun onMyLocationButtonClick(): Boolean {
        return false
    }

    override fun onMyLocationClick(location: Location) {
        Toast.makeText(this.requireContext().applicationContext, "Current location:\n$location", Toast.LENGTH_LONG)
            .show()
    }

    companion object {

        private const val LOCATION_PERMISSION_REQUEST_CODE = 1
    }
}
