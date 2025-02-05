import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Memo App Home Page'),
    );
  }
}

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

  void _captureScreenshot() async {
    final image = await screenshotController.capture();
    setState(() {
      imageFile = image;
    });
  }

  void _shareScreenshot() async {
    if (imageFile != null) {
      try {
        // 一時ディレクトリに画像を保存
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/screenshot.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(this.imageFile!);

        // 共有用のXFileオブジェクトを作成
        final xFile = XFile(imagePath);
        await Share.shareXFiles([xFile]);
      } catch (e) {
        print('画像共有でエラーが発生しました: $e');
      }
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
