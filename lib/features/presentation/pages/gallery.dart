import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      "title": "Meals",
      "icon": Icons.restaurant,
      "color": Colors.green,
      "gradient": const [Color(0xFF66BB6A), Color(0xFF43A047)]
    },
    {
      "title": "Progress",
      "icon": Icons.trending_up,
      "color": Colors.blue,
      "gradient": const [Color(0xFF42A5F5), Color(0xFF1E88E5)]
    },
    {
      "title": "Workouts",
      "icon": Icons.fitness_center,
      "color": Colors.orange,
      "gradient": const [Color(0xFFFFB74D), Color(0xFFFFA726)]
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark 
                  ? [const Color(0xFF1A1F25), const Color(0xFF2A2F35)]
                  : [Colors.white, const Color(0xFFF5F7FA)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(theme),
                const SizedBox(height: 20),
                _buildTabs(theme),
                Expanded(
                  child: _buildTabContent(theme),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFAB(theme),
      ),
    );
  }

Widget _buildHeader(ThemeData theme) {
    // Add MediaQuery to get the status bar height
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20 + statusBarHeight, 20, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
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
                    color: theme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Capture Your Progress",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatItem(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

 Widget _buildTabs(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
        indicatorSize: TabBarIndicatorSize.tab,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: _categories[_currentIndex]["gradient"],
          ),
        ),
        tabs: _categories.map((category) => _buildTab(
          category["icon"],
          category["title"],
          _categories.indexOf(category) == _currentIndex,
          theme,
        )).toList(),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool isSelected, ThemeData theme) {
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
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: isSelected ? 13 : 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTabContent(ThemeData theme) {
    return TabBarView(
      controller: _tabController,
      children: _categories.map((category) => _buildPhotoGrid(theme, category)).toList(),
    );
  }

  Widget _buildPhotoGrid(ThemeData theme, Map<String, dynamic> category) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildPhotoCard(index, theme, category),
    );
  }

  Widget _buildPhotoCard(int index, ThemeData theme, Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category["color"].withOpacity(0.1),
            category["color"].withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: category["color"].withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: category["color"].withOpacity(0.1),
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
                    Colors.black.withOpacity(0.7),
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateTime.now().toString().substring(0, 10),
                    style: GoogleFonts.inter(
                      color: Colors.white70,
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

  Widget _buildFAB(ThemeData theme) {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: _categories[_currentIndex]["color"],
      icon: Icon(_categories[_currentIndex]["icon"]),
      label: Text(
        'Add ${_categories[_currentIndex]["title"]}',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}