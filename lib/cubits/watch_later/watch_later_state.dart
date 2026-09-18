part of 'watch_later_cubit.dart';

abstract class WatchLaterState {}

class WatchLaterInitial extends WatchLaterState {}

class WatchLaterLoading extends WatchLaterState {}

class WatchLaterUpdated extends WatchLaterState {
  final List<MovieDetailModel> movies;

  WatchLaterUpdated(this.movies);
}