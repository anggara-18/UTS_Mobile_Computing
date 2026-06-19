import 'package:flutter/material.dart';
import '../models/student.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data yang dikirim dari HomePage via arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Student student = args['student'] as Student;
    final int totalStudents = args['totalStudents'] as int;

    // Tombol hapus disabled jika jumlah mahasiswa tepat 3
    final bool canDelete = totalStudents > 3;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    void handleDelete() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Hapus Mahasiswa'),
          content: Text(
              'Yakin ingin menghapus ${student.name} dari daftar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup dialog
                // Kirim sinyal hapus ke HomePage
                Navigator.pop(context, {
                  'action': 'delete',
                  'student': student,
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          //  AppBar dengan foto di header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // Foto avatar besar
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: colorScheme.surface,
                      backgroundImage: NetworkImage(student.avatar),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(height: 16),
                    // Nama mahasiswa
                    Text(
                      student.name,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          //  Body: detail info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Kartu informasi
                  Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: Icons.person,
                          label: 'Nama Lengkap',
                          value: student.name,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                        Divider(
                            height: 1,
                            color: colorScheme.outlineVariant),
                        _InfoTile(
                          icon: Icons.location_on,
                          label: 'Domisili',
                          value: student.domisili,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                        Divider(
                            height: 1,
                            color: colorScheme.outlineVariant),
                        _InfoTile(
                          icon: Icons.phone,
                          label: 'Nomor HP',
                          value: student.phone,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tombol kembali ke daftar
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali ke Daftar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tombol hapus — disabled jika totalStudents == 3
                  FilledButton.icon(
                    onPressed: canDelete ? handleDelete : null,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(
                      canDelete
                          ? 'Hapus Akun Ini'
                          : 'Tidak Dapat Dihapus (Min. 3 Mahasiswa)',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      disabledBackgroundColor:
                          colorScheme.errorContainer.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Info kenapa disabled
                  if (!canDelete) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Daftar harus memiliki minimal 3 mahasiswa.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget helper untuk baris info
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isLast;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
