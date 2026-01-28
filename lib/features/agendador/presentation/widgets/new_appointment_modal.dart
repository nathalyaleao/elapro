import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/core/injection/injection.dart';
import 'package:elapro/features/agendador/data/models/agendador_models.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';

class NewAppointmentModal extends StatefulWidget {
  final Client? initialClient;
  const NewAppointmentModal({super.key, this.initialClient});

  @override
  State<NewAppointmentModal> createState() => _NewAppointmentModalState();
}

class _NewAppointmentModalState extends State<NewAppointmentModal> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _birthday;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  Service? _selectedService;
  Client? _selectedClient;
  bool _isNewClient = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialClient != null) {
      _selectedClient = widget.initialClient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agendar Cliente',
                  style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -1),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Selección de Cliente
            if (widget.initialClient != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPink.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.primaryPink),
                    const SizedBox(width: 12),
                    Text(
                      "Agendando para: ${widget.initialClient!.name}",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primaryPink),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              _buildSectionLabel("Quem é a cliente?"),
              const SizedBox(height: 12),
              Observer(
                builder: (_) => DropdownButtonFormField<Client>(
                  isExpanded: true,
                  decoration: _inputDecoration(hint: "Selecione...", icon: Icons.person_outline),
                  value: _selectedClient,
                  items: Injection.clientStore.clients.map<DropdownMenuItem<Client>>((Client c) {
                    return DropdownMenuItem<Client>(
                      value: c,
                      child: Text(
                        c.name, 
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(),
                      ),
                    );
                  }).toList(),
                  onChanged: _isNewClient ? null : (val) => setState(() => _selectedClient = val),
                ),
              ),
              CheckboxListTile(
                title: const Text("Nova Cliente?", style: TextStyle(fontSize: 14)),
                value: _isNewClient,
                onChanged: (val) => setState(() {
                  _isNewClient = val ?? false;
                  if (_isNewClient) _selectedClient = null;
                }),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
            
            if (_isNewClient) ...[
              TextField(
                controller: _nameController,
                decoration: _inputDecoration(label: "Nome da Cliente*"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(label: "WhatsApp*", prefix: "+55 "),
              ),
              const SizedBox(height: 12),
              _buildPicker(
                icon: Icons.cake_outlined,
                label: _birthday == null 
                  ? "Aniversário (Opcional)" 
                  : "Nascimento: ${DateFormat('dd/MM').format(_birthday!)}",
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1930),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _birthday = picked);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: _inputDecoration(hint: "Observações (alergias, etc.)"),
              ),
              const SizedBox(height: 16),
            ],

            _buildSectionLabel("Qual o serviço?"),
            const SizedBox(height: 12),
            Observer(
              builder: (_) => DropdownButtonFormField<Service>(
                isExpanded: true, // Ocupa apenas o espaço disponível
                isDense: true,
                decoration: _inputDecoration(
                  hint: "O que será feito?", 
                  icon: Icons.brush_outlined
                ),
                // Builder para garantir que o item selecionado também tenha ellipsis
                selectedItemBuilder: (BuildContext context) {
                  return Injection.serviceStore.services.map<Widget>((Service s) {
                    return Text(
                      "${s.name} - R\$ ${s.price.toStringAsFixed(2)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.inter(fontSize: 15),
                    );
                  }).toList();
                },
                items: Injection.serviceStore.services.map<DropdownMenuItem<Service>>((Service s) {
                  return DropdownMenuItem<Service>(
                    value: s,
                    child: Text(
                      "${s.name} - R\$ ${s.price.toStringAsFixed(2)}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedService = val),
              ),
            ),
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPicker(
                    icon: Icons.calendar_month,
                    label: DateFormat('dd/MM/yyyy').format(_date),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPicker(
                    icon: Icons.access_time,
                    label: _time.format(context),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _time,
                      );
                      if (picked != null) setState(() => _time = picked);
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Observer(
              builder: (_) {
                final conflictMsg = Injection.scheduleStore.errorMessage;
                return Column(
                  children: [
                    if (conflictMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(conflictMsg, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: _saveAppointment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("Salvar Agendamento", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primaryPurple, letterSpacing: 0.5));
  }

  InputDecoration _inputDecoration({String? hint, String? label, IconData? icon, String? prefix}) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryPink) : null,
      prefixText: prefix,
      filled: true,
      fillColor: AppColors.background.withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
    );
  }

  Widget _buildPicker({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryPink),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label, 
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAppointment() {
    // Validation
    if (_selectedService == null) return;
    if (!_isNewClient && _selectedClient == null) return;
    if (_isNewClient && (_nameController.text.isEmpty || _phoneController.text.isEmpty)) return;

    final appointmentDateTime = DateTime(
      _date.year, _date.month, _date.day, _time.hour, _time.minute
    );

    // Conflict Check
    if (Injection.scheduleStore.hasConflict(appointmentDateTime, _selectedService!.durationMinutes)) {
      return;
    }

    Client client;
    if (_isNewClient) {
      client = Injection.clientStore.quickCreateClient(
        _nameController.text, 
        _phoneController.text,
        birthday: _birthday,
        notes: _notesController.text,
      );
    } else {
      client = _selectedClient!;
    }

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      client: client,
      service: _selectedService!,
      dateTime: appointmentDateTime,
      status: 'PENDENTE',
    );

    Injection.scheduleStore.addAppointment(appointment);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Agendamento realizado com sucesso!"), backgroundColor: Colors.green),
    );
  }
}
