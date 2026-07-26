# Darknet: Open Source Neural Networks dalam C

Darknet adalah framework neural network open source yang ditulis menggunakan C dan CUDA. Framework ini cepat, mudah diinstall, dan mendukung komputasi CPU maupun GPU. Repositori ini merupakan fork khusus yang telah dioptimalkan untuk macOS (Apple Silicon M1/M2/M3), sekaligus tetap mendukung Linux dan Windows.

[Read this in English](README-EN.md)

## Fitur Baru & Optimasi macOS (Apple Silicon)
- **Apple Silicon Native**: Optimalisasi penuh untuk prosesor ARM64 (M1/M2/M3).
- **Perbaikan Crash Kamera (Continuity Camera)**: Resolusi tuntas pada isu force close saat menggunakan kamera iPhone via Continuity Camera karena batasan keamanan thread AVFoundation macOS.
- **Perbaikan Bug Multi-Core (OpenMP)**: Memperbaiki Segmentation Fault pada `gemm.c` saat komputasi multi-core diaktifkan (`OPENMP=1`), menjamin FPS tinggi yang stabil.
- **Terminal UI Dashboard**: Antarmuka deteksi real-time berbasis terminal (ASCII) yang rapi dan mudah dibaca, menggantikan output bawaan yang berantakan.
- **Kompatibilitas OpenCV 5**: Memperbaiki isu header dan tipe data C/C++ (`cvWaitKey`, `cvCapture`) untuk mendukung library OpenCV modern.

## 0. Preview 

#### *Untuk informasi gambar dan hasil training:*


