//
//  Shape.swift
//  Tetris
//
//  Created by nju on 17/5/17.
//  Copyright © 2017年 nju. All rights reserved.
//

import SpriteKit

let NumOrientations:UInt32 = 4

enum Orientation:Int,CustomStringConvertible{
    case Zero = 0,Ninety,OneEighty,TwoSeventy
    
    // 四个方向
    var description: String{
        switch self{
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    //随机函数
    static func random() ->Orientation{
        return Orientation(rawValue:Int(arc4random_uniform(NumOrientations)))!
    }
    
    //旋转函数
    static func rotate(orientation:Orientation,clockwise:Bool) ->Orientation{
        var rotated  = orientation.rawValue + (clockwise ? 1 : -1)
        if  rotated > Orientation.TwoSeventy.rawValue{
            rotated = Orientation.Zero.rawValue
        }
        else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue:rotated)!
        
    }
    
}

//形状的总数量
let NumShapeTypes: UInt32 = 7

//形状下标
let FirstBlockIndex: Int = 0
let SecondBlockIndex: Int = 1
let ThirdBlockIndex: Int = 2
let FourthBlockIndex: Int = 3

class Shape: Hashable,CustomStringConvertible{
    //形状的颜色
    let color:BlockColor
    
    //块组成的形状
    var blocks = Array<Block>()
    
    //当前的定位
    private var orientation: Orientation
    
    //当前形状的列和行
    var column,row:Int
    
    //required overrides
    
    // 每一个方块的位置，不同角度下
    public var blockRowColumnPositions: [Orientation: Array<(columDiff: Int,rowDiff: Int)>]{
        return [:]
    }

    //下降时底部重写
    public var bottomBlocksForOrientations: [Orientation: Array<Block>]{
        return [:]
    }
    
    var bottomBlocks:Array<Block>{
        guard let bottomBlocks = bottomBlocksForOrientations[orientation] else{
                return []
        }
        return bottomBlocks
    }
    
    
    //hashable
    var hashValue: Int{
        return blocks.reduce(0){ $0.hashValue ^ $1.hashValue }
    }
    
    //CustomStringCovertible
    var description: String{
        return "\(color)block facing \(orientation): \(blocks[FirstBlockIndex]),\(blocks[SecondBlockIndex]),\(blocks[ThirdBlockIndex]),\(blocks[FourthBlockIndex])"
    }
    
    init(column:Int,row: Int,color:BlockColor,orientation:Orientation){
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    convenience init(column:Int,row:Int){
        self.init(column:column,row:row,color:BlockColor.random(),orientation:Orientation.random())
    }
    
    //不可被override，智能呗shape类及其子嘞调用，初始化方块
    final func initializeBlocks(){
        guard let blockRowColumnTranslations = blockRowColumnPositions[orientation] else{
                return
        }
        
        blocks = blockRowColumnTranslations.map{(diff)-> Block in
            return Block(column: column + diff.columDiff,row: row + diff.rowDiff,color: color)
        }
    }
    
    //方块变形函数
    final func rotateBlocks(orientation:Orientation){
        guard let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] as! Array<(columnDiff: Int, rowDiff: Int)>? else {
            return
        }
        //枚举函数
        for (idx, diff) in blockRowColumnTranslation.enumerated() {
            blocks[idx].column = column + diff.columnDiff
            blocks[idx].row = row + diff.rowDiff
        }
    
    }
    
    //旋转
    final func rotateClockwise(){
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: true)
        rotateBlocks(orientation: newOrientation)
        orientation = newOrientation
    }
    
    final func rotateCounterClockwise(){
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: false)
        rotateBlocks(orientation: newOrientation)
        orientation = newOrientation
    }
    
    //下降一行
    final func lowerShapeByOneRow(){
        shiftBy(columns: 0,rows:1)
    }
    
    //上升一行
    final func raiseShapeByOneRow(){
        shiftBy(columns: 0, rows: -1)
    }
    
    //右移一列
    final func shiftRightByOneColumn(){
        shiftBy(columns: 1, rows: 0)
    }
    
    //左移一列
    final func shiftLeftByOneColumn(){
        shiftBy(columns: -1, rows: 0)
    }
    
    
    
    //根据每个函数来决定方块的形状
    final func shiftBy(columns: Int,rows: Int){
        self.column += columns
        self.row += rows
        for block in blocks{
            block.column += columns
            block.row += rows
        }
    }
    
    final func moveTo(column: Int,row: Int){
        self.column = column
        self.row = row
        rotateBlocks(orientation: orientation)
    }
    
    //随机函数，根据不同数字产生不同的方块
    final class func random(startingColumn: Int,startingRow: Int) -> Shape{
        switch Int(arc4random_uniform(NumShapeTypes)){
        case 0:
            return OShape(column:startingColumn,row:startingRow)
        case 1:
            return IShape(column:startingColumn,row:startingRow)
        case 2:
            return TShape(column:startingColumn,row:startingRow)
        case 3:
            return LShape(column:startingColumn,row:startingRow)
        case 4:
            return JShape(column:startingColumn,row:startingRow)
        case 5:
            return SShape(column:startingColumn,row:startingRow)
        default:
            return ZShape(column:startingColumn,row:startingRow)
        }
        
    }
}


func == (lhs: Shape,rhs:Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}

