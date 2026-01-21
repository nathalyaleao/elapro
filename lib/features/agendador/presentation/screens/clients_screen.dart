import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:elapro/features/agendador/data/models/agendador_models.dart';
// import 'package:url_launcher/url_launcher.dart'; // Para integração real com WhatsApp

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Client> _clients = [
    Client(id: '1', name: 'Ana Silva', phone: '11999998888', lastVisit: DateTime.now().subtract(const Duration(days: 5))),
    Client(id: '2', name: 'Beatriz Costa', phone: '11988887777', lastVisit: DateTime.now().subtract(const Duration(days: 45))), // Sumida
    Client(id: '3', name: 'Carla Dias', phone: '11977776666', lastVisit: DateTime.now().subtract(const Duration(days: 10))),
    Client(id: '4', name: 'Daniela Lima', phone: '11966665555', lastVisit: DateTime.now().subtract(const Duration(days: 60))), // Sumida
    Client(id: '5', name: 'Eliane Souza', phone: '11955554444', lastVisit: DateTime.now().subtract(const Duration(days: 2))),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Ação Mock do WhatsApp
  void _openWhatsApp(String phone, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo WhatsApp para $phone...\nMensagem: "$message"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lostClients = _clients.where((c) => c.isLost).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Gestão de Clientes"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: "Todos"),
            Tab(text: "Sumidos 😱"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClientList(_clients, isRetention: false),
          _buildClientList(lostClients, isRetention: true),
        ],
      ),
    );
  }

  Widget _buildClientList(List<Client> clients, {required bool isRetention}) {
    if (clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isRetention ? Icons.sentiment_very_satisfied : Icons.people_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              isRetention ? "Nenhum cliente sumido!" : "Nenhum cliente cadastrado.",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        final daysSince = DateTime.now().difference(client.lastVisit).inDays;

        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isRetention ? Colors.orange.shade100 : AppColors.secondary,
                      child: Text(client.name[0], style: TextStyle(color: isRetention ? Colors.orange : AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            "Última visita: há $daysSince dias",
                            style: TextStyle(color: isRetention ? Colors.red : Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (!isRetention)
                      IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.grey)),
                  ],
                ),
                if (isRetention) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(client.phone, "Olá ${client.name}! Estamos com saudades. Que tal agendar um horário com 10% de desconto?"),
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text("Resgatar Cliente"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
