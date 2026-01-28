import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:elapro/features/agendador/presentation/screens/services_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/clients_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/full_agenda_screen.dart';
import 'package:elapro/features/finance/data/finance_repository.dart';

import 'package:elapro/features/finance/presentation/screens/finance_dashboard.dart';

import 'package:elapro/features/agendador/presentation/screens/settings_screen.dart';
import 'package:elapro/features/agendador/presentation/widgets/new_appointment_modal.dart';
import 'package:elapro/core/injection/injection.dart';
import 'package:elapro/features/agendador/data/models/agendador_models.dart';

class AgendadorDashboard extends StatefulWidget {
  const AgendadorDashboard({super.key});

  @override
  State<AgendadorDashboard> createState() => _AgendadorDashboardState();
}

class _AgendadorDashboardState extends State<AgendadorDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _AgendadorHome(),     // Painel
    const FullAgendaScreen(),   // Agenda Completa
    const ClientsScreen(),      // Clientes
    const FinanceDashboard(),   // Finanças
    const SettingsScreen(),     // Configurações (Substituto de Perfil)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primaryPink, 
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Clientes'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Finanças'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
      floatingActionButton: _currentIndex == 0 ? Container(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const NewAppointmentModal(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ) : null,
    );
  }
}

class _AgendadorHome extends StatefulWidget {
  const _AgendadorHome();

  @override
  State<_AgendadorHome> createState() => _AgendadorHomeState();
}

class _AgendadorHomeState extends State<_AgendadorHome> {
  int _selectedDayIndex = 0; // Starts at "Hoje" (14/Seg)

  // Mock Data Structure
  final Map<int, List<Map<String, dynamic>>> _appointmentsByDay = {
    0: [ // Hoje (14)
       {"time": "09:00", "name": "Beatriz Oliveira", "service": "Manicure + Pedicure", "status": "PENDENTE", "color": Colors.orange},
       {"time": "14:00", "name": "Maria Fernanda", "service": "Limpeza de Pele", "status": "CONFIRMADO", "color": Colors.green},
    ],
    1: [], // Amanhã (15) - Empty
    2: [ // 16/Qua
       {"time": "10:30", "name": "Carla Mendes", "service": "Design de Sobrancelha", "status": "CONFIRMADO", "color": Colors.green},
       {"time": "16:30", "name": "Patrícia Santos", "service": "Extensão de Cílios", "status": "AGUARDANDO", "color": Colors.grey},
    ],
    3: [ // 17/Qui
       {"time": "08:00", "name": "Juliana Silva", "service": "Manicure", "status": "CONFIRMADO", "color": Colors.green},
    ]
  };

  @override
  void initState() {
    super.initState();
    _seedMockData();
  }

  void _seedMockData() {
    if (Injection.serviceStore.services.isEmpty) {
      Injection.serviceStore.addService(name: "Manicure", price: 40, durationMinutes: 60);
      Injection.serviceStore.addService(name: "Limpeza de Pele", price: 120, durationMinutes: 90);
      Injection.serviceStore.addService(name: "Design de Sobrancelha", price: 45, durationMinutes: 30);
    }
    
    if (Injection.clientStore.clients.isEmpty) {
      Injection.clientStore.quickCreateClient("Ana Silva", "11988887777");
      Injection.clientStore.quickCreateClient("Beatriz Oliveira", "11977776666");
      Injection.clientStore.quickCreateClient("Carla Mendes", "11966665555");
      Injection.clientStore.quickCreateTestClient(
        "Julia Sumida", 
        "11999999999", 
        lastVisit: DateTime.now().subtract(const Duration(days: 45))
      );
    }

    if (Injection.scheduleStore.appointments.isEmpty && Injection.clientStore.clients.isNotEmpty) {
      final client = Injection.clientStore.clients.first;
      final service = Injection.serviceStore.services.first;
      
      // Agendamento para hoje
      Injection.scheduleStore.addAppointment(Appointment(
        id: "seed-1",
        client: client,
        service: service,
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        status: "CONFIRMADO",
      ));

      // Outro agendamento
      if (Injection.serviceStore.services.length > 1) {
        Injection.scheduleStore.addAppointment(Appointment(
          id: "seed-2",
          client: Injection.clientStore.clients[1],
          service: Injection.serviceStore.services[1],
          dateTime: DateTime.now().add(const Duration(hours: 5)),
          status: "PENDENTE",
        ));
      }
    }

    if (Injection.financeStore.totalGrossRevenue == 0) {
      Injection.financeStore.recordPayment(150.0, "Pix");
      Injection.financeStore.recordPayment(45.0, "Débito");
      Injection.financeStore.recordPayment(200.0, "Crédito");
    }
  }

