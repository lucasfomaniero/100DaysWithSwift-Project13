//
//  PhotoFilter.swift
//  Project13
//
//  Created by Lucas Maniero on 12/03/22.
//

import CoreImage
import UIKit

struct PhotoFilter {
    var context: CIContext!
    var intensity: Double = 0.0
    var currentFilter: CIFilter!
    var currentImage: UIImage?
    
    var processedImage: UIImage? {
        guard let currentImage = currentImage else {
            return nil
        }

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        guard let image = currentFilter.outputImage, let cgimg = context.createCGImage(image, from: image.extent) else {
            return nil
        }
        let processedImage = UIImage(cgImage: cgimg)
        return processedImage
    }
    
    init(_ filter: FilterType = .sepia) {
        context = CIContext()
        currentFilter = CIFilter(name: filter.name)
    }
    
    public enum FilterType: String, CaseIterable {
        case bumpDistortion
        case gaussianBlur
        case pixellate
        case sepia
        case twirlDistortion
        case unsharp
        case vignette
        
        var name:  String {
            switch self {
            case .bumpDistortion:  return "CIBumpDistortion"
            case .gaussianBlur:    return "CIGaussianBlur"
            case .pixellate:       return "CIPixellate"
            case .sepia:           return "CISepiaTone"
            case .twirlDistortion: return "CITwirlDistortion"
            case .unsharp:         return "CIUnsharpMask"
            case .vignette:        return "CIVignette"
            }
        }
    }
    
}
