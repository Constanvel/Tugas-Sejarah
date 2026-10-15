# Bandung 1946 — Garis Pertahanan

Game edukasi sejarah 2D top-down, single-player dan offline. Sumber kebutuhan: [PRD versi 1.0](docs/prd.md). Saat ini baru Phase 1 — Project Foundation; cerita, misi, interaksi dan combat belum tersedia.

## Membuka proyek

1. Gunakan Godot 4.7.2 Stable yang terpasang pada komputer pengembangan.
2. Di Project Manager pilih Import, lalu pilih project.godot di folder repositori Tugas-Sejarah ini.
3. Tekan F6 untuk menjalankan scene yang dibuka atau F5 untuk menjalankan menu utama proyek. Untuk alur lengkap gunakan F5.
4. Pilih Mulai Permainan. Gunakan WASD untuk berjalan; diagonal boleh menggunakan dua tombol.
5. Tekan ESC untuk jeda. Lanjutkan mengembalikan gameplay, Ulangi Peta mengembalikan posisi awal, Menu Utama kembali ke menu. Keluar menutup aplikasi.

Path pada komputer pengembangan:

```text
D:\Tugas-sejarah\sejarah\Tugas-Sejarah\project.godot
```

Perhatikan: proyek kosong lama di D:\Tugas-sejarah\sejarah\project.godot adalah proyek berbeda. Buka berkas di dalam repositori, bukan yang di folder induk.

## Fitur fondasi

- CharacterBody2D, kecepatan 100 px/detik dengan delapan arah dan diagonal ternormalisasi.
- Camera2D mengikuti pemain dan dibatasi pada map 1600 x 720.
- Satu map placeholder dengan permukiman, kawasan konflik dan jalur pengungsian, seluruhnya dapat dieksplorasi pada fase ini.
- Collision kaki player, bangunan, batang pohon, peti dan empat batas luar map.
- Menu dan pause dengan navigasi keyboard Tab/panah serta Enter/Space; seluruh teks game berbahasa Indonesia.
- Resolusi internal 640 x 360, window awal 1280 x 720, skala integer dan nearest-neighbor.
- Renderer Compatibility, tanpa plugin/dependensi tambahan atau koneksi internet.

E dan J baru dicadangkan dalam Input Map. Belum ada interaksi, serangan, HP, enemy atau misi. Ulangi Peta belum sama dengan Retry area aktif pada Phase 2/3.

## Struktur dan cara mengedit

```text
project.godot                 Pengaturan, entry point dan input
scenes/main_menu.tscn         Menu utama
scenes/main_game.tscn         Map, batas, properti dan pause UI
scenes/player.tscn            Player, collider kaki dan kamera
scenes/props/                Rumah, pohon dan peti yang dapat dipakai ulang
scripts/                     Tiga script: player, main_menu, main_game
assets/sprites/              Lima placeholder SVG orisinal
assets/ui/theme.tres         Tema warna dan tombol UI
docs/                       PRD, rencana, laporan, referensi dan credits
docs/qa/                    Screenshot renderer dan hasil CLI
tests/                      Tes integrasi, tombol Keluar dan render/UI
```

Map dapat diedit melalui editor 2D: pindahkan instance House/Tree/Crate atau duplikasikan dengan Ctrl+D. Jalur utama berada pada y=304..416. Saat mengubah ukuran map, sesuaikan empat Bounds, bidang Ground dan limit Camera2D di player.tscn. Player dimulai pada (192, 360), posisi aman di jalan.

Node MainGame berjalan saat pause agar menerima ESC; Player memakai process mode Pausable secara eksplisit. Saat menambah aktor bergerak pada fase berikutnya, gunakan mode Pausable juga agar fisikanya berhenti saat jeda.

Tidak ada tileset final; map memakai bidang warna dan sprite. Rama dapat mengganti aset secara bertahap. Ukuran player 16 x 24, peti 32 x 32, pohon 48 x 64, rumah 128 x 96; collision properti dapat disunting langsung pada scene masing-masing. Daftar aset/lisensi: [asset_credits.md](docs/asset_credits.md).

Simpan berkas .gd.uid dan .svg.import yang dihasilkan Godot ke Git bersama sumbernya. Cache .godot dan keluaran builds diabaikan.

## Pengujian CLI

PowerShell, dari folder repositori:

```powershell
$GodotExe = 'C:\Users\IDEAPAD SLIM 3\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $GodotExe --version
& $GodotExe --headless --path . --editor --import --quit
& $GodotExe --headless --path . --script tests/phase1_test.gd --fixed-fps 60
& $GodotExe --headless --path . --script tests/menu_exit_test.gd
& $GodotExe --headless --path . --quit-after 120
```

Periksa $LASTEXITCODE segera sesudah masing-masing perintah. Suite fondasi yang berhasil mencetak PHASE1_RESULT checks=45 failures=0; tes Keluar mencetak EXIT_BUTTON_ACTIVATED lalu exit 0, dan exit 1 jika tombol gagal menutup aplikasi dalam 3 detik. Periksa juga output SCRIPT ERROR/ERROR: exit code Godot saja tidak cukup untuk menyimpulkan bebas script error.

Bukti visual dan pengecekan geometri UI memerlukan renderer asli dan membuka window sementara:

```powershell
& $GodotExe --path . --script tests/render_preview.gd --fixed-fps 60 --rendering-method gl_compatibility
```

Perintah ini memperbarui enam PNG di docs/qa. Screenshot adalah viewport internal 640 x 360; window diuji pada 1280 x 720 dan 640 x 360. Hasil detail dan batas pengujian: [laporan Phase 1](docs/phase1_report.md).

## Rencana berikutnya

Fondasi pipeline aset visual tersedia di [docs/art/README.md](docs/art/README.md): palet tujuh warna, generator GDScript yang dapat dijalankan ulang, manifest PNG dan satu style guide teknis. Baru tiga studi kecil; aset gameplay Phase 1 tetap memakai SVG lama. Referensi suasana AI disimpan terpisah dan tidak dianggap atlas siap pakai.

[Rencana implementasi lima fase](docs/implementation_plan.md) menjelaskan urutan dan Definition of Done setiap fase. Phase 2 baru dimulai pada tugas berikutnya setelah fondasi diterima: interaksi/dialog, HP, aksi arcade, enemy, Game Over dan Retry. Build Windows serta pemeriksaan fakta sejarah lengkap termasuk tahap release; fondasi ini belum menjadi MVP lengkap.

## Template Git

Semua perubahan masih lokal, belum di-commit atau di-push. Jalankan setelah meninjau hasil:

```powershell
cd 'D:\Tugas-sejarah\sejarah\Tugas-Sejarah'
git status --short
git branch --show-current
git add -- .editorconfig .gitattributes .gitignore README.md project.godot assets scenes scripts tests docs
git diff --cached --stat
git commit -m "feat: implement Phase 1 project foundation"
git push -u origin codex/phase-1-foundation
```

Template menggunakan branch codex/phase-1-foundation yang telah dibuat. Pastikan branch tersebut masih aktif sebelum commit/push. Tidak perlu force push. Remote origin yang diperiksa: https://github.com/Constanvel/Tugas-Sejarah.git.
