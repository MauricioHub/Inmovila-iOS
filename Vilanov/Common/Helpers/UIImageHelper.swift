//
//  UIImageHelper.swift
//  Vilanov
//
//  Created by andres paladines on 3/4/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//


/*
 #1 : Load GIF image Using Name
 
 let jeremyGif = UIImage.gifImageWithName("funny")
 let imageView = UIImageView(image: jeremyGif)
 imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
 view.addSubview(imageView)
 
 #2 : Load GIF image Using Data
 
 let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "play", withExtension: "gif")!)
 let advTimeGif = UIImage.gifImageWithData(imageData!)
 let imageView2 = UIImageView(image: advTimeGif)
 imageView2.frame = CGRect(x: 20.0, y: 220.0, width:
 self.view.frame.size.width - 40, height: 150.0)
 view.addSubview(imageView2)
 
 #3 : Load GIF image Using URL
 
 let gifURL : String = "http://www.gifbin.com/bin/4802swswsw04.gif"
 let imageURL = UIImage.gifImageWithURL(gifURL)
 let imageView3 = UIImageView(image: imageURL)
 imageView3.frame = CGRect(x: 20.0, y: 390.0, width: self.view.frame.size.width - 40, height: 150.0)
 view.addSubview(imageView3)
 */
import Foundation
import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension UIImage {
    
    public class func imageWithURL(_ url: String) -> UIImage? {
        guard let bundleURL:URL = URL(string: url)
            else {
                print("image named \"\(url)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(url)\" into NSData")
            return nil
        }
        
        return UIImage(data: imageData)
    }
    
    
    public class func gifImageWithData(_ data: Data, loopTime: Double = 450.0) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source, loopTime: loopTime)
    }
    
    public class func gifImageWithURL(_ gifUrl:String, loopTime: Double = 450.0) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData, loopTime: loopTime)
    }
    
    public class func gif(name: String, loopTime: Double = 450.0) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData, loopTime: loopTime)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource, loopTime: Double) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i), source: source)
            delays.append(Int(delaySeconds * loopTime)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 500.0)
        
        return animation
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo(width: Int, height: Int) -> UIImage {
        
        let newSize = CGSize(width: width, height: height)
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let _newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(_newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: _newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}



class UIImageHelper {
    
    static func imageToBase64(image: UIImage, width: CGFloat) -> String? {
        let thumb = image.resized(toWidth: width)
        let imageData = UIImagePNGRepresentation(thumb!)
        let strBase64 = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        return strBase64
    }
    
    //ESTE SI FUNCIONA!
    static func imageToBase64(image: UIImage, size: CGSize = CGSize(width: Const.avatarSize, height: Const.avatarSize)) -> String? {
        let thumb = UIImageHelper.resizeImage(image: image, targetSize: size)
        let imageData = UIImagePNGRepresentation(thumb)
        let strBase64 = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        return strBase64
    }

    
    static func base64ToImage(string: String) -> UIImage? {
        guard let dataDecoded : Data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else {
            print("no se pudo convertir imagen")
            return nil
        }
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func cornered(_ image:UIImageView, corners: CGFloat = 0, borderColor: UIColor = .white, borderWith: CGFloat = 0) -> UIImageView {
        image.layoutSubviews()
        if corners == 0 {
            let cornerRadius = image.bounds.size.width / 2.0
            image.layer.cornerRadius = cornerRadius
        }
        image.clipsToBounds = true
        if borderWith > 0 {
            image.layer.borderWidth    = borderWith
            image.layer.borderColor    = borderColor.cgColor
        }
        image.contentMode          = .scaleAspectFill
        return image
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    var highestQualityJPEGNSData:NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
    var highQualityJPEGNSData:NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
    var mediumQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
    var lowQualityJPEGNSData:NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
    var lowestQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.0)! as NSData }

}
