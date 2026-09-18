


import '../../model/carousel_model.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeDisplayShowGreet extends HomeState {}
final class HomeErrorShowMovies extends HomeState {}
final class HomeCarouselMovies extends HomeState {}
final class HomeSuccessMovies extends HomeState {
  final List<MovieModel> movies;
  HomeSuccessMovies(this.movies);
}