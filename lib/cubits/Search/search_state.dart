part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final MovieResponse movieResponse;

  SearchSuccess({
    required this.movieResponse,
  });
}

class SearchFailure extends SearchState {
  final String error;

  SearchFailure({
    required this.error,
  });
}