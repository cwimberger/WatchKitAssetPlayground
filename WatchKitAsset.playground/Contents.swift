//: This Playground is (C) 2015 Christoph Wimberger, see https://github.com/cwimberger/WatchKitAssetPlayground for more information and documentation.
//: 
//: IMPORTANT: Click "View" -> "Assistant Editor" -> "Show Assistant Editor" to show the animation previews in this playground.

import UIKit

//: Implement an Apple-like activiy indicator animation
func appleActivityIndicator(#dots: Int, #dotSize: CGFloat, #duration: NSTimeInterval, #color: UIColor) -> AnimationBlock {
    let c = circle(size: constant(dotSize), color: color)
    let ac = alpha(value: interpolate(duration: duration, curve: linear, values: 0.2, 1.0, 0.6, 0.2), animation: c)
    let tc = translate(x: constant(0), y: constant(-5), animation: ac)
    
    var circles: [AnimationBlock] = []
    for i in 0..<dots {
        let rot = rotate(angle: constant(CGFloat(360*i/dots)), animation: tc)
        let dur = duration * Double(i) / Double(dots)
        let del = delay(duration: dur, animation: rot)
        circles.append(del)
    }
    
    return loop(from: duration, duration: duration, animation: overlay(circles))
}

//: Implement a Twitter-like activity indicator animation
func twitterActivityIndicator(#dots: Int, #duration: NSTimeInterval, #color: UIColor) -> AnimationBlock {
    let c = circle(size: interpolate(duration: duration, curve: easeInOutQuad, values: 0.0, 20.0), color: color)
    let ac = alpha(value: interpolate(duration: duration, curve: easeInOutQuad, values: 1.0, 0.0), animation: c)

    var circles: [AnimationBlock] = []
    for i in 0..<dots {
        let dur = duration * Double(i) / Double(dots)
        let del = delay(duration: dur, animation: ac)
        circles.append(del)
    }
    
    return loop(from: duration, duration: duration, animation: overlay(circles))
}

//: Create the Twitter and Apple animations
let twitterAnimation = twitterActivityIndicator(dots: 3, duration: 2.0, color: UIColor.blackColor())
let appleAnimation = appleActivityIndicator(dots: 6, dotSize: 4, duration: 1.0, color: UIColor.blackColor())

//: In this example we want all our assets to be 20 x 20 points (40 x 40 pixels) and playing at a framerate of 20 frames per second.
let assetSize = CGSize(width: 20, height: 20)
let framerate = 20

//: The showAnimation function shows the animation 5x magnified directly in the playground - perfect for prototyping.
showAnimation(name: "Twitter", size: assetSize, framerate: framerate, animation: twitterAnimation)
showAnimation(name: "Apple", size: assetSize, framerate: framerate, animation: appleAnimation)

//: When finished, the animations can be saved into '~/Documents/Shared Playground Data/' as a list of PNG files. You can then easily drop these files into your asset catalog. The directory has to be created manually to let this playground write the images to disk.
// createAssets(name: "twitter", duration: 2.0, size: assetSize, framerate: framerate, animation: twitterAnimation)
// createAssets(name: "apple", duration: 1.0, size: assetSize, framerate: framerate, animation: appleAnimation)
