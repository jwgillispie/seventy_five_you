import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/themes.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
// Update the categories list in the state class:
  // final List<Map<String, dynamic>> _categories = [
  //   {
  //     "title": "Meals",
  //     "icon": Icons.restaurant,
  //     "color": Theme.of(context).colorScheme.primary, // Green - 4daa57
  //     "gradient": [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary] // 4daa57 to b5dda4
  //   },
  //   {
  //     "title": "Progress",
  //     "icon": Icons.trending_up,
  //     "color": Theme.of(context).colorScheme.secondaryFixed, // Purple - 754668
  //     "gradient": [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.tertiary] // 754668 to 587d71
  //   },
  //   {
  //     "title": "Workouts",
  //     "icon": Icons.fitness_center,
  //     "color": Theme.of(context).colorScheme.tertiary, // Sage - 587d71
  //     "gradient": [Theme.of(context).colorScheme.tertiary, Theme.of(context).colorScheme.primary] // 587d71 to 4daa57
  //   }
  // ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [
                      Theme.of(context)
                          .colorScheme
                          .secondaryFixed
                          .withOpacity(0.9),
                      Theme.of(context).colorScheme.tertiary,
                    ]
                  : [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.background,
                    ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildTabs(),
                Expanded(
                  child: _buildTabContent(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  List<Map<String, dynamic>> getCategories(BuildContext context) {
    return [
      {
        "title": "Meals",
        "icon": Icons.restaurant,
        "color": Theme.of(context).colorScheme.primary,
        "gradient": [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ]
      },
      {
        "title": "Progress",
        "icon": Icons.trending_up,
        "color": Theme.of(context).colorScheme.secondary,
        "gradient": [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary,
        ]
      },
      {
        "title": "Workouts",
        "icon": Icons.fitness_center,
        "color": Theme.of(context).colorScheme.tertiary,
        "gradient": [
          Theme.of(context).colorScheme.tertiary,
          Theme.of(context).colorScheme.primary,
        ]
      }
    ];
  }

  Widget _buildHeader() {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20 + statusBarHeight, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondaryFixed,
              Theme.of(context).colorScheme.tertiary
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Journey Gallery',
                  style: GoogleFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Capture Your Progress",
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final categories = getCategories(context); // Add this line
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.surface,
        unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: categories[_currentIndex]["gradient"],
          ),
        ),
        tabs: categories
            .map(
              (category) => Tab(
                text: category["title"],
                icon: Icon(category["icon"]),
              ),
            )
            .toList(),
            
            
      ),
    );
  }

  Widget _buildTabContent() {
    final categories = getCategories(context); // Add this line
    return TabBarView(
      controller: _tabController,
      children:
          categories.map((category) => _buildPhotoGrid(category)).toList(),
    );
  }

  Widget _buildFAB() {
    final categories = getCategories(context); // Add this line
    final category = categories[_currentIndex];
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: category["color"],
      icon: Icon(
        category["icon"],
        color: Theme.of(context).colorScheme.surface,
      ),
      label: Text(
        'Add ${category["title"]}',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(Map<String, dynamic> category) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildPhotoCard(index, category),
    );
  }

  Widget _buildPhotoCard(int index, Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.background,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (category["color"] as Color),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (category["color"] as Color).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://picsum.photos/300/400?random=$index',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (category["color"] as Color).withOpacity(0.9),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${category["title"]} ${index + 1}',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateTime.now().toString().substring(0, 10),
                    style: GoogleFonts.inter(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//   // Update the FAB to use category colors consistently
//   Widget _buildFAB() {
//     final category = _categories[_currentIndex];
//     return FloatingActionButton.extended(
//       onPressed: () {},
//       backgroundColor: category["color"],
//       icon: Icon(
//         category["icon"],
//         color: Theme.of(context).colorScheme.surface,
//       ),
//       label: Text(
//         'Add ${category["title"]}',
//         style: GoogleFonts.inter(
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).colorScheme.surface,
//         ),
//       ),
//     );
//   }
// }
