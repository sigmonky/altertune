//: Playground - noun: a place where people can play

import UIKit

let scale = ["1/1","9/8","5/4","4/3","3/2","5/3","15/8","2/1"]

func stringRatioToRealNum(ratio:String) -> Double {
    let factors = ratio.components(separatedBy:"/")
    let ratio:Double = Double(factors[0])!/Double(factors[1])!
    return ratio
    
}

let scale2 = scale.map({stringRatioToRealNum(ratio:$0)})
print(scale2)
