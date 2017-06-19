//
//  Array2D.swift
//  Tetris
//
//  Created by nju on 17/5/16.
//  Copyright © 2017年 nju. All rights reserved.
//

//用 <T>保证我们可以使用不同类型的数据
class Array2D<T>{
    let columns:Int
    let rows:Int 
    
    var array: Array<T?>
    
    init(columns:Int,rows:Int){
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(repeating:nil,count:rows*columns)
        
        
    }
    
    subscript(column:Int,row:Int)->T?{
        get{
            return array[(row*columns)+column]
        }
        
        set(newValue){
            array[(row*columns)+column] = newValue
        }
    }
    
    
}
