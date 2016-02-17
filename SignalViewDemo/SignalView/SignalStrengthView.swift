//
//  SignalStrengthView.swift
//  RotateAnimationSample
//
//  Created by Khanh Pham on 2/17/16.
//  Copyright © 2016 Misfit Inc. All rights reserved.
//

import UIKit

class SignalStrengthView: UIView {

    var maxValue: Double = 0 {
        didSet {
            updateSignalDisplay()
        }
    }
    
    var minValue: Double = -100 {
        didSet {
            updateSignalDisplay()
        }
    }
    
    var currentValue: Double? = nil {
        didSet {
            updateSignalDisplay()
            updateSignalLabel()
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor.grayColor() {
        didSet {
            bgLayer.backgroundColor = bgColor.CGColor
        }
    }
    
    @IBInspectable var fgColor: UIColor = UIColor.blueColor() {
        didSet {
            fgLayer.backgroundColor = fgColor.CGColor
        }
    }
    
    var valueLabelFont: UIFont = UIFont.systemFontOfSize(11) {
        didSet {
            valueLabel.font = valueLabelFont
        }
    }
    
    @IBInspectable var valueLabelTextColor: UIColor = UIColor.blackColor() {
        didSet {
            valueLabel.textColor = valueLabelTextColor
        }
    }
    
    let valueLabel = UILabel()
    let margin: CGFloat = 0.0
    let columnsCount = 5
    
    let bgMaskLayer = CAShapeLayer()
    let fgMaskLayer = CAShapeLayer()
    let bgLayer = CALayer()
    let fgLayer = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    private func setup() {
        layer.addSublayer(bgLayer)
        layer.addSublayer(fgLayer)
        
        bgLayer.mask = bgMaskLayer
        bgLayer.masksToBounds = true
        
        fgLayer.mask = fgMaskLayer
        fgLayer.masksToBounds = true
        
        // Setup percent label
        valueLabel.text = "---"
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        // Setup constraints
        let valueLabelCenterX = valueLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let valueLabelBottom = valueLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -2.0)
        NSLayoutConstraint.activateConstraints([valueLabelCenterX, valueLabelBottom])
        
    }
    
    private func configure() {
        bgLayer.backgroundColor = bgColor.CGColor
        fgLayer.backgroundColor = fgColor.CGColor
        valueLabel.font = valueLabelFont
        valueLabel.textColor = valueLabelTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
        bgLayer.frame = boundRect
        updateSignalDisplay()
        
        bgMaskLayer.frame = boundRect
        fgMaskLayer.frame = boundRect
        
        let drawWidth = CGRectGetWidth(boundRect) - (2 * margin)
        let columnMargin = (drawWidth / CGFloat(columnsCount)) * 0.2
        let columnWidth = (drawWidth / CGFloat(columnsCount)) * 0.6
        let columnHeight = CGRectGetHeight(boundRect) - (2 * margin)
        
        let maskPath = CGPathCreateMutable()
        for idx in 0..<columnsCount {
            
            let x = margin + (CGFloat(columnsCount - idx - 1) * (columnWidth + 2 * columnMargin)) + columnMargin
            let height = CGFloat(columnsCount - idx) * (columnHeight / CGFloat(columnsCount))
            let y = CGRectGetHeight(boundRect) - margin - height
            
            let colRect = CGRectMake(x, y, columnWidth, height)
            let path = UIBezierPath(roundedRect: colRect, cornerRadius: columnWidth / 2.0)
            CGPathAddPath(maskPath, nil, path.CGPath)
        }
        
        bgMaskLayer.path = maskPath
        fgMaskLayer.path = maskPath
        
        
    }
    
    func updateSignalDisplay() {
        let curVal = currentValue != nil ? currentValue! : 0.0
        var ratio = (curVal - minValue) / (maxValue - minValue)
        ratio = ratio > 1 ? 1 : ratio < 0 ? 0 : ratio
        let level = Int(round(ratio * Double(columnsCount)))
        
        let boundRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
        let drawWidth = CGRectGetWidth(boundRect) - (2 * margin)
        let columnMargin = (drawWidth / CGFloat(columnsCount)) * 0.2
        let columnWidth = (drawWidth / CGFloat(columnsCount)) * 0.6
        
        let x = margin + (CGFloat(level) * (columnWidth + 2 * columnMargin))
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        fgLayer.frame = CGRect(x: 0, y: 0, width: x, height: boundRect.height)
        CATransaction.commit()
    }
    
    func updateSignalLabel() {
        if currentValue != nil {
            valueLabel.text = String(format: "%.0f", currentValue!)
        } else {
            valueLabel.text = "---"
        }
    }
    
}
