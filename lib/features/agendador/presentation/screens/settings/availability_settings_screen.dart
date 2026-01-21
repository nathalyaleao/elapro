import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';

class AvailabilitySettingsScreen extends StatefulWidget {
  const AvailabilitySettingsScreen({super.key});

  @override
  State<AvailabilitySettingsScreen> createState() => _AvailabilitySettingsScreenState();
}

class _AvailabilitySettingsScreenState extends State<AvailabilitySettingsScreen> {
  final Map<String, bool> _workingDays = {
    "Seg": true, "Ter": true, "Qua": true, "Qui": true, "Sex": true, "Sáb": true, "Dom": false
  };

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 19, minute: 0);
  bool _hasLunchBreak = true;
  TimeOfDay _lunchStart = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _lunchEnd = const TimeOfDay(hour: 13, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Minha Disponibilidade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dias de Trabalho", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _workingDays.keys.map((day) {
                final isSelected = _workingDays[day]!;
                return GestureDetector(
                  onTap: () => setState(() => _workingDays[day] = !isSelected),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text("Horário de Funcionamento", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildTimePicker("Início", _startTime, (t) => setState(() => _startTime = t)),
            const SizedBox(height: 12),
            _buildTimePicker("Fim", _endTime, (t) => setState(() => _endTime = t)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pausa para Almoço", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Switch(
                  value: _hasLunchBreak,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _hasLunchBreak = val),
                ),
              ],
            ),
            if (_hasLunchBreak) ...[
              const SizedBox(height: 16),
              _buildTimePicker("Início Almoço", _lunchStart, (t) => setState(() => _lunchStart = t)),
              const SizedBox(height: 12),
              _buildTimePicker("Fim Almoço", _lunchEnd, (t) => setState(() => _lunchEnd = t)),
            ],
            const SizedBox(height: 48),
            CustomButton(text: "Salvar Horários", onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) OnChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          TextButton(
            onPressed: () async {
              final picked = await showTimePicker(context: context, initialTime: time);
              if (picked != null) OnChanged(picked);
            },
            child: Text(
              time.format(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          )
        ],
      ),
    );
  }
}
