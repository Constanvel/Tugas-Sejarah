# Rencana implementasi Bandung 1946 — Garis Pertahanan

Tanggal: 15 Oktober 2026. Sumber kebutuhan: docs/prd.md versi 1.0 yang diberikan Rainer di percakapan. Seluruh fase di bawah mengikuti PRD; hanya Phase 1 dikerjakan pada tugas ini.

## Kondisi awal

- Folder kerja awal D:/Tugas-sejarah berisi proyek kosong di sejarah/project.godot.
- Repositori Git berada di sejarah/Tugas-Sejarah dan awalnya hanya melacak README.md.
- Godot terpasang: 4.7.2.stable.official.ed1daf0bf. Tidak tersedia melalui PATH; gunakan executable lengkap atau variabel PowerShell.
- Tidak ada scene, script, tileset, pengujian, atau dependensi lama yang perlu dimigrasikan.
- Implementasi dibuat di akar repositori Tugas-Sejarah agar seluruh sumber dapat dilacak Git. Proyek kosong di folder induk dipertahankan.
- Branch kerja: codex/phase-1-foundation. Commit dan push dilakukan pengguna.

## Keputusan fondasi

1. Godot 4.7.2 dan GDScript tanpa plugin. Renderer Compatibility dipilih untuk game 2D dan laptop sekolah; tidak memerlukan Forward+ atau fitur 3D.
2. Viewport 640 x 360, window 1280 x 720, stretch viewport dengan skala integer, aspect keep, texture nearest. Letterbox menjaga proporsi ketika window berbeda ukuran.
3. CharacterBody2D, CollisionShape2D, Camera2D. Input.get_vector menormalkan diagonal; kecepatan 100 px/detik. Collision pada kaki agar berjalan dekat bangunan terasa wajar.
4. Satu map 1600 x 720 dengan tiga kawasan placeholder yang tersambung. Kamera dibatasi pada map; empat dinding fisika mencegah keluar map. Semua kawasan masih dapat dieksplorasi tanpa sistem misi.
5. Placeholder orisinal berupa SVG dengan bentuk pada grid piksel dan bidang warna datar. Belum ada tileset final, sehingga gunakan Sprite2D, Polygon2D, dan scene properti StaticBody2D. Ganti lantai ke TileMapLayer ketika tileset Rama siap.
6. Menu berbasis Control dan tombol native Godot dengan fokus keyboard. Semua teks Bahasa Indonesia. ESC serta Resume/Lanjutkan, Restart/Ulangi, Main Menu/Menu Utama disiapkan sebagai bagian lifecycle fondasi; restart sekarang mengulang seluruh map karena belum ada area aktif/misi.
7. Tidak ada autoload atau manager kosong. SceneTree menangani perpindahan scene dan pause. Fitur Phase 2/3 memperoleh script sendiri ketika benar-benar diperlukan.
8. E dan J dicadangkan dalam Input Map sesuai PRD, tetapi belum mengaktifkan interaksi/aksi. Petunjuk gameplay Phase 1 hanya menampilkan kontrol yang sudah berfungsi.

## Phase 1 — Project Foundation (tugas saat ini)

### Langkah 1: sumber dan konfigurasi

- Simpan PRD, rencana ini, daftar aset dan referensi sejarah.
- Buat konfigurasi, gitignore, README dan input WASD/ESC.
- Tulis tes CLI sebelum implementasi scene: harus gagal karena scene belum tersedia.

### Langkah 2: player dan lingkungan

- scenes/player.tscn dan scripts/player.gd: gerak delapan arah, berhenti saat tidak ada input, melepas input saat window kehilangan fokus.
- Camera2D sebagai anak player, batas 0..1600 dan 0..720 tanpa smoothing agar pixel art tajam.
- scenes/props/house.tscn, tree.tscn, crate.tscn: StaticBody2D, sprite dan shape; collision hanya pada bagian solid yang relevan.
- scenes/main_game.tscn: lantai, jalan penghubung, properti dan empat batas; spawn aman di jalan, bukan di dalam collider.
- Uji gerak setiap arah, diagonal, kombinasi berlawanan, berhenti, fokus, collision bangunan/pohon/peti, sudut, batas, dan kamera.

### Langkah 3: alur aplikasi

- scenes/main_menu.tscn dan scripts/main_menu.gd: Mulai Permainan/Keluar, fokus keyboard, penanganan kegagalan perubahan scene.
- scripts/main_game.gd: pause/resume/restart/menu, HUD petunjuk Phase 1 dengan CanvasLayer, fokus tombol saat pause.
- Uji tombol Mulai, ESC, pause menghentikan fisika, resume, restart memulihkan spawn, menu kembali tanpa status pause tertinggal, dan Exit melalui proses CLI terpisah.

### Langkah 4: verifikasi dan dokumentasi

- Impor headless editor, jalankan seluruh tes integrasi GDScript, smoke test entry point, muat semua scene dan aset.
- Periksa hasil render menu/gameplay/pause pada resolusi acuan bila renderer tersedia; simpan bukti dan bedakan dari playtest input fisik.
- Catat perintah, exit code, jumlah pemeriksaan, keterbatasan, serta matriks penerimaan pada docs/phase1_report.md.
- Definition of Done: pemain berjalan di map tanpa menembus solid, kamera mengikuti, menu berfungsi, tidak ada error fatal. Jangan mulai Phase 2 pada tugas ini.