![yolo_progress](https://user-images.githubusercontent.com/4096485/146988929-1ed0cbec-1e01-4ad0-b42c-808dcef32994.png) https://paperswithcode.com/sota/object-detection-on-coco

----

![scaled_yolov4](https://user-images.githubusercontent.com/4096485/112776361-281d8380-9048-11eb-8083-8728b12dcd55.png) AP50:95 - FPS (Tesla V100) Paper: https://arxiv.org/abs/2011.08036

----

![YOLOv4Tiny](https://user-images.githubusercontent.com/4096485/101363015-e5c21200-38b1-11eb-986f-b3e516e05977.png)

----

![YOLOv4](https://user-images.githubusercontent.com/4096485/90338826-06114c80-dff5-11ea-9ba2-8eb63a7409b3.png)

</details>

----

![OpenCV_TRT](https://user-images.githubusercontent.com/4096485/90338805-e5e18d80-dff4-11ea-8a68-5710956256ff.png)


## 1. Requirements

Sebelum memulai, pastikan sistem Anda memiliki:
*   **OS**: Linux (Ubuntu/Debian sangat disarankan), macOS (M1/M2), atau Windows (dengan WSL atau build khusus).
*   **Compiler**: `gcc` atau `clang`.
*   **CUDA** (Opsional, tapi sangat disarankan untuk performa): Jika Anda memiliki GPU NVIDIA.
*   **OpenCV** (Opsional tapi wajib untuk kamera): Untuk menampilkan hasil deteksi secara visual dan memproses video.
*   **OpenMP** (Sangat disarankan): Untuk komputasi CPU multi-core.

## 2. Instalasi dan Kompilasi

### Langkah 1: Clone Repository
Jika Anda belum memiliki repository ini:
```bash
git clone https://github.com/alvinzanuaputra/Detection-Yolo-DarknetV1.git
cd Detection-Yolo-DarknetV1
```

### Langkah 2: Konfigurasi Makefile
Sebelum melakukan kompilasi, Anda perlu mengedit file `Makefile` untuk mengaktifkan fitur GPU, OpenCV, dan optimasi lainnya.

Buka file `Makefile` dengan text editor (seperti `nano` atau VS Code) dan ubah baris berikut di bagian paling atas. Untuk macOS Apple Silicon, setting terbaik adalah:

```makefile
GPU=0      # Ubah menjadi 1 jika menggunakan NVIDIA GPU dan CUDA
CUDNN=0    # Ubah menjadi 1 jika menggunakan cuDNN (untuk percepatan lebih lanjut)
OPENCV=1   # Ubah menjadi 1 untuk dukungan video dan webcam
OPENMP=1   # Aktifkan multi-core untuk performa maksimal di CPU
DEBUG=0
```

Disini untuk konfigurasi 
Darknet mudah diinstal hanya dengan dua dependensi opsional:

- [OpenCV](https://opencv.org) jika Anda menginginkan lebih banyak variasi jenis citra yang didukung.
- [CUDA](https://developer.nvidia.com/cuda-downloads) jika Anda menginginkan komputasi GPU.

Keduanya opsional, jadi bisa dimulai dengan menginstal sistem dasarnya saja. Saya hanya menguji ini di komputer Linux dan optimasi baru di macOS.

### Langkah 3: Kompilasi
Jalankan perintah berikut di terminal untuk mengompilasi program:

```bash
make
```

Jika gagal dapat diulangi prosesnya menjalankan make ulang:

```bash
make clean
make -j4
```

Jika berhasil, Anda akan melihat file executable bernama `darknet` di folder tersebut.

## 3. Download Pre-trained Weights

Untuk menjalankan deteksi objek, Anda memerlukan file bobot (weights) yang sudah dilatih. Untuk YOLOv3, download file berikut:

```Disini sudah ada berkas konfigurasi untuk versi YOLO full version di subdirektori cfg/. Butuh berkas untuk training```

```bash
wget https://pjreddie.com/media/files/yolov3.weights
```

```yolov3-tiny. Untuk menggunakan model ini, unduh berkas ini versi tiny YOLO```

```bash
wget https://data.pjreddie.com/files/yolov3-tiny.weights
```

## 4. Penggunaan (Usage)

Berikut adalah beberapa perintah dasar untuk menggunakan Darknet.

### Deteksi pada Gambar (Image)
Untuk mendeteksi objek pada satu gambar:

```bash
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input/images/eagle.jpg
```
Hasil deteksi akan disimpan sebagai `predictions.jpg`.

### Deteksi pada File Video
Untuk memproses file video:

```bash
./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights <path_to_video_file>
```

Contoh:
```bash
./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights video/videoplayback1.mp4
```

**Menyimpan Hasil Video (Tanpa Tampilan Window):**
Jika menjalankan di server tanpa monitor atau ingin menyimpan setiap frame by frame dengan hasil deteksi:

```bash
./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights video/videoplayback1.mp4 -prefix output/video_frames/frame
```
Perintah di atas akan menyimpan frame hasil deteksi ke folder `output/video_frames/`.

### Deteksi Real-time (Webcam / iPhone)
Untuk menggunakan webcam yang terhubung ke komputer:

```bash
./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights -c 1
```
*(Ubah angka `-c 1` menjadi `-c 0` jika kamera tidak terbuka otomatis).*
(Pastikan `OPENCV=1` di Makefile dan webcam terdeteksi).

## 5. Konfigurasi untuk Inferensi (Penting!)

Jika Anda mengalami error **"CUDA Error: out of memory"** saat menjalankan deteksi, Anda perlu mengubah konfigurasi di file `cfg/yolov3.cfg`.

1.  Buka `cfg/yolov3.cfg`.
2.  Cari bagian `[net]` di baris-baris awal.
3.  Ubah `batch` dan `subdivisions` untuk mode **Testing** (bukan Training):

```ini
[net]
# Testing
batch=1
subdivisions=1
# Training
# batch=64
# subdivisions=16
```

Pastikan bagian `# Testing` tidak dikomentari (aktif), dan bagian `# Training` dikomentari (tanda `#`).

## 6. Struktur Folder Penting

*   `cfg/`: Berisi file konfigurasi jaringan (.cfg).
*   `data/`: Berisi file label nama objek (misal `coco.names`) dan gambar contoh.
*   `src/`: Source code C/CUDA.
*   `weights/`: Tempat menyimpan file .weights (disarankan buat folder ini agar rapi).
*   `results/`: Folder output (bisa dibuat manual untuk menyimpan hasil).

## Citation


```
@misc{https://doi.org/10.48550/arxiv.2207.02696,
  doi = {10.48550/ARXIV.2207.02696},
  url = {https://arxiv.org/abs/2207.02696},
  author = {Wang, Chien-Yao and Bochkovskiy, Alexey and Liao, Hong-Yuan Mark},
  keywords = {Computer Vision and Pattern Recognition (cs.CV), FOS: Computer and information sciences, FOS: Computer and information sciences},
  title = {YOLOv7: Trainable bag-of-freebies sets new state-of-the-art for real-time object detectors},
  publisher = {arXiv},
  year = {2022}, 
  copyright = {arXiv.org perpetual, non-exclusive license}
}
```

```
@misc{bochkovskiy2020yolov4,
      title={YOLOv4: Optimal Speed and Accuracy of Object Detection}, 
      author={Alexey Bochkovskiy and Chien-Yao Wang and Hong-Yuan Mark Liao},
      year={2020},
      eprint={2004.10934},
      archivePrefix={arXiv},
      primaryClass={cs.CV}
}
```

```
@InProceedings{Wang_2021_CVPR,
    author    = {Wang, Chien-Yao and Bochkovskiy, Alexey and Liao, Hong-Yuan Mark},
    title     = {{Scaled-YOLOv4}: Scaling Cross Stage Partial Network},
    booktitle = {Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
    month     = {June},
    year      = {2021},
    pages     = {13029-13038}
}
```

## Referensi

*   Website Resmi: [https://pjreddie.com/darknet](https://pjreddie.com/darknet)
*   YOLO: [https://pjreddie.com/darknet/yolo](https://pjreddie.com/darknet/yolo)
*   paper - YOLOv7: [https://arxiv.org/abs/2207.02696](https://arxiv.org/abs/2207.02696)
*   kode sumber - Pytorch: [https://github.com/WongKinYiu/yolov7](https://github.com/WongKinYiu/yolov7)