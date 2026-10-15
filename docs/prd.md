# PRODUCT REQUIREMENTS DOCUMENT (PRD)

# BANDUNG 1946 — GARIS PERTAHANAN

Versi: 1.0
Status: Initial Development Specification
Jenis Proyek: Game Edukasi Sejarah Indonesia
Genre: 2D Top-Down Action Adventure / Historical War
Game Engine: Godot 4.x Stable
Bahasa Pemrograman: GDScript
Platform: PC Windows
Art Style: Retro Pixel Art
Mode Permainan: Single-player, Offline
Target Durasi Gameplay: 10–15 Menit
Tim Pengembang: 4 Siswa
AI Development Assistant: OpenAI Codex

Catatan penyimpanan: PRD ini berasal dari teks lengkap yang diberikan Rainer pada 15 Oktober 2026. Format daftar dan penekanan dinormalisasi tanpa mengubah kebutuhan. PRD adalah sumber utama kebutuhan; status implementasi dilaporkan terpisah.

## 1. PROJECT OVERVIEW

### 1.1 Deskripsi Produk

Bandung 1946 — Garis Pertahanan adalah game edukasi sejarah Indonesia bergenre 2D top-down action adventure yang mengangkat peristiwa Bandung Lautan Api pada Maret 1946.

Pemain berperan sebagai seorang pejuang muda fiktif yang menjalankan beberapa misi selama proses perjuangan dan pengungsian masyarakat Bandung.

Game menggabungkan eksplorasi, pertarungan arcade sederhana, interaksi objek, dan penyampaian informasi sejarah.

Konsep permainan dirancang agar mudah dimainkan oleh pelajar serta dapat dikembangkan oleh tim kecil dengan pengalaman pemrograman yang masih terbatas.

### 1.2 Latar Belakang

Pembelajaran sejarah sering dilakukan melalui buku, teks, dan penjelasan guru. Game ini bertujuan memberikan pendekatan pembelajaran alternatif dengan menghadirkan peristiwa sejarah dalam bentuk pengalaman interaktif.

Pemain tidak hanya membaca informasi, tetapi menjalankan misi yang membantu memahami situasi dan tantangan masyarakat pada masa perjuangan kemerdekaan.

### 1.3 Tujuan Produk

1. Mengenalkan peristiwa Bandung Lautan Api kepada pemain.
2. Menggabungkan pembelajaran sejarah dengan permainan interaktif.
3. Mengembangkan game 2D yang sederhana tetapi menarik.
4. Memberikan pengalaman eksplorasi dan pertarungan arcade.
5. Menghasilkan proyek yang dapat dipresentasikan dan dijelaskan oleh kelompok siswa.

### 1.4 Target Pengguna

- Pelajar SMP, SMA, dan SMK.
- Pengguna yang tertarik dengan sejarah Indonesia.
- Pemain kasual yang menyukai game pixel art.
- Pemain yang menyukai game aksi 2D berdurasi singkat.

Target usia utama: 13 tahun ke atas.

## 2. HISTORICAL BACKGROUND

### 2.1 Peristiwa Sejarah

Game mengangkat peristiwa Bandung Lautan Api yang terjadi pada 23–24 Maret 1946.

Peristiwa ini berlangsung setelah meningkatnya ketegangan antara pasukan Republik Indonesia dengan pasukan Sekutu dan Belanda (NICA).

Pada Maret 1946, Sekutu menyampaikan ultimatum agar pasukan Indonesia meninggalkan Bandung Selatan.

Dalam perkembangan peristiwa tersebut, dilakukan pengungsian masyarakat dan pembumihangusan sejumlah kawasan Bandung agar fasilitasnya tidak digunakan oleh pihak lawan.

### 2.2 Pendekatan Sejarah

Game menggunakan pendekatan historical fiction.

Artinya:

- Latar waktu dan peristiwa utama mengikuti sejarah nyata.
- Karakter utama merupakan tokoh fiktif.
- Percakapan dan misi merupakan dramatisasi untuk kebutuhan gameplay.
- Tidak mengubah hasil peristiwa sejarah yang sesungguhnya.
- Tidak mengklaim misi atau pertempuran fiktif sebagai kejadian yang benar-benar terdokumentasi.
- Informasi sejarah disampaikan melalui dialog, catatan, dan layar penutup.

### 2.3 Sumber Referensi

Sumber 1: Direktorat Jenderal Kebudayaan

