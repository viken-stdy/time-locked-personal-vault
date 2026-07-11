# Time-Locked Personal Vault

## 📋 Deskripsi
Kontrak pintar berbasis Solidity untuk jaringan Ethereum. Berfungsi sebagai brankas penyimpanan yang dapat mengunci ETH selama jangka waktu yang ditentukan. Dana hanya dapat ditarik setelah masa penguncian selesai.

## ✨ Fitur Utama
- Hanya pemilik kontrak yang dapat melakukan setoran dan penarikan dana
- Durasi penguncian dapat diatur saat kontrak dibuat
- Dana terkunci sepenuhnya dan tidak bisa ditarik sebelum waktunya habis
- Menampilkan informasi sisa waktu penguncian
- Mengikuti standar keamanan Solidity versi 0.8.20

## 🛠️ Cara Penggunaan
1. Pasang kontrak dengan memasukkan lama waktu kunci dalam satuan detik
2. Lakukan setoran sejumlah ETH
3. Tunggu hingga masa kunci berakhir
4. Tarik kembali seluruh dana yang tersimpan

## 🧪 Pengujian
Kontrak sudah diuji secara lengkap menggunakan Remix IDE, seluruh fungsi berjalan sesuai aturan yang ditetapkan.
