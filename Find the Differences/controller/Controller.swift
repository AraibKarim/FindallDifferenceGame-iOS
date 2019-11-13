//
//  Level.swift
//  Find the Differences
//
//  Created by Araib on 14/11/2019.
//  Copyright © 2019 Woody Apps. All rights reserved.
//

import Foundation


class Controller {
    var numberOfObjectsFound = 0
    var level : Level!
    init(levelIndex: Int) {
        level = Level(index :levelIndex)
    }
    
    func foundObject (pictureObject : PictureObject){
        pictureObject.isFound  = true
        numberOfObjectsFound += 1
        //setting tags to negative.
        //you can use some other logic.
        if let sprite = pictureObject.visibleSprite, sprite != nil {
            sprite.tag = -100
        }
        if let sprite = pictureObject.hiddenSprite, sprite != nil {
            sprite.tag = -100
        }
      
    }
    
    func checkObjectWithTag (tag : Int) -> Bool{
        for view in level.allPictureObjects {
            if(view.visibleSprite!.tag == tag && view.hiddenSprite!.tag == tag){
                foundObject(pictureObject: view)
                return true 
            }
        }
        return false
    }
}
