// lib/cart.dart
class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; 

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  }) : assert(discount >= 0.0 && discount <= 1.0);

  double get lineTotal => price * quantity;

  double get discountAmount => price * quantity * discount;

  double get totalAfterDiscount => lineTotal - discountAmount;
}

class CartManager {
  final List<CartItem> _items = [];
  final int maxQuantity;

  CartManager({this.maxQuantity = 99});

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(String id, String name, double price, {double discount = 0.0, int quantity = 1}) {
    if (quantity <= 0) return;
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final newQty = (_items[idx].quantity + quantity).clamp(0, maxQuantity);
      if (newQty == 0) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity = newQty;
      }
    } else {
      final q = quantity.clamp(1, maxQuantity);
      _items.add(CartItem(id: id, name: name, price: price, quantity: q, discount: discount));
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = newQuantity.clamp(1, maxQuantity);
    }
  }

  void clear() => _items.clear();

  double get subtotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.lineTotal;
    }
    return total;
  }

  double get totalDiscount {
    double total = 0.0;
    for (var item in _items) {
      total += item.discountAmount;
    }
    return total;
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => _items.isEmpty;
}
