import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/api/api_client.dart';
import '../models/auth/user.dart';
import '../models/profile/profile_academic_model.dart';
import '../models/profile/user_model.dart';
import '../routes/app_routes.dart';
import '../services/auth/auth_service.dart';
import '../services/profile/profile_service.dart';
import '../widgets/login/custom_text_field.dart';
import '../widgets/profile/identity_upload_field.dart';
import '../widgets/profile/profile_card.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/validation_profile_section.dart';

enum ValidationGender { male, female }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  final _editProfileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _validationFormKey = GlobalKey<FormState>();
  final Map<String, GlobalKey<FormFieldState>> _validationFieldKeys = {};
  final ScrollController _validationScrollController = ScrollController();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _validationFirstNameController = TextEditingController();
  final TextEditingController _validationLastNameController = TextEditingController();
  final TextEditingController _validationEmailController = TextEditingController();
  final TextEditingController _validationUsernameController = TextEditingController();
  final TextEditingController _validationMatriculeController = TextEditingController();
  final TextEditingController _validationPhoneController = TextEditingController();
  final TextEditingController _validationGenderController = TextEditingController();
  final TextEditingController _validationBirthDateController = TextEditingController();
  final TextEditingController _validationBirthPlaceController = TextEditingController();
  final TextEditingController _validationCountryController = TextEditingController();
  final TextEditingController _validationNationalityController = TextEditingController();
  final TextEditingController _validationSkypeController = TextEditingController();
  final TextEditingController _validationWhatsappController = TextEditingController();
  final TextEditingController _validationSituationMatrimonialController = TextEditingController();
  final TextEditingController _validationIdentityNumberController = TextEditingController();
  final TextEditingController _validationPrenomPersoPrevController = TextEditingController();
  final TextEditingController _validationPermanentPostalBoxController = TextEditingController();
  final TextEditingController _validationPermanentCityController = TextEditingController();
  final TextEditingController _validationPermanentQuarterController = TextEditingController();
  final TextEditingController _validationPermanentStreetController = TextEditingController();
  final TextEditingController _validationPermanentHomePhoneController = TextEditingController();
  final TextEditingController _validationPermanentMobileController = TextEditingController();
  final TextEditingController _validationLomePostalBoxController = TextEditingController();
  final TextEditingController _validationLomeCityController = TextEditingController();
  final TextEditingController _validationLomeQuarterController = TextEditingController();
  final TextEditingController _validationLomeStreetController = TextEditingController();
  final TextEditingController _validationLomeHomePhoneController = TextEditingController();
  final TextEditingController _validationLomeMobileController = TextEditingController();
  final TextEditingController _validationLomeEmailController = TextEditingController();
  final TextEditingController _validationEmergencyNameController = TextEditingController();
  final TextEditingController _validationEmergencyPostalBoxController = TextEditingController();
  final TextEditingController _validationEmergencyCityController = TextEditingController();
  final TextEditingController _validationEmergencyQuarterController = TextEditingController();
  final TextEditingController _validationEmergencyStreetController = TextEditingController();
  final TextEditingController _validationEmergencyHomePhoneController = TextEditingController();
  final TextEditingController _validationEmergencyMobileController = TextEditingController();
  final TextEditingController _validationEmergencyEmailController = TextEditingController();
  final TextEditingController _validationIdentityFrontController = TextEditingController();
  final TextEditingController _validationIdentityBackController = TextEditingController();

  UserModel _user = UserModel.empty();
  ProfileAcademicModel _academicInfo = ProfileAcademicModel.empty();
  String? _authUserRole;
  bool _loading = true;
  bool _isLoggedIn = false;
  bool _isLoggingOut = false;
  bool _isUpdatingProfile = false;
  bool _isChangingPassword = false;
  bool _isRequestingValidation = false;
  File? _identityFrontFile;
  File? _identityBackFile;
  ValidationGender? _selectedGender;
  final Map<String, String> _phoneCountryCodes = {};

  @override
  void initState() {
    super.initState();
    _phoneCountryCodes.addAll({
      'permanent_home_phone': '+228',
      'permanent_mobile': '+228',
      'lome_home_phone': '+228',
      'lome_mobile': '+228',
      'emergency_home_phone': '+228',
      'emergency_mobile': '+228',
    });
    _init();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _matriculeController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _validationFirstNameController.dispose();
    _validationLastNameController.dispose();
    _validationEmailController.dispose();
    _validationUsernameController.dispose();
    _validationMatriculeController.dispose();
    _validationPhoneController.dispose();
    _validationGenderController.dispose();
    _validationBirthDateController.dispose();
    _validationBirthPlaceController.dispose();
    _validationCountryController.dispose();
    _validationNationalityController.dispose();
    _validationSkypeController.dispose();
    _validationWhatsappController.dispose();
    _validationSituationMatrimonialController.dispose();
    _validationIdentityNumberController.dispose();
    _validationPrenomPersoPrevController.dispose();
    _validationPermanentPostalBoxController.dispose();
    _validationPermanentCityController.dispose();
    _validationPermanentQuarterController.dispose();
    _validationPermanentStreetController.dispose();
    _validationPermanentHomePhoneController.dispose();
    _validationPermanentMobileController.dispose();
    _validationLomePostalBoxController.dispose();
    _validationLomeCityController.dispose();
    _validationLomeQuarterController.dispose();
    _validationLomeStreetController.dispose();
    _validationLomeHomePhoneController.dispose();
    _validationLomeMobileController.dispose();
    _validationLomeEmailController.dispose();
    _validationEmergencyNameController.dispose();
    _validationEmergencyPostalBoxController.dispose();
    _validationEmergencyCityController.dispose();
    _validationEmergencyQuarterController.dispose();
    _validationEmergencyStreetController.dispose();
    _validationEmergencyHomePhoneController.dispose();
    _validationEmergencyMobileController.dispose();
    _validationEmergencyEmailController.dispose();
    _validationIdentityFrontController.dispose();
    _validationIdentityBackController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final logged = await _authService.isLoggedIn();
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggedIn = logged;
    });

    if (!logged) {
      setState(() {
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vous n'êtes pas encore connecté."),
            duration: Duration(seconds: 3),
          ),
        );
      });
      return;
    }

    await _loadProfileData();

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _loading = true;
    });

    UserModel profile = UserModel.empty();
    ProfileAcademicModel academic = ProfileAcademicModel.empty();
    User? authUser;

    try {
      profile = await _profileService.getProfile();
    } catch (_) {
      // Profile endpoint failed; we'll still try to load other data.
    }

    try {
      academic = await _profileService.getAcademicInfo();
    } catch (_) {
      // Ignore academic info failure.
    }

    try {
      authUser = await _authService.getCurrentUser();
    } catch (_) {
      // Ignore auth/me failure.
    }

    if (!mounted) {
      return;
    }

    final mergedProfile = authUser != null
        ? UserModel(
            fullName: profile.fullName.isNotEmpty
                ? profile.fullName
                : authUser.fullName,
            firstName: profile.firstName.isNotEmpty
                ? profile.firstName
                : (authUser.firstName ?? ''),
            lastName: profile.lastName.isNotEmpty
                ? profile.lastName
                : (authUser.lastName ?? ''),
            email: profile.email.isNotEmpty ? profile.email : authUser.email,
            phone: profile.phone.isNotEmpty ? profile.phone : (authUser.phone ?? ''),
            address: profile.address,
            birthDate: profile.birthDate,
            birthPlace: profile.birthPlace,
            gender: profile.gender,
            country: profile.country,
            nationality: profile.nationality,
            countryId: profile.countryId,
            skype: profile.skype,
            whatsapp: profile.whatsapp,
            maritalStatus: profile.maritalStatus,
            identityNumber: profile.identityNumber,
            level: profile.level,
            department: profile.department,
            avatar: profile.avatar.isNotEmpty ? profile.avatar : (authUser.avatar ?? ''),
            active: profile.active,
            username: profile.username,
            matricule: profile.matricule,
            permanentPostalBox: profile.permanentPostalBox,
            permanentCity: profile.permanentCity,
            permanentQuarter: profile.permanentQuarter,
            permanentStreet: profile.permanentStreet,
            permanentHomePhone: profile.permanentHomePhone,
            permanentMobile: profile.permanentMobile,
            lomePostalBox: profile.lomePostalBox,
            lomeCity: profile.lomeCity,
            lomeQuarter: profile.lomeQuarter,
            lomeStreet: profile.lomeStreet,
            lomeHomePhone: profile.lomeHomePhone,
            lomeMobile: profile.lomeMobile,
            lomeEmail: profile.lomeEmail,
            emergencyName: profile.emergencyName,
            emergencyPostalBox: profile.emergencyPostalBox,
            emergencyCity: profile.emergencyCity,
            emergencyQuarter: profile.emergencyQuarter,
            emergencyStreet: profile.emergencyStreet,
            emergencyHomePhone: profile.emergencyHomePhone,
            emergencyMobile: profile.emergencyMobile,
            emergencyEmail: profile.emergencyEmail,
            emergencyFirstName: profile.emergencyFirstName,
            identityFront: profile.identityFront,
            identityBack: profile.identityBack,
          )
        : profile;

    setState(() {
      _user = mergedProfile;
      _academicInfo = academic;
      _authUserRole = authUser?.role?.toLowerCase();
    });
  }

  String? _nullable(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  bool _isUserRole() {
    final normalizedRole = _authUserRole?.toLowerCase();
    if (normalizedRole == null || normalizedRole.isEmpty) {
      return false;
    }
    return normalizedRole == 'user' ||
        normalizedRole.contains('role_user') ||
        normalizedRole.contains('roles_user') ||
        normalizedRole == 'role';
  }

  void _prepareEditControllers() {
    final parts = _user.fullName.trim().split(' ');
    _firstnameController.text = parts.isNotEmpty ? parts.first : '';
    _lastnameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    _emailController.text = _user.email;
    _usernameController.text = _user.username;
    _matriculeController.text = _user.matricule;
    _phoneController.text = _user.phone;
  }

  void _prepareValidationControllers() {
    final fullNameParts = _user.fullName.split(' ');
    _validationFirstNameController.text = _user.firstName.isNotEmpty
        ? _user.firstName
        : (fullNameParts.isNotEmpty ? fullNameParts.first : '');
    _validationLastNameController.text = _user.lastName.isNotEmpty
        ? _user.lastName
        : (fullNameParts.length > 1 ? fullNameParts.sublist(1).join(' ') : '');
    _validationEmailController.text = _user.email;
    _validationUsernameController.text = _user.username;
    _validationMatriculeController.text = _user.matricule;
    _validationPhoneController.text = _user.phone;
    _validationBirthDateController.text = _user.birthDate;
    _validationBirthPlaceController.text = _user.birthPlace;
    _validationCountryController.text = _user.country;
    _validationNationalityController.text = _user.nationality;
    _validationSkypeController.text = _user.skype;
    _validationWhatsappController.text = _user.whatsapp;
    _validationSituationMatrimonialController.text = _user.maritalStatus;
    _validationIdentityNumberController.text = _user.identityNumber;
    _validationPermanentPostalBoxController.text = _user.permanentPostalBox;
    _validationPermanentCityController.text = _user.permanentCity;
    _validationPermanentQuarterController.text = _user.permanentQuarter;
    _validationPermanentStreetController.text = _user.permanentStreet;
    _validationPermanentHomePhoneController.text = _user.permanentHomePhone.isNotEmpty ? _user.permanentHomePhone : _user.phone;
    _validationPermanentMobileController.text = _user.permanentMobile.isNotEmpty ? _user.permanentMobile : _user.phone;
    _validationLomePostalBoxController.text = _user.lomePostalBox;
    _validationLomeCityController.text = _user.lomeCity;
    _validationLomeQuarterController.text = _user.lomeQuarter;
    _validationLomeStreetController.text = _user.lomeStreet;
    _validationLomeHomePhoneController.text = _user.lomeHomePhone.isNotEmpty ? _user.lomeHomePhone : _user.phone;
    _validationLomeMobileController.text = _user.lomeMobile.isNotEmpty ? _user.lomeMobile : _user.phone;
    _validationLomeEmailController.text = _user.lomeEmail.isNotEmpty ? _user.lomeEmail : _user.email;
    _validationEmergencyNameController.text = _user.emergencyName;
    _validationEmergencyPostalBoxController.text = _user.emergencyPostalBox;
    _validationEmergencyCityController.text = _user.emergencyCity;
    _validationEmergencyQuarterController.text = _user.emergencyQuarter;
    _validationEmergencyStreetController.text = _user.emergencyStreet;
    _validationEmergencyHomePhoneController.text = _user.emergencyHomePhone;
    _validationEmergencyMobileController.text = _user.emergencyMobile;
    _validationEmergencyEmailController.text = _user.emergencyEmail.isNotEmpty ? _user.emergencyEmail : _user.email;
    _validationPrenomPersoPrevController.text = _user.emergencyFirstName;
    _validationIdentityFrontController.text = _user.identityFront;
    _validationIdentityBackController.text = _user.identityBack;
  }

  Future<void> _showEditProfileSheet() async {
    _prepareEditControllers();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _editProfileFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modifier mon profil',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Prénom',
                    hint: 'Jean',
                    icon: Icons.person_outline,
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le prénom est requis.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Nom',
                    hint: 'Dupont',
                    icon: Icons.person_outline,
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le nom est requis.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Email',
                    hint: 'jeun.dupont@email.com',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "L'email est requis.";
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
                        return 'Email invalide.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: "Nom d'utilisateur",
                    hint: 'jdupont2026',
                    icon: Icons.person,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Matricule',
                    hint: 'ETU00123',
                    icon: Icons.badge_outlined,
                    controller: _matriculeController,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Téléphone',
                    hint: '+228 90 12 34 56',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isUpdatingProfile
                          ? null
                          : () async {
                              if (!_editProfileFormKey.currentState!.validate()) {
                                return;
                              }

                              setState(() => _isUpdatingProfile = true);
                              try {
                                final updatedUser = await _profileService.updateProfile(
                                  firstname: _nullable(_firstnameController.text),
                                  lastname: _nullable(_lastnameController.text),
                                  email: _nullable(_emailController.text),
                                  username: _nullable(_usernameController.text),
                                  matricule: _nullable(_matriculeController.text),
                                  phone: _nullable(_phoneController.text),
                                );

                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  _user = updatedUser;
                                });
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Profil mis à jour.')),
                                );
                              } catch (e) {
                                if (!mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e is Exception
                                          ? e.toString()
                                          : 'Impossible de mettre à jour le profil.',
                                    ),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isUpdatingProfile = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1682F8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isUpdatingProfile
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Enregistrer les modifications'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showChangePasswordSheet() async {
    _currentPasswordController.clear();
    _newPasswordController.clear();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _passwordFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Changer le mot de passe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Mot de passe actuel',
                    hint: 'Ancien mot de passe',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _currentPasswordController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le mot de passe actuel est requis.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Nouveau mot de passe',
                    hint: 'Au moins 8 caractères',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _newPasswordController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le nouveau mot de passe est requis.';
                      }
                      if (value.trim().length < 8) {
                        return 'Le mot de passe doit contenir au moins 8 caractères.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isChangingPassword
                          ? null
                          : () async {
                              if (!_passwordFormKey.currentState!.validate()) {
                                return;
                              }

                              setState(() => _isChangingPassword = true);
                              try {
                                await _profileService.changePassword(
                                  currentPassword: _currentPasswordController.text.trim(),
                                  newPassword: _newPasswordController.text.trim(),
                                );

                                if (!mounted) {
                                  return;
                                }
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Mot de passe mis à jour.')),
                                );
                              } catch (e) {
                                if (!mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e is Exception
                                          ? e.toString()
                                          : 'Impossible de changer le mot de passe.',
                                    ),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isChangingPassword = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isChangingPassword
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Enregistrer le mot de passe'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showValidationRequestSheet() async {
    _prepareValidationControllers();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            controller: _validationScrollController,
            child: Form(
              key: _validationFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFF1682F8),
                          child: Icon(Icons.verified_user_outlined, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Demande de validation de compte',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Renseignez les informations demandées pour finaliser la procédure en quelques minutes.',
                                style: TextStyle(color: Color(0xFF64748B), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildValidationSectionCard('Identité personnelle', [
                    _buildValidationField('Prénom', 'Prénom', _validationFirstNameController, icon: Icons.person_outline),
                    _buildValidationField('Nom', 'Nom', _validationLastNameController, icon: Icons.badge_outlined),
                    _buildValidationField('Email', 'Email', _validationEmailController, validator: _emailValidator, keyboardType: TextInputType.emailAddress, icon: Icons.email_outlined),
                    _buildValidationField('Nom d’utilisateur', 'Nom d’utilisateur', _validationUsernameController, icon: Icons.account_circle_outlined),
                    _buildValidationField('Matricule', 'Matricule', _validationMatriculeController, icon: Icons.numbers_outlined),
                    _buildPhoneField('Téléphone', 'Téléphone', _validationPhoneController, 'phone'),
                    _buildGenderField(),
                    _buildDateField('Date de naissance', 'Date de naissance', _validationBirthDateController),
                    _buildValidationField('Lieu de naissance', 'Lieu de naissance', _validationBirthPlaceController, icon: Icons.location_city_outlined),
                    _buildAfricanCountryDropdownField('Pays d’origine', 'Pays d’origine', _validationCountryController),
                    _buildAfricanCountryDropdownField('Nationalité', 'Nationalité', _validationNationalityController),
                    _buildValidationField('Skype', 'Skype', _validationSkypeController, icon: Icons.chat_outlined),
                    _buildValidationField('WhatsApp', 'WhatsApp', _validationWhatsappController, icon: Icons.message_outlined),
                    _buildValidationField('Situation matrimoniale', 'Situation matrimoniale', _validationSituationMatrimonialController, icon: Icons.family_restroom_outlined),
                    _buildValidationField('N° pièce d’identité', 'N° pièce d’identité', _validationIdentityNumberController, icon: Icons.credit_card_outlined),
                  ]),
                  _buildValidationSectionCard('Adresse permanente', [
                    _buildValidationField('Boîte postale', 'Boîte postale', _validationPermanentPostalBoxController, icon: Icons.mail_outline),
                    _buildValidationField('Ville', 'Ville', _validationPermanentCityController, icon: Icons.location_city_outlined),
                    _buildValidationField('Quartier', 'Quartier', _validationPermanentQuarterController, icon: Icons.map_outlined),
                    _buildValidationField('Rue', 'Rue', _validationPermanentStreetController, icon: Icons.streetview_outlined),
                    _buildPhoneField('Téléphone domicile', 'Téléphone domicile', _validationPermanentHomePhoneController, 'permanent_home_phone'),
                    _buildPhoneField('Téléphone mobile', 'Téléphone mobile', _validationPermanentMobileController, 'permanent_mobile'),
                  ]),
                  _buildValidationSectionCard('Adresse à Lomé', [
                    _buildValidationField('Boîte postale', 'Boîte postale', _validationLomePostalBoxController, icon: Icons.mail_outline),
                    _buildValidationField('Ville', 'Ville', _validationLomeCityController, icon: Icons.location_city_outlined),
                    _buildValidationField('Quartier', 'Quartier', _validationLomeQuarterController, icon: Icons.map_outlined),
                    _buildValidationField('Rue', 'Rue', _validationLomeStreetController, icon: Icons.streetview_outlined),
                    _buildPhoneField('Téléphone domicile', 'Téléphone domicile', _validationLomeHomePhoneController, 'lome_home_phone'),
                    _buildPhoneField('Téléphone mobile', 'Téléphone mobile', _validationLomeMobileController, 'lome_mobile'),
                    _buildValidationField('Email', 'Email', _validationLomeEmailController, validator: _emailValidator, keyboardType: TextInputType.emailAddress, icon: Icons.email_outlined),
                  ]),
                  _buildValidationSectionCard('Personne à prévenir', [
                    _buildValidationField('Nom & prénom', 'Nom & prénom', _validationEmergencyNameController, icon: Icons.person_outline),
                    _buildValidationField('Prénom perso prev', 'Prénom perso prev', _validationPrenomPersoPrevController, icon: Icons.person_add_alt_1_outlined),
                    _buildValidationField('Boîte postale', 'Boîte postale', _validationEmergencyPostalBoxController, icon: Icons.mail_outline),
                    _buildValidationField('Ville', 'Ville', _validationEmergencyCityController, icon: Icons.location_city_outlined),
                    _buildValidationField('Quartier', 'Quartier', _validationEmergencyQuarterController, icon: Icons.map_outlined),
                    _buildValidationField('Rue', 'Rue', _validationEmergencyStreetController, icon: Icons.streetview_outlined),
                    _buildPhoneField('Téléphone domicile', 'Téléphone domicile', _validationEmergencyHomePhoneController, 'emergency_home_phone'),
                    _buildPhoneField('Téléphone mobile', 'Téléphone mobile', _validationEmergencyMobileController, 'emergency_mobile'),
                    _buildValidationField('Email', 'Email', _validationEmergencyEmailController, validator: _emailValidator, keyboardType: TextInputType.emailAddress, icon: Icons.email_outlined),
                  ]),
                  _buildValidationSectionCard('Pièce d’identité', [
                    IdentityUploadField(
                      label: 'Recto',
                      subtitle: 'Prenez une photo, importez depuis la galerie ou sélectionnez un document',
                      onFileSelected: (file) {
                        setState(() => _identityFrontFile = file);
                      },
                      onFileNameChanged: (name) {
                        _validationIdentityFrontController.text = name;
                      },
                    ),
                    IdentityUploadField(
                      label: 'Verso',
                      subtitle: 'Prenez une photo, importez depuis la galerie ou sélectionnez un document',
                      onFileSelected: (file) {
                        setState(() => _identityBackFile = file);
                      },
                      onFileNameChanged: (name) {
                        _validationIdentityBackController.text = name;
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isRequestingValidation
                          ? null
                          : () async {
                              if (!_validationFormKey.currentState!.validate()) {
                                _scrollToFirstInvalidValidationField();
                                return;
                              }

                              final payload = _buildValidationPayload();
                              if (_identityFrontFile == null || _identityBackFile == null) {
                                if (!mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Veuillez joindre les pièces d’identité recto et verso avant de continuer.')),
                                );
                                return;
                              }

                              setState(() => _isRequestingValidation = true);
                              var profileUpdated = false;
                              try {
                                await _profileService.updateProfileWithPayload(
                                  payload: payload,
                                  identityFrontFile: _identityFrontFile,
                                  identityBackFile: _identityBackFile,
                                );
                                profileUpdated = true;
                                await _profileService.saveValidationProfile(
                                  payload: payload,
                                  identityFrontFile: _identityFrontFile,
                                  identityBackFile: _identityBackFile,
                                );

                                if (!mounted) {
                                  return;
                                }
                                await _loadProfileData();
                                if (!mounted) {
                                  return;
                                }
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Informations enregistrées et demande de validation envoyée.')),
                                );
                              } catch (e) {
                                if (!mounted) {
                                  return;
                                }
                                await _showValidationSubmissionError(
                                  e,
                                  profileUpdated: profileUpdated,
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isRequestingValidation = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1682F8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isRequestingValidation
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Soumettre la demande'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildValidationSectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAfricanCountryDropdownField(String label, String hint, TextEditingController controller) {
    final fieldKey = _validationFieldKeys['$label-${identityHashCode(controller)}'] ??= GlobalKey<FormFieldState>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        key: fieldKey,
        initialValue: controller.text.trim().isEmpty ? null : controller.text.trim(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: const Icon(Icons.public_outlined),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1682F8))),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        items: _africanCountries.map((country) {
          return DropdownMenuItem<String>(
            value: country.name,
            child: Text(country.name),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              controller.text = value;
            });
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label est requis.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderField() {
    final fieldKey = _validationFieldKeys['Sexe'] ??= GlobalKey<FormFieldState>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<ValidationGender>(
        key: fieldKey,
        initialValue: _selectedGender,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Sexe',
          hintText: 'Sélectionnez le sexe',
          prefixIcon: const Icon(Icons.wc_outlined),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1682F8))),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        items: const [
          DropdownMenuItem(value: ValidationGender.male, child: Text('Masculin')),
          DropdownMenuItem(value: ValidationGender.female, child: Text('Féminin')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
            _validationGenderController.text = value == ValidationGender.male ? 'Masculin' : 'Féminin';
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Le sexe est requis.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildValidationField(
    String label,
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    IconData icon = Icons.edit_outlined,
    String? prefixText,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final fieldKey = _validationFieldKeys['$label-${identityHashCode(controller)}'] ??= GlobalKey<FormFieldState>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: onTap,
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label est requis.';
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          prefixText: prefixText,
          prefixStyle: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1682F8))),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String hint, TextEditingController controller) {
    return _buildValidationField(
      label,
      hint,
      controller,
      icon: Icons.calendar_month_outlined,
      readOnly: true,
      onTap: () async {
        final initialDate = DateTime.tryParse(controller.text) ?? DateTime.now();
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }

  Widget _buildPhoneField(String label, String hint, TextEditingController controller, String fieldKey) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 98,
            child: DropdownButtonFormField<String>(
              initialValue: _phoneCountryCodes[fieldKey] ?? '+228',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1682F8))),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              ),
              items: _africanCountries.map((country) {
                return DropdownMenuItem<String>(
                  value: country.code,
                  child: Row(
                    children: [
                      Text(country.flag),
                      const SizedBox(width: 6),
                      Text(
                        country.shortName,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _phoneCountryCodes[fieldKey] = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label est requis.';
                }
                final digits = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
                if (!RegExp(r'^\d{8,}$').hasMatch(digits)) {
                  return 'Format invalide.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                prefixIcon: const Icon(Icons.phone_android_outlined),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1682F8))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToFirstInvalidValidationField() {
    for (final entry in _validationFieldKeys.entries) {
      final formFieldState = entry.value.currentState;
      if (formFieldState != null && formFieldState.hasError) {
        final fieldContext = entry.value.currentContext;
        if (fieldContext != null) {
          Scrollable.ensureVisible(
            fieldContext,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: 0.1,
          );
          break;
        }
      }
    }
  }

  String _formatErrorMessage(Object error) {
    if (error is DioException) {
      final nestedError = error.error;

      if (nestedError is ApiException) {
        return _humanizeApiException(nestedError);
      }

      if (error.response?.data is Map) {
        final responseData = Map<String, dynamic>.from(error.response!.data as Map);
        final message = _humanizeBackendPayload(responseData);
        if (message.isNotEmpty) {
          return message;
        }
      }

      final fallback = error.message ?? 'Impossible d’envoyer la demande de validation.';
      return _cleanTechnicalMessage(fallback);
    }

    if (error is ApiException) {
      return _humanizeApiException(error);
    }

    if (error is Exception) {
      return _cleanTechnicalMessage(error.toString());
    }

    return 'Impossible d’envoyer la demande de validation.';
  }

  String _humanizeApiException(ApiException exception) {
    if (exception is ValidationException && exception.errors != null) {
      final nestedErrors = _flattenErrorDetails(exception.errors);
      if (nestedErrors.isNotEmpty) {
        return nestedErrors.join('\n');
      }
    }

    final humanParts = <String>[];
    if (exception.message.trim().isNotEmpty) {
      humanParts.add(_cleanTechnicalMessage(exception.message));
    }

    if (humanParts.isEmpty) {
      return 'La demande n’a pas pu être envoyée. Vérifiez les informations saisies.';
    }

    final combined = humanParts.join(' ');
    return combined.trim();
  }

  String _humanizeBackendPayload(Map<String, dynamic> payload) {
    final errors = payload['errors'];
    final flattened = _flattenErrorDetails(errors);
    if (flattened.isNotEmpty) {
      return flattened.join('\n');
    }

    final message = payload['message'];
    if (message is String && message.trim().isNotEmpty) {
      return _cleanTechnicalMessage(message);
    }

    final error = payload['error'];
    if (error is String && error.trim().isNotEmpty) {
      return _cleanTechnicalMessage(error);
    }

    return '';
  }

  List<String> _flattenErrorDetails(dynamic details) {
    final messages = <String>[];

    if (details is List) {
      for (final item in details) {
        if (item is String && item.trim().isNotEmpty) {
          messages.add(_cleanTechnicalMessage(item));
        } else if (item is Map) {
          messages.addAll(_flattenErrorDetails(item));
        }
      }
      return messages;
    }

    if (details is Map) {
      for (final entry in details.entries) {
        final value = entry.value;
        if (value is List) {
          for (final item in value) {
            if (item is String && item.trim().isNotEmpty) {
              messages.add(_formatValidationDetail(entry.key.toString(), item));
            } else if (item is Map) {
              messages.addAll(_flattenErrorDetails(item));
            }
          }
        } else if (value is String && value.trim().isNotEmpty) {
          messages.add(_formatValidationDetail(entry.key.toString(), value));
        } else if (value is Map) {
          messages.addAll(_flattenErrorDetails(value));
        }
      }
      return messages;
    }

    return messages;
  }

  Future<void> _showValidationSubmissionError(
    Object error, {
    required bool profileUpdated,
  }) {
    final message = _formatErrorMessage(error);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Demande non envoyée'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profileUpdated) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Profil mis à jour avec succès.',
                  style: TextStyle(
                    color: Color(0xFF065F46),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Corriger les informations'),
          ),
        ],
      ),
    );
  }

  String _formatValidationDetail(String field, String rawMessage) {
    const labels = <String, String>{
      'first_name': 'Le prénom',
      'last_name': 'Le nom',
      'email': 'L’adresse e-mail',
      'phone': 'Le numéro de téléphone',
      'birth_date': 'La date de naissance',
      'country': 'Le pays d’origine',
      'nationalite': 'La nationalité',
      'identity_number': 'Le numéro de pièce d’identité',
      'identity_front': 'La photo du recto de la pièce d’identité',
      'identity_back': 'La photo du verso de la pièce d’identité',
    };
    final label = labels[field] ?? 'Le champ « $field »';
    final message = rawMessage.trim().toLowerCase();

    if (message.contains('required') || message.contains('obligatoire')) {
      return '$label : veuillez joindre le document.';
    }
    if (message.contains('image') || message.contains('pdf')) {
      return '$label : le fichier doit être une image ou un PDF.';
    }
    if (message.contains('must be') || message.contains('invalid') || message.contains('format')) {
      return '$label contient une information invalide.';
    }
    if (message.contains('file') || message.contains('document')) {
      return '$label doit être un document valide.';
    }

    return _cleanTechnicalMessage(rawMessage);
  }

  String _cleanTechnicalMessage(String rawMessage) {
    var cleaned = rawMessage
        .replaceAll(RegExp(r'\[|\]|\{|\}|\(|\)'), '')
        .replaceAll('ValidationException', '')
        .replaceAll('DioException', '')
        .replaceAll('Exception', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleaned.isEmpty) {
      return 'La demande n’a pas pu être envoyée. Vérifiez les informations saisies.';
    }

    final missingField = RegExp(
      r'^veillez\s+renseigner\s+votre\s*:\s*(.+)$',
      caseSensitive: false,
    ).firstMatch(cleaned);
    if (missingField != null) {
      final field = missingField.group(1)!.trim();
      final humanField = field.isEmpty
          ? 'information'
          : '${field[0].toLowerCase()}${field.substring(1)}';
      return 'Veuillez renseigner votre $humanField.';
    }

    if (cleaned.contains('must not be empty') || cleaned.contains('is required')) {
      return 'Un ou plusieurs champs obligatoires sont manquants.';
    }

    if (cleaned.contains('already exists') || cleaned.contains('duplicate')) {
      return 'Une information saisie existe déjà. Vérifiez les données avant de réessayer.';
    }

    if (cleaned.contains('invalid') || cleaned.contains('format')) {
      return 'Le format d’une ou plusieurs informations est invalide. Vérifiez les champs.';
    }

    return cleaned;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "L'email est requis.";
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Email invalide.';
    }
    return null;
  }

  int _getCountryId(String countryName) {
    final normalized = countryName.trim().toLowerCase();
    final mapping = {
      'algérie': 12,
      'algerie': 12,
      'angola': 24,
      'bénin': 204,
      'benin': 204,
      'botswana': 72,
      'burkina faso': 854,
      'burundi': 108,
      'cameroun': 120,
      'cap-vert': 132,
      'cap vert': 132,
      'comores': 174,
      'congo-brazzaville': 178,
      'congo brazzaville': 178,
      'congo': 178,
      'congo-kinshasa': 180,
      'congo kinshasa': 180,
      'rdc': 180,
      'côte d’ivoire': 384,
      'cote d’ivoire': 384,
      'côte d ivoire': 384,
      'cote d ivoire': 384,
      'djibouti': 262,
      'egypte': 818,
      'erythrée': 232,
      'erythree': 232,
      'eswatini': 748,
      'swaziland': 748,
      'ethiopie': 231,
      'gabon': 266,
      'gambie': 270,
      'ghana': 288,
      'guinée': 324,
      'guinee': 324,
      'guinée-bissau': 624,
      'guinee-bissau': 624,
      'guinée équatoriale': 226,
      'guinee equatoriale': 226,
      'kenya': 404,
      'lesotho': 426,
      'liberia': 430,
      'libye': 434,
      'madagascar': 450,
      'malawi': 454,
      'mali': 466,
      'maroc': 504,
      'maurice': 480,
      'mauritanie': 478,
      'mozambique': 508,
      'namibie': 516,
      'niger': 562,
      'nigeria': 566,
      'ouganda': 800,
      'centrafrique': 140,
      'rwanda': 646,
      'sao tomé-et-principe': 678,
      'sao tome-et-principe': 678,
      'sénégal': 686,
      'senegal': 686,
      'seychelles': 690,
      'sierra leone': 694,
      'somalie': 706,
      'soudan': 729,
      'soudan du sud': 728,
      'tanzanie': 834,
      'tchad': 148,
      'togo': 768,
      'tunisie': 788,
      'zambie': 894,
      'zimbabwe': 716,
      'afrique du sud': 710,
    };
    return mapping[normalized] ?? 1;
  }

  static const List<_PhoneCountryOption> _africanCountries = [
    _PhoneCountryOption(name: 'Togo', shortName: 'TG', code: '+228', flag: '🇹🇬'),
    _PhoneCountryOption(name: 'Bénin', shortName: 'BJ', code: '+229', flag: '🇧🇯'),
    _PhoneCountryOption(name: 'Burkina Faso', shortName: 'BF', code: '+226', flag: '🇧🇫'),
    _PhoneCountryOption(name: 'Côte d’Ivoire', shortName: 'CI', code: '+225', flag: '🇨🇮'),
    _PhoneCountryOption(name: 'Ghana', shortName: 'GH', code: '+233', flag: '🇬🇭'),
    _PhoneCountryOption(name: 'Nigeria', shortName: 'NG', code: '+234', flag: '🇳🇬'),
    _PhoneCountryOption(name: 'Cameroun', shortName: 'CM', code: '+237', flag: '🇨🇲'),
    _PhoneCountryOption(name: 'Sénégal', shortName: 'SN', code: '+221', flag: '🇸🇳'),
    _PhoneCountryOption(name: 'Mali', shortName: 'ML', code: '+223', flag: '🇲🇱'),
    _PhoneCountryOption(name: 'Guinée', shortName: 'GN', code: '+224', flag: '🇬🇳'),
    _PhoneCountryOption(name: 'Congo', shortName: 'CG', code: '+242', flag: '🇨🇬'),
    _PhoneCountryOption(name: 'RDC', shortName: 'CD', code: '+243', flag: '🇨🇩'),
    _PhoneCountryOption(name: 'Gabon', shortName: 'GA', code: '+241', flag: '🇬🇦'),
    _PhoneCountryOption(name: 'Tchad', shortName: 'TD', code: '+235', flag: '🇹🇩'),
    _PhoneCountryOption(name: 'Mauritanie', shortName: 'MR', code: '+222', flag: '🇲🇷'),
    _PhoneCountryOption(name: 'Maroc', shortName: 'MA', code: '+212', flag: '🇲🇦'),
    _PhoneCountryOption(name: 'Algérie', shortName: 'DZ', code: '+213', flag: '🇩🇿'),
    _PhoneCountryOption(name: 'Tunisie', shortName: 'TN', code: '+216', flag: '🇹🇳'),
    _PhoneCountryOption(name: 'Égypte', shortName: 'EG', code: '+20', flag: '🇪🇬'),
    _PhoneCountryOption(name: 'Ethiopie', shortName: 'ET', code: '+251', flag: '🇪🇹'),
    _PhoneCountryOption(name: 'Kenya', shortName: 'KE', code: '+254', flag: '🇰🇪'),
  ];

  String _formatPhoneValue(String rawValue, String fieldKey) {
    final digits = rawValue.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return '';
    }
    final countryCode = _phoneCountryCodes[fieldKey] ?? '+228';
    return '$countryCode $digits';
  }

  Map<String, dynamic> _buildValidationPayload() {
    final username = _validationUsernameController.text.trim().isNotEmpty
        ? _validationUsernameController.text.trim()
        : _user.username;
    final matricule = _validationMatriculeController.text.trim().isNotEmpty
        ? _validationMatriculeController.text.trim()
        : _user.matricule;
    final phone = _formatPhoneValue(_validationPhoneController.text.trim(), 'phone');
    final whatsapp = _formatPhoneValue(_validationWhatsappController.text.trim(), 'whatsapp');
    final nationality = _validationNationalityController.text.trim();
    final country = _validationCountryController.text.trim();
    final contryIdValue = _getCountryId(nationality.isNotEmpty ? nationality : country);

    final payload = <String, dynamic>{
      'first_name': _validationFirstNameController.text.trim(),
      'last_name': _validationLastNameController.text.trim(),
      'email': _validationEmailController.text.trim(),
      'username': username,
      'matricule': matricule,
      'phone': phone,
      'gender': _selectedGender == null
          ? (_validationGenderController.text.trim().isNotEmpty ? _validationGenderController.text.trim() : 'Masculin')
          : (_selectedGender == ValidationGender.male ? 'Masculin' : 'Féminin'),
      'birth_date': _validationBirthDateController.text.trim(),
      'birth_place': _validationBirthPlaceController.text.trim(),
      'country': country,
      'nationalite': nationality,
      'skype': _validationSkypeController.text.trim(),
      'whatsapp': whatsapp,
      'situation_matri': _validationSituationMatrimonialController.text.trim(),
      'contry_id': contryIdValue,
      'identity_number': _validationIdentityNumberController.text.trim(),
      'permanent_postal_box': _validationPermanentPostalBoxController.text.trim(),
      'permanent_city': _validationPermanentCityController.text.trim(),
      'permanent_quarter': _validationPermanentQuarterController.text.trim(),
      'permanent_street': _validationPermanentStreetController.text.trim(),
      'permanent_home_phone': _formatPhoneValue(_validationPermanentHomePhoneController.text.trim(), 'permanent_home_phone'),
      'permanent_mobile': _formatPhoneValue(_validationPermanentMobileController.text.trim(), 'permanent_mobile'),
      'lome_postal_box': _validationLomePostalBoxController.text.trim(),
      'lome_city': _validationLomeCityController.text.trim(),
      'lome_quarter': _validationLomeQuarterController.text.trim(),
      'lome_street': _validationLomeStreetController.text.trim(),
      'lome_home_phone': _formatPhoneValue(_validationLomeHomePhoneController.text.trim(), 'lome_home_phone'),
      'lome_mobile': _formatPhoneValue(_validationLomeMobileController.text.trim(), 'lome_mobile'),
      'lome_email': _validationLomeEmailController.text.trim(),
      'emergency_name': _validationEmergencyNameController.text.trim(),
      'emergency_postal_box': _validationEmergencyPostalBoxController.text.trim(),
      'emergency_city': _validationEmergencyCityController.text.trim(),
      'emergency_quarter': _validationEmergencyQuarterController.text.trim(),
      'emergency_street': _validationEmergencyStreetController.text.trim(),
      'emergency_home_phone': _formatPhoneValue(_validationEmergencyHomePhoneController.text.trim(), 'emergency_home_phone'),
      'emergency_mobile': _formatPhoneValue(_validationEmergencyMobileController.text.trim(), 'emergency_mobile'),
      'emergency_email': _validationEmergencyEmailController.text.trim(),
      'prenompersoprev': _validationPrenomPersoPrevController.text.trim(),
      'identity_front': _validationIdentityFrontController.text.trim(),
      'identity_back': _validationIdentityBackController.text.trim(),
    };

    return payload;
  }

  Widget _buildAcademicSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_outlined, color: Color(0xFF1682F8)),
              SizedBox(width: 10),
              Text(
                'Informations académiques',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_academicInfo.year.isEmpty)
            const Text('Aucune information académique disponible.', style: TextStyle(color: Color(0xFF64748B)))
          else ...[
            _buildAcademicInfoRow('Année', _academicInfo.year),
            _buildAcademicInfoRow('Filière', _academicInfo.specialty),
            _buildAcademicInfoRow('Grade', _academicInfo.grade),
            _buildAcademicInfoRow('Groupe', _academicInfo.group),
            _buildAcademicInfoRow('Statut', _academicInfo.status),
          ],
        ],
      ),
    );
  }

  Widget _buildValidationRequestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFF1682F8)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Demande de validation',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Votre compte est en attente de validation. Renseignez toutes les informations demandées pour finaliser la procédure.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showValidationRequestSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1682F8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Demander la validation'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.lock_outline, size: 64, color: Color(0xFF1682F8)),
                  const SizedBox(height: 16),
                  const Text(
                    'Profil privé',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Vous n'êtes pas encore connecté. Connectez-vous pour accéder à votre profil et à vos informations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B), height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Se connecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1682F8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _isLoggedIn
              ? RefreshIndicator(
                  onRefresh: _loadProfileData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const ProfileHeader(),
                        Transform.translate(
                          offset: const Offset(0, -55),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ProfileCard(user: _user, onEdit: _showEditProfileSheet),
                                const SizedBox(height: 24),
                                ProfileSection(user: _user),
                                const SizedBox(height: 24),
                                ValidationProfileSection(user: _user),
                                const SizedBox(height: 24),
                                _buildAcademicSection(),
                                const SizedBox(height: 24),
                                if (_isUserRole()) ...[
                                  _buildValidationRequestCard(),
                                  const SizedBox(height: 24),
                                ],
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed: _showChangePasswordSheet,
                                    icon: const Icon(Icons.lock_reset_outlined),
                                    label: const Text('Changer le mot de passe'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed: _isLoggingOut
                                        ? null
                                        : () async {
                                            final navigator = Navigator.of(context);
                                            final messenger = ScaffoldMessenger.of(context);

                                            setState(() => _isLoggingOut = true);
                                            try {
                                              await _authService.logout();
                                              if (!mounted) {
                                                return;
                                              }
                                              navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                                            } catch (_) {
                                              if (!mounted) {
                                                return;
                                              }
                                              messenger.showSnackBar(
                                                const SnackBar(content: Text('Déconnexion effectuée localement.')),
                                              );
                                              navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                                            } finally {
                                              if (mounted) {
                                                setState(() => _isLoggingOut = false);
                                              }
                                            }
                                          },
                                    icon: const Icon(Icons.logout),
                                    label: _isLoggingOut ? const Text('Déconnexion...') : const Text('Se déconnecter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB91C1C),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                )
              : _buildGuestView(),
    );
  }
}

class _PhoneCountryOption {
  final String name;
  final String shortName;
  final String code;
  final String flag;

  const _PhoneCountryOption({required this.name, required this.shortName, required this.code, required this.flag});
}
