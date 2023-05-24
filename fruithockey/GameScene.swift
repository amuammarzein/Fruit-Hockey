//
//  GameScene.swift
//  SpriteKit
//
//  Created by Aang Muammar Zein on 22/05/23.
//

import Foundation
import SpriteKit

extension SKNode
{
    func addGlow(radius:CGFloat=20)
    {
        let view = SKView()
        let effectNode = SKEffectNode()
        let texture = view.texture(from: self)
        effectNode.shouldRasterize = true
        effectNode.filter = CIFilter(name: "CIGaussianBlur",parameters: ["inputRadius":radius])
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
    }
}

class GameScene : SKScene,SKPhysicsContactDelegate{
    let ball = SKSpriteNode(imageNamed: "ball")
    let player1 = SKSpriteNode(imageNamed: "player1")
    let player2 = SKSpriteNode(imageNamed: "player2")
    var giftLabel = SKLabelNode(fontNamed:"Menlo")
    var score1Label = SKLabelNode(fontNamed:"Menlo")
    var score2Label = SKLabelNode(fontNamed:"Menlo")
    var guideLabel = SKLabelNode(fontNamed:"Menlo")
    var countdownLabel = SKLabelNode(fontNamed:"Menlo")
    var captionLabel = SKLabelNode(fontNamed:"Menlo")
    var score1:Int = 0
    var countdown:Int = 60
    var score2:Int = 0
    var selected:Int = 0
    var arrSound:[String] = []
    var isPlay:Bool = false
    var isGameOver:Bool = false
    var isGift:Bool = false
    var lastPlayerHitBall:Int = 0
    var scoreGoal:Int = 0
    
    var emitter = SKEmitterNode(fileNamed:"Spark")!
    
    var arrGift:[giftModel] = [
        giftModel(icon:"🍇",score:1),
        giftModel(icon:"🍈",score:2),
        giftModel(icon:"🍉",score:3),
        giftModel(icon:"🍊",score:4),
        giftModel(icon:"🍋",score:5),
        giftModel(icon:"🍌",score:6),
        giftModel(icon:"🍍",score:7),
        giftModel(icon:"🍎",score:8),
        giftModel(icon:"🍏",score:9),
        giftModel(icon:"🍐",score:10),
        giftModel(icon:"🍑",score:11),
        giftModel(icon:"🍒",score:12),
    ]
    
    struct giftModel:Identifiable{
        var id = UUID()
        var name:String = ""
        var icon:String = ""
        var score:Int = 0
        var status:Bool = false
    }
    
    struct CategoryBitMask {
        static let Ball: UInt32 = 0b1 << 0
        static let Player1: UInt32 = 0b1 << 1
        static let Player2: UInt32 = 0b1 << 2
        static let Goal1: UInt32 = 0b1 << 3
        static let Goal2: UInt32 = 0b1 << 4
        static let GiftLabel: UInt32 = 0b1 << 5
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        
        scene?.backgroundColor = .black
        
        
        
        let rectangle = SKShapeNode(rectOf: CGSize(width: 5, height: size.height))
        rectangle.zPosition = 2
        rectangle.fillColor = SKColor.darkGray
        rectangle.strokeColor = SKColor.darkGray
        rectangle.position = CGPointMake(size.width/2, size.height/2)
        addChild(rectangle)
        
        let circle = SKShapeNode(circleOfRadius: size.height/4 )
        rectangle.zPosition = 1
        circle.position = CGPointMake(size.width/2, size.height/2)
        circle.strokeColor = SKColor.darkGray
        circle.lineWidth = 5
        circle.fillColor = SKColor.black
        addChild(circle)
        
        let circleLeft = SKShapeNode(circleOfRadius: size.height/3.5 )
        circleLeft.zPosition = 1
        circleLeft.position = CGPointMake(0, size.height/2)
        circleLeft.strokeColor = SKColor.darkGray
        circleLeft.lineWidth = 5
        circleLeft.fillColor = SKColor.black
        addChild(circleLeft)
        
        let circleRight = SKShapeNode(circleOfRadius: size.height/3.5 )
        circleRight.zPosition = 1
        circleRight.position = CGPointMake(size.width, size.height/2)
        circleRight.strokeColor = SKColor.darkGray
        circleRight.lineWidth = 5
        circleRight.fillColor = SKColor.black
        addChild(circleRight)
        
