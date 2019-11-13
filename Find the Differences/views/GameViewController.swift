//
//  GameViewController.swift
//  Find the Differences
//
//  Created by Araib on 13/11/2019.
//  Copyright © 2019 Woody Apps. All rights reserved.
//


// Find all Difference - Find the differences between two images.
// 'fullImageWithVisibleItems' & 'fullImageWithHiddenItems' are ImageViews  used to display the full images without objects (hidden/visible)
// Objects are added to both imagesviews but hidden in the 'fullImageWithHiddenItems'
// Scrollviews is used to zoom and pan  imageviews. Both imageviews are zoomed together.
// tap gesture is used to tap the hidden and visible objects in both imageviews.
// As in iOS, hidden views are not tappable hence it is necessary to track them through their locations and tags.


import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    // MARK: Properties
    var gameScene : GameScene!
    
    var controller : Controller!
    var scrollView1 = UIScrollView ()
    var scrollView2 = UIScrollView ()
    
    
    //need global imageviews for tracking objects.
    var fullImageWithVisibleItems = UIImageView ()
    var fullImageWithHiddenItems = UIImageView ()
    func launchGameScene (){
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.ignoresSiblingOrder = false
        gameScene = GameScene(size: skView.bounds.size)
        gameScene.gameViewController =  self
        
        gameScene.scaleMode = .aspectFill
        skView.presentScene(self.gameScene)
        
    }
    // MARK: GameViewController's functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchGameScene ()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    // MARK: Create GamePlay
    func createGamePlay (){
        
        //creating PictureObjects to be placed in the ImageViews.
        controller = Controller(levelIndex: 1)
        //calculating height and width with respect to the provided Image.
        let spacing =  CGFloat(10.0)
        let originalImage = UIImage.init(named: controller.level.imageName)
        let originalWidthOfImage = Double(originalImage!.size.width)
        let originalHeightOfImage = Double(originalImage!.size.height)
        let ratio = originalHeightOfImage/originalWidthOfImage
        let mainViewWidth = view.frame.size.width
        let viewWidth = CGFloat(mainViewWidth - spacing)
        let viewHeight = CGFloat(ratio) * CGFloat(viewWidth)
        
        //initializing ScrollView 1
        scrollView1 = UIScrollView.init(frame: CGRect.init(x: 5.0, y: self.view.frame.size.height * 0.5 - (viewHeight) - 10 , width: (viewWidth), height: (viewHeight)))
        
        let width = viewWidth
        let height = viewHeight
        
        scrollView1.delegate =  self
        scrollView1.isScrollEnabled = true
        scrollView1.minimumZoomScale = 1.0
        scrollView1.maximumZoomScale = 3.0
        scrollView1.tag = 1
        scrollView1.backgroundColor = UIColor.white
        
        fullImageWithVisibleItems = UIImageView.init(image: originalImage)
        fullImageWithVisibleItems.frame =  CGRect.init(x: 0, y: 0 , width: (viewWidth), height: (viewHeight))
        scrollView1.addSubview(fullImageWithVisibleItems)
        fullImageWithVisibleItems.isUserInteractionEnabled =  true
        view.addSubview(scrollView1)
        
        //initializing ScrollView 2
        //adding spacing between two scrollview -> 10
        scrollView2 = UIScrollView.init(frame: CGRect.init(x: 5.0, y: view.frame.size.height * 0.5 + 10 , width: (viewWidth), height: (viewHeight)))
        
        
        scrollView2.delegate =  self
        scrollView2.isScrollEnabled = true
        scrollView2.minimumZoomScale = 1.0
        scrollView2.maximumZoomScale = 3.0
        scrollView2.tag = 2
        scrollView2.backgroundColor = UIColor.white
        
        fullImageWithHiddenItems = UIImageView.init(image: originalImage)
        
        fullImageWithHiddenItems.frame =  CGRect.init(x: 0, y: 0 , width: (viewWidth), height: (viewHeight))
        scrollView2.addSubview(fullImageWithHiddenItems)
        
        view.addSubview(scrollView2)
        
        scrollView2.alwaysBounceHorizontal = false
        scrollView2.bounces = false
        
        scrollView1.alwaysBounceHorizontal = false
        scrollView1.bounces = false
        
        //adding objects to first ImageView -> Hidden
        for i in 0 ..< controller.level.allPictureObjects.count {
            let picture = controller.level.allPictureObjects[i]
            let object = UIImage.init(named: picture.imageName)
            
            let widthChange = object!.size.width/CGFloat(originalWidthOfImage)
            let heightChange = object!.size.height/CGFloat(originalHeightOfImage)
            let newObjectImage =  object?.resize(size: CGSize.init(width: viewWidth * widthChange, height: viewHeight * heightChange))
            let objectView = UIImageView.init(image: object)
            objectView.tag = i + 1
            let newPointX = picture.x/originalWidthOfImage * Double(width)
            let newPointY = picture.y/originalHeightOfImage * Double(height)
            objectView.frame =  CGRect.init(x: CGFloat(newPointX), y: CGFloat(newPointY), width: newObjectImage!.size.width, height: newObjectImage!.size.height)
            fullImageWithVisibleItems.addSubview(objectView)
            picture.hiddenSprite =  objectView
            objectView.isHidden = true
            if (picture.pictureType == .colorchange){
                objectView.isHidden = false
            }else if (picture.pictureType == .inverted){
                objectView.isHidden = false
            }
        }
        //Setting tap gestures
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tappedImageWithHiddenItems(_:)))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture1.numberOfTouchesRequired = 1
        fullImageWithHiddenItems.isUserInteractionEnabled  = true
        tapGesture1.cancelsTouchesInView = false
        tapGesture1.delegate = self
        fullImageWithVisibleItems.addGestureRecognizer(tapGesture1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImageWithVisibleItems(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        fullImageWithHiddenItems.isUserInteractionEnabled  = true
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        fullImageWithHiddenItems.addGestureRecognizer(tapGesture)
         //adding objects to second ImageView -> Visible.
        
        for i in 0 ..< controller.level.allPictureObjects.count {
            
            let picture = controller.level.allPictureObjects[i]
            var object = UIImage.init(named: picture.imageName)
            if(picture.pictureType == .colorchange){
                object = UIImage.init(named: picture.imageName_correct)
            }else if (picture.pictureType == .inverted){
                object = UIImage.init(named: picture.imageName_correct)
            }
            let widthChange = object!.size.width/CGFloat(originalWidthOfImage)
            let heightChange = object!.size.height/CGFloat(originalHeightOfImage)
            let newWidth =  widthChange  * viewWidth
            let newHeight =  heightChange  * viewHeight
            let objectView = UIImageView.init(image: object)
            objectView.tag =  i + 1
            let newPointX = picture.x/2600 * Double(width)
            let newPointY = picture.y/1703 * Double(height)
            print(newPointX)
            print(newPointY)
            objectView.frame =  CGRect.init(x: CGFloat(newPointX), y: CGFloat(newPointY), width: newWidth, height: newHeight)
            fullImageWithHiddenItems.addSubview(objectView)
            picture.visibleSprite =  objectView
        }
        
        self.gameScene.launchGame(count : controller.level.allPictureObjects.count)
        
        scrollView2.delaysContentTouches = false
        
        
        
    }
    // MARK: tap gesture methods.
    @objc func tappedImageWithHiddenItems(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: fullImageWithVisibleItems)
        var locationInView = CGPoint.zero
        let subViews =  fullImageWithVisibleItems.subviews
        for subview in subViews {
            locationInView =  subview.convert(location, from: fullImageWithVisibleItems)
            if subview.point(inside: locationInView, with: nil){
                if(subview.tag > 0) {
                    verifyObjects(subview: subview, tag: subview.tag)
                }
            }
        }
        
    }
    @objc func tappedImageWithVisibleItems(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: fullImageWithHiddenItems)
        var locationInView = CGPoint.zero
        let subViews =  fullImageWithHiddenItems.subviews
        for subview in subViews {
            locationInView =  subview.convert(location, from: fullImageWithHiddenItems)
            if subview.point(inside: locationInView, with: nil){
                if(subview.tag > 0) {
                    verifyObjects(subview: subview, tag: subview.tag)
                }
            }
        }
    }
    
    // MARK: tap inputs
    func verifyObjects (subview: UIView, tag : Int){
        
        let success = controller.checkObjectWithTag (tag : tag)
        if(success) {
            foundObject (subview: subview)
        }
        
    }
    func foundObject (subview: UIView){
        
        addFoundCircle(parent: self.fullImageWithVisibleItems, x: subview.frame.origin.x + subview.frame.size.width/2 , y: subview.frame.origin.y + subview.frame.size.height/2)
        addFoundCircle(parent: self.fullImageWithHiddenItems, x: subview.frame.origin.x + subview.frame.size.width/2 , y: subview.frame.origin.y + subview.frame.size.height/2)
    }
    
    func addFoundCircle (parent : UIImageView, x : CGFloat, y: CGFloat){
        let image = UIImage.init(named: "found")
        let imageView = UIImageView.init(image: image)
        let xPos =  x - (image!.size.height/2)
        let yPos =  y - (image!.size.height/2)
        imageView.frame =  CGRect.init(x: xPos, y: yPos, width: (image!.size.width), height: (image!.size.height))
        parent.addSubview(imageView)
    }
    // MARK: Delegate methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if(scrollView.tag == 1){
            return fullImageWithVisibleItems
        }else{
            return fullImageWithHiddenItems
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.tag == 1){
            self.scrollView2.contentOffset = scrollView.contentOffset
            self.scrollView2.zoomScale = scrollView.zoomScale
            
            
        }else{
            self.scrollView1.contentOffset = scrollView.contentOffset
            self.scrollView1.zoomScale = scrollView.zoomScale
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let height = (width/self.size.width)*self.size.height
        return self.resize(size: CGSize(width: width, height: height))
    }
    
    func resize(height: CGFloat) -> UIImage {
        let width = (height/self.size.height)*self.size.width
        return self.resize(size: CGSize(width: width, height: height))
    }
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio  = size.width/self.size.width
        let heightRatio = size.height/self.size.height
        var updateSize = size
        if(widthRatio > heightRatio) {
            updateSize = CGSize(width:self.size.width*heightRatio, height:self.size.height*heightRatio)
        } else if heightRatio > widthRatio {
            updateSize = CGSize(width:self.size.width*widthRatio,  height:self.size.height*widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(updateSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: updateSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
extension UIView {
    /// Remove all subview
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /// Remove all subview with specific type
    func removeAllSubviews<T: UIView>(type: T.Type) {
        subviews
            .filter { $0.isMember(of: type) }
            .forEach { $0.removeFromSuperview() }
    }
}
