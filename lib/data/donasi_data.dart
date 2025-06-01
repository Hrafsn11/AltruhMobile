import '../models/donasi.dart';

class DonasiData {
  static final List<Donasi> _riwayat = [
    Donasi(
      tipe: 'Barang',
      judul: 'Pakaian Layak Pakai',
      tanggal: '11 Mei 2025',
      deskripsi: 'Berisi pakaian anak-anak dan dewasa dalam kondisi baik.',
    ),
    Donasi(
      tipe: 'Uang',
      judul: 'Donasi Ramadan',
      tanggal: '10 Mei 2025',
      deskripsi: 'Transfer donasi senilai Rp200.000 untuk kegiatan sosial.',
    ),
    Donasi(
      tipe: 'Emosional',
      judul: 'Motivasi untuk Anak Yatim',
      tanggal: '9 Mei 2025',
      deskripsi: 'Pesan motivasi dan semangat untuk anak-anak panti asuhan.',
    ),
  ];

  /// Tambahkan donasi baru ke dalam riwayat
  static void tambahDonasi(Donasi donasi) {
    _riwayat.add(donasi);
  }

  /// Ambil semua riwayat donasi
  static List<Donasi> semua() {
    return _riwayat;
  }

  /// Alias ke semua() untuk kompatibilitas lama
  static List<Donasi> getRiwayat() {
    return semua();
  }
}
