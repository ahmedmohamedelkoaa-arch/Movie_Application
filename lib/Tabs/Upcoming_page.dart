import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/Screen/detail_screen.dart';
import 'package:movie_nti_aug/cubits/search/search_cubit.dart';
import '../cubits/upcoming/upcoming_cubit.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpcomingCubit()..getUpcoming(),
      child: Scaffold(
        backgroundColor: const Color(0xff242A32),
        body: BlocBuilder<UpcomingCubit, UpcomingState>(
          builder: (context, state) {
            if (state is UpcomingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UpcomingFailure) {
              return const Center(
                child: Text(
                  "Error",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            }

            if (state is UpcomingSuccess) {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.movies.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = state.movies[index];

                  return Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (movie.id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SearchCubit(),
                                child: detail_screen(
                                  movieId: movie.id!,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.movie,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
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
    );
  }
}