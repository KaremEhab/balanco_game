import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- State ---
class AppState extends Equatable {
  final bool isMultiplayer;
  final String playerRole;

  const AppState({
    this.isMultiplayer = false,
    this.playerRole = 'BOTH', // 'LEFT', 'RIGHT', 'BOTH'
  });

  AppState copyWith({bool? isMultiplayer, String? playerRole}) {
    return AppState(
      isMultiplayer: isMultiplayer ?? this.isMultiplayer,
      playerRole: playerRole ?? this.playerRole,
    );
  }

  @override
  List<Object?> get props => [isMultiplayer, playerRole];
}

// --- Events ---
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class ToggleMultiplayer extends AppEvent {
  final bool isMultiplayer;
  const ToggleMultiplayer(this.isMultiplayer);

  @override
  List<Object?> get props => [isMultiplayer];
}

class ChangePlayerRole extends AppEvent {
  final String role;
  const ChangePlayerRole(this.role);

  @override
  List<Object?> get props => [role];
}

// --- Bloc ---
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<ToggleMultiplayer>((event, emit) {
      emit(state.copyWith(isMultiplayer: event.isMultiplayer));
    });

    on<ChangePlayerRole>((event, emit) {
      emit(state.copyWith(playerRole: event.role));
    });
  }
}
