//
//  DrawingWithPath.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/21/21.
//

import UIKit

protocol DrawingWithPathDelegate: AnyObject {
    func drawingWithPathDidDraw(_ view: DrawingWithPath, fromIndex: Int, toIndex: Int, isFromRightToLeft: Bool)
}

class DrawingWithPath: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var lineDrawingArea: UIView?
    
    let controller = Counting_1Controller()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Properties
    private var numberOfSegments = 4
    private var firstPoint: CGPoint = .zero
    private var lastPoint: CGPoint = .zero
    private var lines = [[CGPoint]]()
    let path = UIBezierPath()

    weak var delegate: DrawingWithPathDelegate?
    
    //MARK: - Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(4)
        context.setLineCap(.butt)
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstPoint = touches.first?.location(in: self) ?? .zero
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: self) ?? .zero
        
        let firstSegmentIndex = index(for: firstPoint)
        let lastSegmentIndex = index(for: lastPoint)
        let isFromRightToLeft = firstPoint.x >= lastPoint.x
        
        lines.removeAll()
        setNeedsDisplay()
        
        delegate?.drawingWithPathDidDraw(self, fromIndex: firstSegmentIndex, toIndex: lastSegmentIndex, isFromRightToLeft: isFromRightToLeft)
    }
    
    func drawStraightLine() {
        var drawingView: UIView = self
        if let lineDrawingView = lineDrawingArea {
            drawingView = lineDrawingView
        }

        let firstSegmentIndex = index(for: firstPoint)
        let lastSegmentIndex = index(for: lastPoint)
        let segmentHeight = drawingView.frame.height / CGFloat(numberOfSegments)
        let isFromRightToLeft = firstPoint.x >= lastPoint.x
        
        let fromX = isFromRightToLeft ? drawingView.frame.width : 0
        let fromY = (CGFloat(firstSegmentIndex) * segmentHeight) + segmentHeight / 2
        let fromPoint = CGPoint(x: fromX, y: fromY)
        
        let toX = isFromRightToLeft ? 0 : drawingView.frame.width
        let toY = (CGFloat(lastSegmentIndex) * segmentHeight) + segmentHeight / 2
        let toPoint = CGPoint(x: toX, y: toY)
        
        drawLineFromPoint(start: fromPoint, toPoint: toPoint, ofColor: .red, inView: drawingView)
    }
    
    private func drawLineFromPoint(start: CGPoint, toPoint end: CGPoint, ofColor lineColor: UIColor, inView view: UIView) {
        
        path.move(to: start)
        path.addLine(to: end)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        shapeLayer.lineWidth = 4
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func index(for point: CGPoint) -> Int {
        let segmentHeight = frame.height / CGFloat(numberOfSegments)
        return Int(point.y / segmentHeight)
    }
    
    func removePath() {
        path.removeAllPoints()
        
        var drawingLayer: CALayer = self.layer
        if let lineDrawingView = lineDrawingArea {
            drawingLayer = lineDrawingView.layer
        }
        _ = drawingLayer.sublayers?.map({$0.removeFromSuperlayer()})
    }
}

