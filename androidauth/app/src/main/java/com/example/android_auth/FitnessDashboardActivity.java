package com.example.android_auth;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

import com.google.firebase.auth.FirebaseAuth;

public class FitnessDashboardActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // ✅ Root ScrollView (prevents layout overflow)
        ScrollView scrollView = new ScrollView(this);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setGravity(Gravity.CENTER_HORIZONTAL);
        root.setPadding(40, 80, 40, 40);
        scrollView.addView(root);

        // ✅ Title
        TextView title = new TextView(this);
        title.setText("🏋️ Fitness Tracker Dashboard");
        title.setTextSize(22f);
        title.setTypeface(Typeface.DEFAULT_BOLD);
        title.setGravity(Gravity.CENTER);
        root.addView(title);

        // ✅ Steps section
        TextView stepsView = new TextView(this);
        stepsView.setText("Steps Today: 6,350");
        stepsView.setTextSize(18f);
        stepsView.setPadding(0, 40, 0, 12);
        root.addView(stepsView);

        ProgressBar stepsBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        stepsBar.setMax(10000);
        stepsBar.setProgress(6350);
        stepsBar.setScaleY(2f);
        stepsBar.setContentDescription("Progress bar showing steps completed");
        root.addView(stepsBar);

        // ✅ Calories
        TextView caloriesView = new TextView(this);
        caloriesView.setText("Calories Burned: 480 kcal");
        caloriesView.setTextSize(18f);
        caloriesView.setPadding(0, 30, 0, 12);
        root.addView(caloriesView);

        // ✅ Distance
        TextView distanceView = new TextView(this);
        distanceView.setText("Distance: 4.8 km");
        distanceView.setTextSize(18f);
        distanceView.setPadding(0, 12, 0, 12);
        root.addView(distanceView);

        // ✅ Active Minutes
        TextView minutesView = new TextView(this);
        minutesView.setText("Active Minutes: 35 min");
        minutesView.setTextSize(18f);
        minutesView.setPadding(0, 12, 0, 12);
        root.addView(minutesView);

        // ✅ Daily Goal
        TextView goalView = new TextView(this);
        goalView.setText("Daily Step Goal: 10,000");
        goalView.setTextSize(16f);
        goalView.setPadding(0, 22, 0, 8);
        goalView.setGravity(Gravity.CENTER);
        root.addView(goalView);

        // ✅ Logout button
        Button logoutButton = new Button(this);
        logoutButton.setText("Logout");
        logoutButton.setTextSize(16f);
        logoutButton.setAllCaps(false);
        logoutButton.setPadding(0, 40, 0, 0);
        logoutButton.setOnClickListener(v -> {
            FirebaseAuth.getInstance().signOut();
            Intent intent = new Intent(FitnessDashboardActivity.this, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            finish();
        });
        root.addView(logoutButton);

        // ✅ Apply the view
        setContentView(scrollView);
    }
}
