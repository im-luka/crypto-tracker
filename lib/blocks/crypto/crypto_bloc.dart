import 'package:bloc/bloc.dart';
import 'package:cryptocurrency_api/models/coin_model.dart';
import 'package:cryptocurrency_api/models/failure.dart';
import 'package:cryptocurrency_api/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;

  CryptoBloc({required CryptoRepository cryptoRepository})
      : _cryptoRepository = cryptoRepository,
        super(CryptoState.initial()) {
    on<AppStarted>(
      (event, emit) async {
        emit(state.copyWith(status: CryptoStatus.loading));
        await getCoins(emit);
      },
    );
    on<RefreshCoins>(
      (event, emit) async {
        await getCoins(emit);
      },
    );
    on<LoadMoreCoins>(
      (event, emit) async {
        final nextPage = state.coins.length ~/ CryptoRepository.perPage;
        await getCoins(emit, page: nextPage);
      },
    );
  }

  Future<void> getCoins(Emitter<CryptoState> emit, {int page = 0}) async {
    try {
      final coins = [
        if (page != 0) ...state.coins,
        ...await _cryptoRepository.getTopCoins(page: page),
      ];

      emit(state.copyWith(coins: coins, status: CryptoStatus.loaded));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: CryptoStatus.error));
    }
  }
}