## Phase 2 — Core Gameplay (belum dikerjakan)

Prasyarat: Phase 1 stabil dan diverifikasi; kerjakan pada tugas berikutnya.

- Area2D untuk objek interaktif; E hanya berfungsi dalam jangkauan, indikator kedekatan, satu pemicu per input.
- Dialogue panel dan data/dialogues.json; gerak/aksi berhenti ketika dialog menguasai input.
- HP 3, damage dan invincibility singkat; J jarak dekat dengan cooldown 0,5 detik, satu jenis enemy HP 1.
- Dua enemy pada area konflik, pendekatan lurus dalam arena terbuka, satu animasi aksi dasar dan feedback non-grafis. Tidak ada pathfinding kompleks.
- Game Over menghentikan gameplay; Retry memulihkan area aktif dan state konsisten. Mulai dengan state area eksplisit, tanpa save permanen.
- Uji TC-04/05/08/09, jangkauan, cooldown, invincibility, enemy berhenti, dialog vs movement, dan retry berulang. Ulangi suite Phase 1.
- Selesai ketika interaksi, tantangan, HP dan retry bekerja. Belum menyatakan cerita lengkap.

## Phase 3 — Mission & Story (belum dikerjakan)

- data/missions.json dan scripts/mission_manager.gd: LOCKED/ACTIVE/COMPLETED, tepat satu misi aktif, urutan 1 > 2 > 3 > ending.
- Mission 1: ambil pesan lalu serahkan di pos; Mission 2: dua lawan selesai lalu gerbang terbuka; Mission 3: berbicara dengan warga statis lalu pengungsian.
- Objective HUD, narasi/dialog Bahasa Indonesia, trigger sekali, gerbang fisik terkunci sebelum syarat terpenuhi.
- Retry mengulang area aktif dengan inventory pesan/state misi yang sesuai, tanpa meloloskan objective.
- Ending dengan narasi 23–24 Maret 1946, konteks ultimatum/pengungsian/pembumihangusan, pemisahan fakta dan fiksi, referensi, credits, tombol menu.
- Uji TC-06/07/11/12, urutan yang salah, trigger berulang dan retry di ketiga area. Mainkan awal sampai akhir tanpa editor.
- Fakta dan naskah diperiksa Fahkri menggunakan sumber PRD sebelum dianggap final.

## Phase 4 — Art & Polish (belum dikerjakan)

- Integrasikan tileset 16 x 16 dan sprite 16 x 24 dari Rama, pertahankan collision dan framing; gunakan TileMapLayer bila aset tersedia.
- Idle/walk/action minimum player/enemy. Suasana senja/malam dan cahaya kemerahan, tanpa siklus waktu dinamis.
- Raja memasang tiga ambience (menu/gameplay/ending) dan empat SFX (aksi/damage/interaksi/misi); catat lisensi dan seimbangkan volume.
- Polish HUD, dialog, tiga ikon HP, Game Over/ending dan transisi sederhana. Sesuaikan kesulitan dan durasi 10–15 menit berdasarkan playtest.
- Audit semua P0 sebelum fitur P1. Uji keterbacaan 640 x 360/1280 x 720, keyboard, audio dan regresi semua alur.
- Selesai ketika semua P0 dan aset utama tersedia serta game dapat ditamatkan.

## Phase 5 — Testing & Release (belum dikerjakan)

- Keempat anggota menjalankan TC-01 sampai TC-13, mencatat bug, durasi dan kesulitan; perbaiki blocker dan ulangi skenario terdampak.
- Fahkri memeriksa kronologi, klaim fakta/fiksi, tiga sumber PRD dan teks ending. Catat sumber yang belum berhasil diakses.
- Periksa template ekspor yang benar-benar tersedia dan cocok 4.7.2. Buat preset Windows dan ekspor hanya bila template tersedia.
- Uji executable Windows secara offline tanpa editor, pada laptop sekolah; ukur performa mendekati 60 FPS, bukan hanya hasil headless.
- README penggunaan, kontrol, credits/lisensi, ringkasan kontribusi, alur demonstrasi guru dan daftar keterbatasan.
- Selesai ketika build Windows mandiri dapat dimainkan sampai ending dan seluruh anggota dapat menjelaskan kontribusinya.

## Cakupan dan risiko

- Tidak membuat enemy, interaksi, HP, mission manager, audio, Game Over atau ending pada Phase 1.
- Folder assets/audio, assets/tilesets, data dan builds baru dibuat ketika memiliki konten; tidak menambah file kosong untuk fitur mendatang.
- Tidak ada perubahan pada API/caller lama karena repo hanya memiliki README. Seluruh caller baru: main menu > main game > player/props, serta tes yang memuat scene yang sama.
- Pergantian scene memeriksa Error; pause direset sebelum restart/menu agar pemain tidak terjebak.
- Uji automated keyboard injection tidak membuktikan pengalaman tombol fisik, performa perangkat sekolah, atau build ekspor Windows.
