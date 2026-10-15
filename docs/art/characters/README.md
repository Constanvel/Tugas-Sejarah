# Aset karakter — Bandung 1946

Tiga karakter orisinal, dibuat pada grid piksel menggunakan palet dan generator proyek. Tahap ini hanya menambahkan aset; scene, input, movement, collision, kamera dan kode gameplay tidak diubah. Ketiganya belum menggantikan SVG player lama.

## Output

| Aset | Dimensi PNG | Isi |
|---|---|---|
| assets/sprites/characters/player.png | 48 x 96 | 12 frame pejuang muda fiktif |
| assets/sprites/characters/enemy.png | 48 x 96 | 12 frame lawan militer fiktif |
| assets/sprites/characters/civilian.png | 16 x 24 | Satu pose warga, menghadap bawah |
| assets/sprites/characters/manifest.json | Tidak berlaku | Nama, fungsi, ukuran, frame, arah, pivot dan preview |
| docs/art/characters/player_8x.png | 384 x 768 | Pembesaran nearest, tetap transparan |
| docs/art/characters/enemy_8x.png | 384 x 768 | Pembesaran nearest, tetap transparan |
| docs/art/characters/civilian_8x.png | 128 x 192 | Pembesaran nearest, tetap transparan |
| docs/art/characters/contact_sheet.png | 960 x 1120 | Semua frame dengan label dan panduan baseline |

Pola kotak dan tulisan hanya terdapat pada contact sheet. PNG dunia serta preview individual tidak memiliki label, watermark, latar kotak atau bayangan yang menempel di luar karakter.

## Desain

- Player: rambut gelap, ikat kepala merah-putih, pakaian cokelat dengan panel zaitun, celana gelap, tas/tali sederhana. Siluet lebih ramping dibanding lawan.
- Enemy: helm polos lebih lebar, tunik khaki kusam dan celana cokelat gelap. Tidak memiliki bendera, pangkat, lambang satuan, senjata atau identitas militer tertentu. Ini desain fiksi, bukan rekonstruksi seragam yang diklaim akurat.
- Civilian: rambut gelap, pakaian sederhana krem/cokelat dan kain panjang merah kusam. Siluet bagian bawah berbeda dari dua karakter bercelana.
- Palet tetap tujuh warna pada assets/art_sources/palette.json. Tidak ada warna baru, gradien, blur atau antialias; alpha hanya 0 atau 255.
- Pencahayaan utama kiri atas. Tampak samping memiliki profil hidung dan mata di sisi arah hadap; tampak belakang tidak memiliki wajah.

Desain awal telah dirapikan setelah inspeksi: langkah depan yang terlalu mengangkat lutut diperpendek, lengan dibuat berayun, bagian kepala player disederhanakan menjadi rambut dan pita, serta aksen terang terisolasi pada tunik lawan dihapus agar tidak menyerupai lencana.

## Layout atlas

Semua frame berukuran 16 x 24, tanpa padding antar-frame. Player dan enemy memakai 3 kolom x 4 baris:

| Baris | Arah | Kolom 0 | Kolom 1 | Kolom 2 |
|---|---|---|---|---|
| 0 | Down / bawah | Idle | Walk A | Walk B |
| 1 | Left / kiri | Idle | Walk A | Walk B |
| 2 | Right / kanan | Idle | Walk A | Walk B |
| 3 | Up / atas | Idle | Walk A | Walk B |

Untuk Sprite2D pada integrasi berikutnya: hframes=3 dan vframes=4. Indeks frame idle adalah 0/3/6/9; pasangan langkah adalah 1–2 / 4–5 / 7–8 / 10–11. Gunakan loop Walk A > Walk B saat bergerak dan frame Idle saat berhenti; jangan menganggap seluruh tiga kolom sebagai tiga tahap berjalan.

Kepala tidak berpindah antar-frame dalam satu arah. Tubuh/lengan dan kaki berubah; Walk A/B bukan salinan frame atau sekadar pewarnaan kepala. Tidak ada efek kekerasan grafis atau animasi aksi pada tahap ini.

