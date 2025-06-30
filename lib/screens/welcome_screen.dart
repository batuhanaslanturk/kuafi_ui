import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(###)-###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {}); // Tab değişince formu güncelle
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası giriniz';
    } else if (!_phoneMaskFormatter.isFill()) {
      return 'Geçerli bir telefon numarası giriniz (5xx)-xxx-xx-xx';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.card,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.card.withOpacity(0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      'Kuafi',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 48,
                            color: AppColors.accent,
                            fontFamily: 'PlayfairDisplay',
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Modern Kuaför Deneyimi',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.accent,
                      labelColor: AppColors.accent,
                      unselectedLabelColor: AppColors.textSecondary,
                      tabs: const [
                        Tab(text: 'Kayıt Ol'),
                        Tab(text: 'Giriş Yap'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Builder(
                      builder: (context) {
                        final isRegister = _tabController.index == 0;
                        return Column(
                          children: [
                            if (isRegister) ...[
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Ad Soyad',
                                  labelStyle: TextStyle(color: AppColors.textSecondary),
                                  filled: true,
                                  fillColor: AppColors.card.withOpacity(0.7),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(color: AppColors.textPrimary),
                                validator: (value) {
                                  if (!isRegister) return null;
                                  return value == null || value.isEmpty ? 'Ad soyad giriniz' : null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [_phoneMaskFormatter],
                              decoration: InputDecoration(
                                labelText: 'Telefon Numarası',
                                hintText: '(5xx)-xxx-xx-xx',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                                filled: true,
                                fillColor: AppColors.card.withOpacity(0.7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                counterText: '',
                              ),
                              style: TextStyle(color: AppColors.textPrimary),
                              validator: _validatePhone,
                              maxLength: 15,
                            ),
                            const SizedBox(height: 28),
                            CustomButton(
                              text: isRegister ? 'Kayıt Ol' : 'Giriş Yap',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(isRegister ? 'Bilgilerinizi Onaylayın' : 'Giriş Bilgileri'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (isRegister) ...[
                                            Text('Ad Soyad'),
                                            Text(_nameController.text, style: TextStyle(color: AppColors.accent)),
                                            const SizedBox(height: 8),
                                          ],
                                          Text('Telefon'),
                                          Text(_phoneController.text, style: TextStyle(color: AppColors.accent)),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Vazgeç'),
                                        ),
                                        CustomButton(
                                          text: isRegister ? 'Onaylıyorum' : 'Devam',
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            // Onaylandıktan/giriş yapıldıktan sonra yapılacak işlemler
                                          },
                                          backgroundColor: AppColors.accent,
                                          foregroundColor: AppColors.background,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.background,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      // İşletme sahibi girişi
                    },
                    child: Text(
                      'İşletme sahibi misiniz? O zaman tıklayın.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
