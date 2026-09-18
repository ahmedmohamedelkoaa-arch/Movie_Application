import 'package:flutter/material.dart';

import '../cubits/search/search_cubit.dart';
import '../cubits/watch_later/watch_later_cubit.dart';
import '../model/search_model.dart';

class detail_screen extends StatefulWidget {
  final int movieId;

  const detail_screen({
    super.key,
    required this.movieId,
  });

  @override
  State<detail_screen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<detail_screen> {
  late Future<MovieDetailModel?> movieFuture;
  late Future<List<CastModel>> castFuture;

  late SearchCubit searchCubit;

  final WatchLaterCubit watchLaterCubit =
      WatchLaterCubit.instance;

  bool isAdded = false;

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    searchCubit = SearchCubit();

    movieFuture =
        searchCubit.getMovieDetail(widget.movieId);

    castFuture =
        searchCubit.getMovieCast(widget.movieId);

    isAdded =
        watchLaterCubit.isMovieAdded(widget.movieId);
  }

  @override
  void dispose() {
    searchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      body: FutureBuilder<MovieDetailModel?>(
        future: movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null) {
            return const Center(
              child: Text(
                "Failed to load movie",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final movie = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: movie.backdropPath != null
                          ? Image.network(
                        "https://image.tmdb.org/t/p/w780${movie.backdropPath}",
                        fit: BoxFit.cover,
                      )
                          : Container(
                        color: Colors.grey.shade800,
                      ),
                    ),

                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            const Color(0xff242A32),
                          ],
                        ),
                      ),
                    ),

                    SafeArea(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),

                            const Text(
                              "Detail",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isAdded) {
                                    watchLaterCubit
                                        .removeMovie(movie.id);
                                    isAdded = false;
                                  } else {
                                    watchLaterCubit
                                        .addMovie(movie);
                                    isAdded = true;
                                  }
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isAdded
                                          ? "Added to Watch Later"
                                          : "Removed from Watch Later",
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                isAdded
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      bottom: -48,
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(12),
                        child: movie.posterPath != null
                            ? Image.network(
                          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                          width: 105,
                          height: 140,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 105,
                          height: 140,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.movie,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 20,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration:
                        const BoxDecoration(
                          color: Color(0xff242A32),
                          borderRadius:
                          BorderRadius.only(
                            topLeft:
                            Radius.circular(10),
                            bottomLeft:
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xffF5A000),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                color:
                                Color(0xffF5A000),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 58),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        movie.releaseDate != null &&
                            movie.releaseDate!.length >= 4
                            ? movie.releaseDate!.substring(0, 4)
                            : "Unknown",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "|",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: 15,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${movie.runtime} Minutes",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "|",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.movie_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          movie.genres.isNotEmpty
                              ? movie.genres.first
                              : "Unknown",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      tabButton(
                        "About Movie",
                        0,
                      ),
                      tabButton(
                        "Reviews",
                        1,
                      ),
                      tabButton(
                        "Cast",
                        2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                if (selectedTab == 0)
                  aboutMovie(movie),

                if (selectedTab == 1)
                  reviews(),

                if (selectedTab == 2)
                  cast(),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget tabButton(
      String title,
      int index,
      ) {
    final selected =
        selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 3,
              width: selected ? 70 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget aboutMovie(
      MovieDetailModel movie,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Text(
        movie.overview ??
            "No overview available",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }

  Widget reviews() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          reviewItem(
            "Igal Shafia Rozen",
            "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government.",
          ),
          const SizedBox(height: 20),
          reviewItem(
            "Igal Shafia Rozen",
            "A very interesting movie with great characters and an amazing story.",
          ),
        ],
      ),
    );
  }

  Widget reviewItem(
      String name,
      String text,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 20,
          child: Icon(
            Icons.person,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cast() {
    return FutureBuilder<List<CastModel>>(
      future: castFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData) {
          return const Center(
            child: Text(
              "Failed to load cast",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }

        final actors = snapshot.data!;

        if (actors.isEmpty) {
          return const Center(
            child: Text(
              "No cast available",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }

        return Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: GridView.builder(
            itemCount: actors.length,
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              childAspectRatio: 0.85,
            ),
            itemBuilder:
                (context, index) {
              final actor =
              actors[index];

              return Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor:
                    Colors.grey.shade700,
                    backgroundImage:
                    actor.profilePath != null
                        ? NetworkImage(
                      "https://image.tmdb.org/t/p/w500${actor.profilePath}",
                    )
                        : null,
                    child:
                    actor.profilePath == null
                        ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    )
                        : null,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    actor.name,
                    textAlign:
                    TextAlign.center,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    actor.character,
                    textAlign:
                    TextAlign.center,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}