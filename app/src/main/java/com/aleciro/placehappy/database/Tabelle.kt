package com.aleciro.placehappy.database

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey




@Entity(tableName = "places")
data class Place  (
    @PrimaryKey(autoGenerate = false) val name: String,
    val description: String,
    val shortDescr: String,
    val address: String,
    val latitude: Double,
    val longitude: Double,
    val image: String,


)



@Entity(tableName = "tags", primaryKeys = arrayOf("tagName", "place"),foreignKeys=[
    (ForeignKey(
        entity=Place::class,
        parentColumns=["name"],
        childColumns=["place"],
        onDelete= ForeignKey.CASCADE
    ))]
)
data class Tag (

    val tagName : String,
    val place: String

)



