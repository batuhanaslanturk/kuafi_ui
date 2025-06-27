import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'sms_verify_dialog.dart';
import 'customer_home_screen.dart'; // CustomerHomeScreen için import ekliyorum

class CustomerInfoScreen extends StatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salonController = TextEditingController();

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(###)-###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası giriniz';
    } else if (!_phoneMaskFormatter.isFill()) {
      return 'Geçerli bir telefon numarası giriniz ((5xx)-xxx-xx-xx)';
    }
    return null;
  }

  String? _validateSalon(String? value) {
    if (value == null || value.isEmpty) {
      return 'Salon numarası giriniz';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Bilgileriniz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Ad soyad giriniz' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _salonController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salon Numarası',
                  border: OutlineInputBorder(),
                ),
                validator: _validateSalon,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneMaskFormatter],
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası',
                  hintText: '(5xx)-xxx-xx-xx',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
                maxLength: 15,
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.card,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Geri'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          final smsResult = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => SmsVerifyDialog(
                              name: _nameController.text,
                              phone: _phoneController.text,
                              salonNumber: _salonController.text,
                            ),
                          );
                          if (smsResult == true && mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const CustomerHomeScreen(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Onayla'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
