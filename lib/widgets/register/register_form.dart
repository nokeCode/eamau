import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController emailController;
  final TextEditingController telephoneController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nomController,
    required this.prenomController,
    required this.emailController,
    required this.telephoneController,
    required this.passwordController,
    required this.passwordConfirmController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  String _countryCode = '+228';

  InputDecoration decoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0F4DA8)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F7FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0F4DA8), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.nomController,
                    textInputAction: TextInputAction.next,
                    decoration: decoration(
                      label: "Nom",
                      hint: "Votre nom",
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Champ obligatoire";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextFormField(
                    controller: widget.prenomController,
                    textInputAction: TextInputAction.next,
                    decoration: decoration(
                      label: "Prénom",
                      hint: "Votre prénom",
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Champ obligatoire";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: decoration(
                label: "Email",
                hint: "exemple@email.com",
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Email obligatoire";
                }

                if (!RegExp(
                  r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
                ).hasMatch(value)) {
                  return "Adresse email invalide";
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      builder: (_) {
                        return ListView(
                          children: [
                            ListTile(
                              title: const Text('Algérie (+213)'),
                              leading: const Text('🇩🇿'),
                              onTap: () => Navigator.pop(context, '+213'),
                            ),
                            ListTile(
                              title: const Text('Angola (+244)'),
                              leading: const Text('🇦🇴'),
                              onTap: () => Navigator.pop(context, '+244'),
                            ),
                            ListTile(
                              title: const Text('Bénin (+229)'),
                              leading: const Text('🇧🇯'),
                              onTap: () => Navigator.pop(context, '+229'),
                            ),
                            ListTile(
                              title: const Text('Botswana (+267)'),
                              leading: const Text('🇧🇼'),
                              onTap: () => Navigator.pop(context, '+267'),
                            ),
                            ListTile(
                              title: const Text('Burkina Faso (+226)'),
                              leading: const Text('🇧🇫'),
                              onTap: () => Navigator.pop(context, '+226'),
                            ),
                            ListTile(
                              title: const Text('Burundi (+257)'),
                              leading: const Text('🇧🇮'),
                              onTap: () => Navigator.pop(context, '+257'),
                            ),
                            ListTile(
                              title: const Text('Cabo Verde (+238)'),
                              leading: const Text('🇨🇻'),
                              onTap: () => Navigator.pop(context, '+238'),
                            ),
                            ListTile(
                              title: const Text('Cameroun (+237)'),
                              leading: const Text('🇨🇲'),
                              onTap: () => Navigator.pop(context, '+237'),
                            ),
                            ListTile(
                              title: const Text(
                                'République centrafricaine (+236)',
                              ),
                              leading: const Text('🇨🇫'),
                              onTap: () => Navigator.pop(context, '+236'),
                            ),
                            ListTile(
                              title: const Text('Tchad (+235)'),
                              leading: const Text('🇹🇩'),
                              onTap: () => Navigator.pop(context, '+235'),
                            ),
                            ListTile(
                              title: const Text('Comores (+269)'),
                              leading: const Text('🇰🇲'),
                              onTap: () => Navigator.pop(context, '+269'),
                            ),
                            ListTile(
                              title: const Text('Congo (+242)'),
                              leading: const Text('🇨🇬'),
                              onTap: () => Navigator.pop(context, '+242'),
                            ),
                            ListTile(
                              title: const Text('RDC (+243)'),
                              leading: const Text('🇨🇩'),
                              onTap: () => Navigator.pop(context, '+243'),
                            ),
                            ListTile(
                              title: const Text('Côte d\'Ivoire (+225)'),
                              leading: const Text('🇨🇮'),
                              onTap: () => Navigator.pop(context, '+225'),
                            ),
                            ListTile(
                              title: const Text('Djibouti (+253)'),
                              leading: const Text('🇩🇯'),
                              onTap: () => Navigator.pop(context, '+253'),
                            ),
                            ListTile(
                              title: const Text('Égypte (+20)'),
                              leading: const Text('🇪🇬'),
                              onTap: () => Navigator.pop(context, '+20'),
                            ),
                            ListTile(
                              title: const Text('Guinée équatoriale (+240)'),
                              leading: const Text('🇬🇶'),
                              onTap: () => Navigator.pop(context, '+240'),
                            ),
                            ListTile(
                              title: const Text('Érythrée (+291)'),
                              leading: const Text('🇪🇷'),
                              onTap: () => Navigator.pop(context, '+291'),
                            ),
                            ListTile(
                              title: const Text('Eswatini (+268)'),
                              leading: const Text('🇸🇿'),
                              onTap: () => Navigator.pop(context, '+268'),
                            ),
                            ListTile(
                              title: const Text('Éthiopie (+251)'),
                              leading: const Text('🇪🇹'),
                              onTap: () => Navigator.pop(context, '+251'),
                            ),
                            ListTile(
                              title: const Text('Gabon (+241)'),
                              leading: const Text('🇬🇦'),
                              onTap: () => Navigator.pop(context, '+241'),
                            ),
                            ListTile(
                              title: const Text('Gambie (+220)'),
                              leading: const Text('🇬🇲'),
                              onTap: () => Navigator.pop(context, '+220'),
                            ),
                            ListTile(
                              title: const Text('Ghana (+233)'),
                              leading: const Text('🇬🇭'),
                              onTap: () => Navigator.pop(context, '+233'),
                            ),
                            ListTile(
                              title: const Text('Guinée (+224)'),
                              leading: const Text('🇬🇳'),
                              onTap: () => Navigator.pop(context, '+224'),
                            ),
                            ListTile(
                              title: const Text('Guinée-Bissau (+245)'),
                              leading: const Text('🇬🇼'),
                              onTap: () => Navigator.pop(context, '+245'),
                            ),
                            ListTile(
                              title: const Text('Kenya (+254)'),
                              leading: const Text('🇰🇪'),
                              onTap: () => Navigator.pop(context, '+254'),
                            ),
                            ListTile(
                              title: const Text('Lesotho (+266)'),
                              leading: const Text('🇱🇸'),
                              onTap: () => Navigator.pop(context, '+266'),
                            ),
                            ListTile(
                              title: const Text('Libéria (+231)'),
                              leading: const Text('🇱🇷'),
                              onTap: () => Navigator.pop(context, '+231'),
                            ),
                            ListTile(
                              title: const Text('Libye (+218)'),
                              leading: const Text('🇱🇾'),
                              onTap: () => Navigator.pop(context, '+218'),
                            ),
                            ListTile(
                              title: const Text('Madagascar (+261)'),
                              leading: const Text('🇲🇬'),
                              onTap: () => Navigator.pop(context, '+261'),
                            ),
                            ListTile(
                              title: const Text('Malawi (+265)'),
                              leading: const Text('🇲🇼'),
                              onTap: () => Navigator.pop(context, '+265'),
                            ),
                            ListTile(
                              title: const Text('Mali (+223)'),
                              leading: const Text('🇲🇱'),
                              onTap: () => Navigator.pop(context, '+223'),
                            ),
                            ListTile(
                              title: const Text('Mauritanie (+222)'),
                              leading: const Text('🇲🇷'),
                              onTap: () => Navigator.pop(context, '+222'),
                            ),
                            ListTile(
                              title: const Text('Maurice (+230)'),
                              leading: const Text('🇲🇺'),
                              onTap: () => Navigator.pop(context, '+230'),
                            ),
                            ListTile(
                              title: const Text('Maroc (+212)'),
                              leading: const Text('🇲🇦'),
                              onTap: () => Navigator.pop(context, '+212'),
                            ),
                            ListTile(
                              title: const Text('Mozambique (+258)'),
                              leading: const Text('🇲🇿'),
                              onTap: () => Navigator.pop(context, '+258'),
                            ),
                            ListTile(
                              title: const Text('Namibie (+264)'),
                              leading: const Text('🇳🇦'),
                              onTap: () => Navigator.pop(context, '+264'),
                            ),
                            ListTile(
                              title: const Text('Niger (+227)'),
                              leading: const Text('🇳🇪'),
                              onTap: () => Navigator.pop(context, '+227'),
                            ),
                            ListTile(
                              title: const Text('Nigéria (+234)'),
                              leading: const Text('🇳🇬'),
                              onTap: () => Navigator.pop(context, '+234'),
                            ),
                            ListTile(
                              title: const Text('Rwanda (+250)'),
                              leading: const Text('🇷🇼'),
                              onTap: () => Navigator.pop(context, '+250'),
                            ),
                            ListTile(
                              title: const Text('Sao Tomé-et-Principe (+239)'),
                              leading: const Text('🇸🇹'),
                              onTap: () => Navigator.pop(context, '+239'),
                            ),
                            ListTile(
                              title: const Text('Sénégal (+221)'),
                              leading: const Text('🇸🇳'),
                              onTap: () => Navigator.pop(context, '+221'),
                            ),
                            ListTile(
                              title: const Text('Seychelles (+248)'),
                              leading: const Text('🇸🇨'),
                              onTap: () => Navigator.pop(context, '+248'),
                            ),
                            ListTile(
                              title: const Text('Sierra Leone (+232)'),
                              leading: const Text('🇸🇱'),
                              onTap: () => Navigator.pop(context, '+232'),
                            ),
                            ListTile(
                              title: const Text('Somalie (+252)'),
                              leading: const Text('🇸🇴'),
                              onTap: () => Navigator.pop(context, '+252'),
                            ),
                            ListTile(
                              title: const Text('Afrique du Sud (+27)'),
                              leading: const Text('🇿🇦'),
                              onTap: () => Navigator.pop(context, '+27'),
                            ),
                            ListTile(
                              title: const Text('Soudan du Sud (+211)'),
                              leading: const Text('🇸🇸'),
                              onTap: () => Navigator.pop(context, '+211'),
                            ),
                            ListTile(
                              title: const Text('Soudan (+249)'),
                              leading: const Text('🇸🇩'),
                              onTap: () => Navigator.pop(context, '+249'),
                            ),
                            ListTile(
                              title: const Text('Tanzanie (+255)'),
                              leading: const Text('🇹🇿'),
                              onTap: () => Navigator.pop(context, '+255'),
                            ),
                            ListTile(
                              title: const Text('Togo (+228)'),
                              leading: const Text('🇹🇬'),
                              onTap: () => Navigator.pop(context, '+228'),
                            ),
                            ListTile(
                              title: const Text('Tunisie (+216)'),
                              leading: const Text('🇹🇳'),
                              onTap: () => Navigator.pop(context, '+216'),
                            ),
                            ListTile(
                              title: const Text('Ouganda (+256)'),
                              leading: const Text('🇺🇬'),
                              onTap: () => Navigator.pop(context, '+256'),
                            ),
                            ListTile(
                              title: const Text('Zambie (+260)'),
                              leading: const Text('🇿🇲'),
                              onTap: () => Navigator.pop(context, '+260'),
                            ),
                            ListTile(
                              title: const Text('Zimbabwe (+263)'),
                              leading: const Text('🇿🇼'),
                              onTap: () => Navigator.pop(context, '+263'),
                            ),
                          ],
                        );
                      },
                    );

                    if (selected != null) {
                      setState(() => _countryCode = selected);
                      if (widget.telephoneController.text.trim().isEmpty) {
                        widget.telephoneController.text = '$_countryCode ';
                      } else if (!widget.telephoneController.text.startsWith(
                        '+',
                      )) {
                        widget.telephoneController.text =
                            '$_countryCode ${widget.telephoneController.text}';
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(_countryCode),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: TextFormField(
                    controller: widget.telephoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: decoration(
                      label: "Téléphone",
                      hint: "+228 XX XX XX XX",
                      icon: Icons.phone_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Téléphone obligatoire";
                      }

                      if (value.replaceAll(RegExp(r'\D'), '').length < 8) {
                        return "Numéro invalide";
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              decoration: decoration(
                label: "Mot de passe",
                hint: "********",
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mot de passe obligatoire";
                }

                if (value.length < 8) {
                  return "Le mot de passe doit contenir au moins 8 caractères";
                }

                final uppercase = RegExp(r'[A-Z]');
                final lowercase = RegExp(r'[a-z]');
                final digit = RegExp(r'\d');
                final special = RegExp(r'[!@#\$%\^&*(),.?":{}|<>]');

                if (!uppercase.hasMatch(value)) {
                  return "Le mot de passe doit contenir une majuscule";
                }
                if (!lowercase.hasMatch(value)) {
                  return "Le mot de passe doit contenir une minuscule";
                }
                if (!digit.hasMatch(value)) {
                  return "Le mot de passe doit contenir un chiffre";
                }
                if (!special.hasMatch(value)) {
                  return "Le mot de passe doit contenir un caractère spécial";
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: widget.passwordConfirmController,
              obscureText: _obscurePasswordConfirm,
              textInputAction: TextInputAction.done,
              decoration: decoration(
                label: "Confirmer le mot de passe",
                hint: "********",
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePasswordConfirm = !_obscurePasswordConfirm;
                    });
                  },
                  icon: Icon(
                    _obscurePasswordConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirmation obligatoire";
                }

                if (value.length < 6) {
                  return "Minimum 6 caractères";
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
