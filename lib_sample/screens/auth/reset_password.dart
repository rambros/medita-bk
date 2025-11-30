import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  var formKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();

  _handleSubmit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await AuthService().sendPasswordRestEmail(context, emailCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'reset-password',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 28),
              ).tr(),
              const SizedBox(height: 10),
              Text(
                'follow-simple-steps',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ).tr(),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'username@mail.com', labelText: 'email'.tr()),
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value!.isEmpty) return "Email can't be empty";
                  return null;
                },
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, elevation: 0),
                    child: Text(
                      'submit',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),
                    ).tr(),
                    onPressed: () => _handleSubmit()),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
