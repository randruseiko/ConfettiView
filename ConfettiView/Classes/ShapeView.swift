//
//  ShapeView.swift
//  Confetti
//
//  Created by Or on 30/09/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import UIKit
import CoreGraphics

// MARK: ShapeType


/// Enum to describes the possible shaps
enum ShapeType {
    
    ///Defines the possible colors of the confetti
    var possibleColors:[UIColor] {
        get {
            return [#colorLiteral(red: 0.7921568627, green: 0, blue: 0.1019607843, alpha: 1),#colorLiteral(red: 0.8392156863, green: 0.2470588235, blue: 0.2666666667, alpha: 1),#colorLiteral(red: 0.9764705882, green: 0.4470588235, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.9568627451, green: 0.3764705882, blue: 0.1254901961, alpha: 1)]
        }
    }
    
    case circle
    case triangle
    case square
    
    
    /**
        Depends on the enum returns draw clousre
        - Returns: A draw clousure that is adaptable to size and color
        - Attention: The returned clousre is intented to be called inside of draw rect
     */
    
    func getDrawfunction() -> ((CGRect,UIColor)->()) {
        switch self {
        case .circle:
            return { rect,color in
                let path = UIBezierPath(ovalIn: rect)
                color.setFill()
                path.fill()
            }
        case .square:
            return { rect,color in
                let path = UIBezierPath(rect: rect)
                color.setFill()
                path.fill()
            }
        case .triangle:
            return { rect,color in
                let path = UIBezierPath()
                path.move(to: CGPoint(x:0, y: rect.size.width))
                path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
                path.addLine(to: CGPoint(x: rect.size.width/2, y: 0))
                path.addLine(to: CGPoint(x:0, y: rect.size.width))
                color.setFill()
                path.fill()
            }
    }
    
    /// Returns a random color
    func getRandomColor() -> UIColor {
        return possibleColors.randomElement()!
    }
    
    /// Returns a randum ShapeType
    static func random()-> ShapeType {
        return [ShapeType.circle,ShapeType.square,.triangle].randomElement()!
    }
}

// MARK: ShapeView

/// UIView subclass which is initialized with a random Shape and color
class ShapeView: UIView {
    
    
    /// The shape that will be draw in the view. *This cannot change*
    let shapeType:ShapeType
    /// The color of the shape that will be drawen in the view. *This cannot change*
    let shapeColor:UIColor
    
    // MARK: life cycle
    
    override func draw(_ rect: CGRect) {
        let drawFunction = shapeType.getDrawfunction()
        drawFunction(rect,shapeColor)
    }

    override init(frame: CGRect) {
        shapeType = ShapeType.random()
        shapeColor = shapeType.getRandomColor()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    /**
      Initialize a new shape view with random shape and color
        
     - Parameters:
        - center: The center position of the initiaized view
        - depth: The wanted depth, this causes the shape to move faster and apear smaller to create the illusion of depth *Default Value is 1*
     */
    convenience init(center point:CGPoint, depth:Double = 1) {
        self.init(frame:CGRect(x: 0, y: 0, width: 20/depth, height: 20/depth))
        self.center = point
    }
    
   
    

}

extension Collection where Index == Int {
    /// Returns random elemnt from an array
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
    
}
