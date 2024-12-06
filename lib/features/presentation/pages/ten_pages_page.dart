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

        if ((tenPages!.completed ?? false) && !_showCompletion) {
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SFColors.primary.withOpacity(0.1),
              SFColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildReadingProgress(),
                      const SizedBox(height: 24),
                      _buildCurrentBook(),
                      const SizedBox(height: 24),
                      _buildNotes(),
                      if (_showCompletion) ...[
                        const SizedBox(height: 24),
                        _buildAchievements(),
                      ],
                      const SizedBox(height: 24),
                      _buildSaveButton(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: SFColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: SFColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Reading',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Day ${today.difference(DateTime(2024, 1, 1)).inDays + 1} of 75',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _buildProgressRing(),
            ],
          ),
          const SizedBox(height: 20),
          _buildReadingStats(),
        ],
      ),
    );
  }

  Widget _buildProgressRing() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '${(_currentPage * 10).toInt()}%',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildReadingStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Pages', '$_currentPage/10', Icons.menu_book),
        _buildStatItem('Streak', '7 days', Icons.local_fire_department),
        _buildStatItem('Books', '3', Icons.library_books),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadingProgress() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: SFColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.primary.withOpacity(0.2),
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
                'Today\'s Progress',
                style: GoogleFonts.inter(
                  fontSize: 18,
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
                  '$_currentPage/10',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _currentPage / 10,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [0, 5, 10].map((pages) {
              return ElevatedButton(
                onPressed: () => _updatePageCount(pages),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == pages
                      ? Colors.white
                      : Colors.white.withOpacity(0.2),
                  foregroundColor:
                      _currentPage == pages ? SFColors.primary : Colors.white,
                ),
                child: Text('$pages pages'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBook() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Book',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _bookTitleController,
            decoration: InputDecoration(
              hintText: 'What are you reading?',
              prefixIcon: Icon(Icons.auto_stories, color: SFColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: SFColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotes() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reading Notes',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _summaryController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Share your thoughts and key takeaways...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: SFColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: SFColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Reading Milestones',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      achievement['icon'],
                      color: Colors.white,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            achievement['description'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (achievement['earned'])
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
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

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: SFColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Save Progress',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
