//
//  Objects.swift
//  Find the Differences
//
//  Created by Araib on 13/11/2019.
//  Copyright © 2019 Woody Apps. All rights reserved.
//

import Foundation
import SpriteKit

enum PictureType {
    case hidden
    case colorchange
    case inverted
}
class PictureObject {
    var x = 0.0
    var y =  0.0
    var hiddenSprite : UIImageView?
    var visibleSprite : UIImageView?
    var imageName = String ()
    var imageName_correct = String ()
    var index = 0
    var isFound = false
    var pictureType : PictureType = .hidden
    init(index : Int, x : Double, y: Double, image : String, type : PictureType) {
        self.x =  x
        self.y = y
        imageName =  image
        self.index = index
        self.pictureType = type
        if(pictureType == .colorchange){
            imageName_correct = image + "_c"
        }else if(pictureType == .inverted){
            imageName_correct = image + "_c"
        }
    }
    
    
}
