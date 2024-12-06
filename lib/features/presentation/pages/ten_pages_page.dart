import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/themes.dart';
import '../models/ten_pages_model.dart';
import '../models/day_model.dart';
import 'dart:math' as math;

class TenPagesPage extends StatefulWidget {
  const TenPagesPage({Key? key}) : super(key: key);

  @override
  State<TenPagesPage> createState() => _TenPagesPageState();
}

class _TenPagesPageState extends State<TenPagesPage>
    with TickerProviderStateMixin {
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _pageCountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _progressAnimation;

  User? user;
  Day? day;
  TenPages? tenPages;
  DateTime today = DateTime.now();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _showCompletion = false;
  int _currentPage = 0;

  final List<String> _readingQuotes = [
    "Books are a uniquely portable magic. 📚",
    "Reading is to the mind what exercise is to the body. 💪",
    "Knowledge is power, and books are the battery! 🔋",
    "Every page turned is progress earned. 📖",
    "Reading shapes the leader within you. 🌟"
  ];

  final List<Map<String, dynamic>> _readingStats = [
    {
      'title': 'Current Streak',
      'value': '7 Days',
      'icon': Icons.local_fire_department,
      'color': Color(0xFFFF6B6B),
    },
    {
      'title': 'Pages Read',
      'value': '70',
      'icon': Icons.menu_book,
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': 'Books Started',
      'value': '3',
      'icon': Icons.library_books,
      'color': Color(0xFFFFBE0B),
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'First Book',
      'description': 'Started your reading journey',
      'icon': Icons.auto_stories,
      'color': Color(0xFF4CAF50),
      'earned': true,
    },
    {
      'title': '7-Day Streak',
      'description': 'Read consistently for a week',
      'icon': Icons.workspace_premium,
      'color': Color(0xFF9B5DE5),
      'earned': true,
    },
    {
      'title': 'Quick Notes',
      'description': 'Made detailed reading notes',
      'icon': Icons.rate_review,
      'color': Color(0xFF00B4D8),
      'earned': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    // Main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _fetchDayData();
    _mainController.forward();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _bookTitleController.dispose();
    _pageCountController.dispose();
    _mainController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  String get _randomQuote {
    return _readingQuotes[math.Random().nextInt(_readingQuotes.length)];
  }

  Future<void> _fetchDayData() async {
    if (user == null) return;
    setState(() => _isLoading = true);

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          tenPages = day!.pages;
          _summaryController.text = tenPages?.summary ?? "";
          _bookTitleController.text = tenPages?.bookTitle ?? "";
          _pageCountController.text = tenPages?.pagesRead?.toString() ?? "";
          _currentPage = tenPages?.pagesRead ?? 0;

          if (_currentPage > 0) {
            _progressController.animateTo(_currentPage / 10);
          }

          if (tenPages?.completed == true) {
            _showCompletion = true;
          }
        });
      } else {
        _showErrorSnackBar('Failed to load reading data');
      }
    } catch (e) {
      _showErrorSnackBar('Error loading data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitData() async {
    if (user == null || tenPages == null) return;
    if (_bookTitleController.text.isEmpty) {
      _showErrorSnackBar('Please enter a book title');
      return;
    }

    setState(() => _isSaving = true);

    tenPages!.summary = _summaryController.text;
    tenPages!.bookTitle = _bookTitleController.text;
    tenPages!.pagesRead = int.tryParse(_pageCountController.text) ?? 0;
    tenPages!.completed = (tenPages!.pagesRead! >= 10);

    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({'pages': tenPages!.toJson()}),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar(tenPages!.completed ?? false
            ? '🎉 Great job completing your reading goal!'
            : '📚 Progress saved! Keep reading!');

        if ((tenPages!.completed ?? false )&& !_showCompletion) {
          setState(() => _showCompletion = true);
        }
      } else {
        _showErrorSnackBar('Failed to save progress');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving progress');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _updatePageCount(int count) {
    if (count >= 0 && count <= 10) {
      setState(() {
        _currentPage = count;
        _pageCountController.text = count.toString();
      });
      _progressController.animateTo(count / 10);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: SFColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: SFColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SFColors.primary.withOpacity(0.05),
                      Colors.white,
                    ],
                  ),
                ),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverHeader(),
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildProgressCard(),
                          const SizedBox(height: 24),
                          _buildStatsGrid(),
                          const SizedBox(height: 24),
                          _buildBookTitleCard(),
                          const SizedBox(height: 24),
                          _buildReflectionCard(),
                          const SizedBox(height: 24),
                          if (_showCompletion) _buildAchievementsCard(),
                          const SizedBox(height: 24),
                          _buildSubmitButton(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            SFColors.primary.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(SFColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your reading progress...',
              style: GoogleFonts.poppins(
                color: SFColors.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: SFColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: SFColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Animated book icons pattern
              ...List.generate(5, (index) {
                return Positioned(
                  left: math.Random().nextDouble() *
                      MediaQuery.of(context).size.width,
                  top: math.Random().nextDouble() * 200,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseController.value,
                        child: Icon(
                          Icons.auto_stories,
                          color: Colors.white.withOpacity(0.1),
                          size: 40 * (index + 1),
                        ),
                      );
                    },
                  ),
                );
              }),
              // Title and quote
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '75 Hard: Daily Reading',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Day ${today.day} of 75',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reading Progress',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_currentPage/10 Pages',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              // Background track
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Animated progress
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [0, 5, 10].map((count) {
              return ElevatedButton(
                onPressed: () => _updatePageCount(count),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == count
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  foregroundColor: _currentPage == count
                      ? const Color(0xFF4CAF50)
                      : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('$count Pages'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: _readingStats.length,
      itemBuilder: (context, index) {
        final stat = _readingStats[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: stat['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  stat['icon'],
                  color: stat['color'],
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stat['value'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: SFColors.textPrimary,
                ),
              ),
              Text(
                stat['title'],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: SFColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookTitleCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book, color: SFColors.primary),
              const SizedBox(width: 12),
              Text(
                'Book Details',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _bookTitleController,
            decoration: InputDecoration(
              hintText: 'What are you reading?',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.auto_stories),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: SFColors.primary),
              const SizedBox(width: 12),
              Text(
                'Reading Notes',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _summaryController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Share your thoughts and key takeaways...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: SFColors.primary),
              const SizedBox(width: 12),
              Text(
                'Achievements',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: achievement['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: achievement['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        achievement['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SFColors.textPrimary,
                            ),
                          ),
                          Text(
                            achievement['description'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: SFColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (achievement['earned'])
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4CAF50),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: SFColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSaving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline),
                  const SizedBox(width: 8),
                  Text(
                    'Save Progress',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
