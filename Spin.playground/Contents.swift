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
let moonPhaseCoefRandom = GKRandomDistribution(lowestValue: 1, highestValue: 70)
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
    
    let textureFull = Moon.drawFull()
    let textureNew = Moon.drawNew()
    let textureFirstQuarter = Moon.drawFirstQuarter()
    let textureThirdQuarter = Moon.drawThirdQuarter()
    let textureWaxingCrescent = Moon.drawWaxingCrescent()
    let textureWaningCrescent = Moon.drawWaningCrescent()
    let textureWaxingGibbous = Moon.drawWaxingGibous()
    let textureWaningGibbous = Moon.drawWaningGibous()
    
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
        
        //let filter:CIFilter = CIFilter(name: "CIDroste")!
        //filter.setDefaults()
        //let texture = textureFull.textureByApplyingCIFilter(filter)
        super.init(texture: textureFull, color: SKColor.clearColor(), size: CGSizeMake(50,50))
        name = "moon"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMoon(type:MoonType, distanceRatio:Float) {
        self.distanceRatio = distanceRatio
        self.realSize = CGSizeMake(Moon.BaseSize.width * CGFloat(distanceRatio), Moon.BaseSize.height * CGFloat(distanceRatio))
        
        let texture:SKTexture
        switch type {
        case .Full:
            texture = textureFull
        case .New:
            texture = textureNew
        case .FirstQuarter:
            texture = textureFirstQuarter
        case .ThirdQuarter:
            texture = textureThirdQuarter
        case .WaningCrescent:
            texture = textureWaningCrescent
        case .WaxingCrescent:
            texture = textureWaxingCrescent
        case .WaningGibbous:
            texture = textureWaningGibbous
        case .WaxingGibbous:
            texture = textureWaxingGibbous
        }
        self.texture = texture
        
        // TODO : SCALE WITH REAL SIZE
        // TODO : FILTER ON TEXTURE TO AVOID PERFORMANCE PROBLEMS ?
    }
    
    private class func drawFull() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_full")!)
        return texture
    }
    
    private class func drawThirdQuarter() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_third_quarter")!)
        return texture
    }
    
    private class func drawFirstQuarter() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_first_quarter")!)
        return texture
    }
    
    private class func drawWaningCrescent() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_waning_crescent")!)
        return texture
    }
    
    private class func drawWaxingCrescent() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_waxing_crescent")!)
        return texture
    }
    
    private class func drawWaningGibous() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_full")!)
        return texture
    }
    
    private class func drawWaxingGibous() -> SKTexture {
        let texture = SKTexture(image: UIImage(named: "moon_full")!)
        return texture
    }
    
    private class func drawNew() -> SKTexture {
        return drawFull()
    }
}

class CustomFilter:CIFilter {
    var inputImage: CIImage?
    var inputCenter: CIVector?
    
    override var outputImage:CIImage! {
//        let dist1 = CIFilter(name: "CILineScreen")
//        let dist2 = CIFilter(name: "CIAdditionCompositing")
        let dist3 = CIFilter(name: "CIConvolution5X5")
        
//        if let vector:CIVector = self.valueForKey("inputCenter") as? CIVector {
//            dist1!.setValue(vector, forKey: "inputCenter")
//        }
//        dist1!.setValue(1.14, forKey: "inputAngle")
//        dist1?.setValue(11, forKey: "inputWidth")
//        dist1?.setValue(0, forKey: "inputSharpness")
//        
//        
//        dist1!.setValue(inputImage, forKey: kCIInputImageKey)
//        dist2!.setValue(dist1!.outputImage, forKey: kCIInputImageKey)
//        dist2?.setValue(inputImage, forKey: "inputBackgroundImage")
        dist3?.setValue(inputImage, forKey: kCIInputImageKey)

        let weights: [CGFloat] = [0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.5]
        let vector = CIVector(values: weights, count: Int(weights.count))
        dist3?.setValue(vector, forKey: "inputWeights")
        dist3?.setValue(0, forKey: "inputBias")
        return dist3?.outputImage
    }
}


/*
 * EXECUTION
 */
let scene = Scene()
scene.scaleMode = .AspectFit
scene.backgroundColor = [#Color(colorLiteralRed: 0.05185846117082699, green: 0.04016332929495874, blue: 0.8689872382198953, alpha: 1)#]

var moon1 = Moon(type: Moon.MoonType.Full, distanceRatio: 1.0)
var moon2 = Moon(type: Moon.MoonType.Full, distanceRatio: 1.0)
var moon3 = Moon(type: Moon.MoonType.Full, distanceRatio: 1.0)
var moonEffect1 = SKEffectNode()
var moonEffect2 = SKEffectNode()
var moonEffect3 = SKEffectNode()
moonEffect1.name = "moonEffect"
moonEffect2.name = "moonEffect"
moonEffect3.name = "moonEffect"
moonEffect1.addChild(moon1)
moonEffect2.addChild(moon2)
moonEffect3.addChild(moon3)
moon1.alpha = 1.0
moon2.alpha = 0.5
moon3.alpha = 0.5
scene.addChild(moonEffect3)
scene.addChild(moonEffect2)
scene.addChild(moonEffect1)

// Moon
func setMoon() {
    //scene.removeChildrenInArray(scene.children.filter({ $0.name == "moonEffect"}))
    moonEffect1.hidden = true
    moonEffect2.hidden = true
    moonEffect3.hidden = true
    
    let distanceRatio:Float = Float(moonDistanceRandom.nextInt())/100.0
    let position:CGPoint = CGPoint(x: moonXRandom.nextInt(), y: moonYRandom.nextInt())
    var type:Moon.MoonType? = Moon.MoonType(rawValue:moonTypeRandom.nextInt())
    if type == nil { type = .Full }
    let moonCount:Int = moonPhaseRandom.nextInt()
    
    
    /*let filter:CIFilter = CustomFilter()
    filter.setDefaults()
    filter.setValue(CIVector(x: moonEffect1.frame.width/2, y:moonEffect1.frame.height/2), forKey: "inputCenter")
    moonEffect1.filter = filter
    moonEffect1.shouldEnableEffects = true
    moonEffect2.filter = filter
    moonEffect2.shouldEnableEffects = true
    moonEffect3.filter = filter
    moonEffect3.shouldEnableEffects = true*/
    
    
    for i in 1...moonCount {
        
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
        
        switch i {
        case 1:
        moon1.setMoon(type!, distanceRatio: distanceRatio)
        moonEffect1.position = CGPoint(x: x, y: y)
        moonEffect1.hidden = false
            
        case 2:
        moon2.setMoon(type!, distanceRatio: distanceRatio)
        moonEffect2.position = CGPoint(x: x, y: y)
        moonEffect2.hidden = false
            
        case 3:
        moon3.setMoon(type!, distanceRatio: distanceRatio)
        moonEffect3.position = CGPoint(x: x, y: y)
        moonEffect3.hidden = false
            
        default:
            break
        }
    }
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
        setMoon()
    }
}

setMoon()

let view = SKView(frame: playframe)
view.presentScene(scene)
view.ignoresSiblingOrder = false
XCPlaygroundPage.currentPage.liveView = view


