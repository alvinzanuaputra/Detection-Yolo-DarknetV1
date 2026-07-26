# Darknet: Open Source Neural Networks in C

Darknet is an open source neural network framework written in C and CUDA. It is fast, easy to install, and supports CPU and GPU computation. This repository is a specialized fork that has been highly optimized for macOS (Apple Silicon M1/M2/M3), while retaining full compatibility with Linux and Windows.

[Baca dalam Bahasa Indonesia](README.md)

## New Features & macOS (Apple Silicon) Optimizations
- **Apple Silicon Native**: Fully optimized for ARM64 processors (M1/M2/M3 architecture).
- **Camera Threading Fix (Continuity Camera)**: Completely resolved the force close issue when using iPhone Continuity Camera due to macOS AVFoundation security thread limitations.
- **Multi-Core (OpenMP) Bug Fix**: Fixed a Segmentation Fault in `gemm.c` when multi-core processing is enabled (`OPENMP=1`), ensuring stable high FPS.
- **Terminal UI Dashboard**: A clean and easy-to-read terminal-based real-time detection interface (ASCII), replacing the messy default output.
- **OpenCV 5 Compatibility**: Fixed header and C/C++ data type issues (`cvWaitKey`, `cvCapture`) to support modern OpenCV libraries.

## 0. Preview 

#### *For image and training result information:*


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

Before you begin, ensure your system has:
*   **OS**: Linux (Ubuntu/Debian highly recommended), macOS (M1/M2), or Windows (with WSL or a custom build).
*   **Compiler**: `gcc` or `clang`.
*   **CUDA** (Optional, but highly recommended for performance): If you have an NVIDIA GPU.
*   **OpenCV** (Optional but required for camera): To display detection results visually and process video.
*   **OpenMP** (Highly recommended): For multi-core CPU processing.

## 2. Installation and Compilation

### Step 1: Clone Repository
If you haven't already:
```bash
git clone https://github.com/alvinzanuaputra/Detection-Yolo-DarknetV1.git
cd Detection-Yolo-DarknetV1
```

### Step 2: Configure Makefile
Before compiling, you need to edit the `Makefile` to enable GPU, OpenCV, and other optimizations.

Open `Makefile` with a text editor (like `nano` or VS Code) and change the following lines at the top. For macOS Apple Silicon, the best settings are:

```makefile
GPU=0      # Change to 1 if using an NVIDIA GPU and CUDA
CUDNN=0    # Change to 1 if using cuDNN (for further acceleration)
OPENCV=1   # Change to 1 for video and webcam support
OPENMP=1   # Enable multi-core for maximum CPU performance
DEBUG=0
```

Configuration details
Darknet is easy to install with just two optional dependencies:

- [OpenCV](https://opencv.org) if you want a wider variety of supported image types.
- [CUDA](https://developer.nvidia.com/cuda-downloads) if you want GPU computation.

Both are optional, so you can start by installing just the base system. I have tested this on a Linux machine and the new optimizations on macOS.

### Step 3: Compilation
Run the following command in the terminal to compile the program:

```bash
make
```

If it fails, you can repeat the process by running make again:

```bash
make clean
make -j4
```

If successful, you will see an executable file named `darknet` in the folder.

## 3. Download Pre-trained Weights

To run object detection, you need a pre-trained weights file. For YOLOv3, download the following file:

```Configuration files for the full YOLO version are already in the cfg/ subdirectory. You will need the training files.```

```bash
wget https://pjreddie.com/media/files/yolov3.weights
```

```yolov3-tiny. To use this model, download the tiny YOLO version```

```bash
wget https://data.pjreddie.com/files/yolov3-tiny.weights
```

## 4. Usage

Here are some basic commands to use Darknet.

### Detection on an Image
To detect objects in a single image:

```bash
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input/images/eagle.jpg
```
The detection result will be saved as `predictions.jpg`.

### Detection on a Video File
To process a video file:

```bash
./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights <path_to_video_file>
```

Example:
```bash
./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights video/videoplayback1.mp4
```

**Saving Video Results (Without a Display Window):**
If you are running on a headless server or want to save the detection results frame by frame:

```bash
./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights video/videoplayback1.mp4 -prefix output/video_frames/frame
```
The command above will save the detection frames into the `output/video_frames/` directory.

### Real-time Detection (Webcam / iPhone)
To use a webcam connected to the computer:

```bash
./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights -c 1
```
*(Change `-c 1` to `-c 0` if the camera does not open automatically).*
(Ensure `OPENCV=1` in the Makefile and the webcam is detected).

## 5. Configuration for Inference (Important!)

If you experience a **"CUDA Error: out of memory"** error while running detection, you need to change the configuration in the `cfg/yolov3.cfg` file.

1.  Open `cfg/yolov3.cfg`.
2.  Locate the `[net]` section in the early lines.
3.  Change `batch` and `subdivisions` for **Testing** mode (not Training):

```ini
[net]
# Testing
batch=1
subdivisions=1
# Training
# batch=64
# subdivisions=16
```

Make sure the `# Testing` section is uncommented (active) and the `# Training` section is commented (with a `#`).

## 6. Important Folder Structure

*   `cfg/`: Contains network configuration files (.cfg).
*   `data/`: Contains object name labels (e.g., `coco.names`) and sample images.
*   `src/`: C/CUDA source code.
*   `weights/`: Directory for storing .weights files (it's recommended to create this folder to keep things tidy).
*   `results/`: Output folder (can be created manually to store results).

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

## References

*   Official Website: [https://pjreddie.com/darknet](https://pjreddie.com/darknet)
*   YOLO: [https://pjreddie.com/darknet/yolo](https://pjreddie.com/darknet/yolo)
*   paper - YOLOv7: [https://arxiv.org/abs/2207.02696](https://arxiv.org/abs/2207.02696)
*   source code - Pytorch: [https://github.com/WongKinYiu/yolov7](https://github.com/WongKinYiu/yolov7)
