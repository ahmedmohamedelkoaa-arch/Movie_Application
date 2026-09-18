part of 'upcoming_cubit.dart';

@immutable
sealed class UpcomingState {}

final class UpcomingInitial extends UpcomingState {}

final class UpcomingLoading extends UpcomingState {}

final class UpcomingSuccess extends UpcomingState {
  final List<UpcomingMovie> movies;

  UpcomingSuccess({
    required this.movies,
  });
}

final class UpcomingFailure extends UpcomingState {
  final String message;

  UpcomingFailure({this.message = "حدث خطأ في التحميل"});
}
