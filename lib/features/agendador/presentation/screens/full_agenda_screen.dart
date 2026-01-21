import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';

class FullAgendaScreen extends StatefulWidget {
  const FullAgendaScreen({super.key});

  @override
  State<FullAgendaScreen> createState() => _FullAgendaScreenState();
}

class _FullAgendaScreenState extends State<FullAgendaScreen> {
  final List<String> _timeSlots = [
    "08:00", "09:00", "10:00", "11:00", "12:00", 
    "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
  ];

  // Mock appointments mapped by time key
  final Map<String, Map<String, dynamic>> _appointments = {
    "09:00": {"name": "Beatriz Oliveira", "service": "Manicure", "duration": "1h", "color": Colors.orange},
    "10:00": {"name": "Carla Mendes", "service": "Sobrancelha", "duration": "30m", "color": Colors.green},
    "14:00": {"name": "Maria Fernanda", "service": "Limpeza Pele", "duration": "1h30", "color": Colors.green},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Agenda Completa"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.date_range)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.print)),
        ],
      ),
      body: Column(
        children: [
          // Date Selector Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: (){}),
                const Text("Segunda, 14 Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: (){}),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final time = _timeSlots[index];
                final appointment = _appointments[time];
                final isBusy = appointment != null;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Time Column
                      SizedBox(
                        width: 50,
                        child: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      
                      // Slot
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isBusy ? appointment['color'].withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: isBusy 
                              ? Border(
                                  left: BorderSide(color: appointment['color'], width: 4),
                                  top: BorderSide(color: Colors.grey.shade200),
                                  right: BorderSide(color: Colors.grey.shade200),
                                  bottom: BorderSide(color: Colors.grey.shade200),
                                ) 
                              : Border.all(color: Colors.grey.shade200),
                          ),
                          child: isBusy 
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appointment['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(appointment['service'], style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: Colors.grey[700]),
                                      const SizedBox(width: 4),
                                      Text(appointment['duration'], style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                    ],
                                  )
                                ],
                              )
                            : const Text("Livre", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
