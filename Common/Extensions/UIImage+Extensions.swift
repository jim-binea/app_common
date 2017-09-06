//
//  UIImage+Extensions.swift
//  Common
//
//  Created by binea on 2017/3/15.
//  Copyright © 2017年 binea. All rights reserved.
//

import Foundation
public typealias ImageEncode = (UIImage) -> Data?

public enum ImageFormat {
    case png
    case jpeg(quality: CGFloat)
    
    var encode: ImageEncode {
        switch self {
        case .png:
            return UIImagePNGRepresentation
        case .jpeg(let quality):
            return { UIImageJPEGRepresentation($0, quality) }
        }
    }
}

extension UIImage {
    public func write(toFile filePath: String, format: ImageFormat) throws {
        guard let data = format.encode(self) else {
            fatalError("image format: \(format) encode image failed!")
        }
        let fileUrl = URL(fileURLWithPath: filePath)
        try data.write(to: fileUrl)
    }
    
    public func imageView() -> UIImageView {
        let view = UIImageView(image: self)
        view.contentMode = .scaleAspectFill
        return view
    }
    
    public func imageButton<T: UIButton>() -> T {
        let button = T(frame: CGRect(origin: .zero, size: self.size))
        button.setImage(self, for: .normal)
        
        return button
    }
    
    public func clip(with path: CGPath) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.addPath(path)
        context.clip()
        self.draw(at: .zero)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    public class func from(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
}

extension UIImage {
    
    public func resizableImageInCenter(top:CGFloat = 10,left:CGFloat = 10,bottom:CGFloat = 10,right:CGFloat = 10) -> UIImage {
        
        return resizableImage(withCapInsets:UIEdgeInsetsMake(top, left, bottom, right) , resizingMode: UIImageResizingMode.tile)
    }
    
    public func fixRotation() -> UIImage {
        return rotation(orientation: imageOrientation)
    }
    
    public func rotation(orientation: UIImageOrientation) -> UIImage {
        if case .up = orientation {
            return self
        }
        
        var rotate: Double = Double.pi/2
        var rect = CGRect.zero
        var translateX: CGFloat = 0
        var translateY: CGFloat = 0
        var scaleX: CGFloat = 0
        var scaleY: CGFloat = 0
        
        switch (orientation) {
        case .left:
            rotate = Double.pi/2
            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
            translateX = 0
            translateY = -rect.width
            scaleY = rect.width/rect.height
            scaleX = rect.height/rect.width
        case .right:
            rotate = 3 * Double.pi/2
            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
            translateX = -rect.size.height
            translateY = 0
            scaleY = rect.width/rect.height
            scaleX = rect.height/rect.width
        case .down:
            rotate = Double.pi
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            translateX = -rect.width
            translateY = -rect.height
        default:
            rotate = 0.0
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            translateX = 0
            translateY = 0
        }
        guard let ctx = CGContext.init(data: nil, width: Int(rect.width), height: Int(rect.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace)!, bitmapInfo: (cgImage?.bitmapInfo.rawValue)!) else {
            return self
        }
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: rect.width, y: rect.height)
        transform = transform.scaledBy(x: -1, y: -1)
        transform = transform.rotated(by: CGFloat(rotate))
        transform = transform.translatedBy(x: translateX, y: translateY)
        transform = transform.scaledBy(x: scaleX, y: scaleY)
        
        ctx.concatenate(transform)
        ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        
        guard let image = ctx.makeImage() else {
            return self
        }
        return UIImage(cgImage: image)
    }
    
    public func ui_resizeImage(to targetSize: CGSize) -> UIImage {
        let imageSize = self.size.scale(to: targetSize)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        let bounds = CGRect(origin: CGPoint.zero, size: imageSize)
        draw(in: bounds)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    public func ui_resizeImage(toWidth targetWidth: CGFloat) -> UIImage {
        let imageSize = self.size.scale(toWidth: targetWidth)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 2)
        let bounds = CGRect(origin: CGPoint.zero, size: imageSize)
        draw(in: bounds)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    public func ui_shadowImage(with color: UIColor, shadowOffset: CGSize, shadowBlur: CGFloat, targetSize: CGSize) -> UIImage {
        let imageSize = self.size.scale(to: targetSize)
        
        guard let shadowContext = CGContext.init(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace)!, bitmapInfo: (cgImage?.bitmapInfo.rawValue)!) else {
            return self
        }
        shadowContext.setShadow(offset: shadowOffset, blur: shadowBlur, color: color.cgColor)
        
        let drawRect = CGRect(x: -shadowBlur, y: -shadowBlur, width: imageSize.width + shadowBlur, height: imageSize.height + shadowBlur)
        shadowContext.draw(cgImage!, in: drawRect)
        let shadowedCGImage = shadowContext.makeImage()!
        return UIImage(cgImage: shadowedCGImage)
    }
}