        let rectangleLeft = SKShapeNode(rectOf: CGSize(width: 50, height: size.height))
        rectangleLeft.zPosition = 2
        rectangleLeft.fillColor = SKColor.black
        rectangleLeft.strokeColor = SKColor.black
        rectangleLeft.position = CGPointMake(0, size.height/2)
        addChild(rectangleLeft)
        
        let rectangleRight = SKShapeNode(rectOf: CGSize(width: 50, height: size.height))
        rectangleRight.zPosition = 2
        rectangleRight.fillColor = SKColor.black
        rectangleRight.strokeColor = SKColor.black
        rectangleRight.position = CGPointMake(size.width, size.height/2)
        addChild(rectangleRight)
        
        
        let square1Top = SKShapeNode(rectOf: CGSize(width: 20, height: size.height/4),cornerRadius: 15)
        square1Top.fillColor = SKColor.blue
        square1Top.strokeColor = SKColor.blue
        square1Top.position = CGPoint(x: 30, y: size.height - (size.height/6))
        square1Top.zPosition = 10
        square1Top.physicsBody = SKPhysicsBody(rectangleOf: square1Top.frame.size)
        square1Top.physicsBody?.friction = 0
        square1Top.physicsBody?.restitution = 1
        square1Top.physicsBody?.linearDamping = 0
        square1Top.physicsBody?.angularDamping = 0
        square1Top.physicsBody?.allowsRotation = true
        square1Top.physicsBody?.isDynamic = false
        addChild(square1Top)
        
        let square1Bottom = SKShapeNode(rectOf: CGSize(width: 20, height: size.height/4),cornerRadius: 15)
        square1Bottom.fillColor = SKColor.blue
        square1Bottom.strokeColor = SKColor.blue
        square1Bottom.position = CGPoint(x: 30, y:(size.height/6))
        square1Bottom.zPosition = 10
        square1Bottom.physicsBody = SKPhysicsBody(rectangleOf: square1Bottom.frame.size)
        square1Bottom.physicsBody?.friction = 0
        square1Bottom.physicsBody?.restitution = 1
        square1Bottom.physicsBody?.linearDamping = 0
        square1Bottom.physicsBody?.angularDamping = 0
        square1Bottom.physicsBody?.allowsRotation = true
        square1Bottom.physicsBody?.isDynamic = false
        addChild(square1Bottom)
        
        let square1 = SKShapeNode(rectOf: CGSize(width: 20, height: size.height/2.6),cornerRadius: 15)
        square1.fillColor = SKColor.white
        square1.strokeColor = SKColor.white
        square1.position = CGPoint(x: 30, y: size.height/2)
        square1.zPosition = 10
        square1.physicsBody = SKPhysicsBody(rectangleOf: square1.frame.size)
        square1.physicsBody?.friction = 0
        square1.physicsBody?.restitution = 1
        square1.physicsBody?.linearDamping = 0
        square1.physicsBody?.angularDamping = 0
        square1.physicsBody?.allowsRotation = true
        square1.physicsBody?.isDynamic = false
        square1.physicsBody!.categoryBitMask = CategoryBitMask.Goal1
        square1.physicsBody!.contactTestBitMask = CategoryBitMask.Ball
        addChild(square1)
        
        let square2Top = SKShapeNode(rectOf: CGSize(width: 20, height: size.height/4),cornerRadius: 15)
        square2Top.fillColor = SKColor.blue
        square2Top.strokeColor = SKColor.blue
        square2Top.position = CGPoint(x: size.width-30, y: size.height - (size.height/6))
        square2Top.zPosition = 10
        square2Top.physicsBody = SKPhysicsBody(rectangleOf: square2Top.frame.size)
        square2Top.physicsBody?.friction = 0
        square2Top.physicsBody?.restitution = 1
        square2Top.physicsBody?.linearDamping = 0
        square2Top.physicsBody?.angularDamping = 0
        square2Top.physicsBody?.allowsRotation = true
        square2Top.physicsBody?.isDynamic = false
        addChild(square2Top)
        
