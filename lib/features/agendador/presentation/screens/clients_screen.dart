import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:elapro/core/injection/injection.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:elapro/features/agendador/data/models/agendador_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:elapro/features/agendador/presentation/widgets/new_appointment_modal.dart';
import 'package:elapro/features/agendador/presentation/widgets/add_client_modal.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      Injection.clientStore.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    Injection.clientStore.setSearchQuery('');
    super.dispose();
  }

  Future<void> _openWhatsApp(String phone, String message) async {
    final url = "https://wa.me/55$phone?text=${Uri.encodeFull(message)}";
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp'), backgroundColor: Colors.red)
      );
    }
  }

  void _showAddClientModal({Client? existingClient}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddClientModal(existingClient: existingClient),
    );
  }

  void _showClientDetails(Client client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              height: 4, width: 40,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(client.name[0], style: GoogleFonts.inter(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(client.name, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1)),
                              Text("Cliente desde ${DateFormat('MM/yyyy').format(client.lastVisit)}", style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showAddClientModal(existingClient: client);
                          }, 
                          icon: Icon(Icons.edit_outlined, color: AppColors.primaryPink)
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    _buildDetailRow(Icons.chat_bubble_outline, "WhatsApp", client.phone, action: () => _openWhatsApp(client.phone, "Olá ${client.name}!")),
                    if (client.email != null && client.email!.isNotEmpty)
                      _buildDetailRow(Icons.email_outlined, "E-mail", client.email!),
                    if (client.birthday != null)
                      _buildDetailRow(Icons.cake_outlined, "Aniversário", DateFormat('dd/MM').format(client.birthday!)),
                    
                    const SizedBox(height: 32),
                    Text("HISTÓRICO & ANAMNESE", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryPink, letterSpacing: 1)),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        (client.notes == null || client.notes!.isEmpty) 
                          ? "Nenhuma observação registrada." 
                          : client.notes!,
                        style: GoogleFonts.inter(fontSize: 15, height: 1.5, color: Colors.blueGrey.shade800, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => NewAppointmentModal(initialClient: client),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                          label: Text("Agendar Novamente", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {VoidCallback? action}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: action,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ],
              ),
            ),
            if (action != null) ...[
              Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryPink.withOpacity(0.5)),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _importContactsBatch() async {
    if (kIsWeb) {
      // Lógica específica para WEB
      setState(() => _isImporting = true);
      try {
        // No Web, usamos openExternalPick que invoca a API nativa de "Contact Picker" do Browser
        // Nota: FlutterContacts para Web usa a API nativa de contatos do navegador (se disponível)
        // Tentamos permitir seleção múltipla via openExternalPick
        final contacts = await FlutterContacts.openExternalPick();
        
        if (contacts == null) {
          setState(() => _isImporting = false);
          return;
        }

        // Se o plugin retornar apenas um contato no Web por limitação de implementação/API,
        // processamos ele. Se retornar lista, iteramos.
        final List<Contact> selected = [contacts];
        
        await _processImportedContacts(selected);
      } catch (e) {
        if (mounted) {
          setState(() => _isImporting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("O seu navegador não suporta a importação de contatos. Tente no celular!"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
      return;
    }

    // Lógica para MOBILE NATIVO (APK/IPA)
    final permission = await Permission.contacts.request();
    if (!permission.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permissão de contatos necessária para importar.")),
        );
      }
      return;
    }

    setState(() => _isImporting = true);

    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      final validContacts = contacts.where((c) => c.phones.isNotEmpty).toList();

      if (!mounted) return;
      setState(() => _isImporting = false);

      if (validContacts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhum contato com telefone encontrado.")),
        );
        return;
      }

      final List<Contact>? selected = await showDialog<List<Contact>>(
        context: context,
        builder: (context) => _ContactSelectionDialog(contacts: validContacts),
      );

      if (selected != null && selected.isNotEmpty) {
        await _processImportedContacts(selected);
      } else {
        setState(() => _isImporting = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ocorreu um erro ao importar contatos."), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _processImportedContacts(List<Contact> selected) async {
    setState(() => _isImporting = true);
    
    int count = 0;
    final store = Injection.clientStore;
    final existingPhones = store.clients.map((c) => c.phone.replaceAll(RegExp(r'\D'), '')).toSet();

    for (final contact in selected) {
      if (contact.phones.isEmpty) continue;
      
      String rawPhone = contact.phones.first.number.replaceAll(RegExp(r'\D'), '');
      
      if (rawPhone.startsWith('55') && rawPhone.length > 11) {
        rawPhone = rawPhone.substring(2);
      }

      if (rawPhone.isNotEmpty && !existingPhones.contains(rawPhone)) {
        store.quickCreateClient(
          contact.displayName,
          rawPhone,
          notes: "Importado da Agenda",
          email: contact.emails.isNotEmpty ? contact.emails.first.address : null,
        );
        count++;
        existingPhones.add(rawPhone);
      }
    }

    if (mounted) {
      setState(() => _isImporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sucesso! $count clientes foram importadas."),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Minhas Clientes", style: GoogleFonts.inter(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isImporting 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryPink))
              : const Icon(Icons.contact_phone_outlined, color: AppColors.primaryPink),
            tooltip: "Importar Contatos",
            onPressed: _isImporting ? null : _importContactsBatch,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Column(
            children: [
              // Barra de Busca
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Observer(
                  builder: (_) => TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar por nome ou celular...",
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              Injection.clientStore.setSearchQuery('');
                            },
                          )
                        : null,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
              // Abas
              Container(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                color: Colors.white,
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPink.withOpacity(0.12), 
                          blurRadius: 10, 
                          offset: const Offset(0, 4)
                        )
                      ],
                    ),
                    labelColor: AppColors.primaryPink,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: -0.5),
                    unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(child: Center(child: Text("Todas"))),
                      Tab(child: Center(child: Text("Sumidas"))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
          final allClients = Injection.clientStore.filteredClients;
          
          // Lógica Sumidas (30 dias + sem futuro)
          final lostClients = allClients.where((c) {
            final isOld = DateTime.now().difference(c.lastVisit).inDays > 30;
            final hasFuture = Injection.scheduleStore.appointments.any((a) => 
               a.client.id == c.id && a.dateTime.isAfter(DateTime.now()) && a.status != 'CANCELADO'
            );
            return isOld && !hasFuture;
          }).toList();
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildClientList(allClients, isRetention: false),
              _buildClientList(lostClients, isRetention: true),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientModal,
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person_add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildClientList(List<Client> clients, {required bool isRetention}) {
    final searchStore = Injection.clientStore;
    final isSearching = searchStore.searchQuery.isNotEmpty;

    if (clients.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSearching 
                      ? Icons.person_search_outlined 
                      : (isRetention ? Icons.sentiment_very_satisfied : Icons.people_outline), 
                  size: 64, 
                  color: Colors.grey.shade400
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isSearching 
                    ? "Nenhuma cliente encontrada" 
                    : (isRetention ? "Nenhum cliente sumida! ✨" : "Nenhum cliente cadastrado."),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isSearching 
                    ? "Não encontramos resultados para \"${searchStore.searchQuery}\". Tente outro nome ou telefone." 
                    : (isRetention ? "Todas as suas clientes estão com a agenda em dia!" : "Comece adicionando sua primeira cliente no botão abaixo."),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              if (isSearching) ...[
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    searchStore.setSearchQuery('');
                  },
                  child: Text("Limpar busca", style: GoogleFonts.inter(color: AppColors.primaryPink, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        final daysSince = DateTime.now().difference(client.lastVisit).inDays;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24), // Extra rounded for Lifestyle vibe
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _showClientDetails(client),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isRetention ? Colors.orange.shade50 : AppColors.primaryPink.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              client.name[0], 
                              style: GoogleFonts.inter(
                                color: isRetention ? Colors.orange : AppColors.primaryPink, 
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              )
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(client.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(
                                isRetention 
                                  ? "Ausente há $daysSince dias" 
                                  : "Última visita: há $daysSince dias",
                                style: GoogleFonts.inter(
                                  color: isRetention ? Colors.redAccent : AppColors.textSecondary, 
                                  fontSize: 12,
                                  fontWeight: isRetention ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isRetention)
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                    if (isRetention) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton.icon(
                          onPressed: () => _openWhatsApp(client.phone, "Olá ${client.name}, tudo bem? 🌸 Notei que faz um tempo desde sua última visita. Gostaria de verificar um horário na agenda para o seu retorno/manutenção?"),
                          icon: const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.green),
                          label: Text("Resgatar via Whats", style: GoogleFonts.inter(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContactSelectionDialog extends StatefulWidget {
  final List<Contact> contacts;

  const _ContactSelectionDialog({required this.contacts});

  @override
  State<_ContactSelectionDialog> createState() => _ContactSelectionDialogState();
}

class _ContactSelectionDialogState extends State<_ContactSelectionDialog> {
  final Set<Contact> _selected = {};
  String _search = '';

  @override
  void initState() {
    super.initState();
    // Inicia com todos selecionados para facilitar a vida da usuária
    _selected.addAll(widget.contacts);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.contacts.where((c) => 
      c.displayName.toLowerCase().contains(_search.toLowerCase())
    ).toList();

    return AlertDialog(
      title: Text("Selecione as Clientes", style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: "Filtrar por nome...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text("${_selected.length} selecionadas", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _selected.clear()),
                    child: const Text("Desmarcar tudo", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final contact = filtered[index];
                  final isSelected = _selected.contains(contact);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) _selected.add(contact);
                        else _selected.remove(contact);
                      });
                    },
                    title: Text(contact.displayName, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(contact.phones.first.number, style: GoogleFonts.inter(fontSize: 12)),
                    activeColor: AppColors.primaryPink,
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: GoogleFonts.inter(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _selected.isEmpty ? null : () => Navigator.pop(context, _selected.toList()),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text("Importar Selecionados", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}
