# Laporan Phase 1 — Project Foundation

Tanggal pengujian: 15 Oktober 2026. Sumber kebutuhan: docs/prd.md versi 1.0. Status: fondasi diimplementasikan dan lulus verifikasi otomatis serta inspeksi gambar render; playtest anggota tim masih diperlukan. Phase 2 belum dikerjakan.

## Kondisi awal dan lokasi proyek

- Proyek kosong ditemukan di D:/Tugas-sejarah/sejarah/project.godot. Proyek itu belum mempunyai main scene, player, menu atau map.
- Repo Git berada satu tingkat di bawahnya, D:/Tugas-sejarah/sejarah/Tugas-Sejarah, awalnya hanya README.md, commit fa11efd, branch main, remote origin https://github.com/Constanvel/Tugas-Sejarah.git.
- PRD belum ada di disk saat pemeriksaan pertama; implementasi baru dimulai setelah Rainer memberikan seluruh isinya. PRD disimpan ke docs/prd.md dengan normalisasi format.
- Proyek yang dikerjakan adalah project.godot di akar repo Tugas-Sejarah. Proyek induk dipertahankan; jangan salah memilihnya pada Project Manager.
- Godot CLI yang diverifikasi: 4.7.2.stable.official.ed1daf0bf, executable console pada C:/Users/IDEAPAD SLIM 3/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe.
- Branch kerja dibuat: codex/phase-1-foundation. Tidak ada commit atau push otomatis.

## Fitur yang dibuat

1. Main menu dengan judul, Mulai Permainan dan Keluar. Fokus awal pada Mulai, navigasi keyboard native Godot, teks Bahasa Indonesia.
2. CharacterBody2D dengan input WASD delapan arah, Input.get_vector untuk normalisasi diagonal, kecepatan 100 px/detik dan move_and_slide. Collider hanya pada kaki.
3. Camera2D mengikuti player tanpa smoothing; batas (0,0)..(1600,720) mencegah kamera menampilkan area di luar map.
4. Satu map placeholder 1600 x 720 dengan permukiman, kawasan konflik dan jalur pengungsian. Jalur utama menghubungkan semua kawasan; belum ada gerbang misi.
5. Rumah, pohon dan peti berupa instance scene StaticBody2D; empat dinding fisika di tepi map. Sorting berdasarkan koordinat Y untuk kedalaman visual.
6. ESC pause/resume, tombol Lanjutkan, Ulangi Peta dan Menu Utama. Fisika player berhenti ketika pause, status pause direset saat berpindah scene. Ulangi mengembalikan seluruh map ke spawn awal.
7. Resolusi internal 640 x 360, window awal 1280 x 720, integer viewport scaling dan texture nearest. Renderer Compatibility berjalan pada Intel UHD Graphics.
8. Lima placeholder SVG orisinal dan theme UI mengikuti warna PRD. Tidak ada aset unduhan atau dependensi plugin.
9. PRD, rencana seluruh lima fase, referensi sejarah, daftar aset, README, tes dan bukti CLI/render.

Keputusan kecil beserta alasannya tercatat pada docs/implementation_plan.md. Fitur untuk fase mendatang tidak dibuat sebagai script/manager kosong.

## Berkas yang dibuat atau diubah

README.md adalah satu-satunya berkas lama yang dimodifikasi. Semua berkas di bawah dibuat pada tugas ini:

| Kelompok | Berkas |
|---|---|
| Konfigurasi | project.godot, .gitignore, .gitattributes, .editorconfig |
| Scene | scenes/main_menu.tscn, scenes/main_game.tscn, scenes/player.tscn |
| Properti | scenes/props/house.tscn, scenes/props/tree.tscn, scenes/props/crate.tscn |
| Script | scripts/player.gd, scripts/main_menu.gd, scripts/main_game.gd |
| Aset | assets/sprites/player.svg, house.svg, tree.svg, crate.svg, ground.svg; assets/ui/theme.tres |
| Dokumen | docs/prd.md, docs/implementation_plan.md, docs/history_references.md, docs/asset_credits.md, docs/phase1_report.md, docs/.gdignore |
| Pengujian | tests/phase1_test.gd, tests/menu_exit_test.gd, tests/render_preview.gd |
| Bukti gambar | docs/qa/main_menu.png, main_menu_640.png, gameplay.png, area2.png, area3.png, pause.png |
| Bukti CLI | docs/qa/cli_import.txt, cli_tests.txt, cli_exit.txt, cli_smoke.txt, cli_render.txt |

Godot juga menghasilkan pasangan .gd.uid untuk keenam script dan .svg.import untuk kelima SVG. Metadata ini disertakan dalam sumber Git. Cache .godot diabaikan. docs/.gdignore mencegah bukti QA diimpor sebagai aset game.

## Perintah dan hasil aktual

Semua perintah dijalankan dari akar repo menggunakan executable Godot di atas. Berikut bentuk ringkas dengan variabel $GodotExe; nilai lengkap dan instruksi tersedia di README.

| Pengujian | Perintah | Hasil |
|---|---|---|
| Versi terpasang | & $GodotExe --version | 4.7.2.stable.official.ed1daf0bf; exit 0 |
| Impor editor | & $GodotExe --headless --path . --editor --import --quit | Exit 0, tidak ada SCRIPT ERROR/ERROR pada output akhir |
| Integrasi fondasi | & $GodotExe --headless --path . --script tests/phase1_test.gd --fixed-fps 60 | PHASE1_RESULT checks=45 failures=0; exit 0 |
| Tombol Keluar | & $GodotExe --headless --path . --script tests/menu_exit_test.gd | Fokus Tab lalu Enter, EXIT_BUTTON_ACTIVATED, aplikasi keluar dengan exit 0 |
| Entry point normal | & $GodotExe --headless --path . --quit-after 120 | Menu berjalan 120 frame lalu exit 0; tanpa script error |
| Render asli/UI | & $GodotExe --path . --script tests/render_preview.gd --fixed-fps 60 --rendering-method gl_compatibility | OpenGL 3.3 Intel UHD; enam PNG 640 x 360 tersimpan; WINDOW_SIZE 1280 x 720 dan 640 x 360; VISUAL_RESULT failures=0; exit 0 |

