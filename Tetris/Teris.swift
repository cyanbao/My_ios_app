//
//  Tetris.swift
//  Tetris
//
//  Created by nju on 17/5/21.
//  Copyright © 2017年 nju. All rights reserved.
//

//管理逻辑的类

let NumColumns = 10
let NumRows = 20


let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

//积分制度
let PointPerLine = 10
let LevelThreshold = 500


//自定义协议
protocol TetrisDelegate{
    // 当前tetris轮结束时调用
    func gameDidEnd(tetris: Tetris)
    
    //当新游戏开始时调用
    func gameDidBegin(tetris: Tetris)
    
    //当方块坠落变成底板的一部分时调用
    func gameShapeDidLand(tetris: Tetris)
    
    //当坠落的方块改变位置
    func gameShapeDidMove(tetris: Tetris)
    
    //当下降形状再丢弃后改变其位置时调用
    func gameShapeDidDrop(tetris: Tetris)
    
    //当游戏进入一个新等级时调用
    func gameDidLevelUp(tetris: Tetris)
    
}



class Tetris {
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    
    var score = 0
    var level  = 1
    
    var delegate: TetrisDelegate?
    
    init(){
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns,rows:NumRows)
    }
    
    
    //开始游戏的时候，最初的形状出现在右上方
    func beiginGame(){
        if(nextShape == nil){
            nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        }
        delegate?.gameDidBegin(tetris: self)
    }
    
    //产生下一个方块
    func newShape() -> (fallingShape:Shape?,nextShape:Shape?){
        fallingShape = nextShape
        nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(column: StartingColumn, row:StartingRow)
        
        guard  detectIllegalPlacement() == false else {
            nextShape = fallingShape
            nextShape!.moveTo(column: PreviewColumn, row: PreviewRow)
            endGame()
            return (nil,nil)
        }
        return (fallingShape,nextShape)
    }
    
    
    func detectIllegalPlacement() -> Bool{
        guard let shape = fallingShape else {
            return false
        }
        for block in shape.blocks{
            if block.column < 0 || block.column >= NumColumns||block.row<0||block.row>=NumRows{
                return true
            }
            else if blockArray[block.column,block.row] != nil{
                return true
            }
        }
        return false
    }
    
    
    
    
    //形状坠落，将形状加入存形状的表，当形状变为背景板时，将fallShape删掉
    func settleShape(){
        guard let shape = fallingShape else {
            return
        }
        for block in shape.blocks{
            blockArray[block.column,block.row] = block
        }
        fallingShape = nil
        delegate?.gameShapeDidLand(tetris: self)
    }
    
    //监测一个形状触碰底部或者背景方块板上，返回true，否则返回false
    func detectTouch() -> Bool{
        guard let shape = fallingShape else {
            return false
        }
        for bottomBlock in shape.bottomBlocks{
            if bottomBlock.row == NumRows - 1 || blockArray[bottomBlock.column,bottomBlock.row+1] != nil{
                return true
            }
        }
        return false
    }
    //结束游戏
    func endGame(){
        score = 0
        level = 1
        delegate?.gameDidEnd(tetris: self)
    }
    
    
    //直接下落，直到变为非法放置，就丢弃
    func dropShape(){
        guard let shape = fallingShape else{
            return
        }
        while detectIllegalPlacement() == false{
            shape.lowerShapeByOneRow()
        }
        shape.raiseShapeByOneRow()
        delegate?.gameShapeDidDrop(tetris: self)
    }
    
    
    //每调用一次形状下降一行，如果找不到合理的位置放不下了，就结束游戏
    func letShapeFall(){
        guard let shape = fallingShape else{
            return
        }
        shape.lowerShapeByOneRow()
        if detectIllegalPlacement(){
            shape.raiseShapeByOneRow()
            if detectIllegalPlacement(){
                endGame()
            }else{
                settleShape()
            }
        }else{
            delegate?.gameShapeDidMove(tetris: self)
            if detectTouch(){
                settleShape()
            }
        }
    }
    
    //旋转形状，如果旋转的位置不合法了，就恢复原样
    func rotateShape(){
        guard let shape = fallingShape else {
            return
        }
        shape.rotateClockwise()
        guard detectIllegalPlacement() == false else {
            shape.rotateCounterClockwise()
            return
        }
        delegate?.gameShapeDidMove(tetris: self)
    }
    
    
    //左移，出界恢复
    func moveShapeLeft(){
        guard let shape = fallingShape else {
            return
        }
        shape.shiftLeftByOneColumn()
        guard detectIllegalPlacement() == false else {
            shape.shiftRightByOneColumn()
            return
        }
        delegate?.gameShapeDidMove(tetris: self)
    }
    
    //右移出界恢复
    func moveShapeRight(){
        guard let shape = fallingShape else {
            return
        }
        shape.shiftRightByOneColumn()
        guard detectIllegalPlacement() == false else {
            shape.shiftLeftByOneColumn()
            return
        }
        delegate?.gameShapeDidMove(tetris: self)
    }
    
    //删除满行
    func removeCompleteLines() -> (linesRemoved: Array<Array<Block>>,fallenBlocks: Array<Array<Block>>){
        var removedLines = Array<Array<Block>>()
        for row in(1..<NumRows).reversed(){
            var rowOfBlocks = Array<Block>()
            
            //检测满行的列数
            for column in 0..<NumColumns{
                guard let block = blockArray[column,row] else {
                    continue
                }
                rowOfBlocks.append(block)
            }
            if rowOfBlocks.count == NumColumns{
                removedLines.append(rowOfBlocks)
                for block in rowOfBlocks{
                    blockArray[block.column,block.row] = nil
                }
            }
        }
        
        //检测一下是否恢复了任何行，没有则返回空数组
        if removedLines.count == 0{
            return([],[])
        }
        
        
        //根据消除计算分数，超过1000分就升级
        let pointEarned = removedLines.count * PointPerLine * level
        score += pointEarned
        if score >= level*LevelThreshold{
            level += 1
            delegate?.gameDidLevelUp(tetris: self)
        }
        
        var  fallenBlocks = Array<Array<Block>>()
        for column in 0..<NumColumns{
            var fallenBlockArray = Array<Block>()
            //下降背景方块板
            for row in (1..<removedLines[0][0].row).reversed(){
                guard let block = blockArray[column,row] else {
                    continue
                }
                var newRow = row
                while(newRow < NumRows-1 && blockArray[column,newRow+1] == nil){
                    newRow += 1
                }
                block.row = newRow
                blockArray[column,row] = nil
                blockArray[column,newRow] = block
                fallenBlockArray.append(block)
            }
            if fallenBlockArray.count > 0{
                fallenBlocks.append(fallenBlockArray)
            }
        }
        return(removedLines,fallenBlocks)
    }
    
    func removeAllBlocks() ->Array<Array<Block>>{
        var allBlocks = Array<Array<Block>>()
        for row in 0..<NumRows{
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns{
                guard let block = blockArray[column,row] else {
                    continue
                }
                rowOfBlocks.append(block)
                blockArray[column,row] = nil
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }
}
