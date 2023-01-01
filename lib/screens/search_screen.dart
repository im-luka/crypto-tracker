import 'package:cryptocurrency_api/models/coin_model.dart';
import 'package:cryptocurrency_api/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _coinSearch = 'BTC';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Search for Coin'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Enter coin name...',
                  contentPadding: const EdgeInsets.only(top: 15.0),
                ),
                onSubmitted: (val) {
                  setState(() {
                    _coinSearch = val;
                  });
                },
              ),
            ),
            Container(
              child: FutureBuilder(
                future: CryptoRepository().getSelectedCoins(_coinSearch),
                builder: (BuildContext context, AsyncSnapshot<Coin> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  }
                  return ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      snapshot.data!.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data!.name,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    trailing: Text(
                      '\$${snapshot.data!.price.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
