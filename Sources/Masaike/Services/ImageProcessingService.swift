import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import AppKit

final class ImageProcessingService {
    static let shared = ImageProcessingService()
    private let context = CIContext(options: [
        .cacheIntermediates: false,
        .name: "MasaikeProcessingContext"
    ])

    private init() {}

    func apply(regions: [BlurRegion], to image: CIImage) -> CIImage {
        var output = image
        for region in regions {
            output = apply(region: region, to: output)
        }
        return output
    }

    private func apply(region: BlurRegion, to image: CIImage) -> CIImage {
        let rect = region.rect.intersection(image.extent)
        guard !rect.isEmpty else { return image }

        let cropped = image.cropped(to: rect)
        let blurred: CIImage

        switch region.type {
        case .mosaic:
            blurred = applyMosaic(to: cropped, intensity: region.intensity)
        case .gaussian:
            blurred = applyGaussianBlur(to: cropped, intensity: region.intensity)
        }

        // Gaussian blur expands the image; crop back to region size and translate to original position
        let croppedBlurred = blurred.cropped(to: CGRect(origin: .zero, size: rect.size))
        let translated = croppedBlurred.transformed(by: CGAffineTransform(translationX: rect.origin.x, y: rect.origin.y))
        return translated.composited(over: image)
    }

    private func applyMosaic(to image: CIImage, intensity: Double) -> CIImage {
        let filter = CIFilter.pixellate()
        filter.inputImage = image
        // Map intensity (0...1) to scale (4...60)
        filter.scale = Float(4 + intensity * 56)
        return filter.outputImage ?? image
    }

    private func applyGaussianBlur(to image: CIImage, intensity: Double) -> CIImage {
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = image
        // Map intensity (0...1) to radius (2...40)
        filter.radius = Float(2 + intensity * 38)
        return filter.outputImage ?? image
    }

    func render(_ ciImage: CIImage, toSize targetSize: CGSize? = nil) -> NSImage? {
        let size = targetSize ?? ciImage.extent.size
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: size)
    }
}