Judul: Peristiwa Bandung Lautan Api

https://kebudayaan.kemdikbud.go.id/peristiwa-bandung-lautan-api/

Digunakan untuk referensi kronologi, latar belakang konflik, ultimatum, dan pengungsian.

Sumber 2: Ensiklopedia Sejarah Indonesia

Judul: Bandung Lautan Api

https://esi.kemenbud.go.id/wiki/Bandung_Lautan_Api

Digunakan untuk referensi peristiwa sejarah serta dampaknya.

Sumber 3: Sejarah Nasional Indonesia VI

Penulis: Marwati Djoened Poesponegoro dan Nugroho Notosusanto.

Digunakan sebagai referensi tambahan untuk memeriksa keakuratan narasi.

## 3. GAME DESIGN

### 3.1 Core Gameplay

Game menggunakan perspektif top-down dengan karakter yang dapat bergerak ke empat arah dan diagonal.

Pemain menjelajahi lingkungan Bandung tahun 1946, menyelesaikan misi, berinteraksi dengan objek, dan menghadapi tantangan arcade sederhana.

Game tidak menggunakan open-world.

Seluruh gameplay berlangsung dalam satu level utama yang terbagi menjadi tiga area.

### 3.2 Core Gameplay Loop

1. Pemain menerima tujuan misi.
2. Pemain mengeksplorasi area.
3. Pemain berinteraksi dengan objek atau karakter.
4. Pemain menyelesaikan tantangan.
5. Sistem memeriksa penyelesaian misi.
6. Misi berikutnya terbuka.
7. Pemain mencapai ending sejarah.

### 3.3 Kontrol Pemain

| Input | Fungsi |
|---|---|
| W | Bergerak ke atas |
| A | Bergerak ke kiri |
| S | Bergerak ke bawah |
| D | Bergerak ke kanan |
| E | Interaksi |
| J | Aksi pertarungan arcade |
| ESC | Pause / Resume |

Karakter bergerak menggunakan sistem 8-direction movement.

Gerakan diagonal harus dinormalisasi agar kecepatan tetap konsisten.

## 4. STORYLINE & MISSION DESIGN

### 4.1 Premis Cerita

Bandung, 24 Maret 1946.

Ketegangan meningkat setelah ultimatum yang disampaikan oleh pasukan Sekutu.

Di tengah persiapan pengungsian, seorang pejuang muda menerima tugas untuk menyampaikan pesan penting kepada kelompok pejuang.

Dalam perjalanannya, ia harus melewati kawasan yang tidak aman, menghadapi rintangan, dan membantu warga yang bersiap meninggalkan kota.

Ketika malam tiba, pemain menyaksikan suasana Bandung yang berubah akibat peristiwa pembumihangusan.

Cerita berakhir ketika pemain berhasil mencapai tempat pengungsian.

### 4.2 Struktur Cerita

Game terdiri dari tiga misi utama.

#### MISSION 1 — PESAN DARI BANDUNG

Estimasi durasi: 3–4 menit.

Objective: Menyampaikan pesan kepada pos kelompok pejuang.

Alur:

1. Pemain muncul di kawasan permukiman.
2. Teks narasi menjelaskan kondisi Bandung.
3. Pemain menerima pesan melalui interaksi dengan objek.
4. Pemain mengikuti jalan menuju pos pejuang.
5. Pemain berinteraksi dengan pos untuk menyampaikan pesan.
6. Misi pertama selesai.

Mekanik:

- Movement
- Collision
- Interaksi objek
- Sistem dialog
- Objective tracking

Kondisi Selesai: Pemain berhasil mencapai pos dan menyerahkan pesan.

#### MISSION 2 — GARIS PERTAHANAN

Estimasi durasi: 3–4 menit.

Objective: Melewati kawasan yang terhalang oleh pasukan lawan.

Alur:

1. Pemain memasuki area konflik.
2. Jalur menuju area berikutnya tertutup.
3. Pemain menghadapi dua lawan dalam pertarungan arcade sederhana.
4. Setelah tantangan selesai, jalur terbuka.
5. Pemain melanjutkan perjalanan.

Mekanik:

- Sistem aksi sederhana
- Sistem HP
- AI lawan dasar
- Deteksi collision
- Objective completion

Pertarungan menggunakan efek visual non-grafis dan tidak menyimulasikan penggunaan senjata secara realistis.

Kondisi Selesai: Tantangan selesai dan pemain mencapai gerbang menuju area berikutnya.