  void _chargeClient(String clientName, String serviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registrar Pagamento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cliente: $clientName"),
            Text("Serviço: $serviceName"),
            const SizedBox(height: 16),
            const Text("Escolha a forma de pagamento:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPayMethod(context, "Pix", 50.0), // Mock value 50
            _buildPayMethod(context, "Débito", 50.0),
            _buildPayMethod(context, "Crédito", 50.0),
          ],
        ),
      ),
    );
  }

  Widget _buildPayMethod(BuildContext context, String method, double amount) {
    return ListTile(
      title: Text(method),
      onTap: () {
        Injection.financeStore.recordPayment(amount, method);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pagamento de R\$ ${amount.toStringAsFixed(2)} ($method) registrado!'),
            backgroundColor: Colors.green,
          )
        );
      },
      trailing: const Icon(Icons.chevron_right),
    );
  }
  
  Future<void> _confirmClient(String clientName, String serviceName, String phone, String time) async {
      final message = "Olá $clientName, confirmando seu horário de $serviceName para hoje às $time. Posso confirmar?";
      final url = "https://wa.me/55$phone?text=${Uri.encodeFull(message)}";
      
      if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp'), backgroundColor: Colors.red)
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    final dailyAppointments = _appointmentsByDay[_selectedDayIndex] ?? [];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          gradient: AppColors.brandGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                    backgroundColor: AppColors.primaryPink,
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                    radius: 24,
                  ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Juliana Costa", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, size: 28)),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar Strip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Outubro 2024", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("Hoje", style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CalendarDate(day: "14", weekDay: "Seg", isActive: _selectedDayIndex == 0, onTap: () => setState(() => _selectedDayIndex = 0)),
                    _CalendarDate(day: "15", weekDay: "Ter", isActive: _selectedDayIndex == 1, onTap: () => setState(() => _selectedDayIndex = 1)),
                    _CalendarDate(day: "16", weekDay: "Qua", isActive: _selectedDayIndex == 2, onTap: () => setState(() => _selectedDayIndex = 2)),
                    _CalendarDate(day: "17", weekDay: "Qui", isActive: _selectedDayIndex == 3, onTap: () => setState(() => _selectedDayIndex = 3)),
                    _CalendarDate(day: "18", weekDay: "Sex", isActive: _selectedDayIndex == 4, onTap: () => setState(() => _selectedDayIndex = 4)),
                    _CalendarDate(day: "19", weekDay: "Sáb", isActive: _selectedDayIndex == 5, onTap: () => setState(() => _selectedDayIndex = 5)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row (Static for demo)
              Row(
                children: [
                    Expanded(child: _StatCard(icon: Icons.attach_money, title: "GANHOS", value: "R\$ 840,00", subtitle: "+15% vs ontem", subtitleColor: Colors.green, iconBgColor: AppColors.primaryPink.withOpacity(0.1), iconColor: AppColors.primaryPink, cardColor: Colors.white)),
                    const SizedBox(width: 16),
                    Expanded(child: _StatCard(icon: Icons.calendar_today, title: "AGENDA", value: "12", subtitle: "5 concluídos", subtitleColor: AppColors.primaryPurple, iconBgColor: AppColors.primaryPurple.withOpacity(0.1), iconColor: AppColors.primaryPurple, cardColor: Colors.white)),
                ],
              ),
              const SizedBox(height: 32),
              
              const Text("Próximos Atendimentos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Observer(
                builder: (_) {
                  final appointments = Injection.scheduleStore.appointments;
                  if (appointments.isEmpty) {
                    return Container(
                       padding: const EdgeInsets.symmetric(vertical: 48),
                       width: double.infinity,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(32),
                         border: Border.all(color: AppColors.background)
                       ),
                       child: Column(
                         children: [
                           Icon(Icons.event_seat_outlined, size: 48, color: Colors.grey.shade300),
                           const SizedBox(height: 16),
                           Text("Nenhum agendamento para hoje", style: GoogleFonts.inter(color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                         ],
                       ),
                     );
                  }
                  
                  return Column(
                    children: appointments.map((appt) {
                      return _AppointmentCard(
                        time: "${appt.dateTime.hour}:${appt.dateTime.minute.toString().padLeft(2, '0')}",
                        name: appt.client.name,
                        service: appt.service.name,
                        status: appt.status,
                        statusColor: appt.status == 'CONFIRMADO' ? Colors.green : Colors.orange,
                        onConfirm: appt.status == 'PENDENTE' ? () => _confirmClient(appt.client.name, appt.service.name, appt.client.phone, "${appt.dateTime.hour}:00") : null,
                        onCharge: appt.status == 'CONFIRMADO' ? () => _chargeClient(appt.client.name, appt.service.name) : null,
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800));
  }
}

class _CalendarDate extends StatelessWidget {
  final String day;
  final String weekDay;
  final bool isActive;
  final VoidCallback onTap;

  const _CalendarDate({required this.day, required this.weekDay, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Tornando clicável
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.brandGradient : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive ? [
             BoxShadow(color: AppColors.primaryPink.withOpacity(0.3), blurRadius: 10, offset: const Offset(0,6))
          ] : [
             BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(weekDay, style: GoogleFonts.inter(color: isActive ? Colors.white70 : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(day, style: GoogleFonts.inter(color: isActive ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color cardColor;

  const _StatCard({
    required this.icon, required this.title, required this.value, required this.subtitle,
    required this.subtitleColor, required this.iconBgColor, required this.iconColor, required this.cardColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 20)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String time;
  final String name;
  final String service;
  final String status;
  final Color statusColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCharge;

  const _AppointmentCard({
    required this.time, required this.name, required this.service, 
    required this.status, required this.statusColor,
    this.onConfirm, this.onCharge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0,2))
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                        ),
                      ],
                    ),
                    Text(service, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          if (onConfirm != null || onCharge != null) ...[
            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (onConfirm != null)
                  TextButton.icon(
                    onPressed: onConfirm, 
                    icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.green),
                    label: const Text("Confirmar no Zap", style: TextStyle(color: Colors.green)),
                  ),
                if (onCharge != null)
                  TextButton.icon(
                    onPressed: onCharge, 
                    icon: const Icon(Icons.attach_money, size: 16, color: Colors.orange),
                    label: const Text("Cobrar", style: TextStyle(color: Colors.orange)),
                  ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
