import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';

class OrcamentistaDashboard extends StatefulWidget {
  const OrcamentistaDashboard({super.key});

  @override
  State<OrcamentistaDashboard> createState() => _OrcamentistaDashboardState();
}

class _OrcamentistaDashboardState extends State<OrcamentistaDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _currentIndex == 0 ? const _OrcamentistaHome() : Center(child: Text("Tela ${_currentIndex}")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary, // Rosa aqui talvez ou o roxo
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orçamentos'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Clientes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF311B92), // Roxo profundo
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _OrcamentistaHome extends StatelessWidget {
  const _OrcamentistaHome();

  @override
  Widget build(BuildContext context) {
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
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // Placeholder Usuario 2
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("ELAPRO", style: TextStyle(color: Color(0xFF311B92), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          Text("Olá, Amanda", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, size: 28)),
                ],
              ),
              const SizedBox(height: 24),

              // Funil de Vendas Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text("Seu Funil de Vendas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   const Text("Hoje", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              
              // Funil cards row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                   Expanded(child: _FunnelCard(title: "Pendentes", count: "12", icon: Icons.access_time_filled, color: Colors.amber)),
                   SizedBox(width: 12),
                   Expanded(child: _FunnelCard(title: "Aprovados", count: "28", icon: Icons.check_circle, color: Colors.green)),
                   SizedBox(width: 12),
                   Expanded(child: _FunnelCard(title: "Concluídos", count: "15", icon: Icons.task_alt, color: Colors.deepPurple)),
                ],
              ),
              const SizedBox(height: 24),

              // Faturamento Mensal Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Faturamento Mensal", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text("+12%", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("R\$ 12.450", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 24),
                    // Gráfico Placeholder
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         _BarChartColumn(label: "SEM 1", height: 30, color: Colors.grey.shade200),
                         _BarChartColumn(label: "SEM 2", height: 50, color: Colors.grey.shade200),
                         _BarChartColumn(label: "SEM 3", height: 40, color: Colors.grey.shade200),
                         _BarChartColumn(label: "SEM 4", height: 70, color: Colors.green.withOpacity(0.5)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Propostas Recentes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Propostas Recentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text("Ver todas")),
                ],
              ),

              const _ProposalCard(
                title: "Móveis Planejados - Sala",
                client: "Clara Oliveira",
                date: "Ontem",
                value: "R\$ 4.200",
                status: "EM ANÁLISE",
                statusColor: Colors.amber,
                icon: Icons.description,
                iconColor: Colors.amber,
              ),
              const _ProposalCard(
                title: "Reforma Cozinha",
                client: "Beatriz Souza",
                date: "12 Out",
                value: "R\$ 8.950",
                status: "APROVADO",
                statusColor: Colors.green,
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
              ),
              const _ProposalCard(
                title: "Consultoria Decoração",
                client: "Fernanda Lima",
                date: "10 Out",
                value: "R\$ 1.200",
                status: "ENVIADO",
                statusColor: Colors.blue,
                icon: Icons.send,
                iconColor: Colors.blue,
              ),
               
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
    );
  }
}

class _FunnelCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _FunnelCard({required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // In design it's white cards
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BarChartColumn extends StatelessWidget {
  final String label;
  final double height;
  final Color color;

  const _BarChartColumn({required this.label, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 30, height: height, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final String title;
  final String client;
  final String date;
  final String value;
  final String status;
  final Color statusColor;
  final IconData icon;
  final Color iconColor;

  const _ProposalCard({
    required this.title, required this.client, required this.date, required this.value,
    required this.status, required this.statusColor, required this.icon, required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(50)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text("$client • $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
               const SizedBox(height: 4),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                 decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                 child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
               )
            ],
          )
        ],
      ),
    );
  }
}
