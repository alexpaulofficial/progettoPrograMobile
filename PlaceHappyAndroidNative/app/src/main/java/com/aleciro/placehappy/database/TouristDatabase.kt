package com.aleciro.placehappy.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

// Istanza del database
@Database(entities = [Tag::class, Place::class], version = 3)
abstract class TouristDatabase : RoomDatabase() {
    abstract fun tagDao(): TagDao
    abstract fun placeDao(): PlaceDao

    companion object {
        @Volatile
        private var INSTANCE: TouristDatabase? = null
        fun getInstance(context: Context): TouristDatabase {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: Room.databaseBuilder(
                    context.applicationContext,
                    TouristDatabase::class.java, "tourist_database"
                )
                    .fallbackToDestructiveMigration()
                    .build()
                    .also { INSTANCE = it }
            }
        }
    }
}
