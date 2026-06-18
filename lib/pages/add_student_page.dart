// lib/pages/add_student_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student.dart';
import '../data/app_data.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input teks
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // State form
  late String _randomAvatar;
  String _selectedDomisili = domisiliList[0];
  bool _isConsentChecked = false;

  @override
  void initState() {
    super.initState();
    // Avatar dipilih secara acak saat halaman dibuka
    _randomAvatar = avatarList[Random().nextInt(avatarList.length)];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Validasi berhasil — buat objek Student baru
      final newStudent = Student(
        name: _nameController.text.trim(),
        avatar: _randomAvatar,
        domisili: _selectedDomisili,
        phone: _phoneController.text.trim(),
      );
      // Kirim kembali ke HomePage
      Navigator.pop(context, newStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          'Tambah Mahasiswa',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Avatar Preview ──────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: NetworkImage(_randomAvatar),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Avatar dipilih secara acak',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Nama ─────────────────────────────────────────────────
              Text('Nama Lengkap',
                  style: textTheme.labelLarge
                      ?.copyWith(color: colorScheme.onSurface)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ── Domisili ──────────────────────────────────────────────
              Text('Domisili',
                  style: textTheme.labelLarge
                      ?.copyWith(color: colorScheme.onSurface)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDomisili,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                items: domisiliList
                    .map((domisili) => DropdownMenuItem(
                          value: domisili,
                          child: Text(domisili),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDomisili = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ── Nomor HP ──────────────────────────────────────────────
              Text('Nomor HP',
                  style: textTheme.labelLarge
                      ?.copyWith(color: colorScheme.onSurface)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Contoh: 081234567890',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  if (value.length < 9) {
                    return 'Nomor HP tidak valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── Checkbox Persetujuan ───────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: _isConsentChecked
                      ? colorScheme.primaryContainer.withOpacity(0.4)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isConsentChecked
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: CheckboxListTile(
                  value: _isConsentChecked,
                  onChanged: (value) {
                    setState(() {
                      _isConsentChecked = value ?? false;
                    });
                  },
                  title: Text(
                    'Saya menyatakan bahwa data yang saya masukkan adalah benar.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  activeColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 32),

              // ── Tombol Submit ─────────────────────────────────────────
              FilledButton(
                // Disabled selama checkbox belum dicentang
                onPressed: _isConsentChecked ? _submit : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Simpan Mahasiswa',
                  style: textTheme.titleMedium?.copyWith(
                    color: _isConsentChecked
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withOpacity(0.38),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
