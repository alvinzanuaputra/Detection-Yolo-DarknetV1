#import <Metal/Metal.h>
#include <iostream>

int main() {
    std::cout << "--- Mendeteksi GPU di Apple Silicon (Mac M2) ---" << std::endl;
    
    // Coba dapatkan semua device (kadang di M1/M2 hanya mengembalikan 1 default device)
    NSArray<id<MTLDevice>>* devices = MTLCopyAllDevices();
    
    if ([devices count] > 0) {
        for (id<MTLDevice> device in devices) {
            std::cout << "GPU Terdeteksi : " << [[device name] UTF8String] << std::endl;
            std::cout << "Unified Memory : " << [device recommendedMaxWorkingSetSize] / (1024 * 1024) << " MB" << std::endl;
        }
    } else {
        // Fallback untuk Mac M1/M2 dimana MTLCopyAllDevices() mungkin kosong
        id<MTLDevice> defaultDevice = MTLCreateSystemDefaultDevice();
        if (defaultDevice) {
            std::cout << "GPU Terdeteksi : " << [[defaultDevice name] UTF8String] << std::endl;
            std::cout << "Unified Memory : " << [defaultDevice recommendedMaxWorkingSetSize] / (1024 * 1024) << " MB" << std::endl;
        } else {
            std::cout << "Tidak ditemukan GPU yang mendukung framework Metal." << std::endl;
        }
    }
    
    return 0;
}