        let square2Bottom = SKShapeNode(rectOf: CGSize(width: 20, height: size.height/4),cornerRadius: 15)
        square2Bottom.fillColor = SKColor.blue
        square2Bottom.strokeColor = SKColor.blue
        square2Bottom.position = CGPoint(x: size.width-30, y: size.height/6)
        square2Bottom.zPosition = 10
        square2Bottom.physicsBody = SKPhysicsBody(rectangleOf: square2Bottom.frame.size)
        square2Bottom.physicsBody?.friction = 0
        square2Bottom.physicsBody?.restitution = 1
        square2Bottom.physicsBody?.linearDamping = 0
        square2Bottom.physicsBody?.angularDamping = 0
        square2Bottom.physicsBody?.allowsRotation = true
        square2Bottom.physicsBody?.isDynamic = false
        addChild(square2Bottom)
        
        let square2 = SKShapeNode(rectOf: CGSize(width: 20, height: size.height/2.6),cornerRadius: 15)
        square2.fillColor = SKColor.white
        square2.strokeColor = SKColor.white
        square2.position = CGPoint(x: size.width-30, y: size.height/2)
        square2.zPosition = 10
        square2.physicsBody = SKPhysicsBody(rectangleOf: square2.frame.size)
        square2.physicsBody?.friction = 0
        square2.physicsBody?.restitution = 1
        square2.physicsBody?.linearDamping = 0
        square2.physicsBody?.angularDamping = 0
        square2.physicsBody?.allowsRotation = true
        square2.physicsBody?.isDynamic = false
        square2.physicsBody!.categoryBitMask = CategoryBitMask.Goal2
        square2.physicsBody!.contactTestBitMask = CategoryBitMask.Ball
        addChild(square2)
        
        let squareTop = SKShapeNode(rectOf: CGSize(width: size.width-80, height: 20),cornerRadius: 15)
        squareTop.fillColor = SKColor.blue
        squareTop.strokeColor = SKColor.blue
        squareTop.position = CGPoint(x: size.width/2, y: size.height-10)
        squareTop.zPosition = 10
        squareTop.physicsBody = SKPhysicsBody(rectangleOf: squareTop.frame.size)
        squareTop.physicsBody?.friction = 0
        squareTop.physicsBody?.restitution = 1
        squareTop.physicsBody?.linearDamping = 0
        squareTop.physicsBody?.angularDamping = 0
        squareTop.physicsBody?.allowsRotation = true
        squareTop.physicsBody?.isDynamic = false
        addChild(squareTop)
        
        let squareBottom = SKShapeNode(rectOf: CGSize(width: size.width-80, height: 20),cornerRadius: 15)
        squareBottom.fillColor = SKColor.blue
        squareBottom.strokeColor = SKColor.blue
        squareBottom.position = CGPoint(x: size.width/2, y: 10)
        squareBottom.zPosition = 10
        squareBottom.physicsBody = SKPhysicsBody(rectangleOf: squareBottom.frame.size)
        squareBottom.physicsBody?.friction = 0
        squareBottom.physicsBody?.restitution = 1
        squareBottom.physicsBody?.linearDamping = 0
        squareBottom.physicsBody?.angularDamping = 0
        squareBottom.physicsBody?.allowsRotation = true
        squareBottom.physicsBody?.isDynamic = false
        addChild(squareBottom)
        
        
        let player1Label = SKLabelNode(fontNamed:"Menlo")
        player1Label.text = String("Player 1");
        player1Label.fontSize = 15
        player1Label.position = CGPointMake((size.width/4), 5)
        player1Label.fontColor = UIColor.white
        player1Label.zPosition = 10
        addChild(player1Label)
        
