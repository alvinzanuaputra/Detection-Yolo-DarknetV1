# Darknet: Real-Time Object Detection (Optimized for Apple Silicon )

<div align="center">
  <img src="https://user-images.githubusercontent.com/4096485/101363015-e5c21200-38b1-11eb-986f-b3e516e05977.png" alt="YOLOv4 Tiny"/>
</div>

Darknet adalah *framework neural network open-source* yang ditulis dalam C dan CUDA. Repositori ini merupakan *fork* khusus yang telah sangat dioptimalkan untuk **macOS (Apple Silicon M1/M2/M3)**, sekaligus tetap mendukung Linux dan Windows.

[🇬🇧 Read this in English](README-EN.md)

## ✨ Fitur Baru & Optimasi
- **Apple Silicon Native**: Optimalisasi penuh untuk prosesor ARM64 (M1/M2/M3).
- **Perbaikan Crash Kamera (Continuity Camera)**: Resolusi tuntas pada isu *force close* saat menggunakan kamera iPhone via *Continuity Camera* karena batasan keamanan thread AVFoundation macOS.
- **Perbaikan Bug Multi-Core (OpenMP)**: Memperbaiki *Segmentation Fault* pada `gemm.c` saat komputasi multi-core diaktifkan (`OPENMP=1`), menjamin FPS tinggi yang stabil.
- **Terminal UI Dashboard**: Antarmuka deteksi *real-time* berbasis terminal (ASCII) yang rapi dan mudah dibaca, menggantikan output bawaan yang berantakan.
- **Kompatibilitas OpenCV 5**: Memperbaiki isu *header* dan tipe data C/C++ (`cvWaitKey`, `cvCapture`) untuk mendukung library OpenCV modern.

---

## 🛠 Instalasi dan Kompilasi

### 1. Requirements
- **OS**: macOS (M1/M2 direkomendasikan), Linux, atau Windows.
- **Compiler**: `gcc` atau `clang`.
- **OpenCV** (Opsional tapi wajib untuk kamera/video): Disarankan menginstal via Homebrew di Mac (`brew install opencv`).
- **OpenMP** (Sangat disarankan): Untuk komputasi CPU multi-core (`brew install libomp`).

### 2. Konfigurasi `Makefile`
Sebelum melakukan proses *compile*, buka `Makefile` di text editor. Untuk pengguna macOS Apple Silicon, setting terbaik adalah:
```makefile
GPU=0
CUDNN=0
OPENCV=1   # Wajib diaktifkan untuk fitur kamera
OPENMP=1   # Aktifkan multi-core untuk performa maksimal di Mac
DEBUG=0
```
*(Catatan: Pengguna NVIDIA GPU di sistem Linux/Windows dapat mengaktifkan `GPU=1` dan `CUDNN=1`).*

### 3. Build Program
Jalankan perintah berikut di terminal Anda untuk mulai kompilasi:
```bash
make clean
make -j4
```
Jika berhasil, akan muncul file aplikasi bernama `darknet`.

---

## 🚀 Cara Menjalankan YOLO (Real-Time Camera)

### 1. Download Bobot (*Weights*)
Unduh bobot YOLOv3-Tiny (model ringan & sangat cepat) ke dalam folder project:
```bash
wget https://data.pjreddie.com/files/yolov3-tiny.weights
```
*Atau untuk versi YOLOv3 standar (lebih akurat tapi komputasi lebih berat):*
```bash
wget https://pjreddie.com/media/files/yolov3.weights
```

### 2. Jalankan Deteksi Real-Time (Webcam / iPhone)
Jalankan perintah ini untuk memulai deteksi objek secara langsung menggunakan kamera bawaan Anda:
```bash
./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights -c 1
```
*(Ubah angka `-c 1` menjadi `-c 0` jika aplikasi kamera tidak terbuka otomatis).*

Di layar terminal, Anda akan melihat **Dashboard Teks ASCII** yang menampilkan *frame-rate* (FPS) dan daftar objek yang terdeteksi secara rapi!

---

## 📜 Lisensi & Kredit
Sistem dasar repositori ini mengambil dari framework Darknet asli karya **Joseph Redmon** (PJ Reddie). 
*Fork* optimasi ini ditujukan secara khusus untuk memberikan stabilitas pengembangan AI pada mesin Apple Silicon modern.