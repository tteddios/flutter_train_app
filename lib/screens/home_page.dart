import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../providers/theme_provider.dart';
import 'stations_list_page.dart';
import 'seat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],  // 배경색 수정
      appBar: AppBar(
        title: const Text('기차 예매'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color.fromRGBO(66, 66, 69, 1) : Colors.white,  // 다크모드 컨테이너 색상 수정
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStationSection(
                      context,
                      '출발역',
                      context.watch<BookingProvider>().departureStation ?? '선택',
                      true,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStationSection(
                      context,
                      '도착역',
                      context.watch<BookingProvider>().arrivalStation ?? '선택',
                      false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSeatSelectionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStationSection(
    BuildContext context,
    String label,
    String station,
    bool isDeparture,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StationsListPage(isDeparture: isDeparture),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            station,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatSelectionButton(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final canSelectSeat = provider.departureStation != null && 
                         provider.arrivalStation != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: canSelectSeat 
            ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SeatPage(),
                ),
              )
            : null,
        child: const Text(
          '좌석 선택',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}