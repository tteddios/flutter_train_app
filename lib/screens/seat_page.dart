import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class SeatPage extends StatelessWidget {
  const SeatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          '좌석 선택',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 17,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildStationInfo(context),
          _buildLegend(context),
          _buildSeatHeader(context),
          Expanded(
            child: _buildSeatGrid(context),
          ),
          _buildBookingButton(context),
        ],
      ),
    );
  }

  Widget _buildStationInfo(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            provider.departureStation ?? '',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(width: 30),
          Icon(
            Icons.arrow_forward_rounded,
            size: 30,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 30),
          Text(
            provider.arrivalStation ?? '',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(
            context,
            Colors.purple,
            '선택됨',
          ),
          const SizedBox(width: 20),
          _buildLegendItem(
            context,
            isDarkMode ? const Color.fromARGB(255, 101, 101, 108) : Colors.grey[300]!,
            '선택안됨',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 50),
          ...['A', 'B'].map((label) => Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          )),
          Container(width: 50),
          ...['C', 'D'].map((label) => Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          )),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildSeatGrid(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 10,
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50),
              ...['A', 'B'].map((col) => _buildSeat(
                context,
                '${rowIndex + 1}-$col',
              )),
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  '${rowIndex + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.black,
                  ),
                ),
              ),
              ...['C', 'D'].map((col) => _buildSeat(
                context,
                '${rowIndex + 1}-$col',
              )),
              const SizedBox(width: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeat(BuildContext context, String seatNumber) {
    final provider = context.watch<BookingProvider>();
    final isSelected = provider.selectedSeats.contains(seatNumber);
    final isReserved = provider.isSeatReserved(seatNumber);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isReserved ? null : () => provider.toggleSeat(seatNumber),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isReserved 
              ? isDarkMode ? const Color.fromARGB(255, 67, 67, 69) : Colors.grey[400]
              : isSelected 
                  ? Colors.purple 
                  : isDarkMode ? const Color.fromARGB(255, 101, 101, 108) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: isReserved
            ? Center(
                child: Text(
                  '예약됨',
                  style: TextStyle(
                    color: isDarkMode ? const Color.fromARGB(255, 154, 149, 149) : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: provider.selectedSeats.isEmpty 
              ? null 
              : () => _showBookingDialog(context),
          child: const Text(
            '예매 하기',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    final selectedSeats = context.read<BookingProvider>().selectedSeats.join(', ');
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('예매 하시겠습니까?'),
        content: Text('좌석: $selectedSeats'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('취소'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('확인'),
            onPressed: () {
              final provider = context.read<BookingProvider>();
              provider.confirmReservation();
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
    );
  }
}