import 'dart:typed_data';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ScreenshotService {
  Future<void> shareScreenshot(Uint8List imageFile) async {
    try {
      // 一時ディレクトリに画像を保存
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/screenshot.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageFile);

      // 共有用のXFileオブジェクトを作成
      final xFile = XFile(imagePath);
      await Share.shareXFiles([xFile]);
    } catch (e) {
      print('画像共有でエラーが発生しました: $e');
    }
  }
}
