# Credits aset Phase 1

Seluruh placeholder visual berikut dibuat khusus untuk repositori ini melalui kode SVG, tanpa menyalin aset game komersial atau mengunduh aset pihak ketiga:

| Berkas | Ukuran | Fungsi |
|---|---|---|
| assets/sprites/player.svg | 16 x 24 | Pejuang muda fiktif, placeholder satu pose |
| assets/sprites/house.svg | 128 x 96 | Rumah sederhana |
| assets/sprites/tree.svg | 48 x 64 | Pohon; collider hanya pada batang |
| assets/sprites/crate.svg | 32 x 32 | Peti solid |
| assets/sprites/ground.svg | 16 x 16 | Tekstur tanah/rumput berulang |
| assets/ui/theme.tres | Tidak berlaku | Tema UI memakai palet PRD |

Pembuat placeholder: OpenAI Codex untuk proyek tim Bandung 1946 — Garis Pertahanan, 15 Oktober 2026. Aset ini bagian dari sumber proyek; tidak ada lisensi aset eksternal tambahan yang diambil pada Phase 1. Repo belum menetapkan lisensi distribusi umum, sehingga dokumen ini tidak memberikan lisensi pihak lain atas keseluruhan proyek.

Bidang jalan, batas dan siluet menu dibuat dengan node native Godot. Font menggunakan bawaan engine; tidak ada file font tambahan. Belum ada audio. Simpan informasi pencipta, URL sumber, lisensi dan atribusi wajib ketika mengintegrasikan aset pihak ketiga pada fase berikutnya. Rama bertanggung jawab pada pixel art final; Raja pada UI/audio final.

## Fondasi pipeline visual — 15 Oktober 2026

- Tiga studi PNG orisinal di assets/generated (kurir, peti, tanah), strip palet dan docs/art/style_guide.png dibuat dari sumber JSON melalui tools/generate_assets.gd. Status studi awal, belum menggantikan SVG Phase 1. Bentuk piksel dan font bitmap panduan disusun untuk proyek ini tanpa mengambil sprite/font pihak ketiga.
- docs/art/atmosphere_reference_ai.png dibuat dengan tool image generation bawaan Codex, tanpa gambar referensi eksternal. Status hanya referensi suasana; bukan aset produksi atau dokumen sejarah. Prompt, metode dan keterbatasan tersedia pada docs/art/imagegen_prompt.md; dimensinya dicatat pada docs/art/reference_manifest.json.
- Tidak ada aset LORONG 1943 yang disalin. Arahan atmosfer mengikuti deskripsi pengguna. Detail visual dan arsitektur final masih memerlukan peninjauan tim.
- Manifest ukuran/frame/fungsi PNG teknis: assets/generated/manifest.json. Referensi AI memiliki manifest terpisah karena tidak memenuhi palet/piksel produksi.
