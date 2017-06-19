//
//  JShape.swift
//  Tetris
//
//  Created by nju on 17/5/21.
//  Copyright © 2017年 nju. All rights reserved.
//

class JShape:Shape{
    /* 形状示意图
     .的位置标记了行列
     Orientation 0
      . /0/
        /1/
     /3//2/
     
     Orientation 90
     /3./
     /2//1//0/
     
     Orientation 180
     /2.//3/
     /1/
     /0/
     
     Orientation 270
     /0.//1//2/
            /3/
     
     */
    
    
    public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(1,0),(1,1),(1,2),(0,2)],
            Orientation.Ninety: [(2,1),(1,1),(0,1),(0,0)],
            Orientation.OneEighty:[(0,2),(0,1),(0,0),(1,0)],
            Orientation.TwoSeventy: [(0,0),(1,0),(2,0),(2,1)]
        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero:    [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.Ninety:  [blocks[FirstBlockIndex],blocks[SecondBlockIndex],blocks[ThirdBlockIndex]],
            Orientation.OneEighty:[blocks[FirstBlockIndex],blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[FirstBlockIndex],blocks[SecondBlockIndex],blocks[FourthBlockIndex]]
        ]
    }
}
