import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/injection/injection.dart';
import '../../data/models/agendador_models.dart';

class AddClientModal extends StatefulWidget {
  final Client? existingClient;

  const AddClientModal({super.key, this.existingClient});

  @override
  State<AddClientModal> createState() => _AddClientModalState();
}

class _AddClientModalState extends State<AddClientModal> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedBirthday;

  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    if (widget.existingClient != null) {
      final c = widget.existingClient!;
      _nameController.text = c.name;
      _phoneController.text = _phoneMask.maskText(c.phone);
      _emailController.text = c.email ?? '';
      _addressController.text = c.address ?? '';
      _notesController.text = c.notes ?? '';
      _selectedBirthday = c.birthday;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _importFromContacts() async {
    final permission = await Permission.contacts.request();
    
    if (permission.isGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        // Obter o contato completo para detalhes
        final fullContact = await FlutterContacts.getContact(contact.id);
        if (fullContact != null) {
          setState(() {
            _nameController.text = fullContact.displayName;
            if (fullContact.phones.isNotEmpty) {
              String rawPhone = fullContact.phones.first.number.replaceAll(RegExp(r'\D'), '');
              // Remove o 55 se vier junto para a máscara funcionar no padrão BR local
              if (rawPhone.startsWith('55') && rawPhone.length > 11) {
                rawPhone = rawPhone.substring(2);
              }
              _phoneController.text = _phoneMask.maskText(rawPhone);
            }
          });
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permissão de contatos negada.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle de arrastar
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingClient == null ? "Nova Cliente" : "Editar Cliente", 
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -1)
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
              ],
            ),
            const SizedBox(height: 16),

            // 1. TOPO: IMPORTAR CONTATOS (Ação Primária)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _importFromContacts,
                icon: const Icon(Icons.contact_phone, color: AppColors.primaryPurple),
                label: Text(
                  "Importar dos Contatos",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple.withOpacity(0.12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. CAMPOS ESSENCIAIS
            _buildSectionTitle("DADOS ESSENCIAIS"),
            const SizedBox(height: 12),
            _buildTextField(_nameController, "Nome Completo", Icons.person_outline),
            const SizedBox(height: 12),
            _buildTextField(
              _phoneController, 
              "WhatsApp", 
              Icons.phone_android_outlined, 
              prefix: "+55 ", 
              keyboardType: TextInputType.phone,
              formatters: [_phoneMask],
            ),
            const SizedBox(height: 16),

            // 3. SEÇÃO COLAPSÁVEL (ExpansionTile)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  "Mais opções (Aniversário, E-mail...)",
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                children: [
                  const SizedBox(height: 8),
                  _buildTextField(_emailController, "E-mail", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _buildBirthdayPicker(),
                  const SizedBox(height: 12),
                  _buildTextField(_addressController, "Endereço", Icons.location_on_outlined),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 4. SEÇÃO DE NOTAS (Estilo Post-it)
            _buildSectionTitle("NOTAS E HISTÓRICO"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB), // Cinza ultra-suave moderno
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: "Anote aqui preferências, alergias ou observações importantes...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 32),
            
            // BOTÃO SALVAR
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _saveClient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(
                  widget.existingClient == null ? "Salvar Cliente" : "Atualizar Cadastro", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _saveClient() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      final String cleanPhone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      
      if (widget.existingClient == null) {
        Injection.clientStore.quickCreateClient(
          _nameController.text, 
          cleanPhone,
          address: _addressController.text,
          email: _emailController.text,
          notes: _notesController.text,
          birthday: _selectedBirthday,
        );
      } else {
        final updated = Client(
          id: widget.existingClient!.id,
          name: _nameController.text,
          phone: cleanPhone,
          lastVisit: widget.existingClient!.lastVisit,
          address: _addressController.text,
          email: _emailController.text,
          notes: _notesController.text,
          birthday: _selectedBirthday,
        );
        Injection.clientStore.updateClient(updated);
      }
      Navigator.pop(context);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title, 
      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryPink, letterSpacing: 1.2)
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {String? prefix, TextInputType? keyboardType, List<MaskTextInputFormatter>? formatters}
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryPink, size: 22),
        prefixText: prefix,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBirthdayPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedBirthday ?? DateTime(2000),
          firstDate: DateTime(1930),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _selectedBirthday = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.cake_outlined, color: AppColors.primaryPink, size: 22),
            const SizedBox(width: 12),
            Text(
              _selectedBirthday == null 
                ? "Data de Nascimento" 
                : "Nascimento: ${DateFormat('dd/MM/yyyy').format(_selectedBirthday!)}",
              style: GoogleFonts.inter(
                color: _selectedBirthday == null ? Colors.grey.shade600 : AppColors.textPrimary,
                fontWeight: _selectedBirthday == null ? FontWeight.w400 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
