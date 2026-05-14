import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../services/api_service.dart';
import '../utils/glass_box.dart';

class SubmitTaskScreen extends StatefulWidget {
  const SubmitTaskScreen({super.key});

  @override
  State<SubmitTaskScreen> createState() => _SubmitTaskScreenState();
}

class _SubmitTaskScreenState extends State<SubmitTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController(text: 'Dikirim dari aplikasi Flutter');
  final _githubUrlController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _submitTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final name = _nameController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final description = _descriptionController.text.trim();
      final githubUrl = _githubUrlController.text.trim();

      final result = await _apiService.submitTask(name, price, description, githubUrl);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ZoomIn(
              duration: const Duration(milliseconds: 300),
              child: AlertDialog(
                backgroundColor: AppColors.bgDark2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                ),
                contentPadding: const EdgeInsets.all(32),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 100),
                    const SizedBox(height: 24),
                    const Text(
                      'Mission Accomplished!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tugas berhasil dikirim ke dashboard asisten!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Go back to catalog
                        },
                        child: const Text('AWESOME!'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'], style: const TextStyle(color: Colors.white)),
              backgroundColor: AppColors.accent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Submit Task', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgDark1, AppColors.bgDark2, AppColors.bgDark3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.rocket_launch, color: AppColors.accent),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Final Submission! Make sure your GitHub URL is public and correct.',
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: GlassBox(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: glassInputDecoration('Product Name', Icons.title),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter a product name';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: glassInputDecoration('Price', Icons.monetization_on).copyWith(
                              prefixText: 'Rp ',
                              prefixStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter a price';
                              if (int.tryParse(value) == null) return 'Please enter a valid integer price';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 2,
                            style: const TextStyle(color: Colors.white),
                            decoration: glassInputDecoration('Description', Icons.description),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter a description';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _githubUrlController,
                            keyboardType: TextInputType.url,
                            style: const TextStyle(color: Colors.white),
                            decoration: glassInputDecoration('GitHub URL', Icons.link),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your GitHub repository URL';
                              if (!value.startsWith('http://') && !value.startsWith('https://')) {
                                return 'Please enter a valid URL (http/https)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                foregroundColor: Colors.black,
                                shadowColor: Colors.greenAccent.withOpacity(0.5),
                              ),
                              onPressed: _isLoading ? null : _submitTask,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.send_rounded),
                                        SizedBox(width: 8),
                                        Text('SUBMIT FINAL TASK', style: TextStyle(letterSpacing: 1.2)),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _githubUrlController.dispose();
    super.dispose();
  }
}