#### MISSION 3 — MENINGGALKAN BANDUNG

Estimasi durasi: 3–4 menit.

Objective: Membantu warga dan mencapai lokasi pengungsian.

Alur:

1. Pemain memasuki kawasan permukiman terakhir.
2. Pemain menemukan seorang warga yang membutuhkan informasi jalur pengungsian.
3. Pemain berinteraksi dengan warga tersebut.
4. Pemain mengikuti jalan menuju titik pengungsian.
5. Warna lingkungan berubah menjadi lebih gelap.
6. Cahaya kemerahan terlihat dari kejauhan.
7. Pemain mencapai akhir level.
8. Ending ditampilkan.

Mekanik:

- Eksplorasi
- Interaksi NPC statis
- Dialog
- Trigger ending
- Perubahan visual lingkungan

Tidak diperlukan sistem NPC yang mengikuti pemain.

Kondisi Selesai: Pemain berhasil mencapai titik pengungsian.

### 4.3 Ending Game

Game menampilkan ilustrasi kota Bandung dengan cahaya api di kejauhan.

Kemudian muncul narasi sejarah mengenai Bandung Lautan Api.

Setelah narasi, tampil layar edukasi berisi:

1. Peristiwa Bandung Lautan Api berlangsung pada 23–24 Maret 1946.
2. Pengungsian dan pembumihangusan sejumlah kawasan dilakukan dalam konteks ultimatum Sekutu serta perjuangan mempertahankan kemerdekaan.
3. Peristiwa tersebut memperlihatkan perjuangan dan pengorbanan masyarakat Bandung.

Tambahkan keterangan bahwa karakter utama serta misi permainan merupakan fiksi yang terinspirasi oleh konteks sejarah.

Ending harus dapat diakses setelah seluruh misi diselesaikan.

## 5. PLAYER SYSTEM

### 5.1 Player Movement

Priority: P0 — Mandatory

Requirements:

- Pemain menggunakan CharacterBody2D.
- Pergerakan mendukung delapan arah.
- Kecepatan pemain konsisten.
- Collision diterapkan pada objek solid.
- Kamera mengikuti karakter.
- Karakter tidak boleh keluar dari batas map.

Parameter awal:

- Movement speed: 100 pixels/second.
- Movement: 8-direction.
- Camera: Follow Player.
- Collision: Enabled.

Parameter dapat disesuaikan setelah pengujian.

### 5.2 Player Health

Priority: P0 — Mandatory

Pemain memiliki tiga HP.

Requirements:

- HP awal: 3.
- HP berkurang ketika terkena serangan dalam sistem arcade.
- Pemain mendapatkan invincibility singkat setelah menerima damage.
- Ketika HP menjadi 0, muncul layar Game Over.
- Pemain bisa mengulang area aktif.

Tidak diperlukan stamina, armor, atau sistem status karakter lainnya.

### 5.3 Combat System

Priority: P0 — Mandatory

Game menggunakan sistem pertarungan arcade sederhana.

Requirements:

- Satu tombol aksi: J.
- Satu animasi aksi dasar.
- Satu jenis lawan.
- Lawan memiliki satu HP.
- Terdapat jeda singkat antaraksi.
- Terdapat feedback suara dan animasi ketika interaksi pertarungan terjadi.
- Tidak menggunakan efek kekerasan grafis.

Parameter awal:

- Action cooldown: 0,5 detik.
- Action range: jarak dekat.
- Enemy HP: 1.
- Player HP: 3.

Sistem tidak memerlukan berbagai kemampuan khusus, sistem combo, atau perlengkapan rumit.

### 5.4 Enemy AI

Priority: P0 — Mandatory

Lawan hanya digunakan pada Misi 2.

Requirements:

- Lawan memiliki gerakan dasar.
- Lawan merespons ketika pemain memasuki area tertentu.
- Lawan dapat mendekati pemain dalam arena terbuka.
- Lawan memiliki animasi idle dan bergerak.
- Lawan berhenti berinteraksi setelah tantangan selesai.

Tidak diperlukan:

- Pathfinding kompleks.
- Sistem cover.
- Formasi kelompok.
- Behavior tree.
- Boss fight.
- AI dengan banyak fase.

### 5.5 Interaction System

Priority: P0 — Mandatory

Pemain dapat berinteraksi dengan objek tertentu menggunakan tombol E.

Contoh objek:

