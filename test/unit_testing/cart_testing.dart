import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/cart.dart';


void main() {
  group('CartManager basic operations', () {
    test('Add item and update quantity when duplicate added', () {
      final cart = CartManager();
      cart.addItem('1', 'Item A', 10.0);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 1);

      cart.addItem('1', 'Item A', 10.0);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
    });

    test('Remove item', () {
      final cart = CartManager();
      cart.addItem('1', 'Item A', 10.0);
      cart.addItem('2', 'Item B', 5.0);
      expect(cart.items.length, 2);

      cart.removeItem('1');
      expect(cart.items.length, 1);
      expect(cart.items.first.id, '2');
    });

    test('Update quantity and remove when quantity <= 0', () {
      final cart = CartManager();
      cart.addItem('1', 'Item A', 10.0, quantity: 3);
      expect(cart.items.first.quantity, 3);

      cart.updateQuantity('1', 1);
      expect(cart.items.first.quantity, 1);

      cart.updateQuantity('1', 0);
      expect(cart.items.length, 0);
    });
  });

  group('CartManager calculations', () {
    test('Subtotal, totalDiscount and totalAmount compute correctly', () {
      final cart = CartManager();
      cart.addItem('1', 'A', 100.0, discount: 0.1, quantity: 2);
    
      cart.addItem('2', 'B', 50.0, discount: 0.0, quantity: 1);

      expect(cart.subtotal, 250.0); // 200 + 50
      expect(cart.totalDiscount, 20.0); // 20 + 0
      expect(cart.totalAmount, 230.0); // 250 - 20
    });

    test('100% discount results in zero total for that item', () {
      final cart = CartManager();
      cart.addItem('1', 'Freebie', 30.0, discount: 1.0, quantity: 3); // lineTotal=90, discount=90
      expect(cart.subtotal, 90.0);
      expect(cart.totalDiscount, 90.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Empty cart totals are zero', () {
      final cart = CartManager();
      expect(cart.isEmpty, true);
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
      expect(cart.totalItems, 0);
    });
  });

  group('Edge cases', () {
    test('Quantity limits enforced (maxQuantity)', () {
      final cart = CartManager(maxQuantity: 5);
      cart.addItem('1', 'A', 1.0, quantity: 3);
      expect(cart.items.first.quantity, 3);

      cart.addItem('1', 'A', 1.0, quantity: 4);
      expect(cart.items.first.quantity, 5); // clamped to maxQuantity
    });

    test('Adding with negative or zero quantity does nothing', () {
      final cart = CartManager();
      cart.addItem('1', 'A', 10.0, quantity: 0);
      expect(cart.items.length, 0);

      cart.addItem('1', 'A', 10.0, quantity: -3);
      expect(cart.items.length, 0);
    });
  });
}
