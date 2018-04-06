//
//  PianoScene.swift
//  piano_scroll
//
//  Created by Brennan Dowling on 10/23/17.
//  Copyright © 2017 Brennan Dowling. All rights reserved.
//


import SpriteKit
import GameplayKit


// 894 X 894
let sphereShading = SKTexture(imageNamed: "sphere.png")

// 85 X 956
let keyShading = SKTexture(imageNamed: "KeyShading.png")

// 142 X 350
let whiteShading = SKTexture( rect: CGRect( x: 0.40, y: 0.35, width: 142 / 894, height: 350 / 894 ) ,  in: sphereShading )

// 80 X 190
let blackShading = SKTexture( rect: CGRect( x: 0.45, y: 0.45, width: 80 / 894, height: 190 / 894), in: sphereShading )

let sideKeyShading = SKTexture( rect: CGRect( x: 0.71, y: 0.5, width: 4 / 85, height: 350 / 956), in: keyShading )


let bottomKeyShading = sphereShading



// CLASS BlackKey
class BlackKey: SKSpriteNode {
    
    var note: String?
    
    convenience init(note: String){
        self.init( color: .black, size: blackShading.size())
        let shading = SKSpriteNode(texture: bottomKeyShading )
        shading.size = CGSize( width: 80, height: 8)
        shading.position = CGPoint( x: 0, y: -91 )
        addChild(shading)
        self.note = note
    }
    
    func startPlay(){
        let pitch = SKAction.playSoundFileNamed( note!, waitForCompletion: false)
        run(pitch)
    }
    
}

// CLASS BlackLine
class BlackVerticalLine: SKSpriteNode {
    
    convenience init(){
        self.init(color: .black, size: CGSize(width: 2, height: 350.0))
    }
}

// CLASS WhiteKey
class WhiteKey: SKSpriteNode {
    
    var note: String?
    
    convenience init(note: String){
        self.init( color: .white, size: whiteShading.size())
        self.note = note
        let shading = SKSpriteNode(texture: whiteShading)
        let leftShading = SKSpriteNode(texture: sideKeyShading)
        let rightShading = SKSpriteNode(texture: sideKeyShading)
        let bottomShading = SKSpriteNode(texture: bottomKeyShading)
        bottomShading.size = CGSize( width: 142, height: 4)
        bottomShading.position = CGPoint( x: 0, y : -175)
        leftShading.position = CGPoint( x: -69, y: 2)
        rightShading.position = CGPoint( x:  69, y: 2)
        addChild(leftShading)
        addChild(bottomShading)
        addChild(rightShading)
        addChild(shading)
    }
    
    func startPlay(){
        let pitch = SKAction.playSoundFileNamed( note!, waitForCompletion: false)
        super.run(pitch)
    }
    
    
}



// CLASS PianoScene
class PianoScene: SKScene {
    
    let sceneWidth = 1024
    let sceneHeight = 768
    let KeyWidth = 142
    
    let space = SKSpriteNode(imageNamed: "space.png")
    
    let C6Key = WhiteKey(note: "C6.wav")
    let D6Key = WhiteKey(note: "D6.wav")
    let E6Key = WhiteKey(note: "E6.wav")
    let F6Key = WhiteKey(note: "F6.wav")
    let G6Key = WhiteKey(note: "G6.wav")
    let A6Key = WhiteKey(note: "A6.wav")
    let B6Key = WhiteKey(note: "B6.wav")
    let C7Key = WhiteKey(note: "C6.wav")
    let D7Key = WhiteKey(note: "D6.wav")
    let E7Key = WhiteKey(note: "E6.wav")
    let F7Key = WhiteKey(note: "F6.wav")
    let G7Key = WhiteKey(note: "G6.wav")
    let A7Key = WhiteKey(note: "A6.wav")
    let B7Key = WhiteKey(note: "B6.wav")
    
    // Initialize lines
    let lineA = BlackVerticalLine()
    let lineB = BlackVerticalLine()
    let lineC = BlackVerticalLine()
    let lineD = BlackVerticalLine()
    let lineE = BlackVerticalLine()
    let lineF = BlackVerticalLine()
    
    // Initialize Black keys
    let C6Sharp = BlackKey(note: "C#6.wav")
    let D6Sharp = BlackKey(note: "D#6.wav")
    let F6Sharp = BlackKey(note: "F#6.wav")
    let G6Sharp = BlackKey(note: "G#6.wav")
    let A6Sharp = BlackKey(note: "A#6.wav")
    let C7Sharp = BlackKey(note: "C#6.wav")
    let D7Sharp = BlackKey(note: "D#6.wav")
    let F7Sharp = BlackKey(note: "F#6.wav")
    let G7Sharp = BlackKey(note: "G#6.wav")
    let A7Sharp = BlackKey(note: "A#6.wav")
    // Use filename for note string (sounds from freesound.org courtesy of
    // user: Zodoz
    // let WhiteBox = SKSpriteNode(color: .white, size: CGSize(width: 7 * 142, height: 280))


    
    override init(){
        super.init(size: CGSize(width: sceneWidth, height: sceneHeight))
        super.scaleMode = .aspectFill
        space.position = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2)
        addChild(space)
        
        

        
        