- Surat atau pesan.
- Pos kelompok pejuang.
- Warga.
- Pintu atau gerbang.
- Titik pengungsian.

Saat pemain berada cukup dekat dengan objek interaktif, tampil indikator:

"Tekan E untuk berinteraksi"

Interaksi harus mengaktifkan tindakan yang sesuai, seperti mengambil pesan atau menampilkan dialog.

## 6. MISSION SYSTEM

Priority: P0 — Mandatory

Game menggunakan sistem misi linear.

Jumlah misi: 3.

Mission state:

- LOCKED
- ACTIVE
- COMPLETED

Hanya satu misi utama yang aktif pada satu waktu.

Mission Flow: Mission 1 → Mission 2 → Mission 3 → Ending.

Requirements:

- Objective misi ditampilkan pada HUD.
- Objective berubah setelah misi selesai.
- Misi tidak boleh selesai sebelum syaratnya terpenuhi.
- Trigger tidak boleh aktif berulang kali secara tidak sengaja.
- Setelah Game Over, pemain dapat mengulang area aktif dengan state yang konsisten.

Contoh objective:

- Mission 1: "Sampaikan pesan ke pos pejuang."
- Mission 2: "Lewati kawasan pertahanan."
- Mission 3: "Bantu warga dan capai titik pengungsian."

## 7. MAP & LEVEL DESIGN

### 7.1 Struktur Map

Gunakan satu level utama dengan tiga area.

Area 1 — Permukiman: Lingkungan awal permainan.

Elemen:

- Rumah sederhana.
- Jalan.
- Pepohonan.
- Peti.
- Objek pesan.
- Pos pejuang.

Area 2 — Kawasan Konflik: Lokasi tantangan arcade.

Elemen:

- Jalan utama.
- Bangunan.
- Rintangan lingkungan.
- Dua karakter lawan.
- Gerbang menuju area berikutnya.

Area 3 — Jalur Pengungsian: Lokasi misi terakhir.

Elemen:

- Jalan.
- Rumah.
- NPC warga.
- Titik pengungsian.
- Efek cahaya kemerahan.

### 7.2 Batasan Map

- Hanya satu level utama.
- Tidak memerlukan open-world.
- Tidak memerlukan pergantian waktu dinamis.
- Tidak memerlukan bangunan dengan interior kompleks.
- Tidak memerlukan kendaraan yang dapat dikendalikan.
- Tidak memerlukan map procedurally generated.

### 7.3 Collision

Collision diterapkan pada:

- Dinding.
- Bangunan.
- Pohon.
- Rintangan solid.
- Batas area.

Pastikan pemain tidak tersangkut pada sudut objek.

## 8. ART DIRECTION

### 8.1 Visual Style

Art style utama adalah 2D Retro Pixel Art.

Referensi visual:

- Game pixel art top-down klasik.
- Lingkungan kota Indonesia tahun 1940-an.
- Warna kusam yang merepresentasikan suasana sejarah.
- Pencahayaan senja dan malam.

Visual game harus memiliki identitas sejarah Indonesia dan tidak terlihat seperti game fantasi modern.

### 8.2 Color Palette

Warna dasar:

- Dark Brown: #3B302A
- Warm Brown: #78604A
- Dusty Beige: #C4AA84
- Dark Olive: #4B5445
- Muted Orange: #C76B36
- Dark Red: #8B4036
- Cream White: #E9DCC7

Palet ini merupakan arahan visual awal dan dapat direvisi oleh Pixel Artist.

### 8.3 Sprite Requirements

Ukuran awal yang disarankan:

- Tile: 16 × 16 px.
- Player sprite: 16 × 24 px.
- NPC: 16 × 24 px.
- Objek kecil: 16 × 16 atau 32 × 32 px.

Animasi minimum:

Player: Idle, Walk, Action.

Enemy: Idle, Walk, Action.

Pengembangan awal boleh menggunakan placeholder tanpa animasi lengkap.

### 8.4 Asset List

Aset minimum yang diperlukan:

Karakter:

- 1 player.
- 1 jenis enemy.
- 1 NPC warga.

Lingkungan:

- Tileset jalan.
- Tileset tanah.
- Bangunan.
- Pohon.
- Peti.
- Gerbang.
- Pos pejuang.
- Penanda titik pengungsian.

UI:

- Main menu.
- Tombol Start.
- Tombol Exit.
- HP indicator.
- Objective panel.
- Dialogue panel.
- Game Over screen.
- Ending screen.

