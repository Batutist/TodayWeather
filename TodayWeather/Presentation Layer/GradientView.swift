//
//  GradientView.swift
//  gradientBackground
//
//  Created by Ковалева on 22.11.17.
//  Copyright © 2017 Ковалев. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        
        if horizontalGradient {
            layer.startPoint =  CGPoint(x: 0.0, y: 0.5)
            layer.endPoint =    CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint =  CGPoint(x: 0, y: 0)
            layer.endPoint =    CGPoint(x: 0, y: 1)
        }
    }
}
