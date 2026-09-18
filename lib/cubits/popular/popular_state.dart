part of 'popular_cubit.dart';

@immutable
sealed class PopularState {}

final class PopularInitial extends PopularState {}
final class PopularLoading extends PopularState {}
final class PopularSuccess extends PopularState {
  final List <Movie> movies;
  PopularSuccess({
    required this.movies
});
}
final class PopularFailure extends PopularState {}