### 8.5 Asset Policy

- Gunakan aset orisinal atau aset yang lisensinya mengizinkan penggunaan proyek.
- Simpan informasi pembuat dan lisensi aset pihak ketiga.
- Hindari mengambil sprite dari game komersial tanpa izin.
- Gunakan placeholder apabila aset final belum tersedia.
- Jangan menunda pengembangan mekanik hanya karena aset belum selesai.

## 9. UI/UX REQUIREMENTS

### 9.1 Main Menu

Menu terdiri dari:

- Logo atau judul game.
- Start Game.
- Exit Game.

Background dapat menggunakan ilustrasi pixel art Bandung.

### 9.2 Gameplay HUD

HUD terdiri dari:

- Bagian kiri atas: HP pemain berupa tiga ikon.
- Bagian kanan atas: Objective misi aktif.
- Bagian bawah: Dialogue box yang hanya muncul ketika diperlukan.

Desain UI harus sederhana, konsisten, dan mudah dibaca.

### 9.3 Pause Menu

Tombol ESC membuka menu:

- Resume.
- Restart.
- Main Menu.

Ketika game dalam keadaan pause, pergerakan dan mekanik permainan berhenti.

### 9.4 Game Over

Jika HP pemain mencapai 0:

- Gameplay berhenti.
- Muncul teks "GAME OVER".
- Tersedia tombol Retry dan Main Menu.

### 9.5 Ending Screen

Ending menampilkan:

- Ilustrasi atau background.
- Narasi sejarah.
- Informasi pembeda fakta dan fiksi.
- Credits.
- Tombol kembali ke menu utama.

## 10. AUDIO DESIGN

### 10.1 Background Audio

Minimal tiga jenis audio:

1. Main menu ambience.
2. Gameplay ambience.
3. Ending ambience.

### 10.2 Sound Effects

Minimal empat efek suara:

- Player action.
- Player terkena damage.
- Interaksi objek.
- Mission complete.

Tambahan opsional:

- Langkah kaki.
- Ambience angin.
- Suara lingkungan kota.

Audio harus memiliki volume yang seimbang dan tidak mengganggu keterbacaan dialog.

Musik serta efek suara harus menggunakan karya orisinal atau sumber dengan izin penggunaan yang sesuai.

## 11. TECHNICAL REQUIREMENTS

### 11.1 Technology Stack

Engine: Godot 4.x Stable
Language: GDScript
Rendering: 2D
Target: Windows Desktop
Version Control: Git

Gunakan versi stabil Godot 4 yang benar-benar terpasang dan jangan mencampur API dari versi berbeda.

### 11.2 Recommended Project Structure

```text
Bandung1946/
|-- project.godot
|-- README.md
|-- .gitignore
|-- scenes/
|   |-- main_menu.tscn
|   |-- main_game.tscn
|   |-- player.tscn
|   |-- enemy.tscn
|   |-- interactable.tscn
|   |-- game_over.tscn
|   |-- ending.tscn
|-- scripts/
|   |-- player.gd
|   |-- enemy.gd
|   |-- interaction.gd
|   |-- mission_manager.gd
|   |-- game_manager.gd
|   |-- hud.gd
|-- assets/
|   |-- sprites/
|   |-- tilesets/
|   |-- ui/
|   |-- audio/
|-- data/
|   |-- dialogues.json
|   |-- missions.json
|-- docs/
|   |-- prd.md
|   |-- history_references.md
|   |-- asset_credits.md
|-- tests/
|-- builds/
```

Struktur dapat disesuaikan jika Codex menemukan pendekatan yang lebih sederhana.

### 11.3 Godot Nodes

Gunakan node bawaan Godot.

Prioritas:

- CharacterBody2D untuk player dan enemy.
- CollisionShape2D untuk collision.
- Area2D untuk interaksi serta trigger.
- Camera2D untuk kamera.
- TileMapLayer untuk tile-based map jika tileset sudah tersedia.
- CanvasLayer untuk HUD.
- Control untuk menu dan UI.
- AudioStreamPlayer untuk audio.

Tidak perlu menggunakan plugin eksternal apabila fitur dapat dibuat menggunakan node standar Godot.

### 11.4 Resolution

Target window: 1280 × 720.

Internal reference resolution: 640 × 360.

Gunakan scaling yang menjaga ketajaman pixel art, termasuk nearest-neighbor texture filtering.

