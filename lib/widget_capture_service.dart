import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class WidgetCaptureService {
  Future<Uint8List?> captureInvisibleWidget(
      ScreenshotController screenshotController, String memoText) async {
    final image = await screenshotController.captureFromWidget(
      Container(
        height: 300,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            const Text('Widget Memo:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text(
              memoText,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
    return image;
  }
}
