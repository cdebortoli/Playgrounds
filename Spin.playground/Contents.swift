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
        //let filter:CIFilter = CIFilter(name: "CIDroste")!
        //filter.setDefaults()
        //let texture = textureFull.textureByApplyingCIFilter(filter)
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
//        let texture = SKTexture(image: UIImage(named: "moon")!)
        return texture
    }
    
    private class func drawThirdQuarter(size:CGSize) -> SKTexture {
        return drawFull(size)
    }
    
    private class func drawNew(size:CGSize) -> SKTexture {
        return drawFull(size)
    }
}

class CustomFilter:CIFilter {
    var inputImage: CIImage?
    var inputCenter: CIVector?
    
    override var outputImage:CIImage! {
        let dist1 = CIFilter(name: "CILineScreen")
        let dist2 = CIFilter(name: "CIAdditionCompositing")
        let dist3 = CIFilter(name: "CIConvolution5X5")
        
        if let vector:CIVector = self.valueForKey("inputCenter") as? CIVector {
            dist1!.setValue(vector, forKey: "inputCenter")
        }
        dist1!.setValue(1.14, forKey: "inputAngle")
        dist1?.setValue(11, forKey: "inputWidth")
        dist1?.setValue(0, forKey: "inputSharpness")
        
        
        dist1!.setValue(inputImage, forKey: kCIInputImageKey)
        dist2!.setValue(dist1!.outputImage, forKey: kCIInputImageKey)
        dist2?.setValue(inputImage, forKey: "inputBackgroundImage")
        dist3?.setValue(dist2?.outputImage, forKey: kCIInputImageKey)

        let weights: [CGFloat] = [0.5,0,0,0,0,0,0,0,0.5]
        let vector = CIVector(values: weights, count: Int(weights.count))
        dist3?.setValue(vector, forKey: "inputWeights")
        dist3?.setValue(0.5, forKey: "inputBias")
        return dist2?.outputImage
    }
}


/*
 * EXECUTION
 */
let scene = Scene()
scene.scaleMode = .AspectFit
scene.backgroundColor = SKColor.whiteColor()

// Moon
func setMoon() {
    scene.removeChildrenInArray(scene.children.filter({ $0.name == "moonEffect"}))
    
    let distanceRatio:Float = Float(moonDistanceRandom.nextInt())/100.0
    let position:CGPoint = CGPoint(x: moonXRandom.nextInt(), y: moonYRandom.nextInt())
    var type:Moon.MoonType? = Moon.MoonType(rawValue:moonTypeRandom.nextInt())
    if type == nil { type = .Full }
    let moonCount:Int = moonPhaseRandom.nextInt()
    
    for i in 1...moonCount {
        // Init moon
        let moonEffect = SKEffectNode()
        moonEffect.frame
        moonEffect.name = "moonEffect"
        let moon = Moon(type: type!, distanceRatio: distanceRatio)
        moonEffect.addChild(moon)
        
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
        moonEffect.position = CGPoint(x: x, y: y)
        
        // Phase
        if i < moonCount {
            moon.alpha = 0.5
        
        // Effect
//            let filter:CIFilter = CustomFilter()
//            filter.setDefaults()
//            filter.setValue(CIVector(x: moonEffect.frame.width/2, y:moonEffect.frame.height/2), forKey: "inputCenter")
//            moonEffect.filter = filter
//            moonEffect.shouldEnableEffects = true
        }
        
        scene.addChild(moonEffect)
    }
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
        setMoon()
    }
}

setMoon()

let view = SKView(frame: playframe)
view.presentScene(scene)
view.ignoresSiblingOrder = false
XCPlaygroundPage.currentPage.liveView = view

// Generer une fois le plan des étoiles via du perlin noise

