//
//  GameViewController.swift
//  Tetris
//
//  Created by nju on 17/5/16.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit




class GameViewController: UIViewController, TetrisDelegate,UIGestureRecognizerDelegate{

    var scene: GameScene!
    var tetris:Tetris!
    
    //记录面板上点击位置
    var panPointReference:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false;
        
        //create and configure the scence
        scene = GameScene(size:skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.tick = didTick
        
        tetris = Tetris()
        tetris.delegate = self
        tetris.beiginGame()
        
        //present the scence
        skView.presentScene(scene)
        
       
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //点击旋转图形
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        tetris.rotateShape()
    }
    //点击左右移动图形
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        //记录当前点击位置
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference{
            //检测原始位置与当前位置之差，BlockSize*0.9是一个阈值超过了这个值就手势有效
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9){
                //值大于0右移，小于0左移
                if sender.velocity(in: self.view).x > CGFloat(0){
                    tetris.moveShapeRight()
                    panPointReference = currentPoint
                }else{
                    tetris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        }else if sender.state == .began{
            panPointReference = currentPoint
        }
    
    }
    

    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        tetris.dropShape()
    }
    
    //分数
    @IBOutlet weak var scoreLabel: UILabel!
    
    //等级
    @IBOutlet weak var levelLabel: UILabel!

    //等级
    
    
    // #5
    func gestureRecognizer(_ shouldRecognizeSimultaneouslyWithgestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // #6
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return false
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }

    
    
    
     //刷新调用didTick
    func didTick(){
        tetris.letShapeFall()
    }
    
    func nextShape(){
        let newShape = tetris.newShape()
        guard let fallingShape = newShape.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScence(shape: newShape.nextShape!){}
        self.scene.movePreviewShape(shape: fallingShape){
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    
    func gameDidBegin(tetris: Tetris) {
        levelLabel.text = "\(tetris.level)"
        scoreLabel.text = "\(tetris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
        if tetris.nextShape != nil && tetris.nextShape!.blocks[0].sprite == nil{
            scene.addPreviewShapeToScence(shape: tetris.nextShape!){
                self.nextShape()
            }
        }else{
            nextShape()
        }
    }
    
    
    func gameDidLevelUp(tetris: Tetris) {
        levelLabel.text = "\(tetris.level)"
        if scene.tickLengthMillis >= 100{
            scene.tickLengthMillis -= 100
        }else if scene.tickLengthMillis > 50{
            scene.tickLengthMillis -= 50
        }
        scene.playSound(sound: "levelup.mp3")
    }
    
    func gameDidEnd(tetris:Tetris){
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        
        scene.playSound(sound: "gameover.mp3")
        scene.animateCollapsingLines(linesToRemove: tetris.removeAllBlocks(), fallenBlocks: tetris.removeAllBlocks()){
            tetris.beiginGame()
        }
    }
    
    func gameShapeDidDrop(tetris: Tetris) {
        scene.stopTicking()
        scene.redrawShape(shape: tetris.fallingShape!){
            tetris.letShapeFall()
        }
        scene.playSound(sound:"drop.mp3")
    }
    
    func gameShapeDidLand(tetris: Tetris) {
        scene.startTicking()
        //nextShape()
        self.view.isUserInteractionEnabled = false
        
        //
        let removedLines = tetris.removeCompleteLines()
        if removedLines.linesRemoved.count > 0{
            self.scoreLabel.text = "\(tetris.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks: removedLines.fallenBlocks){
                self.gameShapeDidLand(tetris: tetris)
            }
            scene.playSound(sound: "remove.mp3")
        }else{
            nextShape()
        }
    }
    
    
    //17#
    func gameShapeDidMove(tetris: Tetris) {
        scene.redrawShape(shape: tetris.fallingShape! ){}
    }
    
    
}


