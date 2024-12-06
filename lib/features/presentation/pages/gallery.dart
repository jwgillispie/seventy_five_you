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
  final List<Map<String, dynamic>> _categories = [
    {
      "title": "Meals",
      "icon": Icons.restaurant,
      "color": SFColors.primary, // Green - 4daa57
      "gradient": [SFColors.primary, SFColors.secondary] // 4daa57 to b5dda4
    },
    {
      "title": "Progress",
      "icon": Icons.trending_up,
      "color": SFColors.neutral, // Purple - 754668
      "gradient": [SFColors.neutral, SFColors.tertiary] // 754668 to 587d71
    },
    {
      "title": "Workouts",
      "icon": Icons.fitness_center,
      "color": SFColors.tertiary, // Sage - 587d71
      "gradient": [SFColors.tertiary, SFColors.primary] // 587d71 to 4daa57
    }
  ];
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
              colors: [
                SFColors.surface,
                SFColors.background,
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

  Widget _buildHeader() {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20 + statusBarHeight, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SFColors.neutral, SFColors.tertiary],
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
                    color: SFColors.surface,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: SFColors.surface,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Capture Your Progress",
              style: GoogleFonts.inter(
                color: SFColors.surface.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: SFColors.surface,
        unselectedLabelColor: SFColors.textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: _categories[_currentIndex]["gradient"],
          ),
        ),
        tabs: _categories
            .map((category) => _buildTab(
                  category["icon"],
                  category["title"],
                  _categories.indexOf(category) == _currentIndex,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool isSelected) {
    return Tab(
      height: 56,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSelected ? 22 : 18,
              color: isSelected ? SFColors.surface : SFColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: isSelected ? 13 : 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? SFColors.surface : SFColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children:
          _categories.map((category) => _buildPhotoGrid(category)).toList(),
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
            SFColors.surface,
            SFColors.background,
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
                      color: SFColors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateTime.now().toString().substring(0, 10),
                    style: GoogleFonts.inter(
                      color: SFColors.surface.withOpacity(0.7),
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

  // Update the FAB to use category colors consistently
  Widget _buildFAB() {
    final category = _categories[_currentIndex];
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: category["color"],
      icon: Icon(
        category["icon"],
        color: SFColors.surface,
      ),
      label: Text(
        'Add ${category["title"]}',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: SFColors.surface,
        ),
      ),
    );
  }
}
