//
//  Level.swift
//  Find the Differences
//
//  Created by Araib on 14/11/2019.
//  Copyright © 2019 Woody Apps. All rights reserved.
//

import Foundation

class Level {
    var allPictureObjects = [PictureObject] ()
    var imageName = String()
    init(index : Int){
        initLevel()
    }
    func initLevel (){
        imageName = "level1_incomplete"
        allPictureObjects.append(makePictureObject(x:1070.439, y: 211.704, stage: 1, index: 1,type: .hidden))
        allPictureObjects.append(makePictureObject(x:586.54, y: 456.556, stage: 1, index: 2,type: .hidden))
        allPictureObjects.append(makePictureObject(x:1570.613, y: 1258.103, stage: 1, index: 3,type: .hidden))
        allPictureObjects.append(makePictureObject(x:318.91, y: 1325.9, stage: 1, index: 4,type: .hidden))
        allPictureObjects.append(makePictureObject(x:1895.008, y: 169.526, stage: 1, index: 5,type: .hidden))
        
    }
    func makePictureObject (x: Double, y: Double, stage : Int, index: Int, type: PictureType ) -> PictureObject{
        let picture = PictureObject(index: index,x: x, y: y, image : "level"+"\(stage)"+"_"+"\(index)", type:type)
        return picture
    }
}

