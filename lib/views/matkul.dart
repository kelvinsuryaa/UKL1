import 'package:flutter/material.dart';
import 'package:ukl_login/models/matkul_model.dart';
import 'package:ukl_login/services/matkul_service.dart';

class MataKuliah extends StatefulWidget {
  const MataKuliah({super.key});

  @override
  State<MataKuliah> createState() => _MatkulViewState();
}

class _MatkulViewState extends State<MataKuliah> {
  Future<List<MatkulModel>>? futureMatkul;
  Map<int, bool> selectedMap = {};

  @override
  void initState() {
    super.initState();
    futureMatkul = MatkulService().getMatkul();
  }

  Future<void> simpanTerpilih() async {
    final snapshot = await futureMatkul;
    if (snapshot == null) return;

    final selectedMatkulList = snapshot
        .where((matkul) => selectedMap[matkul.id] == true)
        .map(
          (matkul) => {
            'id': matkul.id.toString(),
            'nama_matkul': matkul.nama_matkul,
            'sks': matkul.sks,
          },
        )
        .toList();

    if (selectedMatkulList.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Peringatan'),
          content: Text('Pilih minimal satu mata kuliah terlebih dahulu.'),
        ),
      );
      return;
    }

    try {
      final response = await MatkulService().selectMatkul({
        'list_matkul': selectedMatkulList,
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(response.status ? 'Berhasil' : 'Gagal'),
          content: Text(response.message ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Terjadi kesalahan'),
          content: Text('Gagal menyimpan mata kuliah: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Mata Kuliah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF5563DE),
        foregroundColor: Colors.white,
        elevation: 6,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF5563DE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<MatkulModel>>(
          future: futureMatkul,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Data mata kuliah kosong',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final data = snapshot.data!;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: DataTable(
                          columnSpacing: 70,
                          dataRowHeight: 70,
                          headingRowHeight: 70,
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFFF5F5F5),
                          ),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: const Text('ID', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 260,
                                child: const Text('Mata Kuliah', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: const Text('SKS', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: const Text('Pilih', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                          rows: data.map((matkul) {
                            final isSelected = selectedMap[matkul.id] ?? false;
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      matkul.id.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 280,
                                    child: Text(
                                      matkul.nama_matkul ?? '-',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      matkul.sks?.toString() ?? '-',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: Checkbox(
                                      focusColor: const Color(0xFF5563DE),
                                      activeColor: const Color(0xFF5563DE),
                                      value: isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedMap[matkul.id!] = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: simpanTerpilih,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5563DE),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black38,
                        ),
                        child: const Text(
                          'Simpan yang Terpilih',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
