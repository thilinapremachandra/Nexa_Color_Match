package com.example.color;

import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import org.opencv.android.CameraActivity;
import org.opencv.android.CameraBridgeViewBase;
import org.opencv.android.OpenCVLoader;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfPoint;
import org.opencv.core.Scalar;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
import android.view.View;

import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

import android.Manifest;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MainActivity extends CameraActivity {

    private Scalar selectedWallColor = new Scalar(144, 238, 144);
    private LinearLayout colorPalette;
    private HorizontalScrollView colorPaletteScroll;
    CameraBridgeViewBase cameraBridgeViewBase;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Animation Text View
        TextView landscapeText = findViewById(R.id.landscapeText);

        // Color Palette Scroll Layout
        colorPalette = findViewById(R.id.colorPalette);
        colorPaletteScroll = findViewById(R.id.colorPaletteScroll);

        // Display Animation Text
        new Handler().postDelayed(() -> {
            landscapeText.setVisibility(View.GONE); // Hide text after 3 seconds
            colorPaletteScroll.setVisibility(View.VISIBLE); // Show color palette
        }, 3000); // 3 seconds delay
        // Populate Color Palette
        populateColorPalette();

        // Color Selection Logic
        populateColorPalette();








        if (OpenCVLoader.initLocal()) Log.d("LOADED", "Success");
        else Log.d("LOADED", "error");

        getPermission();



        cameraBridgeViewBase = findViewById(R.id.cameraView);
        cameraBridgeViewBase.setCvCameraViewListener(new CameraBridgeViewBase.CvCameraViewListener2() {
            public Mat onCameraFrame(CameraBridgeViewBase.CvCameraViewFrame inputFrame) {
                Mat rgba = inputFrame.rgba();

                // Convert to HSV color space
                Mat hsv = new Mat();
                Imgproc.cvtColor(rgba, hsv, Imgproc.COLOR_BGR2HSV);

                // Create multiple masks for different lighting conditions
                Mat wallMask1 = new Mat();
                Mat wallMask2 = new Mat();
                Mat wallMask3 = new Mat();
                Mat finalWallMask = new Mat();

                // Range 1: For normally lit walls
                Core.inRange(hsv, new Scalar(0, 0, 150), new Scalar(180, 30, 255), wallMask1);

                // Range 2: For darker walls
                Core.inRange(hsv, new Scalar(0, 0, 80), new Scalar(180, 40, 150), wallMask2);

                // Range 3: For brighter walls
                Core.inRange(hsv, new Scalar(0, 0, 200), new Scalar(180, 25, 255), wallMask3);

                // Combine masks
                Core.bitwise_or(wallMask1, wallMask2, finalWallMask);
                Core.bitwise_or(finalWallMask, wallMask3, finalWallMask);

                // Apply noise reduction
                Mat kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, new Size(3, 3));
                Imgproc.morphologyEx(finalWallMask, finalWallMask, Imgproc.MORPH_CLOSE, kernel);
                Imgproc.morphologyEx(finalWallMask, finalWallMask, Imgproc.MORPH_OPEN, kernel);

                // Apply edge detection to find wall boundaries
                Mat edges = new Mat();
                Imgproc.Canny(rgba, edges, 50, 150);
                // Imgproc.dilate(edges, edges, kernel);


                // Dilate edges to create boundary regions
                Mat dilatedEdges = new Mat();
                Imgproc.dilate(edges, dilatedEdges, kernel);

                // Remove edge regions from wall mask
                Core.bitwise_not(dilatedEdges, dilatedEdges);
                Core.bitwise_and(finalWallMask, dilatedEdges, finalWallMask);

                // Find contours to identify large wall regions
                List<MatOfPoint> contours = new ArrayList<>();
                Mat hierarchy = new Mat();
                Imgproc.findContours(finalWallMask.clone(), contours, hierarchy,
                        Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE);

                // Filter small contours (noise)
                Mat refinedMask = Mat.zeros(finalWallMask.size(), CvType.CV_8UC1);
                double minContourArea = rgba.width() * rgba.height() * 0.1; // Adjust threshold as needed

                for (MatOfPoint contour : contours) {
                    double area = Imgproc.contourArea(contour);
                    if (area > minContourArea) {
                        Imgproc.drawContours(refinedMask, Collections.singletonList(contour),
                                -1, new Scalar(255), -1);
                    }
                }

                // Create colored wall overlay
                Mat coloredWall = Mat.zeros(rgba.size(), rgba.type());
                coloredWall.setTo(selectedWallColor);

                // Create blended result
                Mat blendedWall = new Mat();
                double alpha = 0.5; // Adjust transparency

                // Apply the colored wall only to refined wall areas
                Mat maskedColor = new Mat();
                coloredWall.copyTo(maskedColor, refinedMask);

                // Blend the original image with the colored wall
                Core.addWeighted(maskedColor, alpha, rgba, 1.0 - alpha, 0.0, blendedWall);

                // Copy the result back to original where the mask is active
                Mat result = rgba.clone();
                blendedWall.copyTo(result, refinedMask);

                // Clean up
                hsv.release();
                wallMask1.release();
                wallMask2.release();
                wallMask3.release();
                finalWallMask.release();
                edges.release();
                dilatedEdges.release();
                refinedMask.release();
                coloredWall.release();
                maskedColor.release();
                blendedWall.release();
                hierarchy.release();
                for (MatOfPoint contour : contours) {
                    contour.release();
                }

                return result;
            }
            @Override
            public void onCameraViewStarted(int width, int height) {}

            @Override
            public void onCameraViewStopped() {}
        });

        if (OpenCVLoader.initLocal()) {
            cameraBridgeViewBase.enableView();
        }
    }

    private void populateColorPalette() {
        int[] colors = {
                android.graphics.Color.parseColor("#90EE90"), // Light Green (Hex code)
                android.graphics.Color.parseColor("#FFA07A"), // Light Orange (Hex code)
                android.graphics.Color.parseColor("#FFB6C1") , // Light Pink (Hex code)
                android.graphics.Color.parseColor("#ADD8E6"), // Light Blue (Hex code)
                android.graphics.Color.parseColor("#FFE4B5"), // Moccasin (Hex code)
                android.graphics.Color.parseColor("#98FB98"), // Pale Green (Hex code)
                android.graphics.Color.parseColor("#FF69B4"), // Hot Pink (Hex code)
                android.graphics.Color.parseColor("#FFD700"), // Gold (Hex code)

        };

        for (int color : colors) {
            // Add transparency (50% opacity)
            int transparentColor = (color & 0x00FFFFFF) | (0x80 << 24);  // 0x80 is 50% opacity

            // Create a view for each color block
            View colorView = new View(this);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(100, 100); // Size of color blocks
            params.setMargins(10, 10, 10, 10);
            colorView.setLayoutParams(params);
            colorView.setBackgroundColor(transparentColor);  // Apply transparent color

            // Add click listener to change the selected color
            colorView.setOnClickListener(v -> {
                selectedWallColor = new Scalar(
                        (color >> 16) & 0xFF, // Red channel
                        (color >> 8) & 0xFF,  // Green channel
                        color & 0xFF,         // Blue channel
                        255                   // Alpha channel (fully opaque)
                );
            });

            // Add color view to the palette
            colorPalette.addView(colorView);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        cameraBridgeViewBase.enableView();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        cameraBridgeViewBase.disableView();
    }

    @Override
    protected void onPause() {
        super.onPause();
        cameraBridgeViewBase.disableView();
    }

    @Override
    protected List<? extends CameraBridgeViewBase> getCameraViewList() {
        return Collections.singletonList(cameraBridgeViewBase);
    }

    void getPermission() {
        if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.CAMERA}, 101);
        }
    }
}