import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
  });
}

class Client {
  final String id;
  final String name;
  final String phone;
  final DateTime lastVisit;
  final String? address;
  final String? cpf;
  final String? email;
  final String? notes;
  final DateTime? birthday;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    required this.lastVisit,
    this.address,
    this.cpf,
    this.email,
    this.notes,
    this.birthday,
  });

  // Regra de negócio: Cliente sumido se visita > 30 dias atrás
  bool get isLost {
    final difference = DateTime.now().difference(lastVisit).inDays;
    return difference > 30;
  }
}

class Appointment {
  final String id;
  final Client client;
  final Service service;
  final DateTime dateTime;
  final String status; // 'PENDENTE', 'CONFIRMADO', 'CONCLUIDO'

  Appointment({
    required this.id,
    required this.client,
    required this.service,
    required this.dateTime,
    required this.status,
  });
}
