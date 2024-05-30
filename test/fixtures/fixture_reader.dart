import 'dart:io';

String fixture(String fileName) => File('test/fixtures/$fileName')
    .readAsStringSync()
    .replaceAll(RegExp(r'\s'), '');
