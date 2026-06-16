import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('web metadata uses the Jogeumssik brand', () {
    final indexHtml = File('web/index.html').readAsStringSync();
    final manifest =
        jsonDecode(File('web/manifest.json').readAsStringSync())
            as Map<String, Object?>;

    expect(indexHtml, contains('<title>조금씩</title>'));
    expect(
      indexHtml,
      contains('<meta name="apple-mobile-web-app-title" content="조금씩">'),
    );
    expect(
      indexHtml,
      contains('<meta name="apple-mobile-web-app-capable" content="yes">'),
    );
    expect(
      indexHtml,
      contains(
        '<link rel="apple-touch-icon" sizes="180x180" href="icons/Icon-180.png">',
      ),
    );
    expect(indexHtml, contains('천천히 서로를 알아가는 비공개 웹앱'));
    expect(indexHtml, isNot(contains('<title>알아가기</title>')));

    expect(manifest['name'], '조금씩');
    expect(manifest['short_name'], '조금씩');
    expect(manifest['theme_color'], '#6F7F63');
    expect(manifest['background_color'], '#F4F3EF');
    expect(manifest['description'], contains('천천히 서로를 알아가는'));
  });

  test('web icon assets keep required png sizes', () {
    expect(_pngSize('web/favicon.png'), const PngSize(16, 16));
    expect(_pngSize('web/icons/Icon-180.png'), const PngSize(180, 180));
    expect(_pngSize('web/icons/Icon-192.png'), const PngSize(192, 192));
    expect(_pngSize('web/icons/Icon-512.png'), const PngSize(512, 512));
    expect(
      _pngSize('web/icons/Icon-maskable-192.png'),
      const PngSize(192, 192),
    );
    expect(
      _pngSize('web/icons/Icon-maskable-512.png'),
      const PngSize(512, 512),
    );
  });
}

PngSize _pngSize(String path) {
  final bytes = File(path).readAsBytesSync();
  expect(bytes.length, greaterThanOrEqualTo(24), reason: path);
  expect(bytes.sublist(0, 8), const [137, 80, 78, 71, 13, 10, 26, 10]);
  return PngSize(_readUint32(bytes, 16), _readUint32(bytes, 20));
}

int _readUint32(List<int> bytes, int offset) {
  return bytes[offset] << 24 |
      bytes[offset + 1] << 16 |
      bytes[offset + 2] << 8 |
      bytes[offset + 3];
}

class PngSize {
  const PngSize(this.width, this.height);

  final int width;
  final int height;

  @override
  bool operator ==(Object other) {
    return other is PngSize && other.width == width && other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() => '${width}x$height';
}