Output aktual disimpan dalam docs/qa/cli_*.txt. Screenshot berasal dari viewport asli Godot, bukan mockup. Main menu, gameplay dan pause diperiksa secara visual; geometri Control/Label diuji programatis pada menu dan UI gameplay/pause. Kamera berpindah ke area 2/3 untuk bukti map tambahan.

## Cakupan skenario PRD

| Skenario | Status Phase 1 dan bukti |
|---|---|
| TC-01 Start | Lulus otomatis dengan event Enter pada tombol yang difokuskan; scene gameplay terbuka |
| TC-02 WASD | Lulus empat arah dan empat diagonal; jarak 30 physics tick sekitar 50 px pada 60 Hz |
| TC-03 Collision | Lulus rumah, batang pohon, peti, keempat batas, serta kontak dan meluncur melewati sudut rumah |
| TC-10 ESC | Lulus buka pause, fisika berhenti, tombol resume dan ESC kedua melanjutkan |
| TC-12 Main Menu | Lulus dari pause, scene menu terbuka dan status pause bersih |
| Restart fondasi | Lulus Ulangi Peta, spawn dipulihkan; ini belum menguji Retry area aktif TC-09 |
| Kamera | Lulus mengikuti di tengah dan dibatasi pada keempat tepi |
| Input tambahan | Lulus berhenti ketika tombol dilepas, arah berlawanan saling meniadakan, input dilepas saat kehilangan fokus |
| Map tersambung | Lulus berjalan sepanjang jalan utama hingga kawasan ketiga |
| Keluar dan fokus | Lulus fokus awal Mulai, Tab ke Keluar, Enter menutup aplikasi |
| TC-04/05/06/07/08/09/11 | Belum berlaku: interaksi, misi, HP, Game Over, Retry dan ending belum diimplementasikan |
| TC-13 Windows mandiri | Belum dijalankan; ekspor termasuk fase release |

Tes mengirim InputEventKey ke Godot dan menjalankan scene/physics asli, bukan mock gerak. Beberapa tombol pause diaktifkan melalui signal pressed untuk memeriksa wiring/lifecycle. Pengujian ini tidak menggantikan playtest keyboard/mouse fisik.

## Temuan yang diperbaiki

- Tes awal sengaja gagal karena main_menu.tscn belum tersedia (PHASE1_RESULT checks=1 failures=1), lalu implementasi dibuat.
- Ada kesalahan API pada penanganan kehilangan fokus: Input.release_pressed_events tidak tersedia pada engine ini. Diganti dengan Input.action_release untuk empat aksi gerak; suite akhir lulus dan script dapat diinstansiasi.
- Review menemukan tes awal sudut tidak menyentuh rumah. Lintasan diperbaiki ke W+A, lalu tes memeriksa slide collision benar-benar terjadi sebelum pemain melewati ujung collider. Kedua pemeriksaan kini lulus.
- Review read-only sesudah perbaikan menutup finding tersebut dan tidak menemukan blocker Phase 1 lain. Reviewer membaca kode dan log; tidak mengulang playtest fisik.

## Pengujian manual di Godot

1. Import D:/Tugas-sejarah/sejarah/Tugas-Sejarah/project.godot menggunakan Godot 4.7.2.
2. Tekan F5, pilih Mulai dengan mouse atau Enter.
3. Coba W/A/S/D dan seluruh kombinasi diagonal. Lepas tombol; pemain harus berhenti.
4. Dekati rumah pertama di atas spawn, pohon dan peti. Berjalan menempel pada sisi/sudut; karakter tidak menembus bagian solid atau tersangkut.
5. Ikuti jalan ke kanan hingga kawasan ketiga; jelajahi atas/bawah sampai batas. Player tetap di dalam map, kamera berhenti di tepi.
6. Tekan ESC saat bergerak; posisi harus berhenti. Coba Lanjutkan, Ulangi Peta, ESC dua kali, dan Menu Utama.
7. Dari menu, Tab berpindah ke Keluar, Enter menutup aplikasi. Coba juga klik mouse pada tombol.
8. Periksa panel Debugger/Output; catat error beserta langkah reproduksi jika ada.

## Batas verifikasi dan pekerjaan berikutnya

- Tidak ada blocker yang diketahui pada skenario fondasi yang diuji. Tes otomatis tidak membuktikan seluruh kemungkinan posisi collision.
- Belum dilakukan playtest oleh anggota tim, input keyboard/mouse fisik, alt-tab nyata, pengukuran 60 FPS pada perangkat sekolah, atau pengujian resolusi lain.
- Tidak membuat build Windows. Folder template standar %APPDATA%/Godot/export_templates/4.7.2.stable tidak ditemukan pada pemeriksaan. Tidak memasang/mengunduh template.
- Sumber sejarah di PRD sudah dicatat, tetapi halaman web/buku belum diperiksa langsung. Belum ada naskah sejarah final di game; map adalah fiktif.
- Aset masih placeholder satu pose; animasi lengkap dan audio menunggu fase berikutnya.
- Phase 2, seluruh misi dan MVP lengkap belum dikerjakan. Berikutnya: tim mencoba Phase 1, lalu tugas Phase 2 mengimplementasikan interaksi/dialog, HP, aksi arcade, enemy dan Game Over/Retry sesuai rencana.
