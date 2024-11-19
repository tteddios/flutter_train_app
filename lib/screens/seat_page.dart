import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class SeatPage extends StatelessWidget {
  const SeatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('좌석 선택'),
      ),
      body: Column(
        children: [
          _buildStationInfo(context),
          _buildLegend(),
          _buildSeatHeader(),
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
  return Padding(
    padding: const EdgeInsets.all(20.0),
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
        const SizedBox(width: 30),  // 간격 늘림
        Container(
          padding: const EdgeInsets.all(8),  // 아이콘 주변 패딩 추가
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            size: 30,
          ),
        ),
        const SizedBox(width: 30),  // 간격 늘림
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

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.purple, '선택됨'),
        const SizedBox(width: 20),
        _buildLegendItem(Colors.grey[300]!, '선택안됨'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
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
        Text(label),
      ],
    );
  }

  Widget _buildSeatHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              style: const TextStyle(fontSize: 18),
            ),
          )),
          Container(width: 50),
          ...['C', 'D'].map((label) => Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
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
      itemCount: 20,
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
                  style: const TextStyle(fontSize: 18),
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

    return GestureDetector(
      onTap: () => provider.toggleSeat(seatNumber),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: provider.selectedSeats.isEmpty 
              ? null 
              : () => _showBookingDialog(context),
          child: const Text(
            '예매 하기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

void _showBookingDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('예매 하시겠습니까?'),
      content: Text(
        '좌석: ${context.read<BookingProvider>().selectedSeats.join(", ")}'
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('취소', style: TextStyle(color: Colors.red)),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: const Text('확인', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            // 예매 완료 후 상태 초기화
            final provider = context.read<BookingProvider>();
            provider.reset();  // 모든 선택 상태 초기화
            
            // 모든 화면을 팝하고 홈으로 이동
            Navigator.popUntil(
              context,
              (route) => route.isFirst,  // 첫 번째 라우트(홈화면)까지 pop
            );
          },
        ),
      ],
    ),
  );
}
}