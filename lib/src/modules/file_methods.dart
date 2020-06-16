import 'dart:io';

import 'package:path_provider/path_provider.dart';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get localFile async {
    final path = await _localPath;
    
    print(path);

    return File('$path/data.json');
  }

  Future<File> writeData(String data) async {
    final file = await localFile;

    // Write the file.
    return file.writeAsString('$data');
  }

  Future deleteData() async {
    final file = await localFile;

    // Write the file.
    file.deleteSync();
  }