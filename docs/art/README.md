# Fondasi aset visual

Status: studi awal, belum paket aset final dan belum terpasang pada gameplay. Mengikuti docs/prd.md, khususnya bagian 7, 8 dan 11, serta arahan visual Rainer pada 15 Oktober 2026. PRD dan mekanik Phase 1 dipertahankan.

Pembaruan kategori karakter: [player/enemy empat arah dan civilian statis](characters/README.md) kini tersedia pada assets/sprites/characters. Sumber, manifest dan generator karakter disimpan terpisah agar studi fondasi di bawah tetap dapat dibuat ulang. Aset karakter baru belum diintegrasikan ke gameplay.

## Hasil tahap ini

- assets/art_sources/palette.json: sumber palet tujuh warna, simbol, fungsi warna dan ukuran acuan.
- assets/art_sources/foundation_samples.json: sumber piksel yang dapat disunting; satu pose kurir, satu peti, satu tile tanah.
- tools/generate_assets.gd: generator PNG, manifest dan style guide menggunakan Image bawaan Godot; tidak memerlukan Python/Pillow, plugin atau layanan online.
- assets/generated/manifest.json: nama, fungsi, ukuran, frame, arah, pivot, transparansi dan status integrasi setiap keluaran.
- docs/art/style_guide.png: satu panduan teknis/contact sheet 640 x 360 untuk mengevaluasi palet dan tiga studi.
- docs/art/atmosphere_reference_ai.png: satu referensi suasana 1536 x 1024 yang dibuat memakai tool image generation. Prompt dan keterbatasannya dicatat dalam imagegen_prompt.md, metadata dalam reference_manifest.json.
- tests/asset_pipeline_test.gd: pemeriksaan PNG, warna, alpha, sumber invalid dan pemuatan Texture2D Godot.

## Struktur

```text
assets/
  art_sources/
    palette.json
    foundation_samples.json
  generated/
    characters/courier_idle_south.png
    props/wooden_crate.png
    tiles/dirt_tile.png
    palette.png
    manifest.json
tools/
  generate_assets.gd
docs/art/
  README.md
  style_guide.png
  atmosphere_reference_ai.png
  reference_manifest.json
  imagegen_prompt.md
tests/
  asset_pipeline_test.gd
```

Folder untuk enemy/NPC, tileset lengkap, bangunan, UI dan efek dibuat saat kategorinya benar-benar dikerjakan. assets/sprites dan theme lama tetap dipakai oleh gameplay; tidak ada referensi scene yang diganti.

## Aturan visual

| Aspek | Aturan fondasi |
|---|---|
| Perspektif | Top-down ortografis dengan sebagian sisi depan selatan terlihat. Sumbu properti mengikuti horizontal/vertikal map; hindari tata letak isometrik |
| Skala dunia | 1 piksel aset = 1 piksel dunia. Tile 16 x 16; frame semua karakter manusia 16 x 24 |
| Resolusi | Internal 640 x 360; window sasaran 1280 x 720 |
| Cahaya | Sumber utama kiri atas; bidang bawah/kanan lebih gelap. Belum ada sistem pencahayaan baru |
| Outline | Utamakan 1 px Dark Brown dan siluet utuh; detail 1 px hanya jika terbaca pada ukuran asli |
| Shading | Kelompok piksel tegas, dua atau tiga tingkat dari palet. Tidak ada blur, antialias, gradien atau warna tambahan otomatis |
| Karakter | Proporsi manusia sederhana, pakaian kusam, tanda merah-putih terbatas; bukan anime atau tokoh sejarah tertentu |
| Material | Kayu berserat ringkas, dinding kusam, genteng tanah liat; jangan menambah tanda/teknologi modern |
| Transparansi | Studi karakter dan objek memakai RGBA dengan alpha 0/255. Tile tanah mengisi frame penuh, tanpa alpha kosong |
| Identitas | Arsitektur/properti merupakan interpretasi fiktif, bukan rekonstruksi bangunan Bandung yang terdokumentasi |
| Teks | Dilarang pada sprite dunia. Teks label hanya ada pada panduan/dokumentasi |
| Konten | Tidak ada kekerasan grafis, fantasi, warna neon, watermark atau logo |

Studi ini belum membuktikan keakuratan arsitektur tahun 1946. Fahkri dan Rama perlu memeriksa foto/referensi berizin sebelum aset bangunan final dibuat. Referensi AI tidak dipakai sebagai bukti sejarah.

## Palet terkunci awal

| Simbol | Warna | Hex | Fungsi |
|---|---|---|---|
| D | Dark Brown | #3B302A | Outline, bayangan |
| W | Warm Brown | #78604A | Tanah, kayu, pakaian |
| B | Dusty Beige | #C4AA84 | Kulit, debu, bidang terang |
| O | Dark Olive | #4B5445 | Vegetasi, pakaian gelap |
| M | Muted Orange | #C76B36 | Sorotan hangat |
| R | Dark Red | #8B4036 | Genteng, aksen merah |
| C | Cream White | #E9DCC7 | Sorotan dan aksen putih |
| . | Transparan | Alpha 0 | Ruang di luar siluet |

