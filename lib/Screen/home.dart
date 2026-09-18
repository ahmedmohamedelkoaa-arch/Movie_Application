import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/Screen/SearchPage.dart';
import 'package:movie_nti_aug/Screen/custom_bottom_nav.dart';
import 'package:movie_nti_aug/Screen/detail_screen.dart';
import 'package:movie_nti_aug/Screen/watch_later.dart';
import 'package:movie_nti_aug/Tabs/Popular_Page.dart';
import 'package:movie_nti_aug/Tabs/Top_RatedPage.dart';
import 'package:movie_nti_aug/Tabs/Upcoming_page.dart';
import '../Tabs/Now_playingPage.dart';
import 'package:movie_nti_aug/cubits/home_screen/carousel_cubit.dart';
import 'package:movie_nti_aug/cubits/home_screen/carousel_state.dart';
import 'package:movie_nti_aug/cubits/search/search_cubit.dart';
import 'package:movie_nti_aug/cubits/watch_later/watch_later_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchLaterCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff242A32),

        body: IndexedStack(
          index: selectedPage,
          children: const [
            HomeContent(),
            Searchpage(),
            WatchLaterPage(),
          ],
        ),

        bottomNavigationBar: CustomBottomNav(
          currentIndex: selectedPage,
          onTap: (value) {
            setState(() {
              selectedPage = value;
            });
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> tabs = [
    "Now playing",
    "Upcoming",
    "Top rated",
    "Popular",
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void openDetails(BuildContext context, int movieId) {
    final watchLaterCubit = context.read<WatchLaterCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SearchCubit(),
            ),
            BlocProvider.value(
              value: watchLaterCubit,
            ),
          ],
          child: detail_screen(
            movieId: movieId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getCarouselMovies(),
      child: Scaffold(
        backgroundColor: const Color(0xff242A32),

        appBar: AppBar(
          title: const Text(
            "   What do you want to watch?",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xff242A32),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xff3A3F47),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Searchpage(),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlignVertical:
                      TextAlignVertical.center,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeCarouselMovies) {
                    return const SizedBox(
                      height: 310,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is HomeErrorShowMovies) {
                    return const SizedBox(
                      height: 310,
                      child: Center(
                        child: Text(
                          "Error",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is HomeSuccessMovies) {
                    return SizedBox(
                      height: 310,
                      child: CarouselSlider.builder(
                        itemCount: state.movies.length,
                        options: CarouselOptions(
                          height: 310,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.5,
                        ),
                        itemBuilder: (
                            context,
                            index,
                            realIndex,
                            ) {
                          final movie = state.movies[index];

                          return GestureDetector(
                            onTap: () {
                              if (movie.id != null) {
                                openDetails(
                                  context,
                                  movie.id!,
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(16),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 310,
                  );
                },
              ),

              const SizedBox(height: 20),

              TabBar(
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                padding: EdgeInsets.zero,
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor:
                const Color(0xff3A3F47),
                indicatorSize:
                TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle:
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                tabs: tabs
                    .map(
                      (t) => Tab(
                    text: t,
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 500,
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    NowPlayingpage(),
                    UpcomingPage(),
                    TopRatedpage(),
                    PopularPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}