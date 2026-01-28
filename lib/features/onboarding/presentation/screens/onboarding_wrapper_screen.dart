import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/features/agendador/presentation/screens/agendador_dashboard.dart';

import 'package:google_fonts/google_fonts.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Onboarding Data
  String? _selectedProfile;
  String _businessName = '';
  double _targetSalary = 3000.0;
  double _fixedCosts = 500.0;
  int _hoursPerDay = 8;
  int _daysPerMonth = 22;

  void _nextPage() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    // Foco total no Agendador, Orçamentista desabilitado
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AgendadorDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  _StepProfileSelection(
                    onProfileSelected: (p) => setState(() => _selectedProfile = p),
                    selectedProfile: _selectedProfile,
                    onNext: _nextPage,
                  ),
                  _StepIdentity(
                    onNameChanged: (val) => setState(() => _businessName = val),
                    onNext: _nextPage,
                  ),
                  _StepFinanceCalibration(
                    onSalaryChanged: (val) => _targetSalary = val,
                    onCostsChanged: (val) => _fixedCosts = val,
                    onHoursChanged: (val) => setState(() => _hoursPerDay = val),
                    onDaysChanged: (val) => _daysPerMonth = val,
                    hoursPerDay: _hoursPerDay,
                    onNext: _nextPage,
                  ),
                  _StepResult(
                    targetSalary: _targetSalary,
                    fixedCosts: _fixedCosts,
                    hoursPerDay: _hoursPerDay,
                    daysPerMonth: _daysPerMonth,
                    onFinish: _finishOnboarding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                GestureDetector(
                  onTap: _previousPage,
                  child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textSecondary),
                )
              else
                const SizedBox(width: 20),
              Text(
                'Passo ${_currentStep + 1} de $_totalSteps',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// --- STEP 1: Profile Selection ---
class _StepProfileSelection extends StatelessWidget {
  final Function(String) onProfileSelected;
  final String? selectedProfile;
  final VoidCallback onNext;

  const _StepProfileSelection({
    required this.onProfileSelected,
    required this.selectedProfile,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Como o seu negócio funciona?',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Isto vai nos ajudar a personalizar a sua experiência.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textSecondary,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _SelectionCard(
            title: 'Agendamentos',
            subtitle: 'Trabalho com horários marcados, como manicure, estética, aulas, etc.',
            icon: Icons.calendar_today_rounded,
            isSelected: selectedProfile == 'prestadora',
            onTap: () => onProfileSelected('prestadora'),
          ),
          const SizedBox(height: 16),
          _SelectionCard(
            title: 'Orçamentos (Em breve)',
            subtitle: 'Trabalho com projetos personalizados, como bolos, designs, fotografia, etc.',
            icon: Icons.receipt_long_rounded,
            isSelected: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Este módulo está em manutenção para melhorias!')),
              );
            },
            isEnabled: false,
          ),
          const Spacer(),
          _BottomButton(
            text: 'Próximo',
            isEnabled: selectedProfile != null,
            onPressed: onNext,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// --- STEP 2: Identity ---
class _StepIdentity extends StatelessWidget {
  final Function(String) onNameChanged;
  final VoidCallback onNext;

  const _StepIdentity({required this.onNameChanged, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Qual a cara do seu negócio?',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Logo Upload
          Center(
            child: Stack(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryPink.withOpacity(0.2), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt_outlined, size: 40, color: AppColors.primaryPink.withOpacity(0.5)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Toque para adicionar sua Logo ou Foto',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Pode ser sua melhor foto sorrindo!',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryPink, fontWeight: FontWeight.w500),
          ),
          
          const SizedBox(height: 48),
          
          _AppTextField(
            label: 'Nome do seu Negócio',
            placeholder: 'Ex: Doces da Ju, Studio Bella...',
            onChanged: onNameChanged,
          ),
          
          const SizedBox(height: 40),
          _BottomButton(
            text: 'Ficou lindo, próximo!',
            isEnabled: true, // Optional: add validation
            onPressed: onNext,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// --- STEP 3: Finance Calibration ---
class _StepFinanceCalibration extends StatefulWidget {
  final Function(double) onSalaryChanged;
  final Function(double) onCostsChanged;
  final Function(int) onHoursChanged;
  final Function(int) onDaysChanged;
  final int hoursPerDay;
  final VoidCallback onNext;

  const _StepFinanceCalibration({
    required this.onSalaryChanged,
    required this.onCostsChanged,
    required this.onHoursChanged,
    required this.onDaysChanged,
    required this.hoursPerDay,
    required this.onNext,
  });

  @override
  State<_StepFinanceCalibration> createState() => _StepFinanceCalibrationState();
}

class _StepFinanceCalibrationState extends State<_StepFinanceCalibration> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Vamos falar de metas?',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Para te ajudar a precificar, preciso saber quanto você quer ganhar.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textSecondary,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          _AppTextField(
            label: 'Qual salário você quer tirar por mês livre?',
            placeholder: 'R\$ 3.000,00',
            keyboardType: TextInputType.number,
            onChanged: (val) {
              double? amount = double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), ''));
              if (amount != null) widget.onSalaryChanged(amount);
            },
            hint: 'Seja realista, você pode aumentar depois!',
          ),
          
          const SizedBox(height: 24),
          
          _AppTextField(
            label: 'Quanto você gasta para manter o negócio?',
            placeholder: 'R\$ 500,00',
            keyboardType: TextInputType.number,
            onChanged: (val) {
              double? amount = double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), ''));
              if (amount != null) widget.onCostsChanged(amount);
            },
            hint: 'Soma internet, luz, MEI, aluguel...',
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Horas por dia',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _HourButton(icon: Icons.remove, onTap: () => widget.onHoursChanged(widget.hoursPerDay > 1 ? widget.hoursPerDay - 1 : 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('${widget.hoursPerDay}h', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        _HourButton(icon: Icons.add, onTap: () => widget.onHoursChanged(widget.hoursPerDay < 24 ? widget.hoursPerDay + 1 : 24)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _AppTextField(
                  label: 'Dias/mês',
                  placeholder: '22',
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    int? days = int.tryParse(val);
                    if (days != null) widget.onDaysChanged(days);
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          _BottomButton(
            text: 'Calcular minha hora',
            isEnabled: true,
            onPressed: widget.onNext,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// --- STEP 4: Result ---
class _StepResult extends StatefulWidget {
  final double targetSalary;
  final double fixedCosts;
  final int hoursPerDay;
  final int daysPerMonth;
  final VoidCallback onFinish;

  const _StepResult({
    required this.targetSalary,
    required this.fixedCosts,
    required this.hoursPerDay,
    required this.daysPerMonth,
    required this.onFinish,
  });

  @override
  State<_StepResult> createState() => _StepResultState();
}

class _StepResultState extends State<_StepResult> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Calculando seu valor...',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ],
        ),
      );
    }

    double totalHours = widget.hoursPerDay.toDouble() * widget.daysPerMonth;
    double hourlyRate = (widget.targetSalary + widget.fixedCosts) / totalHours;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.auto_awesome, size: 64, color: AppColors.primaryPink),
          const SizedBox(height: 24),
          Text(
            'Sua hora de trabalho vale...',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
            child: Text(
              'R\$ ${hourlyRate.toStringAsFixed(2)} / hora',
              style: GoogleFonts.inter(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white, // Color doesn't matter much with ShaderMask
                letterSpacing: -2.0,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryPink.withOpacity(0.1)),
            ),
            child: Text(
              'Isso significa que para ganhar R\$ ${widget.targetSalary.toStringAsFixed(2)} pagando suas contas, você não pode cobrar menos que isso pelo seu tempo.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          _BottomButton(
            text: 'Entendi! Começar a usar o ElaPro 🚀',
            isEnabled: true,
            onPressed: widget.onFinish,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// --- SHARED COMPONENTS ---

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  final bool isEnabled;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.6,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColors.primaryPink : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.brandGradient : null,
                  color: isSelected ? null : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: isSelected ? Colors.white : AppColors.primaryPink, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.3)),
                  ],
                ),
              ),
              if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryPink),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _BottomButton({required this.text, required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: isEnabled ? AppColors.brandGradient : null,
        color: isEnabled ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isEnabled ? [
          BoxShadow(color: AppColors.primaryPink.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextInputType? keyboardType;
  final String? hint;
  final Function(String)? onChanged;

  const _AppTextField({
    required this.label,
    required this.placeholder,
    this.keyboardType,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 16),
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primaryPink),
            ),
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(hint!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ],
    );
  }
}

class _HourButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HourButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryPink),
      ),
    );
  }
}
