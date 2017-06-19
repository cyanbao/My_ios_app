//
//  OShape.swift
//  Tetris
//
//  Created by nju on 17/5/19.
//  Copyright © 2017年 nju. All rights reserved.
//

//正方形方块，shape的子类
class OShape:Shape{
    /* 形状示意图
     /0.//1/
     /2//3/
     .的位置标记了行列旋转的中心
     */
    
    //正方形方块是不需要变方向的
    /*public override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int,rowDiff: Int)>]{
     return [
     Orientation.Zero: [(0,0),(1,0),(0,1),(1,1)],
     Orientation.Ninety: [(0,0),(1,0),(0,1),(1,1)],
     Orientation.OneEighty: [(0,0),(1,0),(0,1),(1,1)],
     Orientation.TwoSeventy: [(0,0),(1,0),(0,1),(1,1)]
     ]
     }
     
     public override var bottomBlocksForOrientations: [Orientation: Array<Block>]{
     return[
     Orientation.Zero: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
     Orientation.Ninety: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
     Orientation.OneEighty: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
     Orientation.TwoSeventy: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]]
     ]
     }*/
    
    
    public override var blockRowColumnPositions: [Orientation : Array<(columDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(0,0),(1,0),(0,1),(1,1)],
            Orientation.Ninety: [(0,0),(1,0),(0,1),(1,1)],
            Orientation.OneEighty: [(0,0),(1,0),(0,1),(1,1)],
            Orientation.TwoSeventy: [(0,0),(1,0),(0,1),(1,1)]
            
        ]
    }
    
    public override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return[
            Orientation.Zero: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.Ninety: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.OneEighty: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[ThirdBlockIndex],blocks[FourthBlockIndex]]
        ]
    }
    
}
