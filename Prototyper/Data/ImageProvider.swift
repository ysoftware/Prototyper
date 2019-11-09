//
//  ImageProvider.swift
//  Prototyper
//
//  Created by Ерохин Ярослав Игоревич on 09.11.2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Lottie
import Foundation
import CoreGraphics

final class ImageProvider: AnimationImageProvider {
    
    var baseUrl: URL?
    
    func imageForAsset(asset: ImageAsset) -> CGImage? {
        guard let url = baseUrl else { return nil }
        
        let fileUrl = url.appendingPathComponent(asset.directory)
            .appendingPathComponent(asset.name)
        
        guard let data = CGDataProvider(url: fileUrl as CFURL) else { return nil }
        
        return CGImage(pngDataProviderSource: data,
                       decode: nil,
                       shouldInterpolate: true,
                       intent: .defaultIntent)
    }
}
