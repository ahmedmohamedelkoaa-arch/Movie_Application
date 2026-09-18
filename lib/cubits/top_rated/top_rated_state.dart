part of 'top_rated_cubit.dart';

@immutable
sealed class TopRatedState {}

final class TopRatedInitial extends TopRatedState {}
final class TopRatedLoading extends TopRatedState {}
final class TopRatedSuccess extends TopRatedState {
  final List<Movie> movies;
  TopRatedSuccess({
    required this.movies,
});
}
final class TopRatedFailure extends TopRatedState {}
