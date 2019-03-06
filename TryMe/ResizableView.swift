//
//  OverlayView.swift
//  TryMe
//
//  Created by Ruhsane Sawut on 3/5/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit

class ResizableView: UIImageView {
    
    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }
    
    static var edgeSize: CGFloat = 44.0
    private typealias `Self` = ResizableView
    
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            touchStart = touch.location(in: self)
            
            currentEdge = {
                if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomRight
                } else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                    return .topLeft
                } else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                    return .topRight
                } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomLeft
                }
                return .none
            }()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y
            
            switch currentEdge {
            case .topLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
            case .topRight:
                self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
            case .bottomRight:
                self.frame = CGRect(x: originX, y: originY, width: currentPoint.x + deltaWidth, height: currentPoint.y + deltaWidth)
            case .bottomLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            default:
                // Moving
                self.center = CGPoint(x: self.center.x + currentPoint.x - touchStart.x,
                                      y: self.center.y + currentPoint.y - touchStart.y)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentEdge = .none
    }
}
