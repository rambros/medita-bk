import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';

/// Modal de atualização de informações do usuário antes de iniciar um curso
class UpdateUserInfoDialog extends StatefulWidget {
  const UpdateUserInfoDialog({
    super.key,
    required this.currentUser,
    required this.onSave,
  });

  final UserModel currentUser;
  final Function(String fullName, String whatsapp, String cidade, String uf) onSave;

  @override
  State<UpdateUserInfoDialog> createState() => _UpdateUserInfoDialogState();
}

class _UpdateUserInfoDialogState extends State<UpdateUserInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _whatsappController;
  late TextEditingController _cidadeController;
  String? _selectedUF;
  bool _isSaving = false;

  final List<String> _estadosBrasileiros = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.currentUser.fullName);
    _whatsappController = TextEditingController(text: widget.currentUser.whatsapp);
    _cidadeController = TextEditingController(text: widget.currentUser.cidade);
    if (widget.currentUser.uf.isNotEmpty) {
      _selectedUF = widget.currentUser.uf;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _whatsappController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave(
        _fullNameController.text.trim(),
        _whatsappController.text.trim(),
        _cidadeController.text.trim(),
        _selectedUF ?? '',
      );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar dados: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, informe seu nome completo';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Por favor, informe nome e sobrenome';
    }
    return null;
  }

  String? _validateWhatsapp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length < 10 || numbers.length > 11) {
      return 'Número inválido (use DDD + número)';
    }
    return null;
  }

  String? _validateCidade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, informe sua cidade';
    }
    return null;
  }

  String? _validateGeneric(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    'Atualização do cadastro',
                    style: appTheme.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: appTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtítulo
                  Text(
                    'Para nos comunicarmos durante o curso, solicitamos que você faça a gentileza de atualizar seus dados.',
                    style: appTheme.bodyMedium.copyWith(
                      color: appTheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Campo: Nome Completo
                  Text(
                    'Nome Completo',
                    style: appTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Digite seu nome completo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: appTheme.secondaryBackground,
                      prefixIcon: Icon(Icons.person, color: appTheme.secondaryText),
                    ),
                    validator: _validateFullName,
                    textCapitalization: TextCapitalization.words,
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 16),

                  // Campo: WhatsApp
                  Text(
                    'WhatsApp/Celular (opcional)',
                    style: appTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _whatsappController,
                    decoration: InputDecoration(
                      hintText: '(00) 00000-0000',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: appTheme.secondaryBackground,
                      prefixIcon: Icon(Icons.phone, color: appTheme.secondaryText),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                      _PhoneNumberFormatter(),
                    ],
                    validator: _validateWhatsapp,
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 16),

                  // Campo: Cidade
                  Text(
                    'Cidade',
                    style: appTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cidadeController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua cidade',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: appTheme.secondaryBackground,
                      prefixIcon: Icon(Icons.location_city, color: appTheme.secondaryText),
                    ),
                    validator: _validateCidade,
                    textCapitalization: TextCapitalization.words,
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 16),

                  // Campo: UF (Estado)
                  Text(
                    'Estado (UF)',
                    style: appTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedUF,
                    items: _estadosBrasileiros.map((String uf) {
                      return DropdownMenuItem<String>(
                        value: uf,
                        child: Text(uf),
                      );
                    }).toList(),
                    onChanged: _isSaving
                        ? null
                        : (String? newValue) {
                            setState(() {
                              _selectedUF = newValue;
                            });
                          },
                    decoration: InputDecoration(
                      hintText: 'Selecione o estado',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: appTheme.secondaryBackground,
                      prefixIcon: Icon(Icons.map, color: appTheme.secondaryText),
                    ),
                    validator: _validateGeneric,
                  ),
                  const SizedBox(height: 24),

                  // Botões de ação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: appTheme.secondaryText),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.primary,
                          foregroundColor: appTheme.info,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: _isSaving
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(appTheme.info),
                                ),
                              )
                            : const Text('Salvar'),
                      ),
                    ],
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

/// Formatador de número de telefone
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final textLength = text.length;

    if (textLength == 0) {
      return newValue;
    }

    var buffer = StringBuffer();

    // Adiciona parênteses no DDD
    if (textLength > 0) {
      buffer.write('(');
      buffer.write(text.substring(0, textLength >= 2 ? 2 : textLength));
      if (textLength >= 2) {
        buffer.write(') ');
      }
    }

    // Adiciona os dígitos do número
    if (textLength >= 3) {
      if (textLength <= 6) {
        buffer.write(text.substring(2, textLength));
      } else if (textLength <= 10) {
        buffer.write(text.substring(2, 6));
        buffer.write('-');
        buffer.write(text.substring(6, textLength));
      } else {
        buffer.write(text.substring(2, 7));
        buffer.write('-');
        buffer.write(text.substring(7, textLength));
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
