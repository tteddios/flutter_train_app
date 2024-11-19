import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import 'stations_list_page.dart';
import 'seat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('기차 예매'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStationSelector(context),
            const SizedBox(height: 20),
            _buildSeatSelectionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStationSelector(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildStationSection(
              context,
              '출발역',
              provider.departureStation ?? '선택',
              true,
            ),
          ),
          Container(
            width: 2,
            height: 50,
            color: Colors.grey[400],
          ),
          Expanded(
            child: _buildStationSection(
              context,
              '도착역',
              provider.arrivalStation ?? '선택',
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationSection(
    BuildContext context,
    String label,
    String station,
    bool isDeparture,
  ) {
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
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            station,
            style: const TextStyle(
              fontSize: 40,
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
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
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}