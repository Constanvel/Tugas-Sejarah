# QA tileset lingkungan — 15 Oktober 2026

Engine yang dijalankan: Godot 4.7.2 Stable, ed1daf0bf, executable console Windows yang tercantum dalam README kategori. Semua perintah di bawah dijalankan pada repo D:\Tugas-sejarah\sejarah\Tugas-Sejarah dan selesai dengan exit 0.

| Pemeriksaan aktual | Hasil | Bukti |
|---|---|---|
| Editor headless import | Tiga PNG baru diimpor; tanpa pesan error | qa_import.txt |
| tests/tileset_assets_test.gd | 1200 pemeriksaan, 0 gagal | qa_tilesets.txt |
| tools/generate_tilesets.gd -- --check | 6 PNG, 120 sel, 97 aset; 0 gagal | qa_generator.txt |
| Regenerasi lalu perbandingan SHA256 | 8 keluaran identik byte demi byte | qa_determinism.txt |
| tests/asset_pipeline_test.gd | 52 pemeriksaan, 0 gagal | qa_pipeline.txt |
| tests/character_assets_test.gd | 116 pemeriksaan, 0 gagal | qa_characters.txt |
| tests/phase1_test.gd --fixed-fps 60 | 45 pemeriksaan, 0 gagal | qa_foundation.txt |

Suite tileset memeriksa sumber valid dan invalid, bitmask, ukuran/palet/alpha PNG, opacity manifest terhadap gambar, pemuatan Texture2D, 120 region TileSetAtlasSource sementara, koordinat unik, rekonstruksi objek dari offset, serta ekstrusi setiap sel. Sambungan permukaan, pasangan mask jalan yang kompatibel, tepi/sudut luar dan dalam diperiksa melalui piksel batas. Map preview tidak memiliki lubang alpha dan preview 3x diperiksa sebagai pembesaran nearest yang tepat.

Inspeksi visual dilakukan dengan membuka contact_sheet.png dan map_preview_3x.png. Preview pertama menampilkan variasi tanah kering berbentuk kotak pada rumput; dekorasi diubah menjadi daun transparan dan tanah kering dipindahkan ke halaman tanah. Pola genteng dan perbedaan jalan tanah/debu diperjelas sebelum hasil akhir. Empat contoh bangunan, siluet objek dan sambungan jalan terbaca. Review tambahan read-only tidak menemukan bug pada seam, ekstrusi atau assembly; masukan validasi bitmask dan metadata opacity telah diperbaiki dan dites ulang.

Mekanika gameplay, scene dan resource lama tidak disentuh. SHA256 sebelum/sesudah main_game.tscn tetap 431686832CC8E43E38680830A0A45EE05507BABDB98294E9195C17E7D0A5F17F; project.godot tetap B01CBD9436C2EAC6FD0AA940B4226E0588CBE0112E03EA74305D10BF7EEF81BC. Project.godot telah memiliki perubahan lokal dari editor sebelum tugas ini. Lima JSON pipeline/karakter lama juga menunjukkan perubahan whitespace di working tree; isi semantiknya sama dengan HEAD, dibiarkan dan dikecualikan dari template staging tugas ini.

Belum diuji: pengecatan manual pada editor TileMapLayer, pemasangan ke scene gameplay, collision/terrain peering, build Windows dan peninjauan arsitektur berdasarkan sumber sejarah. Preview dibuat dari komposisi Image Godot, bukan screenshot map gameplay. Tidak ada klaim tes visual runtime atas aset yang belum dipasang.
