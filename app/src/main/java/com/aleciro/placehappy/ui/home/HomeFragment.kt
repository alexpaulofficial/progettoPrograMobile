package com.aleciro.placehappy.ui.home

import android.Manifest
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.aleciro.placehappy.MainActivity
import com.aleciro.placehappy.R
import com.aleciro.placehappy.ui.place.PlaceFragment
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import com.google.android.gms.maps.model.MarkerOptions

class HomeFragment : Fragment(), OnMapReadyCallback, GoogleMap.OnMyLocationButtonClickListener,
    GoogleMap.OnMyLocationClickListener, ActivityCompat.OnRequestPermissionsResultCallback, GoogleMap.OnMarkerClickListener,
    GoogleMap.OnInfoWindowClickListener {


    private val MY_PERMISSION_FINE_LOCATION = 101

    private lateinit var homeViewModel: HomeViewModel
    private var permissionDenied = false
    private lateinit var mMap : GoogleMap
    private var mapReady = false
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        homeViewModel =
            ViewModelProvider(this).get(HomeViewModel::class.java)
        val root = inflater.inflate(R.layout.fragment_home, container, false)
        val mapFragment = childFragmentManager.findFragmentById(R.id.mapFragment) as SupportMapFragment
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this.context!!.applicationContext)
        mapFragment.getMapAsync(this)
        mapFragment.getMapAsync {
            googleMap -> mMap = googleMap
            mapReady = true
        }
        return root
    }

    override fun onMapReady(p0: GoogleMap) {
        // val xxx: MainActivity = activity as MainActivity
        p0.setOnInfoWindowClickListener(this)
        /*var lastLocation: Location? = Location ("")
        fusedLocationClient.lastLocation
            .addOnSuccessListener {location : Location? ->
                // Got last known location. In some rare situations this can be null.
                lastLocation!!.latitude = location!!.latitude
                lastLocation!!.longitude = location!!.longitude
            }*/

        p0.addMarker(
            MarkerOptions().position(LatLng(43.5171122, 13.2253359)).title("Marker").snippet("Population: 4,137,400")
        )
        p0.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(43.5250291, 13.231723), 14f))
        p0.setOnMyLocationButtonClickListener(this)
        p0.setOnMyLocationClickListener(this)
        enableMyLocation()

        with(NotificationManagerCompat.from(this.context!!)) {
            // notificationId is a unique int for each notification that you must define
            // notify(1, xxx.builder.build())
        }

        if (ActivityCompat.checkSelfPermission(this.context!!.applicationContext,
                Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            p0.isMyLocationEnabled = true
        }
        else {//condition for Marshmello and above
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), MY_PERMISSION_FINE_LOCATION)
            }
        }
        p0.setOnMarkerClickListener(this)
    }
    override fun onMarkerClick(p0: Marker?) = false

    override fun onInfoWindowClick(marker: Marker) {
        val transaction = activity?.supportFragmentManager!!.beginTransaction()
        transaction.replace(R.id.mapFragment, PlaceFragment())
        transaction.disallowAddToBackStack()
        transaction.commit()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            MY_PERMISSION_FINE_LOCATION -> if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {//permission to access location grant
                if (ActivityCompat.checkSelfPermission(this.context!!.applicationContext,
                        Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                    mMap.isMyLocationEnabled = true
                }
            }
            //permission to access location denied
            else {
                Toast.makeText(this.context!!.applicationContext, "This app requires location permissions to be granted", Toast.LENGTH_LONG).show()
            }
        }
    }
    /**
     * Enables the My Location layer if the fine location permission has been granted.
     */
    private fun enableMyLocation() {
        if (!::mMap.isInitialized) return
        if (ContextCompat.checkSelfPermission(this.context!!.applicationContext, Manifest.permission.ACCESS_FINE_LOCATION)
            == PackageManager.PERMISSION_GRANTED) {
            mMap.isMyLocationEnabled = true
        } else {
            // Permission to access the location is missing. Show rationale and request permission
            ActivityCompat.requestPermissions(
                this.activity!!.parent, Array<String>(1){Manifest.permission.ACCESS_FINE_LOCATION},
                LOCATION_PERMISSION_REQUEST_CODE
            )

        }
    }

    override fun onMyLocationButtonClick(): Boolean {
        Toast.makeText(this.context!!.applicationContext, "MyLocation button clicked", Toast.LENGTH_SHORT).show()
        // Return false so that we don't consume the event and the default behavior still occurs
        // (the camera animates to the user's current position).
        return false
    }

    override fun onMyLocationClick(location: Location) {
        Toast.makeText(this.context!!.applicationContext, "Current location:\n$location", Toast.LENGTH_LONG).show()
    }

    companion object {
        /**
         * Request code for location permission request.
         *
         * @see .onRequestPermissionsResult
         */
        private const val LOCATION_PERMISSION_REQUEST_CODE = 1
    }


}
