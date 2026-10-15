# Verifikasi aset karakter

Tanggal: 15 Oktober 2026. Engine: Godot 4.7.2.stable.official.ed1daf0bf. Tugas hanya membuat artwork karakter, sumber yang dapat diregenerasi, manifest dan preview; tidak mengintegrasikan gameplay.

## Hasil aktual

| Pemeriksaan | Hasil | Bukti |
|---|---|---|
| Tes sebelum implementasi | Tiga PNG belum ada; exit 1, checks=3 failures=3 | Dijalankan sebelum generator karakter dibuat |
| Generate karakter | Tujuh PNG dan satu manifest; exit 0 | qa_determinism.txt |
| Generate ulang | Delapan berkas memiliki SHA-256 identik sebelum/sesudah | qa_determinism.txt |
| Cocok dengan sumber | png=7 failures=0, exit 0 | qa_generator.txt |
| Tes karakter | checks=116 failures=0, exit 0 | qa_characters.txt |
| Impor Godot | Tiga PNG dunia diimpor tanpa error; exit 0 | qa_import.txt |
| Pipeline fondasi | checks=52 failures=0, exit 0 | qa_foundation.txt |
| Generator fondasi | png=5 failures=0, exit 0 | qa_foundation_generator.txt |
| Regresi Phase 1 | checks=45 failures=0, exit 0 | qa_gameplay.txt |
| Review | Tidak ada finding konkret tersisa | Review kode, sumber, metadata, preview dan log secara read-only |

Tes karakter memeriksa dua atlas 48 x 96 dan satu PNG statis 16 x 24, urutan Down/Left/Right/Up serta Idle/Walk A/Walk B, tujuh warna PRD, alpha biner, transparansi, siluet tidak kosong/terpotong, kaki pada baris y=22, kepala tetap di tempat, perbedaan tubuh/kaki minimal antar-pose, arah idle berbeda dan pemuatan Texture2D Godot.

Preview 8x diperiksa per piksel terhadap sumber agar pembesaran benar-benar nearest. Semua 25 frame memiliki margin transparan; tidak ada sprite yang menyentuh batas frame. Posisi pivot dalam manifest sama: (8,23). Latar kotak, label dan garis baseline hanya ada pada contact sheet.

Sumber tidak valid yang diuji mencakup ID/path tidak sah, pose kosong, nomor baris di luar frame, perubahan kepala saat berjalan, baseline kaki yang salah dan metadata fungsi yang hilang. Kasus metadata hilang diuji merah, lalu validator diperbaiki sebelum suite akhir hijau.

## Pemeriksaan visual

Contact sheet dan preview individual diperiksa setelah render. Pada iterasi pertama, langkah depan tampak terlalu mengangkat lutut. Ayunan diperpendek dan lengan/torso dirapikan sebelum keluaran akhir. Aksen terang terisolasi pada seragam lawan dihapus. Kepala player memiliki pita merah-putih; lawan memakai helm polos tanpa insignia; warga menggunakan siluet kain panjang.

Ini inspeksi frame/contact sheet, bukan klaim pengujian AnimatedSprite2D di gameplay. Belum ada perubahan pada scene untuk memakai PNG baru. Tidak ada animasi aksi atau delapan arah visual yang dibuat di luar permintaan.

## Integritas proyek

Tidak ada perubahan pada scripts/ atau scenes/. Hash sebelum/sesudah project.godot, player.gd, main_game.gd, player.tscn dan main_game.tscn sama. project.godot sudah dimodifikasi editor sebelum tugas ini dan dipertahankan; SHA-256-nya B01CBD9436C2EAC6FD0AA940B4226E0588CBE0112E03EA74305D10BF7EEF81BC.

Berkas baru:

- assets/art_sources/characters.json
- tools/generate_characters.gd dan metadata .gd.uid
- tests/character_assets_test.gd dan metadata .gd.uid
- assets/sprites/characters/player.png, enemy.png, civilian.png, tiga metadata .png.import, dan manifest.json
- docs/art/characters/README.md, qa_report.md, empat PNG preview/contact sheet, serta log qa_*.txt

Berkas yang diperbarui: README.md, docs/art/README.md dan docs/asset_credits.md. Generator fondasi serta output lamanya tidak diedit. Tidak ada commit atau push otomatis.

## Template Git

Branch yang diperiksa: codex/phase-1-foundation. Remote origin: https://github.com/Constanvel/Tugas-Sejarah.git. Template mengecualikan perubahan project.godot milik pengguna.

```powershell
cd 'D:\Tugas-sejarah\sejarah\Tugas-Sejarah'
git status --short
git branch --show-current
git add -- assets/art_sources/characters.json assets/sprites/characters tools/generate_characters.gd tools/generate_characters.gd.uid tests/character_assets_test.gd tests/character_assets_test.gd.uid docs/art/characters docs/art/README.md docs/asset_credits.md README.md
git diff --cached --stat
git commit -m "feat: add directional character spritesheets"
git push -u origin codex/phase-1-foundation
```

## Batas hasil

Aset sederhana untuk MVP sudah memenuhi struktur teknis yang diminta. Pakaian dan karakter adalah desain fiktif, bukan klaim rekonstruksi seragam tertentu. Animasi aksi, integrasi scene, uji kecepatan animasi dalam permainan dan build Windows belum dikerjakan pada tugas aset ini.
