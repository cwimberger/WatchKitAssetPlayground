//
//  Copyright (C) 2015 Christoph Wimberger.
//

import UIKit

public typealias ValueBlock = (NSTimeInterval) -> CGFloat
public typealias AnimationCurve = (CGFloat) -> CGFloat

public func interpolate(#duration: NSTimeInterval, #values: CGFloat...) -> ValueBlock {
    return interpolate(duration: duration, curve: linear, values: values)
}

public func interpolate(#duration: NSTimeInterval, #curve: AnimationCurve, #values: CGFloat...) -> ValueBlock {
    return interpolate(duration: duration, curve: curve, values: values)
}

func interpolate(#duration: NSTimeInterval, #curve: AnimationCurve, #values: [CGFloat]) -> ValueBlock {
    let elementDuration = duration / NSTimeInterval(values.count - 1)
    
    return { time in
        let timeInSequence = time % duration
        let currentIndex = timeInSequence / elementDuration
        let startElementIndex = Int(floor(currentIndex)) % values.count
        let endElementIndex = (startElementIndex + 1) % values.count
        let perc = curve(CGFloat(currentIndex) % 1.0)
        
        let from = values[startElementIndex]
        let to = values[endElementIndex]
        return from + (to - from) * CGFloat(perc)
    }
}

public func constant(value: CGFloat) -> ValueBlock {
    return { _ in
        return value
    }
}

public func linear(value: CGFloat) -> CGFloat {
    return value
}

public func easeInQuad(value: CGFloat) -> CGFloat {
    return value * value
}

public func easeOutQuad(value: CGFloat) -> CGFloat {
    return -(value * (value - 2.0))
}

public func easeInOutQuad(value: CGFloat) -> CGFloat {
    let v = value * 2.0
    
    if v < 1 {
        return easeInQuad(v) * 0.5
    } else {
        return 0.5 + easeOutQuad(v - 1) * 0.5
    }
}

public func easeInCubic(value: CGFloat) -> CGFloat {
    return value * value * value
}

public func easeOutCubic(value: CGFloat) -> CGFloat {
    let v = value - 1.0
    return v * v * v + 1.0
}

public func easeInOutCubic(value: CGFloat) -> CGFloat {
    let v = value * 2.0
    
    if v < 1 {
        return easeInCubic(v) * 0.5
    } else {
        return 0.5 + easeOutCubic(v - 1) * 0.5
    }
}

public func easeInQuart(value: CGFloat) -> CGFloat {
    return value * value * value * value
}

public func easeOutQuart(value: CGFloat) -> CGFloat {
    let v = value - 1.0
    return -(v * v * v * v - 1)
}

public func easeInOutQuart(value: CGFloat) -> CGFloat {
    let v = value * 2.0
    
    if v < 1 {
        return easeInQuart(v) * 0.5
    } else {
        return 0.5 + easeOutQuart(v - 1) * 0.5
    }
}