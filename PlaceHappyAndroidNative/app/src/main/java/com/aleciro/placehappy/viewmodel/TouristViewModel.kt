package com.aleciro.placehappy.viewmodel

import android.app.Application
import androidx.lifecycle.*
import com.aleciro.placehappy.database.Place
import com.aleciro.placehappy.database.Tag
import com.aleciro.placehappy.database.TouristDatabase
import kotlinx.coroutines.launch

// Varie funzionalità per il DB
class TouristViewModel(app: Application) : AndroidViewModel(app) {

    private val placeDao = TouristDatabase.getInstance(app).placeDao()
    private val tagDao = TouristDatabase.getInstance(app).tagDao()
    var placesList: MutableList<Place> = mutableListOf()
    var placesByTag: MutableList<Place> = mutableListOf()
    var tagsList: MutableList<String> = mutableListOf()

    suspend fun getAllPlaces() {

        placesList = placeDao.getAll()

    }

    fun addPlace(places: Array<Place>) {
        viewModelScope.launch {
            placeDao.insert(places)
        }
    }

    suspend fun viewPlacesByTag(tagPlace: String) {
        val places: MutableList<Place> = mutableListOf()
        val tags: MutableList<Tag> = tagDao.getPlacesByTag(tagPlace)
        for (tag in tags) {
            places.add(placeDao.getPlaceByName(tag.place))
        }
        placesByTag = places
    }

    fun addTag(tags: Array<Tag>) {
        viewModelScope.launch {
            tagDao.insert(tags)
        }
    }

    suspend fun getplacebyname(name: String): Place {
        return placeDao.getPlaceByName(name)

    }

    suspend fun getAllTags() {
        val tags = tagDao.getAll()
        val tagNames: MutableList<String> = mutableListOf()
        for (tag in tags) {
            if (!tagNames.contains(tag.tagName)) {
                tagNames.add(tag.tagName)
            }

        }
        tagsList = tagNames
    }


}

