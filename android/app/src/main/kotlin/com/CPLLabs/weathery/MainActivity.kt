package com.CPLLabs.weathery

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log // Keep logs so we can debug if this fails
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {

        var query: String? = null

        // --- SPOT 1: Standard Search Action ---
        if (Intent.ACTION_SEARCH == intent.action || "com.google.android.gms.actions.SEARCH_ACTION" == intent.action) {
            query = intent.getStringExtra("query")
        }

        // --- SPOT 2: The "SearchManager" constant (Very common fallback) ---
        if (query == null) {
            query = intent.getStringExtra("app_data") // Common hidden spot
        }
        if (query == null) {
            // "query" is the value of SearchManager.QUERY
            query = intent.getStringExtra(android.app.SearchManager.QUERY)
        }

        // --- SPOT 3: Checking the Intent Data (URI) ---
        // Sometimes Google sends: googleapp://search?q=Mumbai
        if (query == null && intent.data != null) {
            query = intent.data?.getQueryParameter("q")
            if (query == null) {
                query = intent.data?.getQueryParameter("query")
            }
        }


        if (query == null && intent.extras != null) {
            val extras = intent.extras!!
            query = extras.getString("query")
                ?: extras.getString("user_query")
                        ?: extras.getString("q")
                        ?: extras.getString("com.google.android.gms.actions.EXTRA_QUERY")
        }

        if (query != null && query.isNotEmpty()) {
            val newIntent = Intent(Intent.ACTION_VIEW)
            val cleanQuery = query.trim()
            newIntent.data = Uri.parse("weathery://app/viaAssistant?q=$cleanQuery")
            newIntent.setPackage(packageName)
            startActivity(newIntent)
        }
    }
}