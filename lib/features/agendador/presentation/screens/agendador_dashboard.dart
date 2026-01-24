import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/features/agendador/presentation/screens/services_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/clients_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/full_agenda_screen.dart';
import 'package:elapro/features/finance/data/finance_repository.dart';

import 'package:elapro/features/finance/presentation/screens/finance_dashboard.dart';

import 'package:elapro/features/agendador/presentation/screens/settings_screen.dart';

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
          onPressed: () {},
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

  void _chargeClient(String clientName, String serviceName) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cobrança para $clientName via WhatsApp... e +R\$50.00 no Caixa! 💰'), backgroundColor: Colors.green)
    );

    FinanceRepository().addTransaction(Transaction(
      id: DateTime.now().toString(),
      title: "Pgto: $clientName",
      value: 50.0, // Mock Value
      type: TransactionType.income,
      date: DateTime.now(),
      category: 'Serviço',
    ));
  }
  
  void _confirmClient(String clientName) {
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Confirmando com $clientName via WhatsApp...'), backgroundColor: Colors.green)
    );
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
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=Juliana'),
                          radius: 22,
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

              if (dailyAppointments.isNotEmpty) ...[
                ...dailyAppointments.map((appt) {
                  return _AppointmentCard(
                    time: appt['time'],
                    name: appt['name'],
                    service: appt['service'],
                    status: appt['status'],
                    statusColor: appt['color'],
                    onConfirm: appt['status'] == 'PENDENTE' ? () => _confirmClient(appt['name']) : null,
                    onCharge: appt['status'] == 'CONFIRMADO' ? () => _chargeClient(appt['name'], appt['service']) : null,
                  );
                }).toList()
              ] else ...[
                 Container(
                   padding: const EdgeInsets.symmetric(vertical: 40),
                   width: double.infinity,
                   decoration: BoxDecoration(
                     color: Colors.grey.shade50,
                     borderRadius: BorderRadius.circular(16),
                     border: Border.all(color: Colors.grey.shade200)
                   ),
                   child: Column(
                     children: [
                       Icon(Icons.event_busy, size: 48, color: Colors.grey.shade300),
                       const SizedBox(height: 12),
                       Text("Agenda livre para este dia!", style: TextStyle(color: Colors.grey.shade500)),
                     ],
                   ),
                 )
              ],

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
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
        width: 60,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.brandGradient : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [
             BoxShadow(color: AppColors.primaryPink.withOpacity(0.3), blurRadius: 8, offset: const Offset(0,4))
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(weekDay, style: TextStyle(color: isActive ? Colors.white70 : AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Text(day, style: TextStyle(color: isActive ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            if (isActive) ...[
              const SizedBox(height: 4),
              const CircleAvatar(backgroundColor: Colors.white, radius: 2),
            ]
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
                    icon: const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    label: const Text("Confirmar", style: TextStyle(color: Colors.green)),
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
