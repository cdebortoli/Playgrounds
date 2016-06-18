//: Spin

import SpriteKit
import GameplayKit
import XCPlayground

/* 
 * Data
 */
let playframe = CGRect(x: 0, y: 0, width: 480, height: 320)

// Randoms
let moonDistanceRandom = GKRandomDistribution(lowestValue: 100, highestValue: 115)
let moonXRandom = GKRandomDistribution(lowestValue: 0, highestValue: Int(playframe.width))
let moonYRandom = GKRandomDistribution(lowestValue: 0, highestValue: Int(playframe.height))
let moonTypeRandom = GKRandomDistribution(lowestValue: 0, highestValue: 8)
let moonPhaseRandom = GKRandomDistribution(lowestValue: 1, highestValue: 3)
let moonPhaseCoefRandom = GKRandomDistribution(lowestValue: 1, highestValue: 125)
let boolRandom = GKRandomDistribution()

/* 
 * Classes
 */
class Scene: SKScene {
    override func didMoveToView(view: SKView) {
        self.size = playframe.size
    }
}

class Moon: SKSpriteNode {
    static let BaseSize:CGSize = CGSizeMake(50, 50)
    
    var distanceRatio:Float = 1.0 // 1.0 to 1.15
    var realSize:CGSize
    
    // http://www.moonconnection.com/moon_phases.phtml
    enum MoonType : Int {
        case New
        case WaningCrescent
        case ThirdQuarter
        case WaningGibbous
        case Full
        case WaxingGibbous
        case FirstQuarter
        case WaxingCrescent
    }
    
    init(type:MoonType, distanceRatio:Float) {
        self.distanceRatio = distanceRatio
        self.realSize = CGSizeMake(Moon.BaseSize.width * CGFloat(distanceRatio), Moon.BaseSize.height * CGFloat(distanceRatio))
        
        let textureFull = Moon.drawFull(realSize)
        super.init(texture: textureFull, color: SKColor.clearColor(), size: CGSizeMake(50,50))
        name = "moon"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class func drawFull(size:CGSize) -> SKTexture {
        let moonFrame = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        let bezierPath = UIBezierPath(ovalInRect: moonFrame)
        CGContextAddPath(ctx, bezierPath.CGPath)
        CGContextSetRGBFillColor(ctx, 0.5, 0.3, 0.5, 1) //TMP
        CGContextFillPath(ctx)
        
        let textureImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        let texture = SKTexture(image: textureImage)
        return texture
    }
    
    private class func drawThirdQuarter(size:CGSize) -> SKTexture {
        return drawFull(size)
    }
    
    private class func drawNew(size:CGSize) -> SKTexture {
        return drawFull(size)
    }
}


/*
 * EXECUTION
 */
let scene = Scene()
scene.scaleMode = .AspectFit


// Moon
func setMoon() {
    scene.removeChildrenInArray(scene.children.filter({ $0.name == "moon"}))
    
    let distanceRatio:Float = Float(moonDistanceRandom.nextInt())/100.0
    let position:CGPoint = CGPoint(x: moonXRandom.nextInt(), y: moonYRandom.nextInt())
    var type:Moon.MoonType? = Moon.MoonType(rawValue:moonTypeRandom.nextInt())
    if type == nil { type = .Full }
    let moonCount:Int = moonPhaseRandom.nextInt()
    
    for i in 1...moonCount {
        let moon = Moon(type: type!, distanceRatio: distanceRatio)
        
        // Position
        let dephaseCoef:Float = Float(moonPhaseCoefRandom.nextInt()) / 1000.0
        var x:CGFloat = 0
        var y:CGFloat = 0
        if boolRandom.nextBool() == true {
            x = position.x + (position.x * CGFloat(dephaseCoef))
        } else {
            x = position.x - (position.x * CGFloat(dephaseCoef))
        }
        if boolRandom.nextBool() == true {
            y = position.y + (position.y * CGFloat(dephaseCoef))
        } else {
            y = position.y - (position.y * CGFloat(dephaseCoef))
        }
        moon.position = CGPoint(x: x, y: y)
        
        // Phase
        if i > 1 {
            moon.alpha = 0.5
        }
        
        scene.addChild(moon)
    }
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
        setMoon()
    }
}

setMoon()

let view = SKView(frame: playframe)
view.presentScene(scene)
XCPlaygroundPage.currentPage.liveView = view

// effet dephasage
// Generer une fois le plan des étoiles via du perlin noise