        let player2Label = SKLabelNode(fontNamed:"Menlo")
        player2Label.text = String("Player 2");
        player2Label.fontSize = 15
        player2Label.position = CGPointMake(size.width-(size.width/4), 5)
        player2Label.fontColor = UIColor.white
        player2Label.zPosition = 10
        addChild(player2Label)
        
        
        ball.position = CGPoint(x: size.width/2, y: size.height/2)
        ball.zPosition = 10
        ball.size = CGSize(width: 50, height: 50)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.allowsRotation = true
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 50))
        
        
        player1.position = CGPoint(x: 100, y: size.height/2)
        player1.zPosition = 20
        player1.size = CGSize(width: 80, height: 80)
        player1.physicsBody = SKPhysicsBody(rectangleOf: player1.size)
        player1.physicsBody?.friction = 0
        player1.physicsBody?.restitution = 1
        player1.physicsBody?.linearDamping = 0
        player1.physicsBody?.angularDamping = 0
        player1.physicsBody?.allowsRotation = true
        player1.physicsBody?.isDynamic = false
        player1.physicsBody!.categoryBitMask = CategoryBitMask.Player1
        player1.physicsBody!.contactTestBitMask = CategoryBitMask.Ball
        addChild(player1)
        
        player2.position = CGPoint(x: size.width-100, y: size.height/2)
        player2.zPosition = 20
        player2.size = CGSize(width: 80, height: 80)
        player2.physicsBody = SKPhysicsBody(rectangleOf: player1.size)
        player2.physicsBody?.friction = 0
        player2.physicsBody?.restitution = 1
        player2.physicsBody?.linearDamping = 0
        player2.physicsBody?.angularDamping = 0
        player2.physicsBody?.allowsRotation = true
        player2.physicsBody?.isDynamic = true
        player2.physicsBody!.categoryBitMask = CategoryBitMask.Player2
        player2.physicsBody!.contactTestBitMask = CategoryBitMask.Ball
        addChild(player2)
        player2.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 50))
        
        physicsWorld.contactDelegate = self
        
        setScore1(score:0)
        setScore2(score:0)
        
        startCountdown()
        
    }
    
    func setScore1(score :Int){
        self.score1Label.removeFromParent()
        score1Label.text = String(score);
        score1Label.fontSize = 30
        score1Label.position = CGPointMake((size.width/4), size.height-70)
        score1Label.fontColor = UIColor.white
        score1Label.zPosition = 20
        addChild(score1Label)
    }
    func setScore2(score :Int){
        self.score2Label.removeFromParent()
        score2Label.text = String(score);
        score2Label.fontSize = 30
        score2Label.position = CGPointMake(size.width-(size.width/4), size.height-70)
        score2Label.fontColor = UIColor.white
        score2Label.zPosition = 20
        addChild(score2Label)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if(player2.position.x < (size.width/2)+30  && player2.position.x > 82
           && player2.position.y > 62 && player2.position.y < (size.height - 62)
        ){
            player2.physicsBody?.applyImpulse(CGVector(dx: 50, dy: -50))
        }else{
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isGameOver==false){
            for touch in touches {
                let location = touch.location(in: self)
                if(location.x < (size.width/2)-40  && location.x > 82
                   && location.y > 62 && location.y < (size.height - 62)
                ){
                    player1.position.x = location.x
                    player1.position.y = location.y
                    
                }else if(location.x > (size.width/2)+40 && location.x < size.width-82
                         && location.y > 62 && location.y < (size.height - 62)){
                }
            }
        }
    }
    
    
    func createGift(){
        self.giftLabel.removeFromParent()
        self.guideLabel.removeFromParent()
        selected = Int.random(in: 0..<arrGift.count)
        if(arrGift[selected].score > 1){
            guideLabel.text = "Hit the "+String(arrGift[selected].icon)+" to get +"+String(arrGift[selected].score)+" points!";
        }else{
            guideLabel.text = "Hit the "+String(arrGift[selected].icon)+" to get +"+String(arrGift[selected].score)+" point!";
        }
        guideLabel.fontSize = 15
        guideLabel.position = CGPointMake(size.width/2, 50)
        guideLabel.fontColor = UIColor.white
        guideLabel.zPosition = 20
        addChild(guideLabel)
        
        giftLabel.text = arrGift[selected].icon;
        giftLabel.fontSize = 50
        giftLabel.position = CGPointMake(CGFloat(Int.random(in: 50..<Int(size.width-50))), CGFloat(Int.random(in: 50..<Int(size.height-50))))
        giftLabel.fontColor = UIColor.white
        giftLabel.zPosition = 20
        giftLabel.physicsBody = SKPhysicsBody(rectangleOf:giftLabel.frame.size)
        giftLabel.physicsBody?.isDynamic = true
        giftLabel.physicsBody!.categoryBitMask = CategoryBitMask.GiftLabel
        giftLabel.physicsBody!.contactTestBitMask = CategoryBitMask.Ball
        self.addChild(giftLabel)
        giftLabel.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 50))
        isGift = true
    }
    
    func haptics(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.categoryBitMask==32 && contact.bodyB.categoryBitMask == 4294967295){
            haptics()
            print("Get Extra Power")
            if(lastPlayerHitBall == 1){
                score1 += arrGift[selected].score
                setScore1(score:score1)
            }else if(lastPlayerHitBall == 2){
                score2 += arrGift[selected].score
                setScore2(score:score2)
            }
            scoreGoal += 1
            isGift = false
            self.giftLabel.removeFromParent()
            self.guideLabel.removeFromParent()
            self.emitter.removeFromParent()
            emitter.position = giftLabel.position
            self.addChild(emitter)
            self.run(SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false))
            self.run(SKAction.wait(forDuration: 0.5)) {
                self.emitter.removeFromParent()
            }
        }else if(contact.bodyA.categoryBitMask==2){
            haptics()
            print("Player 1")
            lastPlayerHitBall = 1
        }else if(contact.bodyA.categoryBitMask==4){
            haptics()
            print("Player 2")
            lastPlayerHitBall = 2
        }else if(contact.bodyA.categoryBitMask==8){
            haptics()
            print("Goal 1")
            score2 += 1
            setScore2(score:score2)
            scoreGoal += 1
            score2Label.text = String(score2)
            self.run(SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false))
        }else if(contact.bodyA.categoryBitMask==16){
            haptics()
            print("Goal 2")
            score1 += 1
            setScore1(score:score1)
            scoreGoal += 1
            score1Label.text = String(score1)
            self.run(SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false))
        }
        if((scoreGoal) > 0 && (scoreGoal) % 5 == 0 && isGift==false){
            createGift()
        }
    }
    
    func startCountdown(){
        countdownLabel.removeFromParent()
        countdownLabel.text = String(countdown);
        countdownLabel.fontSize = 15
        countdownLabel.position = CGPointMake(size.width/2, size.height-17)
        countdownLabel.fontColor = UIColor.white
        countdownLabel.zPosition = 10
        addChild(countdownLabel)
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func fireTimer() {
        countdown -= 1
        countdownLabel.removeFromParent()
        countdownLabel.text = String(countdown);
        
        countdownLabel.fontSize = 15
        countdownLabel.position = CGPointMake(size.width/2, size.height-17)
        countdownLabel.fontColor = UIColor.white
        countdownLabel.zPosition = 10
        addChild(countdownLabel)
        
        if(countdown < 1){
            gameOver()
        }
    }
    func gameOver(){
        if(isGameOver==false){
            self.run(SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false))
            haptics()
        }
        countdownLabel.text = "Game Over"
        isGameOver = true
        guideLabel.removeFromParent()
        giftLabel.physicsBody?.isDynamic = false
        ball.physicsBody?.isDynamic = false
        player1.physicsBody?.isDynamic = false
        player2.physicsBody?.isDynamic = false
        
        
        if(score1 > score2){
            captionLabel.removeFromParent()
            let text = "Player 1 Wins!"
            captionLabel.text = text;
            captionLabel.fontSize = 40
            captionLabel.position = CGPointMake(size.width/2, (size.height/2)-10)
            captionLabel.fontColor = UIColor.white
            captionLabel.zPosition = 10
            addChild(captionLabel)
        }else if(score1 < score2){
            captionLabel.removeFromParent()
            let text = "Player 2 Wins!"
            captionLabel.text = text;
            captionLabel.fontSize = 40
            captionLabel.position = CGPointMake(size.width/2, (size.height/2)-10)
            captionLabel.fontColor = UIColor.white
            captionLabel.zPosition = 10
            addChild(captionLabel)
        }else{
            captionLabel.removeFromParent()
            let text = "Player 1 and 2 Draw!"
            captionLabel.text = text;
            captionLabel.fontSize = 40
            captionLabel.position = CGPointMake(size.width/2, (size.height/2)-10)
            captionLabel.fontColor = UIColor.white
            captionLabel.zPosition = 10
            addChild(captionLabel)
        }
        
        
    }
}