Pastikan UI tetap dapat dibaca dan tidak terpotong pada resolusi target.

### 11.5 Performance

Target:

- 60 FPS pada komputer sekolah atau laptop Windows kelas menengah.
- Tidak ada penurunan performa signifikan pada map utama.
- Tidak ada error fatal.
- Tidak memerlukan koneksi internet.
- Semua fitur inti berjalan secara offline.

### 11.6 Code Quality

- Gunakan GDScript yang mudah dibaca.
- Gunakan penamaan variabel yang konsisten.
- Pisahkan mekanik utama ke dalam script yang sesuai.
- Jangan membuat arsitektur terlalu kompleks.
- Hindari dependensi eksternal tanpa kebutuhan.
- Gunakan signals bila membantu komunikasi antarsistem.
- Berikan komentar seperlunya untuk menjelaskan logika penting.
- Pastikan semua scene dan resource dapat dimuat.
- Jangan menghapus fitur yang sudah berjalan ketika mengembangkan fitur baru.

## 12. MVP SCOPE

### 12.1 Fitur Wajib (P0)

1. Main menu.
2. Player movement.
3. Camera follow.
4. Map utama.
5. Collision.
6. Interaksi objek.
7. Sistem misi.
8. Sistem HP.
9. Pertarungan arcade sederhana.
10. Dua karakter lawan di satu area.
11. NPC statis.
12. Dialogue box.
13. Game Over.
14. Ending sejarah.
15. Audio dasar.

### 12.2 Fitur Tambahan (P1)

Dikerjakan hanya setelah seluruh P0 selesai.

- Animasi karakter lebih lengkap.
- Efek visual lingkungan.
- Transisi layar yang lebih halus.
- Variasi ambience.
- Tutorial interaktif.
- Pengaturan volume.

### 12.3 Di Luar Scope

Jangan dikembangkan untuk MVP:

- Multiplayer.
- Open-world.
- Skill tree.
- Sistem crafting.
- Sistem inventori kompleks.
- Sistem perdagangan.
- Banyak jenis musuh.
- Boss fight.
- Cutscene panjang.
- Voice acting.
- AI pathfinding kompleks.
- Sistem cuaca dinamis.
- Sistem save/load permanen.
- Online leaderboard.

Fokus utama adalah menyelesaikan satu game pendek yang stabil.

## 13. DEVELOPMENT ROADMAP

Roadmap ini merupakan estimasi untuk pengerjaan paruh waktu oleh empat siswa.

### Phase 1 — Project Foundation

Target: Membuat proyek Godot yang dapat dijalankan.

Tasks:

- Membuat struktur proyek.
- Mengatur resolusi.
- Membuat main menu sederhana.
- Membuat player.
- Mengimplementasikan movement.
- Membuat camera follow.
- Membuat placeholder map.
- Menambahkan collision.

Definition of Done: Pemain dapat berjalan mengelilingi map tanpa menembus objek solid. Proyek berjalan tanpa error fatal.

### Phase 2 — Core Gameplay

Tasks:

- Sistem interaksi.
- Sistem dialog.
- Sistem HP.
- Sistem pertarungan arcade.
- Enemy behavior sederhana.
- Game Over dan Retry.

Definition of Done: Pemain dapat berinteraksi, menyelesaikan tantangan sederhana, dan mengulang permainan ketika HP habis.

### Phase 3 — Mission & Story

Tasks:

- Implementasi tiga misi.
- Mission manager.
- Objective HUD.
- Dialog cerita.
- Trigger penyelesaian misi.
- Ending edukasi.

Definition of Done: Pemain dapat menyelesaikan game dari awal sampai akhir tanpa perintah manual dari editor.

### Phase 4 — Art & Polish

Tasks:

- Mengganti placeholder dengan pixel art.
- Menambahkan efek suara.
- Memperbaiki keterbacaan UI.
- Menambahkan transisi.
- Mengatur difficulty.
- Memperbaiki bug.

Definition of Done: Semua fitur P0 berjalan, aset utama terpasang, dan permainan dapat dimainkan sampai selesai.

### Phase 5 — Testing & Release

Tasks:

- Pengujian bersama seluruh anggota.
- Pengecekan fakta sejarah.
- Pengecekan error.
- Membuat build Windows.
- Membuat dokumentasi penggunaan.
- Menyiapkan demonstrasi untuk guru.

Definition of Done: Game dapat dijalankan dari build Windows dan dipresentasikan tanpa membutuhkan Godot Editor.

