//
//  TShape.swift
//  Tetris
//
//  Created by nju on 17/5/20.
//  Copyright © 2017年 nju. All rights reserved.
//


class TShape :Shape{
    /* 形状示意图     
     .的位置标记了行列
     Orientation 0
      . /0/
     /1//2//3/
     
     Orientation 90
      . /1/
        /2//0/
        /3/
     
     Orientation 180
     .
     /3//2//1/
        /0/
     
     Orientation 270
      . /3/
     /0//2/
        /1/
     */
    //mark:some problems
    

    public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(1,0),(0,1),(1,1),(2,1)],
            Orientation.Ninety: [(2,1),(1,0),(1,1),(1,2)],
            Orientation.OneEighty:[(1,2),(2,1),(1,1),(0,1)],
            Orientation.TwoSeventy: [(0,1),(1,2),(1,1),(1,0)]
        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero: [blocks[SecondBlockIndex],blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.Ninety:  [blocks[FirstBlockIndex],blocks[FourthBlockIndex]],
            Orientation.OneEighty:[blocks[FirstBlockIndex],blocks[SecondBlockIndex],blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[FirstBlockIndex],blocks[SecondBlockIndex]]
        ]
    }

}
