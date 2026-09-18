
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:movie_nti_aug/cubits/home_screen/carousel_state.dart';

import '../../model/carousel_model.dart';




class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getCarouselMovies() async {
    emit(HomeCarouselMovies());

    try {
      Dio dio = Dio();

      var response = await dio.get(
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmYwNzRjYzk3MzE0YmRiMWZmM2VlMmQ3NWUwNWY0ZiIsIm5iZiI6MTc2MTM5NzAxOS4xMDgsInN1YiI6IjY4ZmNjOTFiYzQzZDA1OTllMjkzODUwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lzdT9GXoMtzophhJo7yb5wZ0MviXwdxUh7Lo1kVT1N4",
            "accept": "application/json",
          },
        ),
      );

      MovieResponse movieResponse = MovieResponse.fromJson(response.data);

      print(movieResponse.results?.length);

      emit(HomeSuccessMovies(movieResponse.results!,
      ));
    } catch (e) {
      print(e);

      emit(HomeErrorShowMovies());
    }
  }
}