// lib/features/calendar/presentation/pages/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bloc/calendar_bloc.dart';
import '../widgets/calendar_header.dart';
import '../widgets/day_details.dart';
import '../../../../themes.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late CalendarBloc _calendarBloc;

  @override
  void initState() {
    super.initState();
    _calendarBloc = CalendarBloc();
    _fetchSelectedDayData();
  }

  void _fetchSelectedDayData() {
    _calendarBloc.add(FetchDayData(_selectedDay.toString().substring(0, 10)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SFColors.surface, SFColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CalendarHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCalendar(),
                      const SizedBox(height: 20),
                      _buildDayContent(),
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

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _fetchSelectedDayData();
        },
        headerStyle: HeaderStyle(
          titleTextStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: SFColors.neutral,
          ),
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: SFColors.neutral),
          rightChevronIcon: Icon(Icons.chevron_right, color: SFColors.neutral),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: SFColors.neutral.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: SFColors.tertiary,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: SFColors.surface),
          selectedTextStyle: TextStyle(color: SFColors.surface),
          defaultTextStyle: TextStyle(color: SFColors.textPrimary),
          outsideTextStyle: TextStyle(color: SFColors.textSecondary),
          weekendTextStyle: TextStyle(color: SFColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildDayContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        bloc: _calendarBloc,
        builder: (context, state) {
          if (state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CalendarLoaded) {
            return DayDetails(day: state.day);
          } else if (state is CalendarEmpty) {
            return _buildEmptyDayScreen();
          } else if (state is CalendarError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyDayScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 100,
              color: SFColors.tertiary.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'No objectives logged for this day',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: SFColors.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Start logging your activities!',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: SFColors.tertiary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _calendarBloc.close();
    super.dispose();
  }
  