Warna dalam PNG studi, strip palet dan style guide diperiksa terhadap tujuh nilai tepat tersebut. Gambar referensi AI dikecualikan karena bukan aset produksi. Penyesuaian palet nantinya harus dilakukan pada sumber JSON dan ditinjau bersama, bukan melalui tint/warna acak pada setiap sprite.

## Dimensi dan anchor

| Studi | PNG | Frame/arah | Pivot dari kiri atas | Status |
|---|---|---|---|---|
| Kurir | 16 x 24 | 1 idle, south/selatan | (8,24), tengah kaki | Studi, belum empat arah/animasi |
| Peti | 32 x 32 | 1 statis, atas-depan | (16,30), dasar peti | Studi material/siluet |
| Tanah | 16 x 16 | 1 tile, top-down | (0,0), sudut tile | Studi pola berulang |
| Palet | 7 x 1 | 7 swatch, masing-masing 1 x 1 | Tidak berlaku | Data warna |
| Style guide | 640 x 360 | 1 gambar | Tidak berlaku | Dokumen/contact sheet |
| Konsep AI | 1536 x 1024 | 1 gambar | Tidak berlaku | Acuan suasana terpisah |

Tiga contoh diperbesar 4x/3x/6x menggunakan nearest hanya dalam preview. Jangan memakai ukuran pratinjau sebagai skala di dunia. Gambar dunia tidak memiliki teks; pola kotak di guide adalah latar demonstrasi transparansi, tidak tertanam pada PNG karakter/peti.

## Menjalankan ulang

Dari akar repo di PowerShell:

```powershell
$GodotExe = 'C:\Users\IDEAPAD SLIM 3\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $GodotExe --headless --path . --script tools/generate_assets.gd
& $GodotExe --headless --path . --editor --import --quit
& $GodotExe --headless --path . --script tools/generate_assets.gd -- --check
& $GodotExe --headless --path . --script tests/asset_pipeline_test.gd
& $GodotExe --headless --path . --script tests/phase1_test.gd --fixed-fps 60
```

Periksa $LASTEXITCODE sesudah setiap perintah serta output ERROR/FAIL. Generator menulis ulang hanya lima PNG yang dimilikinya dan manifest; jangan mengedit file generated secara manual. Mode --check tidak menulis keluaran: ia membandingkan seluruh piksel dan manifest dengan sumber. Referensi AI disimpan terpisah dan tidak dibuat ulang oleh script.

Mengubah kurir: edit 24 string rows, masing-masing tepat 16 karakter. Gunakan simbol palet di atas. Mengubah peti/tanah: edit rects berformat [x,y,lebar,tinggi,simbol]; urutan bidang menentukan tumpukan. Semua koordinat harus bilangan bulat dan berada di dalam frame. Jalankan generator, import, tes, lalu periksa guide pada ukuran asli dan pembesaran integer.

Fondasi sengaja dibatasi tiga studi dan satu frame per PNG. Ketika kategori berikutnya disepakati, perluas sumber, komposisi guide dan tes bersamaan. Belum ada parser atlas, sprite animation importer, editor khusus atau dependensi tambahan.

## Memakai PNG di Godot nanti

1. Jangan mengganti scene pada tahap fondasi ini. Tinjau dulu warna, siluet, skala dan pivot bersama Rama.
2. PNG akan diimpor sebagai Texture2D. Gunakan load/preload resource, bukan pembacaan file PNG mentah di runtime game.
3. Pada Sprite2D, Texture Filter = Nearest; pengaturan project saat ini sudah nearest. Gunakan Scale (1,1), tanpa mipmap/lossy compression.
4. Pivot kurir (8,24) sesuai Sprite2D centered pada posisi (0,-12), seperti player lama. Collider tetap terpisah; ilustrasi tidak menentukan collider secara otomatis.
5. Peti memiliki pivot dan siluet berbeda dari placeholder lama; periksa posisi/collider di scene saat integrasi nanti. Jangan mengubah collision sekadar mengikuti area transparan tekstur.
6. Simpan PNG dan file .png.import ke Git. Cache .godot diabaikan. docs/.gdignore membuat preview/concept tidak diimpor sebagai aset dunia.

## Urutan kategori berikutnya

1. Karakter: sepakati satu kurir terlebih dahulu, lalu empat arah idle/walk/action dengan frame 16 x 24. Selanjutnya satu jenis lawan dan satu NPC; jangan menambah karakter baru di luar PRD.
2. Terrain: tile tanah/jalan 16 x 16 dan sambungannya, diuji pengulangan dan keterbacaan siluet.
3. Lingkungan: rumah bergenteng, pohon, peti, pos, gerbang dan tanda pengungsian; cocokkan footprint scene/collision lama sebelum penggantian.
4. UI: tiga ikon HP, objective/dialog, menu, Game Over dan ending sesuai mekanik yang sudah siap.
5. Efek: aksi non-grafis dan cahaya kemerahan sederhana; tidak membangun cuaca atau waktu dinamis.

Tahap ini berhenti pada fondasi dan contoh. Kekurangan visual: karakter satu arah tanpa animasi, detail peti sederhana, tanah belum memiliki varian sambungan, belum ada bangunan final. Referensi AI terlalu detail/berwarna dan perspektifnya perlu disederhanakan sebelum dijadikan acuan piksel produksi.
