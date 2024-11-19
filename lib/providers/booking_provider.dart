import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  String? _departureStation;
  String? _arrivalStation;
  final Set<String> _selectedSeats = {};

  final List<String> stations = [
    '수서', '동탄', '평택지제', '천안아산', '오송',
    '대전', '김천구미', '동대구', '경주', '울산', '부산'
  ];

  String? get departureStation => _departureStation;
  String? get arrivalStation => _arrivalStation;
  Set<String> get selectedSeats => _selectedSeats;

  void setDepartureStation(String station) {
    _departureStation = station;
    notifyListeners();
  }

  void setArrivalStation(String station) {
    _arrivalStation = station;
    notifyListeners();
  }

  void toggleSeat(String seatNumber) {
    if (_selectedSeats.contains(seatNumber)) {
      _selectedSeats.remove(seatNumber);
    } else {
      _selectedSeats.add(seatNumber);
    }
    notifyListeners();
  }

  List<String> getAvailableStations(bool isDeparture) {
    if (isDeparture && _arrivalStation != null) {
      return stations.where((station) => station != _arrivalStation).toList();
    } else if (!isDeparture && _departureStation != null) {
      return stations.where((station) => station != _departureStation).toList();
    }
    return stations;
  }

  void reset() {
    _departureStation = null;
    _arrivalStation = null;
    _selectedSeats.clear();
    notifyListeners();
  }
}