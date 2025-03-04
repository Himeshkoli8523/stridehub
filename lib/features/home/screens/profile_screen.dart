// lib/features/home/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';
import 'package:stridehub/routes/app_routes.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isEditing = false;
  String _gender = 'Male';
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        if (mounted) {
          setState(() {
            _fullNameController.text = userDoc['fullName'];
            _phoneNumberController.text = userDoc['phoneNumber'];
            _dobController.text = userDoc['dob'];
            _gender = userDoc['gender'];
            _heightController.text = userDoc['height'];
            _weightController.text = userDoc['weight'];
            _email = user.email ?? '';
          });
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_validateFields()) {
      User? user = _auth.currentUser;
      if (user != null) {
        double heightInCm;
        if (_heightUnit == 'feet') {
          List<String> heightParts = _heightController.text.split('\'');
          int feet = int.tryParse(heightParts[0].trim()) ?? 0;
          int inches =
              int.tryParse(heightParts[1].replaceAll('"', '').trim()) ?? 0;
          heightInCm = (feet * 30.48) + (inches * 2.54);
        } else {
          heightInCm = double.tryParse(_heightController.text) ?? 0;
        }
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'dob': _dobController.text,
          'gender': _gender,
          'height': heightInCm.toString(),
          'heightUnit': _heightUnit,
          'weight': _weightController.text,
        }).then((_) {
          if (mounted) {
            setState(() {
              _isEditing = false;
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $error')),
          );
        });
      }
    }
  }

  bool _validateFields() {
    if (_fullNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
      return false;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(_fullNameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Full Name should contain only letters')),
      );
      return false;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(_phoneNumberController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone Number should be 10 digits')),
      );
      return false;
    }
    return true;
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate!);
    });
    }

  void _convertHeight() {
    if (_heightUnit == 'cm') {
      double heightInCm = double.tryParse(_heightController.text) ?? 0;
      int feet = (heightInCm / 30.48).floor();
      int inches = ((heightInCm / 2.54) % 12).round();
      _heightController.text = '$feet\' $inches"';
      _heightUnit = 'feet';
    } else {
      List<String> heightParts = _heightController.text.split('\'');
      int feet = int.tryParse(heightParts[0].trim()) ?? 0;
      int inches = int.tryParse(heightParts[1].replaceAll('"', '').trim()) ?? 0;
      double heightInCm = (feet * 30.48) + (inches * 2.54);
      _heightController.text = heightInCm.toStringAsFixed(2);
      _heightUnit = 'cm';
    }
  }

  void _convertWeight() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    if (_weightUnit == 'kg') {
      weight = weight * 2.20462; // Convert kg to pounds
      _weightUnit = 'pound';
    } else {
      weight = weight / 2.20462; // Convert pounds to kg
      _weightUnit = 'kg';
    }
    _weightController.text = weight.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.dosis(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/default_profile.png'),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileField('Full Name', _fullNameController),
            _buildProfileField('Email', TextEditingController(text: _email),
                readOnly: true),
            _buildProfileField('Phone Number', _phoneNumberController),
            _buildDateField('Date of Birth', _dobController),
            _buildGenderField('Gender', _genderController),
            _buildHeightField('Height', _heightController),
            _buildWeightField('Weight', _weightController),
            SizedBox(height: 20),
            if (_isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.buttonColor,
                    foregroundColor: AppColors.buttonTextColor,
                    minimumSize: Size(double.infinity, 50), // Full width button
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (!_isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.red, // Ensure visibility
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50), // Full width button
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: !_isEditing
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: Icon(Icons.edit),
            )
          : null,
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: _isEditing && !readOnly
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: AppColors.captionColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              style: TextStyle(color: AppColors.textColor),
              keyboardType: label == 'Phone Number'
                  ? TextInputType.phone
                  : TextInputType.text,
            )
          : Card(
              child: ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.captionColor,
                  ),
                ),
                subtitle: Text(
                  controller.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: _isEditing
          ? GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(color: AppColors.captionColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(color: AppColors.textColor),
                ),
              ),
            )
          : Card(
              child: ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.captionColor,
                  ),
                ),
                subtitle: Text(
                  controller.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildGenderField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: _isEditing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.captionColor,
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
              ],
            )
          : Card(
              child: ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.captionColor,
                  ),
                ),
                subtitle: Text(
                  _gender,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeightField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: _isEditing
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: TextStyle(color: AppColors.captionColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: TextStyle(color: AppColors.textColor),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _heightUnit,
                  items: ['cm', 'feet'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _convertHeight();
                    });
                  },
                ),
              ],
            )
          : Card(
              child: ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.captionColor,
                  ),
                ),
                subtitle: Text(
                  '${controller.text} $_heightUnit',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildWeightField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: _isEditing
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: TextStyle(color: AppColors.captionColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: TextStyle(color: AppColors.textColor),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _weightUnit,
                  items: ['kg', 'pound'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _convertWeight();
                    });
                  },
                ),
              ],
            )
          : Card(
              child: ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.captionColor,
                  ),
                ),
                subtitle: Text(
                  '${controller.text} $_weightUnit',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
    );
  }
}
