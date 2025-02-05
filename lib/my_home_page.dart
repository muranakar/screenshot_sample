import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'screenshot_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _memoController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? imageFile;

  final ScreenshotService _screenshotService = ScreenshotService();

  void _captureScreenshot() async {
    final image = await screenshotController.capture();
    setState(() {
      imageFile = image;
    });
  }

  void _shareScreenshot() async {
    if (imageFile != null) {
      await _screenshotService.shareScreenshot(imageFile!);
    }
  }

  void _captureInvisibleWidget() async {
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
              _memoController.text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
    setState(() {
      imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Memo:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _memoController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter your memo here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _captureScreenshot,
              child: const Text('表示されているWidgetをキャプチャ'),
            ),
            ElevatedButton(
              onPressed: _captureInvisibleWidget,
              child: const Text('独自のウィジェットをキャプチャ'),
            ),
            if (imageFile != null)
              Image.memory(
                imageFile!,
                height: 200, // 高さを指定
              ),
            if (imageFile != null)
              ElevatedButton(
                onPressed: _shareScreenshot,
                child: const Text('共有する'),
              ),
          ],
        ),
      ),
    );
  }
}
