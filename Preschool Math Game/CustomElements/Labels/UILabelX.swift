//
//  UILabelX.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 15.03.22.
//

import Foundation
import UIKit

@IBDesignable
class UILabelX: UILabel {
    
    @IBInspectable var angle: CGFloat = 1.6
    @IBInspectable var clockwise: Bool = true
    
    override func draw(_ rect: CGRect) {
        centreArcPerpendicular()
    }
    
    /**
     This draws the self.text around an arc of radius r,
     with the text centred at polar angle theta
     */
    func centreArcPerpendicular() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let str = self.text ?? ""
        let size = self.bounds.size
        context.translateBy(x: size.width / 2, y: size.height / 2)
        
        let radius = getRadiusForLabel()
        let l = str.count
        //        let attributes: [String : Any] = [NSAttributedString.Key: self.font]
        let attributes : [NSAttributedString.Key : Any] = [.font : self.font as Any]
        
        let characters: [String] = str.map { String($0) } // An array of single character strings, each character in str
        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string
        
        // Calculate the arc subtended by each letter and their total
        for i in 0 ..< l {
            //            arcs = [chordToArc(characters[i].widthOfString(usingFont: self.font), radius: radius)]
            arcs += [chordToArc(characters[i].size(withAttributes: attributes).width, radius: radius)]
            totalArc += arcs[i]
        }
        
        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection = clockwise ? -CGFloat(Double.pi/2) : CGFloat(Double.pi/2)
        
        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI = angle - direction * totalArc / 2
        
        for i in 0 ..< l {
            thetaI += direction * arcs[i] / 2
            // Call centre with each character in turn.
            // Remember to add +/-90?? to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[i], context: context, radius: radius, angle: thetaI, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * arcs[i] / 2
        }
    }
    
    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        // *******************************************************
        // Simple geometry
        // *******************************************************
        return 2 * asin(chord / (2 * radius))
    }
    
    /**
     This draws the String str centred at the position
     specified by the polar coordinates (r, theta)
     i.e. the x= r * cos(theta) y= r * sin(theta)
     and rotated by the angle slantAngle
     */
    func centre(text str: String, context: CGContext, radius r:CGFloat, angle theta: CGFloat, slantAngle: CGFloat) {
        // Set the text attributes
        let attributes = [NSAttributedString.Key.font: self.font!] as [NSAttributedString.Key : Any]
        // Save the context
        context.saveGState()
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy(x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }
    
    func getRadiusForLabel() -> CGFloat {
        // Imagine the bounds of this label will have a circle inside it.
        // The circle will be as big as the smallest width or height of this label.
        // But we need to fit the size of the font on the circle so make the circle a little
        // smaller so the text does not get drawn outside the bounds of the circle.
        let smallestWidthOrHeight = min(self.bounds.size.height, self.bounds.size.width)
        let heightOfFont = self.text?.size(withAttributes: [NSAttributedString.Key.font: self.font as Any]).height ?? 0
        
        // Dividing the smallestWidthOrHeight by 2 gives us the radius for the circle.
        return (smallestWidthOrHeight/2) - heightOfFont + 5
    }
}
