import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../model/search_model.dart';

part 'search_state.dart';

const String _tmdbToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4";

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final Dio _dio = Dio();

  Future<void> getSearch(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final res = await _dio.get(
        "https://api.themoviedb.org/3/search/movie",
        queryParameters: {
          "query": query,
          "include_adult": false,
          "language": "en-US",
          "page": 1,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4",
            "accept": "application/json",
          },
        ),
      );

      final movieResponse = MovieResponse.fromJson(res.data);

      emit(
        SearchSuccess(
          movieResponse: movieResponse,
        ),
      );
    } catch (e) {
      emit(
        SearchFailure(
          error: e.toString(),
        ),
      );
    }
  }

  Future<MovieDetailModel?> getMovieDetail(int movieId) async {
    try {
      final res = await _dio.get(
        "https://api.themoviedb.org/3/movie/$movieId",
        queryParameters: {
          "language": "en-US",
        },
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4",
            "accept": "application/json",
          },
        ),
      );

      return MovieDetailModel.fromJson(res.data);
    } catch (e) {
      print("Movie Detail Error: $e");
      return null;
    }
  }

  Future<List<CastModel>> getMovieCast(int movieId) async {
    try {
      final res = await _dio.get(
        "https://api.themoviedb.org/3/movie/$movieId/credits",
        queryParameters: {
          "language": "en-US",
        },
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4",
            "accept": "application/json",
          },
        ),
      );

      final List cast = res.data['cast'] ?? [];

      return cast
          .take(10)
          .map(
            (actor) => CastModel.fromJson(actor),
      )
          .toList();
    } catch (e) {
      print("Cast Error: $e");
      return [];
    }
  }
}