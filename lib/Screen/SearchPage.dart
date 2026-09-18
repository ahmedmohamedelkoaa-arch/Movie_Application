import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/search/search_cubit.dart';
import '../model/search_model.dart';
import 'detail_screen.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  Timer? _debounce;

  final Map<int, Future<MovieDetailModel?>> _detailsCache = {};

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(
      BuildContext context,
      String value,
      ) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
          () {
        if (!mounted) return;

        context
            .read<SearchCubit>()
            .getSearch(value.trim());
      },
    );
  }

  Future<MovieDetailModel?> detai(
      BuildContext context,
      int movieId,
      ) {
    return _detailsCache.putIfAbsent(
      movieId,
          () => context
          .read<SearchCubit>()
          .getMovieDetail(movieId),
    );
  }

  void openDetails(
      BuildContext context,
      MovieModel movie,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detail_screen(
          movieId: movie.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor:
            const Color(0xff242A32),

            appBar: AppBar(
              backgroundColor:
              const Color(0xff242A32),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Search",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),

            body: Column(
              children: [
                Container(
                  height: 45,
                  width: 450,
                  margin: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 12,
                    bottom: 16,
                  ),
                  padding:
                  const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color:
                    const Color(0xff3A3F47),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                    decoration:
                    const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    onChanged: (value) {
                      _onSearchChanged(
                        context,
                        value,
                      );
                    },
                  ),
                ),

                Expanded(
                  child: BlocBuilder<
                      SearchCubit,
                      SearchState>(
                    builder:
                        (context, state) {
                      if (state
                      is SearchInitial) {
                        return const Center(
                          child: Text(
                            "Search for a movie",
                            style: TextStyle(
                              color:
                              Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      if (state
                      is SearchLoading) {
                        return const Center(
                          child:
                          CircularProgressIndicator(
                            color:
                            Colors.deepOrange,
                          ),
                        );
                      }

                      if (state
                      is SearchFailure) {
                        return Center(
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .all(20),
                            child: Text(
                              state.error,
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontSize: 14,
                              ),
                              textAlign:
                              TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (state
                      is SearchSuccess) {
                        final movies =
                            state.movieResponse
                                .results;

                        if (movies.isEmpty) {
                          return const Center(
                            child: Text(
                              "No movies found",
                              style: TextStyle(
                                color:
                                Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding:
                          const EdgeInsets.only(
                            left: 36,
                            right: 36,
                            top: 4,
                            bottom: 20,
                          ),
                          itemCount:
                          movies.length,
                          itemBuilder:
                              (context, index) {
                            final movie =
                            movies[index];

                            return GestureDetector(
                              onTap: () {
                                openDetails(
                                  context,
                                  movie,
                                );
                              },
                              child: Container(
                                margin:
                                const EdgeInsets
                                    .only(
                                  bottom: 24,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        14,
                                      ),
                                      child: movie
                                          .posterPath !=
                                          null
                                          ? Image.network(
                                        "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit
                                            .cover,
                                        errorBuilder:
                                            (context,
                                            error,
                                            stackTrace) {
                                          return moviePlaceholder();
                                        },
                                      )
                                          : moviePlaceholder(),
                                    ),

                                    const SizedBox(
                                      width: 14,
                                    ),

                                    Expanded(
                                      child:
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            movie.title,
                                            maxLines:
                                            2,
                                            overflow:
                                            TextOverflow
                                                .ellipsis,
                                            style:
                                            const TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize:
                                              18,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 12,
                                          ),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons
                                                    .star_border,
                                                color:
                                                Color(
                                                  0xffF5A000,
                                                ),
                                                size: 22,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                movie
                                                    .voteAverage
                                                    .toStringAsFixed(
                                                  1,
                                                ),
                                                style:
                                                const TextStyle(
                                                  color:
                                                  Color(
                                                    0xffF5A000,
                                                  ),
                                                  fontSize:
                                                  15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(
                                            height: 8,
                                          ),

                                          FutureBuilder<
                                              MovieDetailModel?>(
                                            future:
                                            detai(
                                              context,
                                              movie.id,
                                            ),
                                            builder:
                                                (context,
                                                snapshot) {
                                              String
                                              genre =
                                                  "...";

                                              if (snapshot
                                                  .connectionState ==
                                                  ConnectionState
                                                      .done) {
                                                final detail =
                                                    snapshot
                                                        .data;

                                                if (detail !=
                                                    null &&
                                                    detail
                                                        .genres
                                                        .isNotEmpty) {
                                                  genre =
                                                      detail
                                                          .genres
                                                          .first;
                                                }
                                              }

                                              return Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .confirmation_number_outlined,
                                                    color: Colors
                                                        .grey
                                                        .shade400,
                                                    size:
                                                    20,
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                    6,
                                                  ),
                                                  Expanded(
                                                    child:
                                                    Text(
                                                      genre,
                                                      style:
                                                      TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                        fontSize:
                                                        15,
                                                      ),
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),

                                          const SizedBox(
                                            height: 8,
                                          ),

                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .calendar_today_outlined,
                                                color: Colors
                                                    .grey
                                                    .shade400,
                                                size: 19,
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                movie.releaseDate
                                                    .isNotEmpty &&
                                                    movie.releaseDate
                                                        .length >=
                                                        4
                                                    ? movie
                                                    .releaseDate
                                                    .substring(
                                                  0,
                                                  4,
                                                )
                                                    : "Unknown",
                                                style:
                                                TextStyle(
                                                  color: Colors
                                                      .grey
                                                      .shade300,
                                                  fontSize:
                                                  15,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(
                                            height: 8,
                                          ),

                                          FutureBuilder<
                                              MovieDetailModel?>(
                                            future:
                                            detai(
                                              context,
                                              movie.id,
                                            ),
                                            builder:
                                                (context,
                                                snapshot) {
                                              String
                                              runtime =
                                                  "...";

                                              if (snapshot
                                                  .connectionState ==
                                                  ConnectionState
                                                      .done) {
                                                final detail =
                                                    snapshot
                                                        .data;

                                                if (detail !=
                                                    null &&
                                                    detail
                                                        .runtime >
                                                        0) {
                                                  runtime =
                                                  "${detail.runtime} minutes";
                                                }
                                              }

                                              return Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .access_time,
                                                    color: Colors
                                                        .grey
                                                        .shade400,
                                                    size:
                                                    20,
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                    6,
                                                  ),
                                                  Text(
                                                    runtime,
                                                    style:
                                                    TextStyle(
                                                      color: Colors
                                                          .grey
                                                          .shade300,
                                                      fontSize:
                                                      15,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget moviePlaceholder() {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.movie,
        color: Colors.white54,
        size: 35,
      ),
    );
  }
}