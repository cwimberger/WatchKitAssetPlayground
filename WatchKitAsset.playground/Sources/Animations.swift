//
//  Copyright (C) 2015 Christoph Wimberger.
//

import UIKit

public typealias AnimationBlock = (NSTimeInterval, CGSize) -> Void

public func alpha(#value: ValueBlock, #animation: AnimationBlock) -> AnimationBlock {
    return { time, size in
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetAlpha(context, value(time))
        animation(time, size)
        CGContextRestoreGState(context)
    }
}

public func delay(#duration: NSTimeInterval, #animation: AnimationBlock) -> AnimationBlock {
    return { time, size in
        animation(max(time - duration, 0), size)
    }
}

public func fill(#color: UIColor) -> AnimationBlock {
    return { time, canvasSize in
        color.setFill()
        let path = UIBezierPath(rect: CGRect(origin: CGPoint(), size: canvasSize))
        path.fill()
    }
}

public func circle(#size: ValueBlock, #color: UIColor) -> AnimationBlock {
    return { time, canvasSize in
        let sizeValue = size(time)
        color.setFill()
        let o = CGPoint(x: canvasSize.width/2.0-sizeValue/2.0, y: canvasSize.height/2.0-sizeValue/2.0)
        let s = CGSize(width: sizeValue, height: sizeValue)
        let path = UIBezierPath(ovalInRect: CGRect(origin: o, size: s))
        path.fill()
    }
}

public func scale(#x: ValueBlock, #y: ValueBlock, #animation: AnimationBlock) -> AnimationBlock {
    return { time, size in
        let xv = x(time)
        let yv = y(time)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, size.width*(1.0-xv)*0.5, size.height*(1.0-yv)*0.5)
        CGContextScaleCTM(context, xv, yv)
        animation(time, size)
        CGContextRestoreGState(context)
    }
}

public func rotate(#angle: ValueBlock, #animation: AnimationBlock) -> AnimationBlock {
    return { time, size in
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, size.width*0.5, size.height*0.5)
        CGContextRotateCTM(context, angle(time) * CGFloat(M_PI) / 180.0)
        CGContextTranslateCTM(context, -size.width*0.5, -size.height*0.5)
        animation(time, size)
        CGContextRestoreGState(context)
    }
}

public func translate(#x: ValueBlock, #y: ValueBlock, #animation: AnimationBlock) -> AnimationBlock {
    return { time, size in
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, x(time), y(time))
        animation(time, size)
        CGContextRestoreGState(context)
    }
}

public func overlay(animations: AnimationBlock...) -> AnimationBlock {
    return overlay(animations)
}

public func overlay(animations: [AnimationBlock]) -> AnimationBlock {
    return { time, size in
        for animation in animations {
            animation(time, size)
        }
    }
}

public func loop(#from: NSTimeInterval, #duration: NSTimeInterval, #animation: AnimationBlock) -> AnimationBlock {
    return { time, size in
        animation((time - from + duration) % duration + from, size)
    }
}
