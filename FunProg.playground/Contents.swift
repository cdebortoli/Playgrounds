//: Playground - noun: a place where people can play
// Filter, map join reduce
// evens = Array(1...10).filter(isEven)
// evens = Array(1...10).filter { (number) in number % 2 == 0 }
// evens = Array(1...10).filter { $0 % 2 == 0 }


// http://useyourloaf.com/blog/swift-guide-to-map-filter-reduce/

// Filter : T
import SpriteKit
import GameplayKit
import XCPlayground


/*
 * Data
 */
let playframe = CGRect(x: 0, y: 0, width: 480, height: 320)


/*
 * Classes
 */
class Scene: SKScene {
    override func didMoveToView(view: SKView) {
        self.size = playframe.size
    }
}

enum EggType:String {
    case TwoKM = "2km"
    case ThreeKM = "3km"
    case TenKM = "10km"
}
class Egg: SKSpriteNode {
    static let BaseSize:CGSize = CGSizeMake(50, 50)
    var pokemon:Pokemon
    var type:EggType
    
    init(pokemon:Pokemon, type:EggType) {
        self.pokemon = pokemon
        self.type = type
        
        super.init(texture: nil, color: SKColor.clearColor(), size: Egg.BaseSize)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum PokemonType:String {
    case Water = "water"
    case Electric = "electric"
    case Fire = "fire"
    case Ice = "ice"
    case Psychic = "psychic"
}
class Pokemon: SKSpriteNode {
    static let BaseSize:CGSize = CGSizeMake(50, 50)
    
    var pokemonName:String
    var type:PokemonType
    
    init(name:String, type:PokemonType) {
        self.pokemonName = name
        self.type = type
        
        super.init(texture: nil, color: SKColor.clearColor(), size: Egg.BaseSize)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 * EXECUTION
 */
let scene = Scene()
scene.scaleMode = .AspectFit
scene.backgroundColor = [#Color(colorLiteralRed: 0.05185846117082699, green: 0.04016332929495874, blue: 0.8689872382198953, alpha: 1)#]

let view = SKView(frame: playframe)
view.presentScene(scene)
view.ignoresSiblingOrder = false
XCPlaygroundPage.currentPage.liveView = view
