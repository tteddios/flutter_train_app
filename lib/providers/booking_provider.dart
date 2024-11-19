import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  String? _departureStation;
  String? _arrivalStation;
  final Set<String> _selectedSeats = {};
  final Map<String, Set<String>> _reservedSeats = {};

  final List<String> stations = [
    '수서', '동탄', '평택지제', '천안아산', '오송',
    '대전', '김천구미', '동대구', '경주', '울산', '부산'
  ];

  String? get departureStation => _departureStation;
  String? get arrivalStation => _arrivalStation;
  Set<String> get selectedSeats => _selectedSeats;

  String _getRouteKey(String departure, String arrival) {
    return '$departure-$arrival';
  }

  void setDepartureStation(String station) {
    _departureStation = station;
    _selectedSeats.clear();
    notifyListeners();
  }

  void setArrivalStation(String station) {
    _arrivalStation = station;
    _selectedSeats.clear();
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

  bool isSeatReserved(String seatNumber) {
    if (_departureStation == null || _arrivalStation == null) return false;
    final routeKey = _getRouteKey(_departureStation!, _arrivalStation!);
    return _reservedSeats[routeKey]?.contains(seatNumber) ?? false;
  }

  void toggleSeat(String seatNumber) {
    if (_departureStation == null || _arrivalStation == null) return;
    
    final routeKey = _getRouteKey(_departureStation!, _arrivalStation!);
    if (_reservedSeats[routeKey]?.contains(seatNumber) ?? false) return;

    if (_selectedSeats.contains(seatNumber)) {
      _selectedSeats.remove(seatNumber);
    } else {
      _selectedSeats.add(seatNumber);
    }
    notifyListeners();
  }

  void confirmReservation() {
    if (_departureStation == null || _arrivalStation == null) return;
    
    final routeKey = _getRouteKey(_departureStation!, _arrivalStation!);
    _reservedSeats[routeKey] ??= {};
    _reservedSeats[routeKey]!.addAll(_selectedSeats);
    _selectedSeats.clear();
    _departureStation = null;
    _arrivalStation = null;
    notifyListeners();
  }
}