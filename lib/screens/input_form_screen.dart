import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sprints_firebase_task/screens/widgets/gradient_background.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({super.key});

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'hobby': _hobbyController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    _hobbyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Information Form',
          style: GoogleFonts.cairoPlay(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _ageController,
                    label: 'Age',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _hobbyController,
                    label: 'Favorite Hobby',
                    icon: Icons.sports_soccer,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _nameController,
                        builder: (context, nameValue, _) {
                          return ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _ageController,
                            builder: (context, ageValue, _) {
                              return ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _hobbyController,
                                builder: (context, hobbyValue, _) {
                                  final isValid = nameValue.text.isNotEmpty &&
                                      ageValue.text.isNotEmpty &&
                                      hobbyValue.text.isNotEmpty;

                                  return FilledButton.icon(
                                    icon: _isSaving
                                        ? SizedBox(
                                            height: 15,
                                            width: 15,
                                            child:
                                                const CircularProgressIndicator(),
                                          )
                                        : const Icon(Icons.save),
                                    label: Text(
                                        _isSaving ? 'Saving...' : 'Save Data'),
                                    onPressed: isValid && !_isSaving
                                        ? _saveData
                                        : null,
                                  );
                                },
                              );
                            },
                          );
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.list),
                          label: const Text('View List'),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/display'),
                        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.cairoPlay(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Age' && int.tryParse(value) == null) {
          return 'Please enter a valid age';
        }
        return null;
      },
    );
  }
}
