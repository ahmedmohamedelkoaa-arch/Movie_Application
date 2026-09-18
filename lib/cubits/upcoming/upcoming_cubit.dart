import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_nti_aug/model/upcoming_model.dart';

part 'upcoming_state.dart';

class UpcomingCubit extends Cubit<UpcomingState> {
  UpcomingCubit() : super(UpcomingInitial());

  final String _apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4";

  Future<void> getUpcoming() async {
    emit(UpcomingLoading());

    try {
      var dio = Dio();

      var res = await dio.get(
        'https://api.themoviedb.org/3/movie/upcoming',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $_apiKey",
            "accept": "application/json",
          },
        ),
      );

      if (res.statusCode == 200) {
        print("API Response successful");
        print("Response data: ${res.data}");

        var movies = UpcomingResponse.fromJson(res.data);

        print("📽️ Movies count: ${movies.results?.length ?? 0}");
        if (movies.results != null && movies.results!.isNotEmpty) {
          print("First movie: ${movies.results?.first.title}");
          print("Poster path: ${movies.results?.first.posterPath}");
        }

        emit(
          UpcomingSuccess(
            movies: movies.results ?? [],
          ),
        );
      }
    } catch (e) {
      print("UNEXPECTED ERROR: $e");
      emit(UpcomingFailure(message: "erroe"));
    }
  }
}