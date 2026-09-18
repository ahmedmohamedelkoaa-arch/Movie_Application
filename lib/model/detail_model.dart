class MovieDetailModel {
  final String? backdropPath;
  final String? posterPath;
  final String? overview;
  final String title;
  final String? releaseDate;
  final int runtime;
  final double voteAverage;
  final List<String> genres;

  MovieDetailModel({
    this.backdropPath,
    this.posterPath,
    this.overview,
    required this.title,
    this.releaseDate,
    required this.runtime,
    required this.voteAverage,
    required this.genres,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      title: json['title'] ?? '',
      releaseDate: json['release_date'],
      runtime: json['runtime'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      genres: (json['genres'] as List?)
          ?.map((e) => e['name'].toString())
          .toList() ??
          [],
    );
  }
}