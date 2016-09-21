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
        
        super.init(texture: SKTexture(image:UIImage(named: "egg.jpg")!), color: SKColor.clearColor(), size: Egg.BaseSize)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incube() -> Pokemon {
        return pokemon
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
        
        super.init(texture: SKTexture(image:UIImage(named: "pikachu.png")!), color: SKColor.clearColor(), size: Egg.BaseSize)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 * EXECUTION
 */
// Init
let scene = Scene()
scene.scaleMode = .AspectFit
scene.backgroundColor = [#Color(colorLiteralRed: 0.05185846117082699, green: 0.04016332929495874, blue: 0.8689872382198953, alpha: 1)#]

// Data
var eggs = [Egg]()

var pikachu = Pokemon(name: "Pikachu", type: PokemonType.Electric)
var salameche = Pokemon(name: "Salameche", type: PokemonType.Fire)
var carapuce = Pokemon(name:"Carapuce", type:PokemonType.Water)
var psychoCouac = Pokemon(name:"PsychoCouac", type:PokemonType.Psychic)


var egg1 = Egg(pokemon: psychoCouac, type: EggType.TenKM)
egg1.position = CGPointMake(10, 10)
scene.addChild(egg1)

var egg2 = Egg(pokemon: salameche, type: EggType.TwoKM)
egg2.position = CGPointMake(10, 10)
scene.addChild(egg2)

var egg3 = Egg(pokemon: psychoCouac, type: EggType.TenKM)
egg3.position = CGPointMake(10, 10)
scene.addChild(egg3)

var egg4 = Egg(pokemon: salameche, type: EggType.TwoKM)
egg4.position = CGPointMake(10, 10)
scene.addChild(egg4)

var egg5 = Egg(pokemon: pikachu, type: EggType.TenKM)
egg5.position = CGPointMake(10, 10)
scene.addChild(egg5)

var egg6 = Egg(pokemon: carapuce, type: EggType.TenKM)
egg6.position = CGPointMake(10, 10)
scene.addChild(egg6)

var egg7 = Egg(pokemon: pikachu, type: EggType.ThreeKM)
egg7.position = CGPointMake(10, 10)
scene.addChild(egg7)

var egg8 = Egg(pokemon: psychoCouac, type: EggType.TwoKM)
egg8.position = CGPointMake(10, 10)
scene.addChild(egg8)

var egg9 = Egg(pokemon: salameche, type: EggType.TenKM)
egg9.position = CGPointMake(10, 10)
scene.addChild(egg9)

var egg10 = Egg(pokemon: carapuce, type: EggType.ThreeKM)
egg10.position = CGPointMake(10, 10)
scene.addChild(egg10)

eggs.appendContentsOf([egg1, egg2, egg3, egg4, egg5, egg6, egg7, egg8, egg9, egg10])

// Process 1 - Incube
// Old

func oldIncubation(eggType:EggType) -> [Pokemon] {
    var pokemons = [Pokemon]()
    for (index, egg) in eggs.enumerate() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(index) * 2.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
        
            egg.runAction(SKAction.moveToX(300.0, duration: 1.0), completion: {
                if egg.type == eggType {
                    let pokemon = egg.incube()
                    pokemons.append(pokemon)
                    pokemon.position = egg.position
                    egg.removeFromParent()
                    
                    scene.addChild(pokemon)
                    pokemon.runAction(SKAction.moveToX(600.0, duration: 1.0), completion: {
                        pokemon.removeFromParent()
                    })
                    
                } else {
                    egg.runAction(SKAction.moveToX(600.0, duration: 1.0), completion: {
                        egg.removeFromParent()
                    })
                }
            })
        }
    }
    return pokemons
}

func newIncubation() {
    
}

oldIncubation(EggType.TenKM)











// Insert scene
let view = SKView(frame: playframe)
view.presentScene(scene)
view.ignoresSiblingOrder = false
XCPlaygroundPage.currentPage.liveView = view
