package com.CPLLabs.weathery

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri // Import for potentially unique data
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

class MainWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val tempValue = widgetData.getString("temp", "00")
        val descValue = widgetData.getString("desc", "NA")
        val locationValue = widgetData.getString("location", "NA")
        val imagePath = widgetData.getString("iconPath", null)

        val showUmbrellaIcon = widgetData.getBoolean("showUmbrellaIcon", false)
        val showMaskIcon = widgetData.getBoolean("showMaskIcon", false)
        val showWarningIcon = widgetData.getBoolean("showWarningIcon", false)


        val appIntent = Intent(context, MainActivity::class.java).apply {
            putExtra("fromWidget", true)
        }


        val pendingIntent = PendingIntent.getActivity(
            context,
            0, // Request code
            appIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE // Use FLAG_IMMUTABLE for API 31+
        )

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_main).apply {
                // Set text values
                setTextViewText(R.id.temp, tempValue)
                setTextViewText(R.id.desc, descValue)
                setTextViewText(R.id.location, locationValue)

                // Set bottom icons (white when active, gray when inactive)
                setImageViewResource(
                    R.id.umbrella_icon,
                    if (showUmbrellaIcon) R.mipmap.umbrella else R.mipmap.umbrella_gray
                )
                setImageViewResource(
                    R.id.mask_icon,
                    if (showMaskIcon) R.mipmap.mask else R.mipmap.mask_gray
                )
                setImageViewResource(
                    R.id.warning_icon,
                    if (showWarningIcon) R.mipmap.warning else R.mipmap.warning_gray
                )

                // Load and set weather icon if exists
                if (!imagePath.isNullOrEmpty()) {
                    File(imagePath).takeIf { it.exists() }?.let {
                        setImageViewBitmap(R.id.icon, BitmapFactory.decodeFile(imagePath))
                    }
                }

                // Set the PendingIntent for the entire widget layout
                // This makes the whole widget clickable
                setOnClickPendingIntent(R.id.widget_root_layout, pendingIntent)
                // IMPORTANT: Your root layout in widget_main.xml needs an ID,
                // e.g., android:id="@+id/widget_root_layout"
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}