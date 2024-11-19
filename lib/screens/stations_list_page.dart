import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class StationsListPage extends StatelessWidget {
  final bool isDeparture;

  const StationsListPage({
    Key? key,
    required this.isDeparture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isDeparture ? '출발역' : '도착역'),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          final stations = provider.getAvailableStations(isDeparture);
          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return _buildStationItem(context, stations[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildStationItem(BuildContext context, String station) {
    return InkWell(
      onTap: () {
        final provider = context.read<BookingProvider>();
        if (isDeparture) {
          provider.setDepartureStation(station);
        } else {
          provider.setArrivalStation(station);
        }
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              station,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}