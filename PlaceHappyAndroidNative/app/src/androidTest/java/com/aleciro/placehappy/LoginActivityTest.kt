package com.aleciro.placehappy

import androidx.test.espresso.Espresso
import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions
import androidx.test.espresso.assertion.ViewAssertions.doesNotExist
import androidx.test.espresso.assertion.ViewAssertions.matches
import androidx.test.espresso.matcher.ViewMatchers.*

import androidx.test.ext.junit.runners.AndroidJUnit4
import  androidx.test.ext.junit.rules.ActivityScenarioRule
import org.hamcrest.CoreMatchers.not
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith


class LoginActivityTest {

    @Rule
    @JvmField
    var activityRule = ActivityScenarioRule(
        LoginActivity::class.java
    )

    private val username = "chike"
    private val password = "password"

    @Test
    fun clickLoginButton_opensLoginUi() {
        onView(withId(R.id.text_email)).perform(ViewActions.typeText(username))
        onView(withId(R.id.text_password)).perform(ViewActions.typeText(password))

       onView(withId(R.id.btn_login)).perform(ViewActions.scrollTo(), ViewActions.click())

        onView(withId(R.id.bottom_nav))
            .check(doesNotExist())
    }
}