//
//  TagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

@IBDesignable
open class TagView: UIButton {

    /// This property doesn't change background color of the view.
    /// Use `specialBackgroundColor` instead.
    override open var backgroundColor: UIColor? {
        set {

        }
        get {
            return super.backgroundColor
        }
    }

    /// Background color of this view.
    var specialBackgroundColor: UIColor? {
        set {
            super.backgroundColor = newValue
        }
        get {
            return super.backgroundColor
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var paddingY: CGFloat = 2 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    @IBInspectable open var paddingX: CGFloat = 5 {
        didSet {
            titleEdgeInsets.left = paddingX
            updateRightInsets()
        }
    }

    @IBInspectable open var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var highlightedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBorderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    public var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    private func reloadStyles() {
        if isHighlighted {
            if let highlightedBackgroundColor = highlightedBackgroundColor {
                // For highlighted, if it's nil, we should not fallback to backgroundColor.
                // Instead, we keep the current color.
                specialBackgroundColor = highlightedBackgroundColor
            }
        }
        else if isSelected {
            specialBackgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            layer.borderColor = selectedBorderColor?.cgColor ?? borderColor?.cgColor
            setTitleColor(selectedTextColor, for: .normal)
        }
        else {
            specialBackgroundColor = tagBackgroundColor
            layer.borderColor = borderColor?.cgColor
            setTitleColor(textColor, for: .normal)
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    // MARK: remove button
    
    let removeButton = CloseButton()
    
    @IBInspectable open var enableRemoveButton: Bool = false {
        didSet {
            removeButton.isHidden = !enableRemoveButton
            updateRightInsets()
        }
    }
    
    @IBInspectable open var removeButtonIconSize: CGFloat = 12 {
        didSet {
            removeButton.iconSize = removeButtonIconSize
            updateRightInsets()
        }
    }
    
    @IBInspectable open var removeIconLineWidth: CGFloat = 3 {
        didSet {
            removeButton.lineWidth = removeIconLineWidth
        }
    }
    @IBInspectable open var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            removeButton.lineColor = removeIconLineColor
        }
    }
    
    /// Handles Tap (TouchUpInside)
    open var onTap: ((TagView) -> Void)?
    open var onLongPress: ((TagView) -> Void)?
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: .normal)
        
        setupView()
    }
    
    private func setupView() {
        frame.size = intrinsicContentSize
        addSubview(removeButton)
        removeButton.tagView = self
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func longPress() {
        onLongPress?(self)
    }
    
    // MARK: - layout

    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.intrinsicContentSize ?? CGSize.zero
        size.height += paddingY * 2
        size.width += paddingX * 2
        if enableRemoveButton {
            size.width += removeButtonIconSize + paddingX
        }
        return size
    }

    private func updateRightInsets() {
        if enableRemoveButton {
            titleEdgeInsets.right = paddingX  + removeButtonIconSize + paddingX
        }
        else {
            titleEdgeInsets.right = paddingX
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if enableRemoveButton {
            removeButton.frame.size.width = paddingX + removeButtonIconSize + paddingX
            removeButton.frame.origin.x = self.frame.width - removeButton.frame.width
            removeButton.frame.size.height = self.frame.height
            removeButton.frame.origin.y = 0
        }
    }
}
