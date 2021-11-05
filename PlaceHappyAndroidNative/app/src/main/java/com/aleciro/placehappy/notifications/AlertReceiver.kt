package com.aleciro.placehappy.notifications

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.util.Log
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices

class AlertReceiver : BroadcastReceiver() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onReceive(context: Context?, intent: Intent?) {

        var extras = intent!!.extras!!
        var bundleLuoghi = extras.getBundle("Luoghi")
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context!!)

        if (ActivityCompat.checkSelfPermission(
                context!!,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                context!!,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        fusedLocationClient.lastLocation
            .addOnSuccessListener { location : Location? ->
                var locData = Location("")
                if (bundleLuoghi != null)
                {
                    for (i in 0..bundleLuoghi.size())
                    {
                        locData.latitude = bundleLuoghi.getDouble(i.toString() + "LAT")
                        locData.longitude = bundleLuoghi.getDouble(i.toString() + "LONG")

                            if (locData.distanceTo(location) < 300)
                            {
                                var notificationHelper = NotificationHelper(context)

                                var nb = notificationHelper.getChannelNotification(
                                    "Sei vicino a: " + bundleLuoghi.getString(i.toString() + "NAME"),
                                    "Clicca qui per info ",
                                    bundleLuoghi.getString(i.toString() + "NAME")
                                )
                                notificationHelper.getManager()!!.notify(i, nb!!.build())
                            }
                    }
                }

                // Got last known location. In some rare situations this can be null.
            }

    }


}
