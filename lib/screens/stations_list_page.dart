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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(isDeparture ? '출발역' : '도착역'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          final stations = provider.getAvailableStations(isDeparture);
          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (isDeparture) {
                    provider.setDepartureStation(stations[index]);
                  } else {
                    provider.setArrivalStation(stations[index]);
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        stations[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}