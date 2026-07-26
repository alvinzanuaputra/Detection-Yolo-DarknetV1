# Darknet: Real-Time Object Detection (Optimized for Apple Silicon )

<div align="center">
  <img src="https://user-images.githubusercontent.com/4096485/101363015-e5c21200-38b1-11eb-986f-b3e516e05977.png" alt="YOLOv4 Tiny"/>
</div>

Darknet is an open-source neural network framework written in C and CUDA. This repository is a specialized fork highly optimized for **macOS (Apple Silicon M1/M2/M3)**, while retaining full compatibility with Linux and Windows.

[🇮🇩 Baca dalam Bahasa Indonesia](README.md)

## ✨ New Features & Optimizations
- **Apple Silicon Native**: Fully optimized for ARM64 processors (M1/M2/M3 architecture).
- **Camera Threading Fix**: Completely resolved the *force close* (AVFoundation segfault) issue caused by Apple's strict Main Thread UI requirements when using iPhone Continuity Camera.
- **Multi-Core (OpenMP) Stability**: Fixed a critical *Segmentation Fault* race condition in `gemm.c` when using `OPENMP=1`, unlocking stable high-FPS multi-core processing.
- **Terminal UI Dashboard**: Replaced the messy default console output with a beautiful, clean, and organized real-time ASCII dashboard.
- **OpenCV 5 Compatibility**: Fixed legacy C/C++ bindings (`cvWaitKey`, `cvCapture`) to seamlessly compile and run with modern OpenCV 5.0 library via Homebrew.

---

## 🛠 Installation and Build

### 1. Requirements
- **OS**: macOS (M1/M2 highly recommended), Linux, or Windows.
- **Compiler**: `gcc` or `clang`.
- **OpenCV** (Optional but required for webcam/video): Recommended via Homebrew on Mac (`brew install opencv`).
- **OpenMP** (Highly recommended): For multi-core CPU processing (`brew install libomp`).

### 2. Configure `Makefile`
Before compiling, open the `Makefile` with a text editor. For macOS Apple Silicon users, the optimal settings are:
```makefile
GPU=0
CUDNN=0
OPENCV=1   # Required to enable camera support
OPENMP=1   # Enable multi-core for maximum CPU performance
DEBUG=0
```
*(Note: Linux/Windows users with NVIDIA GPUs can set `GPU=1` and `CUDNN=1`).*

### 3. Build the Program
Run the following commands in your terminal to begin compilation:
```bash
make clean
make -j4
```
If successful, an executable file named `darknet` will be generated in the root folder.

---

## 🚀 Running Real-Time YOLO

### 1. Download Pre-trained Weights
Download the YOLOv3-Tiny weights (lightweight & extremely fast) into the project root:
```bash
wget https://data.pjreddie.com/files/yolov3-tiny.weights
```
*Alternatively, for standard YOLOv3 (more accurate but computationally heavier):*
```bash
wget https://pjreddie.com/media/files/yolov3.weights
```

### 2. Run Live Detection (Webcam / iPhone)
Execute this command to start real-time detection using your camera:
```bash
./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights -c 1
```
*(Change `-c 1` to `-c 0` if the camera window does not open automatically).*

In your terminal, you will see a beautiful **ASCII Terminal Dashboard** displaying your real-time FPS and neatly listing all detected objects!

---

## 📜 License & Credits
Based on the original Darknet framework by **Joseph Redmon** (PJ Reddie). 
This macOS optimization fork aims to provide modern stability for Apple Silicon developers.
