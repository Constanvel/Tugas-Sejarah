# Hasil verifikasi fondasi pipeline aset

Tanggal: 15 Oktober 2026. Engine yang digunakan: Godot 4.7.2.stable.official.ed1daf0bf, executable console pada path yang tercantum di README art.

## Hasil aktual

| Pemeriksaan | Hasil | Bukti |
|---|---|---|
| Impor editor headless | Exit 0 | qa_import.txt |
| Generator | Lima PNG dan manifest berhasil ditulis, exit 0 | qa_determinism.txt |
| Pengulangan generator | SHA-256 kelima PNG dan manifest identik sebelum/sesudah generate ulang | qa_determinism.txt |
| Cocok dengan sumber | mode=check png=5 failures=0, exit 0 | qa_generator_check.txt |
| Suite aset | checks=52 failures=0, exit 0 | qa_pipeline.txt |
| Regresi Phase 1 | checks=45 failures=0, exit 0 | qa_gameplay_regression.txt |
| Inspeksi visual | Guide 640 x 360 diperiksa; label terbaca, dimensi tercantum, checker hanya pada preview. Referensi AI diperiksa terpisah | style_guide.png, atmosphere_reference_ai.png |

Suite memeriksa PNG yang bisa dibaca, dimensi tepat, tujuh warna RGB tanpa warna antara, alpha 0/255, siluet tidak kosong, transparansi karakter/peti, tile yang tepinya cocok, nilai swatch sesuai PRD dan pemuatan tiga PNG studi sebagai Texture2D Godot. Referensi AI juga dibaca dan dimensi 1536 x 1024 diperiksa terhadap metadata terpisah. Gambar AI tidak dinyatakan memenuhi batas tujuh warna.

Sumber invalid yang diuji: jumlah warna kurang, simbol duplikat/hilang, hex tidak valid, ID mengandung path, ukuran karakter salah, simbol piksel tidak dikenal, bidang di luar frame, koordinat pecahan, pivot di luar frame dan dua jenis sumber gambar sekaligus.

## Temuan yang diselesaikan

- Sebelum generator dibuat, tes gagal sesuai harapan karena manifest belum tersedia.
- JSON menyimpan angka sebagai float; pengecekan dimensi generator diperbaiki agar mengonversi angka yang sudah divalidasi bulat sebelum membandingkan ukuran frame.
- Pembacaan PNG mentah lewat Image.load pada res:// menimbulkan peringatan ekspor. Pemeriksaan sumber beralih ke FileAccess.get_file_as_bytes dan Image.load_png_from_buffer; pengujian Texture2D tetap menggunakan load resource. Output akhir tidak memuat peringatan tersebut.
- Review menemukan simbol palet bisa diganti menjadi simbol yang tidak dikenali komposisi guide. Tes M menjadi X dijalankan dan gagal, kemudian validator diperbaiki untuk memastikan D/W/B/O/M/R/C tersedia sebelum penulisan. Tes akhir lulus, finding ditutup melalui review kode dan log.

## Integritas scope

- Script gameplay dan semua scene tidak diedit pada tugas ini. Input, movement, collision, kamera dan menu masih memakai sumber serta aset Phase 1.
- project.godot sudah memiliki perubahan normalisasi dari editor sebelum pekerjaan dimulai. SHA-256 sebelum/sesudah tugas sama: B01CBD9436C2EAC6FD0AA940B4226E0588CBE0112E03EA74305D10BF7EEF81BC. File tersebut tidak dimasukkan ke template staging tugas aset.
- README.md dan docs/asset_credits.md diperbarui. File baru berada di assets/art_sources, assets/generated, tools/generate_assets.gd, tests/asset_pipeline_test.gd dan docs/art, termasuk metadata .uid/.png.import hasil Godot.
- Branch tetap codex/phase-1-foundation. Tidak melakukan commit atau push. PRD tidak diubah.

## Batas hasil

Belum ada animasi, arah karakter lengkap, tileset lengkap, bangunan final, UI baru atau efek. Ketiga studi belum diintegrasikan ke scene gameplay. Belum dilakukan uji performa, build Windows, playtest fisik, maupun validasi arsip arsitektur tahun 1946. Hasil merupakan fondasi teknis dan studi visual sederhana, bukan klaim ilustrasi atau paket aset profesional final.

## Template Git untuk perubahan tugas aset saja

```powershell
cd 'D:\Tugas-sejarah\sejarah\Tugas-Sejarah'
git status --short
git branch --show-current
git add -- README.md docs/asset_credits.md docs/art assets/art_sources assets/generated tools/generate_assets.gd tools/generate_assets.gd.uid tests/asset_pipeline_test.gd tests/asset_pipeline_test.gd.uid
git diff --cached --stat
git commit -m "feat: add visual asset pipeline foundation"
git push -u origin codex/phase-1-foundation
```

Template ini mengasumsikan branch codex/phase-1-foundation masih aktif. Periksa perubahan yang sudah pernah di-stage sendiri sebelum commit; template tidak menghapus staging milik pengguna.
