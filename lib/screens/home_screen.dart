import 'package:cryptocurrency_api/blocks/crypto/crypto_bloc.dart';
import 'package:cryptocurrency_api/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Top Coins'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SearchScreen(),
              ),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        child: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            switch (state.status) {
              case CryptoStatus.loaded:
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  onRefresh: () async {
                    context.read<CryptoBloc>().add(RefreshCoins());
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(notification),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.coins.length,
                      itemBuilder: (BuildContext context, int index) {
                        final coin = state.coins[index];
                        return ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${++index}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            coin.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            coin.name,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          trailing: Text(
                            '\$${coin.price.toStringAsFixed(4)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              case CryptoStatus.error:
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                          size: 250.0,
                        ),
                        const SizedBox(height: 30.0),
                        Text(
                          state.failure.message,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              default:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.secondary),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController!.position.extentAfter == 0) {
      context.read<CryptoBloc>().add(LoadMoreCoins());
    }
    return false;
  }
}
