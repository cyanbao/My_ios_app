//
//  IShape.swift
//  Tetris
//
//  Created by nju on 17/5/19.
//  Copyright © 2017年 nju. All rights reserved.
//

class IShape:Shape{
    /*形状示意图
     .的位置标记了行列
     Orientations 0 and 180:
     /0./
     /1/
     /2/
     /3/
     
     Orientations 90 and 270
     /0//1.//2//3/
     
     */
    
    public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(0,0),(0,1),(0,2),(0,3)],
            Orientation.Ninety: [(-1,0),(0,0),(1,0),(2,0)],
            Orientation.OneEighty:[(0,0),(0,1),(0,2),(0,3)],
            Orientation.TwoSeventy: [(-1,0),(0,0),(1,0),(2,0)]
            
        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero: [blocks[FourthBlockIndex]],
            Orientation.Ninety:  blocks,
            Orientation.OneEighty:[blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: blocks
        ]
    }
    
}
