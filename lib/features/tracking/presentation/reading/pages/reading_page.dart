// lib/features/tracking/presentation/reading/pages/reading_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import '../bloc/reading_bloc.dart';
import '../widgets/book_progress.dart';
import '../widgets/reading_summary.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({Key? key}) : super(key: key);

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage>
    with SingleTickerProviderStateMixin {
  late ReadingBloc _readingBloc;
  late AnimationController _animationController;
  final DateTime today = DateTime.now();
  String _bookTitle = '';
  String _summary = '';
  int _pagesRead = 0;

  @override
  void initState() {
    super.initState();
    _readingBloc = ReadingBloc();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _fetchReadingData();
  }

  @override
  void dispose() {
    _readingBloc.close();
    _animationController.dispose();
    super.dispose();
  }

  void _fetchReadingData() {
    _readingBloc.add(FetchReadingData(today.toString().substring(0, 10)));
  }

  void _updateProgress() {
    _readingBloc.add(UpdateReadingProgress(
      date: today.toString().substring(0, 10),
      bookTitle: _bookTitle,
      summary: _summary,
      pagesRead: _pagesRead,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SFColors.surface, SFColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocConsumer<ReadingBloc, ReadingState>(
                  bloc: _readingBloc,
                  listener: (context, state) {
                    if (state is ReadingSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Reading progress updated successfully!'),
                          backgroundColor: SFColors.primary,
                        ),
                      );
                    } else if (state is ReadingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: const Color(0xFFB23B3B),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ReadingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ReadingLoaded) {
                      _bookTitle = state.reading.bookTitle ?? '';
                      _summary = state.reading.summary ?? '';
                      _pagesRead = state.reading.pagesRead ?? 0;
                      return _buildContent();
                    } else if (state is ReadingEmpty) {
                      return _buildContent();
                    } else if (state is ReadingError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
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
          colors: [SFColors.neutral, SFColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading Tracker',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: SFColors.surface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Daily Reading Goal',
                style: GoogleFonts.inter(
                  color: SFColors.surface.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SFColors.surface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.menu_book,
              color: SFColors.surface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          BookProgress(
            pagesRead: _pagesRead,
            onAddPage: () {
              if (_pagesRead < 10) {
                setState(() => _pagesRead++);
                _updateProgress();
              }
            },
            onRemovePage: () {
              if (_pagesRead > 0) {
                setState(() => _pagesRead--);
                _updateProgress();
              }
            },
          ),
          const SizedBox(height: 20),
          ReadingSummary(
            bookTitle: _bookTitle,
            summary: _summary,
            onTitleChanged: (value) {
              setState(() => _bookTitle = value);
              _updateProgress();
            },
            onSummaryChanged: (value) {
              setState(() => _summary = value);
              _updateProgress();
            },
          ),
          if (_pagesRead >= 10) ...[
            const SizedBox(height: 20),
            _buildCompletionCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SFColors.primary, SFColors.secondary],
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
          const Icon(
            Icons.emoji_events,
            color: SFColors.surface,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Reading Goal Achieved! 🎉',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Great job completing your daily reading goal. Keep that mental growth going!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: SFColors.surface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
