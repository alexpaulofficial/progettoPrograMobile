package com.aleciro.placehappy.database

import androidx.room.*

@Dao
interface PlaceDao {
    @Query("SELECT * FROM places")
    suspend fun getAll(): MutableList<Place>

    @Query("SELECT * FROM places WHERE name = :name")
    suspend fun getPlaceByName(name: String): Place

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(places: Array<Place>)

    @Update
    suspend fun update(place: Place)

    @Delete
    suspend fun delete(place: Place)
}