import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String name;
  final String fullName;
  double price;

  Coin({
    required this.name,
    required this.fullName,
    required this.price,
  });

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      name: map['CoinInfo']?['Name'] ?? '',
      fullName: map['CoinInfo']?['FullName'] ?? '',
      price: (map['RAW']?['USD']?['PRICE'] ?? 0).toDouble(),
    );
  }

  factory Coin.selectedCoin(Map<String, dynamic> map, String coinName) {
    return Coin(
      name: map[coinName]?['Name'] ?? '',
      fullName: map[coinName]?['CoinName'] ?? '',
      price: 0,
    );
  }

  @override
  List<Object?> get props => [name, fullName, price];
}
