//
//  PhotoFilter.swift
//  Project13
//
//  Created by Lucas Maniero on 12/03/22.
//

import CoreImage

struct PhotoFilter {
    var context: CIContext!
    var intensity: Double = 0.0
    var currentFilter: CIFilter!
    
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
