//
//  LShape.swift
//  Tetris
//
//  Created by nju on 17/5/20.
//  Copyright © 2017年 nju. All rights reserved.
//

class LShape: Shape{
    /* 形状示意图
     .的位置标记了行列
     Orientation 0
     /0./
     /1/
     /2//3/
     
     Orientation 90
        .
     /2//1//0/
     /3/
     
     Orientation 180
     /3//2./
        /1/
        /0/
     
     Orientation 270
         . /3/
     /0//1//2/
    
     */
    
    public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(0,0),(0,1),(0,2),(1,2)],
            Orientation.Ninety: [(1,1),(0,1),(-1,1),(-1,2)],
            Orientation.OneEighty:[(0,2),(0,1),(0,0),(-1,0)],
            Orientation.TwoSeventy: [(-1,1),(0,1),(1,1),(1,0)]        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero:    [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.Ninety:  [blocks[FirstBlockIndex],blocks[SecondBlockIndex],blocks[FourthBlockIndex]],
            Orientation.OneEighty:[blocks[FirstBlockIndex],blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[FirstBlockIndex],blocks[SecondBlockIndex],blocks[ThirdBlockIndex]]
        ]
    }
}
