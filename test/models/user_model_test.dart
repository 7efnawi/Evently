import 'package:flutter_test/flutter_test.dart';
import 'package:evently/models/user_model.dart';

void main() {
  group('UserModel Unit Tests', () {
    test('UserModel instantiates correctly and serializes to/from map', () {
      const user = UserModel(
        id: 'user_123',
        name: 'John Safwat',
        email: 'johnsafwat.route@gmail.com',
      );

      expect(user.id, 'user_123');
      expect(user.name, 'John Safwat');
      expect(user.email, 'johnsafwat.route@gmail.com');

      final map = user.toMap();
      expect(map['id'], 'user_123');
      expect(map['name'], 'John Safwat');
      expect(map['email'], 'johnsafwat.route@gmail.com');

      final fromMapUser = UserModel.fromMap(map);
      expect(fromMapUser, equals(user));
    });
  });
}
