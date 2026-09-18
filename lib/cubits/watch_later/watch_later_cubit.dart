import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/search_model.dart';

part 'watch_later_state.dart';

class WatchLaterCubit extends Cubit<WatchLaterState> {
  WatchLaterCubit() : super(WatchLaterInitial());

  static final WatchLaterCubit instance = WatchLaterCubit();

  final List<MovieDetailModel> movies = [];

  void addMovie(MovieDetailModel movie) {
    final exists = movies.any(
          (item) => item.id == movie.id,
    );

    if (!exists) {
      movies.add(movie);
      emit(
        WatchLaterUpdated(
          List.from(movies),
        ),
      );
    }
  }

  void removeMovie(int movieId) {
    movies.removeWhere(
          (movie) => movie.id == movieId,
    );

    emit(
      WatchLaterUpdated(
        List.from(movies),
      ),
    );
  }

  bool isMovieAdded(int movieId) {
    return movies.any(
          (movie) => movie.id == movieId,
    );
  }

  void getWatchLater() {
    emit(
      WatchLaterUpdated(
        List.from(movies),
      ),
    );
  }
}