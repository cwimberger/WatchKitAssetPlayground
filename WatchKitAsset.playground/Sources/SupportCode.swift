//
//  Copyright (C) 2015 Christoph Wimberger.
//

import UIKit
import XCPlayground

private let AppleWatchScreenScale = 2

public func createImage(#time: NSTimeInterval, #size: CGSize, #animation: AnimationBlock) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(AppleWatchScreenScale))
    animation(time, size)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

public func createAssets(#name: String, #duration: NSTimeInterval, #size: CGSize, #framerate: Int, #animation: AnimationBlock) -> NSError? {
    let frameCount = Int(duration * Double(framerate))
    
    for frame in 1...frameCount {
        let filePath = XCPSharedDataDirectoryPath.stringByAppendingPathComponent(name) + "\(frame)@\(AppleWatchScreenScale)x.png"
        let time = duration * NSTimeInterval(frame - 1) / NSTimeInterval(frameCount)
        let image = createImage(time: time, size: size, animation: animation)
        let pngData = UIImagePNGRepresentation(image)
        var err: NSError? = nil
        pngData.writeToFile(filePath, options: NSDataWritingOptions.allZeros, error: &err)
        
        if err != nil {
            return err
        }
    }
    
    return nil
}

public func showAnimation(#name: String, #size: CGSize, #framerate: Int, #animation: AnimationBlock) {
    let magnification: CGFloat = 5
    let frame = CGRectMake(0, 0, size.width * magnification, size.height * magnification)
    let rv = RenderView(frame: frame, imageSize: size, framerate: framerate, animation: animation)
    XCPShowView(name, rv)
    XCPSetExecutionShouldContinueIndefinitely()
}

class RenderView: UIImageView {
    private let imageSize: CGSize
    private let animation: AnimationBlock
    private var startTime: NSDate
    private var timer: NSTimer?

    init(frame: CGRect, imageSize: CGSize, framerate: Int, animation: AnimationBlock) {
        self.imageSize = imageSize
        self.animation = animation
        self.startTime = NSDate()
        super.init(frame: frame)
        self.layer.magnificationFilter = kCAFilterNearest
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0 / Double(framerate), target: self, selector: "tick", userInfo: nil, repeats: true)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tick() {
        self.image = createImage(time: -startTime.timeIntervalSinceNow, size: self.imageSize, animation: self.animation)
    }
}