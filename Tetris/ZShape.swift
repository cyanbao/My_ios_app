//
//  ZShape.swift
//  Tetriis
//
//  Created by nju on 17/5/21.
//  Copyright © 2017年 nju. All rights reserved.
//

class ZShape:Shape{
    /* 形状示意图
     .的位置标记了行列
     Orientation 0,180
      . /0/
     /2//1/
     /3/
     
     Orientation 90,270
     /0//1./
        /3//2/
     
     */
    
    
    public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(1,0),(1,1),(0,1),(0,2)],
            Orientation.Ninety: [(-1,0),(0,0),(0,1),(1,1)],
            Orientation.OneEighty:[(1,0),(1,1),(0,1),(0,2)],
            Orientation.TwoSeventy:  [(-1,0),(0,0),(0,1),(1,1)]

        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero:    [blocks[SecondBlockIndex],blocks[FourthBlockIndex]],
            Orientation.Ninety:  [blocks[FirstBlockIndex],blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.OneEighty: [blocks[SecondBlockIndex],blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[FirstBlockIndex],blocks[ThirdBlockIndex],blocks[FourthBlockIndex]]        ]
    }
    
}
