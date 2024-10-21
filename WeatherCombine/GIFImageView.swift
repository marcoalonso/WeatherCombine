//
//  GIFImageView.swift
//  WeatherCombine
//
//  Created by Marco Alonso on 20/10/24.
//

import Foundation
import SwiftUI
import UIKit
import ImageIO

struct GIFImageView: UIViewRepresentable {
    var gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        playGif(named: gifName, in: imageView)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}

    // Función para cargar y reproducir el GIF
    private func playGif(named name: String, in imageView: UIImageView) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else { return }
        let url = URL(fileURLWithPath: path)
        
        guard let gifData = try? Data(contentsOf: url) else { return }
        let gifSource = CGImageSourceCreateWithData(gifData as CFData, nil)
        
        let frameCount = CGImageSourceGetCount(gifSource!)
        var images = [UIImage]()
        var duration: Double = 0
        
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(gifSource!, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                let frameProperties = CGImageSourceCopyPropertiesAtIndex(gifSource!, i, nil) as? [String: Any]
                let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
                let frameDuration = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
                duration += frameDuration
            }
        }
        
        imageView.animationImages = images
        imageView.animationDuration = duration
        imageView.startAnimating()
    }
}
