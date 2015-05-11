# WatchKitAssetPlayground
A swift playground for creating awesome animations for your WatchKit Apps.

![Playground](/readme-assets/playground.png?raw=true "Playground")

Examples:

![Apple Activity Indicator Animation](/readme-assets/apple.gif?raw=true "Apple Activity Indicator Animation")
![Twitter Activity Indicator Animation](/readme-assets/twitter.gif?raw=true "Twitter Activity Indicator Animation")

These little animations can be implemented in a functional way:

```swift
let dots = 3
let duration = 2.0
let color = UIColor.blackColor()
let circleSize = interpolate(duration: duration, curve: easeInOutQuad, values: 0.0, 20.0)
let c = circle(size: circleSize, color: color)
let circleAlpha = interpolate(duration: duration, curve: easeInOutQuad, values: 1.0, 0.0)
let ac = alpha(value: circleAlpha, animation: c)

var circles: [AnimationBlock] = []
for i in 0..<dots {
  let delayDuration = duration * Double(i) / Double(dots)
  let delayedAnimation = delay(duration: delayDuration, animation: ac)
  circles.append(delayedAnimation)
}
  
let anim = loop(from: duration, duration: duration, animation: overlay(circles))
```

To display the animation right in your playground, use the showAnimation function to show the animation 5x magnified directly in the playground - perfect for prototyping.
```swift
let assetSize = CGSize(width: 20, height: 20)
showAnimation(name: "Twitter", size: assetSize, framerate: 20, animation: anim)
```

When you're finished, export all needed PNGs using the createAssets function. It will create all files in your "~/Documents/Shared Playground Data/" directory. Please make sure it exists.
```
createAssets(name: "twitter", duration: 2.0, size: assetSize, framerate: 20, animation: anim)
```

![Generated PNGs](/readme-assets/generated-pngs.png?raw=true "Generated PNGs")
