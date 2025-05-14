import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kostgo/favorite/pembayaran1.dart';
import 'package:kostgo/themes/colors_theme.dart'; // pastikan file ini sudah benar

class AjukanSewa extends StatefulWidget {
  const AjukanSewa({super.key});

  @override
  State<AjukanSewa> createState() => _AjukanSewaState();
}

class _AjukanSewaState extends State<AjukanSewa> {
  TextEditingController namaController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController nokamarController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController namakostController = TextEditingController();

  String? selectedGender;
  String? selectedDurasi;
  DateTime? selectedTanggalMasuk;

  List<String> genderList = ['Laki-laki', 'Perempuan'];

  List<String> generateDurasiList() {
    return List.generate(12, (i) {
      final bulan = i + 1;
      final harga = bulan * 500000;
      final hargaFormatted = harga.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
      return '$bulan bulan, Rp$hargaFormatted';
    });
  }

  Future<void> pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalMasuk ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedTanggalMasuk = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Ajukan Sewa",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: namaController,
              decoration:
                  const InputDecoration(labelText: "Masukkan Nama Anda"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(labelText: "Jenis Kelamin"),
              items: genderList.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notelpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Nomor Telepon"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nokamarController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: alamatController,
              decoration: const InputDecoration(labelText: "Alamat"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Nama Kost"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDurasi,
              decoration: const InputDecoration(labelText: "Durasi Sewa"),
              items: generateDurasiList().map((durasi) {
                return DropdownMenuItem(value: durasi, child: Text(durasi));
              }).toList(),
              onChanged: (value) => setState(() => selectedDurasi = value),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                selectedTanggalMasuk == null
                    ? 'Pilih Tanggal Masuk'
                    : 'Tanggal Masuk: ${selectedTanggalMasuk!.day}/${selectedTanggalMasuk!.month}/${selectedTanggalMasuk!.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pilihTanggal(context),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Pembayaran1()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlueColor,
                side: const BorderSide(color: darkBlueColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Bayar",
                style: GoogleFonts.inter(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