## 14. TEAM RESPONSIBILITIES

### Rainer — Lead Programmer & Game Director

Tanggung jawab:

- Mengarahkan implementasi melalui Codex.
- Mengelola project Godot.
- Menguji mekanik.
- Melakukan debugging dengan bantuan Codex.
- Mengintegrasikan aset.
- Menyiapkan build final.

### Rama — Pixel Artist & Map Designer

Tanggung jawab:

- Membuat karakter.
- Membuat tileset.
- Membuat lingkungan permainan.
- Membuat properti map.
- Menyiapkan sprite dan animasi dasar.

### Fahkri — Story Writer & Historical Researcher

Tanggung jawab:

- Meneliti sejarah Bandung Lautan Api.
- Memastikan fakta sejarah akurat.
- Membuat alur cerita.
- Menyusun dialog.
- Menulis deskripsi misi.
- Menyiapkan materi sejarah pada ending.

### Raja — UI/UX & Sound Designer

Tanggung jawab:

- Mendesain main menu.
- Membuat komponen HUD.
- Menyiapkan ikon dan tampilan dialog.
- Mengumpulkan serta mengatur audio berlisensi sesuai.
- Membantu playtesting.

Seluruh anggota wajib melakukan pengujian sebelum pengumpulan.

## 15. ACCEPTANCE CRITERIA

Proyek dianggap memenuhi MVP apabila:

Player:

- Karakter bergerak dengan WASD.
- Kecepatan diagonal konsisten.
- Karakter tidak menembus bangunan.
- Kamera mengikuti karakter dengan baik.

Combat:

- Tombol J menjalankan aksi yang sesuai.
- HP pemain berkurang sesuai event permainan.
- HP tidak berkurang berulang-ulang tanpa jeda yang dirancang.
- Lawan memberikan respons.
- Game Over muncul ketika HP mencapai nol.

Mission:

- Misi berjalan berurutan.
- Pemain tidak dapat melewati objective yang belum selesai.
- Objective HUD diperbarui.
- Misi ketiga membuka ending.

UI:

- Main menu berfungsi.
- Pause dan Resume berfungsi.
- Tombol Retry berfungsi.
- Tombol kembali ke menu berfungsi.
- Teks dialog dapat dibaca dengan jelas.

Technical:

- Tidak ada script error yang menghalangi permainan.
- Tidak ada resource wajib yang hilang.
- Game dapat dibuka di Godot.
- Game dapat diekspor ke Windows jika export template tersedia.
- Game dapat dimainkan secara offline.

Historical Accuracy:

- Kronologi utama sesuai sumber.
- Peristiwa fiktif tidak disajikan sebagai fakta.
- Terdapat informasi sejarah pada ending.
- Referensi sejarah dicantumkan dalam game.

## 16. QA TEST CASES

| ID | Skenario | Hasil yang Diharapkan |
|---|---|---|
| TC-01 | Tekan Start Game | Gameplay terbuka |
| TC-02 | Gerakkan karakter dengan WASD | Karakter bergerak sesuai input |
| TC-03 | Bergerak ke arah dinding | Karakter berhenti pada collision |
| TC-04 | Tekan E dekat objek | Interaksi berhasil |
| TC-05 | Tekan E jauh dari objek | Tidak terjadi interaksi |
| TC-06 | Selesaikan Mission 1 | Mission 2 aktif |
| TC-07 | Menyelesaikan tantangan Mission 2 | Jalur Mission 3 terbuka |
| TC-08 | HP mencapai nol | Game Over muncul |
| TC-09 | Tekan Retry | Area aktif dimulai ulang dengan benar |
| TC-10 | Tekan ESC | Pause menu muncul |
| TC-11 | Selesaikan Mission 3 | Ending ditampilkan |
| TC-12 | Tekan Main Menu | Kembali ke menu utama |
| TC-13 | Jalankan build Windows | Game berjalan tanpa Godot Editor |

## 17. RISKS & MITIGATION

### Risiko 1: Tim masih pemula

Solusi: Gunakan sistem gameplay sederhana serta manfaatkan Codex untuk membantu pemrograman dan debugging.

### Risiko 2: Pixel art belum selesai

Solusi: Gunakan placeholder terlebih dahulu dan lakukan integrasi aset secara bertahap.

### Risiko 3: Kesalahan dalam pengembangan kode