## Anchor dan batas gambar

- Koordinat dari sudut kiri atas frame.
- Piksel alas kaki berada pada y=22 di semua 25 frame, dengan satu baris transparan y=23.
- Pivot kaki sama untuk semuanya: (8,23). Posisi dunia tetap menggunakan titik ini; kaki yang terangkat pada langkah berganti, sementara kaki tumpuan tetap mencapai baseline.
- Seluruh siluet memiliki margin transparan minimal satu piksel pada empat tepi frame. Tidak ada piksel tubuh yang memotong batas atau menyeberang sel atlas.
- Untuk Sprite2D centered berukuran 16 x 24, posisi visual (0,-11) menyelaraskan pivot (8,23) ke origin player. Ini petunjuk integrasi mendatang, belum diterapkan pada scene.
- Collider tidak dibuat atau diubah dari tekstur. Jangan menggeser collision saat memasang artwork tanpa pengujian terpisah.

## Sumber dan regenerasi

Sumber piksel yang dapat diedit: assets/art_sources/characters.json. Setiap arah memiliki 24 string idle sepanjang 16 karakter. walk_a dan walk_b memuat penggantian baris tubuh/kaki, dengan nomor baris 9..22; kepala diwarisi dari idle. Semua frame disimpan eksplisit melalui sumber ini dan tidak diambil dari sprite game lain.

Generator: tools/generate_characters.gd. Ia memakai renderer piksel, penulis PNG dan font panduan dari tools/generate_assets.gd yang sudah ada. Pipeline fondasi tetap menghasilkan lima PNG lamanya; pipeline karakter menghasilkan tujuh PNG dan satu manifest terpisah.

```powershell
cd 'D:\Tugas-sejarah\sejarah\Tugas-Sejarah'
$GodotExe = 'C:\Users\IDEAPAD SLIM 3\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $GodotExe --headless --path . --script tools/generate_characters.gd
& $GodotExe --headless --path . --editor --import --quit
& $GodotExe --headless --path . --script tools/generate_characters.gd -- --check
& $GodotExe --headless --path . --script tests/character_assets_test.gd
```

Periksa $LASTEXITCODE dan seluruh output error. Mode --check membandingkan semua piksel tujuh PNG dan teks manifest dengan sumber tanpa menulis ulang berkas. Generator biasa menulis ulang hanya berkas keluarannya; edit JSON sumber, bukan PNG hasil generator. Simpan .png.import dan .gd.uid bersama sumber ke Git; cache .godot diabaikan.

Tidak menggunakan panggilan AI baru atau memotong concept sheet AI pada tugas karakter ini. Sumber piksel proyek yang sudah ada diteruskan secara deterministik agar ukuran, layout, palet dan baseline tepat. Referensi AI tahap sebelumnya tetap hanya acuan suasana.

## Pemeriksaan dan batas hasil

Tes karakter memeriksa ukuran, urutan atlas, warna/alpha, frame tidak kosong/terpotong, baseline kaki, kepala stabil, perbedaan pose tubuh/kaki, empat arah berbeda, pemuatan Texture2D Godot dan pembesaran preview nearest per piksel. Tes sumber invalid memastikan perubahan di luar frame/kepala, pose kosong, path tidak sah dan metadata hilang ditolak sebelum menulis aset.

Bukti CLI tersimpan di qa_characters.txt, qa_generator.txt dan qa_import.txt. Ringkasan final/regresi dicatat dalam qa_report.md.

Ini paket karakter sederhana untuk MVP, bukan klaim ilustrasi profesional atau akurasi seragam historis. Belum ada animasi aksi, delapan arah visual, NPC berjalan, integrasi AnimatedSprite2D atau pengujian dalam scene gameplay. Mekanik gerak delapan arah yang sudah ada tetap berjalan dengan aset lama.
