// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import '../models/student.dart';
import '../data/app_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inisialisasi daftar mahasiswa dari data awal yang disediakan
  late List<Student> _students;

  @override
  void initState() {
    super.initState();
    _students = initialStudentsData
        .map((data) => Student.fromMap(data))
        .toList();
  }

  // Navigasi ke halaman Tambah Mahasiswa, tunggu hasilnya
  Future<void> _goToAddPage() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null && result is Student) {
      setState(() {
        _students.add(result);
      });
    }
  }

  // Navigasi ke halaman Profile, kirim data mahasiswa + jumlah total
  Future<void> _goToProfilePage(Student student) async {
    final result = await Navigator.pushNamed(
      context,
      '/profile',
      arguments: {
        'student': student,
        'totalStudents': _students.length,
      },
    );

    // Jika hasil dari Profile adalah perintah hapus
    if (result != null && result is Map && result['action'] == 'delete') {
      setState(() {
        _students.remove(result['student']);
      });
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
          'Student Directory',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Text(
              '${_students.length} Mahasiswa Terdaftar',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimary.withOpacity(0.85),
              ),
            ),
          ),
        ),
      ),
      body: _students.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined,
                      size: 64, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada mahasiswa.\nTambahkan dengan tombol + di bawah.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: _students.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return _StudentCard(
                    student: student,
                    onTap: () => _goToProfilePage(student),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddPage,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        tooltip: 'Tambah Mahasiswa',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const _StudentCard({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: NetworkImage(student.avatar),
                onBackgroundImageError: (_, __) {},
                child: null,
              ),
              const SizedBox(height: 12),
              // Nama
              Text(
                student.name,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Domisili
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: colorScheme.primary),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      student.domisili,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