        // Position White Keys
        C6Key.position = CGPoint(x: 85, y: 305)
        D6Key.position = CGPoint(x: self.KeyWidth + 85, y: 305)
        E6Key.position = CGPoint(x: (2 * self.KeyWidth) + 85, y: 305)
        F6Key.position = CGPoint(x: (3 * self.KeyWidth) + 85, y: 305)
        G6Key.position = CGPoint(x: (4 * self.KeyWidth) + 85, y: 305)
        A6Key.position = CGPoint(x: (5 * self.KeyWidth) + 85, y: 305)
        B6Key.position = CGPoint(x: (6 * self.KeyWidth) + 85, y: 305)
        
        // Position Lines
        lineA.position = CGPoint(x: (self.KeyWidth / 2) + 85, y: 305)
        lineB.position = CGPoint(x: (self.KeyWidth) + (self.KeyWidth / 2) + 85, y: 305)
        lineC.position = CGPoint(x: (2 * self.KeyWidth) + ( self.KeyWidth / 2 ) + 85, y: 305)
        lineD.position = CGPoint(x: (3 * self.KeyWidth) + (self.KeyWidth / 2) + 85 , y : 305)
        lineE.position = CGPoint(x: (4 * self.KeyWidth) + ( self.KeyWidth / 2 ) + 85, y: 305)
        lineF.position = CGPoint(x: (5 * self.KeyWidth) + ( self.KeyWidth / 2 ) + 85, y: 305)
        
        
        //Position Black Keys
        C6Sharp.position = CGPoint(x: (self.KeyWidth / 2) + 85, y: 385)
        D6Sharp.position = CGPoint(x: (self.KeyWidth) + (self.KeyWidth / 2) + 85, y: 385)
        F6Sharp.position = CGPoint(x: (3 * self.KeyWidth) + (self.KeyWidth / 2) + 85 , y : 385)
        G6Sharp.position = CGPoint(x: (4 * self.KeyWidth) + ( self.KeyWidth / 2 ) + 85, y: 385)
        A6Sharp.position = CGPoint(x: (5 * self.KeyWidth) + ( self.KeyWidth / 2 ) + 85, y: 385)
        
        // Add Keys to parent
        addChild(C6Key)
        addChild(D6Key)
        addChild(E6Key)
        addChild(F6Key)
        addChild(G6Key)
        addChild(A6Key)
        addChild(B6Key)
        
        // Add Lines to Parent
        addChild(lineA)
        addChild(lineB)
        addChild(lineC)
        addChild(lineD)
        addChild(lineE)
        addChild(lineF)
        
        // Add Black Keys to parent
        addChild(C6Sharp)
        addChild(D6Sharp)
        addChild(F6Sharp)
        addChild(G6Sharp)
        addChild(A6Sharp)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        
        if (C6Key.contains(touchLocation) && !C6Sharp.contains(touchLocation)) {
            C6Key.startPlay()
        }
        
        if (D6Key.contains(touchLocation) && !C6Sharp.contains(touchLocation) && !D6Sharp.contains(touchLocation) ){
            D6Key.startPlay()
        }
        
        if (E6Key.contains(touchLocation) && !D6Sharp.contains(touchLocation) ){
            E6Key.startPlay()
        }
        
        if (F6Key.contains(touchLocation) && !F6Sharp.contains(touchLocation) ){
            F6Key.startPlay()
        }
        
        if (G6Key.contains(touchLocation) && !F6Sharp.contains(touchLocation) && !G6Sharp.contains(touchLocation) ) {
            G6Key.startPlay()
        }
        
        if (A6Key.contains(touchLocation) && !G6Sharp.contains(touchLocation) && !A6Sharp.contains(touchLocation) ){
            A6Key.startPlay()
        }
        
        if (B6Key.contains(touchLocation) && !A6Sharp.contains(touchLocation) ){
            B6Key.startPlay()
        }
        
        if C6Sharp.contains(touchLocation){
            C6Sharp.startPlay()
        }
        
        if D6Sharp.contains(touchLocation){
            D6Sharp.startPlay()
        }
        
        if F6Sharp.contains(touchLocation){
            F6Sharp.startPlay()
        }
        
        if G6Sharp.contains(touchLocation){
            G6Sharp.startPlay()
        }
        
        if A6Sharp.contains(touchLocation){
            A6Sharp.startPlay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
 
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    
}
