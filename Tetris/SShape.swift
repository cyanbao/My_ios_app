//
//  SShape.swift
//  Tetris
//
//  Created by nju on 17/5/21.
//  Copyright © 2017年 nju. All rights reserved.
//

class SShape:Shape{
    /* 形状示意图
     .的位置标记了行列
     Orientation 0,180
     /0./
     /1//2/
        /3/
     
     Orientation 90,270
      . /1//0/
    /3/ /2/
     
     */
    
    
   public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(0,0),(0,1),(1,1),(1,2)],
            Orientation.Ninety: [(2,0),(1,0),(1,1),(0,1)],
            Orientation.OneEighty:[(0,0),(0,1),(1,1),(1,2)],
            Orientation.TwoSeventy:  [(2,0),(1,0),(1,1),(0,1)]
        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero:    [blocks[SecondBlockIndex],blocks[FourthBlockIndex]],
            Orientation.Ninety:  [blocks[FirstBlockIndex],blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.OneEighty: [blocks[SecondBlockIndex],blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[FirstBlockIndex],blocks[ThirdBlockIndex],blocks[FourthBlockIndex]]
        ]
    }
    
}
