import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppkd_b6/api_3/models/batch_model.dart';
import 'package:ppkd_b6/api_3/models/training_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';
import 'package:ppkd_b6/api_3/views/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _jenisKelamin = 'L';
  String? _errorMessage;

  // Data dropdown dari API
  bool _isLoadingOptions = true;
  String? _optionsError;
  List<Batch> _batches = [];
  List<Training> _trainings = [];
  int? _selectedBatchId;
  int? _selectedTrainingId;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoadingOptions = true;
      _optionsError = null;
    });
    try {
      final results = await Future.wait([
        _authService.getBatches(),
        _authService.getTrainings(),
      ]);
      if (!mounted) return;
      setState(() {
        _batches = results[0] as List<Batch>;
        _trainings = results[1] as List<Training>;
        _selectedBatchId = _batches.isNotEmpty ? _batches.first.id : null;
        _selectedTrainingId =
            _trainings.isNotEmpty ? _trainings.first.id : null;
        _isLoadingOptions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _optionsError = 'Gagal memuat data batch/pelatihan: $e';
        _isLoadingOptions = false;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBatchId == null || _selectedTrainingId == null) {
      setState(() => _errorMessage = 'Batch dan Pelatihan wajib dipilih');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        jenisKelamin: _jenisKelamin,
        batchId: _selectedBatchId!,
        trainingId: _selectedTrainingId!,
      );

      if (!mounted) return;
      // Register berhasil → ke HomePage (token sudah tersimpan)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Terjadi kesalahan';
      if (data != null) {
        if (data['message'] != null) {
          msg = data['message'];
        }
        if (data['errors'] != null) {
          final errors = data['errors'] as Map;
          msg = errors.values.first.first;
        }
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      setState(() => _errorMessage = 'Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildOptionsSection() {
    if (_isLoadingOptions) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Memuat data batch & pelatihan...',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (_optionsError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_optionsError!,
              style: const TextStyle(color: Colors.red, fontSize: 13)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _loadOptions,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Muat Ulang'),
          ),
        ],
      );
    }

    return Column(
      children: [
        // Pelatihan
        DropdownButtonFormField<int>(
          value: _selectedTrainingId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Pelatihan',
            prefixIcon: const Icon(Icons.school_outlined),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          items: _trainings
              .map((t) => DropdownMenuItem(
                    value: t.id,
                    child: Text(t.title ?? 'Pelatihan ${t.id}',
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedTrainingId = v),
          validator: (v) => v == null ? 'Pilih pelatihan' : null,
        ),
        const SizedBox(height: 16),

        // Batch
        DropdownButtonFormField<int>(
          value: _selectedBatchId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Batch',
            prefixIcon: const Icon(Icons.group_outlined),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          items: _batches
              .map((b) => DropdownMenuItem(
                    value: b.id,
                    child: Text(
                        b.batchKe != null ? 'Batch ${b.batchKe}' : 'Batch ${b.id}',
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedBatchId = v),
          validator: (v) => v == null ? 'Pilih batch' : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Daftar Akun'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Header
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Lengkapi data diri Anda',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Error message
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade600, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Nama
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nama Lengkap',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Email wajib diisi';
                            }
                            if (!v.contains('@')) return 'Email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password wajib diisi';
                            }
                            if (v.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Jenis Kelamin
                        DropdownButtonFormField<String>(
                          value: _jenisKelamin,
                          decoration: InputDecoration(
                            labelText: 'Jenis Kelamin',
                            prefixIcon:
                                const Icon(Icons.wc_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                            DropdownMenuItem(
                                value: 'P', child: Text('Perempuan')),
                          ],
                          onChanged: (v) =>
                              setState(() => _jenisKelamin = v ?? 'L'),
                        ),
                        const SizedBox(height: 16),

                        // Batch & Training (dropdown dari API)
                        _buildOptionsSection(),
                        const SizedBox(height: 24),

                        // Tombol Register
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Daftar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Link ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? ',
                      style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
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