Solusi: Bangun game secara bertahap, lakukan pengujian setiap fitur, dan gunakan Git untuk menyimpan perubahan.

### Risiko 4: Waktu pengerjaan terbatas

Solusi: Utamakan fitur P0. Fitur tambahan hanya dikerjakan ketika core gameplay telah stabil.

### Risiko 5: Ketidakakuratan sejarah

Solusi: Gunakan sumber resmi, periksa teks sejarah sebelum dimasukkan ke game, dan pisahkan fakta dari fiksi.

## 18. CODEX DEVELOPMENT INSTRUCTIONS

Instruksi ini wajib diikuti selama pengembangan.

### Role

Act as a senior Godot game developer and technical mentor.

Your responsibility is to develop a complete, stable, beginner-friendly 2D historical action-adventure game based on this PRD.

### Main Rules

1. Gunakan Godot 4.x Stable dan GDScript.
2. Gunakan fitur bawaan Godot sebisa mungkin.
3. Prioritaskan kode sederhana, modular, dan mudah dipahami.
4. Jangan membuat fitur di luar scope MVP tanpa alasan.
5. Jangan membangun seluruh game sekaligus.
6. Mulai dari Phase 1 dan selesaikan setiap phase secara bertahap.
7. Gunakan placeholder bila aset final tidak tersedia.
8. Jangan menghapus atau merusak fitur yang sebelumnya telah bekerja.
9. Jalankan validasi proyek jika executable Godot tersedia.
10. Jangan menyatakan fitur telah diuji apabila pengujian tidak benar-benar dilakukan.
11. Jika muncul error, analisis dan perbaiki akar penyebabnya.
12. Setelah setiap phase, jelaskan perubahan dan cara mengujinya.
13. Sertakan daftar file yang dibuat atau diubah.
14. Gunakan sumber sejarah dari PRD dan jangan mengarang fakta.
15. Pastikan seluruh teks game menggunakan Bahasa Indonesia.

### Development Workflow

Setiap kali menerima tugas:

1. Periksa struktur proyek yang sudah ada.
2. Pahami fitur yang diminta.
3. Identifikasi file yang perlu dimodifikasi.
4. Implementasikan perubahan.
5. Jalankan pengecekan bila memungkinkan.
6. Perbaiki error yang ditemukan.
7. Laporkan hasil pengerjaan.
8. Berikan instruksi pengujian kepada pengguna.

### Required Output After Each Phase

Berikan ringkasan:

- Fitur yang berhasil dibuat.
- File yang ditambahkan.
- File yang dimodifikasi.
- Pengujian yang berhasil.
- Masalah yang belum terselesaikan.
- Langkah pengujian di Godot.
- Tahap berikutnya.

### Project Completion Condition

Proyek selesai apabila:

- Semua fitur P0 diimplementasikan.
- Seluruh misi dapat diselesaikan.
- Tidak terdapat error fatal.
- Alur cerita dapat dimainkan dari awal sampai ending.
- Proyek dapat dibuka dengan Godot.
- Build Windows berhasil dibuat dan diuji, apabila fasilitas ekspor tersedia.
- Dokumentasi proyek tersedia.

## 19. SUCCESS METRICS

Target minimum:

- Game memiliki tiga misi lengkap.
- Game dapat diselesaikan dalam sekitar 10–15 menit.
- Semua kontrol utama berfungsi.
- Seluruh fitur wajib dapat dimainkan.
- Materi sejarah terbaca dan sesuai referensi.
- Tidak terdapat bug yang menghalangi penyelesaian permainan.
- Setiap anggota kelompok dapat menjelaskan kontribusinya.

Evaluasi dilakukan dengan meminta seluruh anggota memainkan game dari awal sampai akhir, kemudian mencatat bug serta kesulitan pemain.

## 20. FINAL PRODUCT VISION

Bandung 1946 — Garis Pertahanan ditargetkan menjadi sebuah game edukasi sejarah Indonesia dengan visual retro pixel art dan gameplay 2D top-down yang sederhana tetapi menarik.

Game harus memberikan pengalaman perjuangan melalui eksplorasi, aksi arcade, dan narasi yang berkaitan dengan sejarah Bandung Lautan Api.

Prioritas pengembangan adalah:

1. Playable.
2. Stable.
3. Historically responsible.
4. Visually consistent.
5. Beginner-friendly.

Prinsip utama: A small, complete, and polished game is better than a large unfinished game.

END OF PRD — VERSION 1.0
