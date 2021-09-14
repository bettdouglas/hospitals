import 'package:hospitals/src/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('String extensions test', () {
    test('capitalizeFirstLetter ', () {
      final c = 'uncapitalized first';
      expect(c.capitalizeFirstLetter, 'Uncapitalized first');
    });
  });
}
