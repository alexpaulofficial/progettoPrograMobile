package com.aleciro.placehappy.database

import androidx.room.*

@Dao
interface TagDao {
    @Query("SELECT * FROM tags")
    suspend fun getAll(): MutableList<Tag>

    @Query("SELECT * FROM tags WHERE tagName=:name")
    suspend fun getPlacesByTag(name: String): MutableList<Tag>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(tags: Array<Tag>)

    @Update
    suspend fun update(tag: Tag)

    @Delete
    suspend fun delete(tag: Tag)
}