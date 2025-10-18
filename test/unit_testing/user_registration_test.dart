import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/validation_class.dart';
void main(){
  group("email validation",(){
    test("email valid", (){
expect(ValidationClass.isValidEmail("abcd@gmail.com"), true);
    });
    test("invalid email", (){
      expect(ValidationClass.isValidEmail("abcd@"), false);
    });

  } );
  group("password validation", (){
    test("valid password",(){
      expect(ValidationClass.isValidPassword("Abcd@1234"), true);
    });
    test("invalid password",(){
      expect(ValidationClass.isValidPassword("Abcd"), false);
    });
  });
} 