//
//  SymbolButton.swift
//  FiveUI
//
//  Created by Varun Santhanam on 1/1/21.
//

import Foundation
import UIKit
import SnapKit

public enum Symbol {
    
    open class View: UIImageView {
        
        
        
    }
    
}

open class SymbolButton: TappableControl {
    
    // MARK: - Initializers
    
    init(symbolName: String) {
        self.symbolName = symbolName
        super.init()
        setUp()
    }
    
    // MARK: - API
    
    open var symbolName: String {
        didSet {
            refreshImage()
        }
    }
    
    open var highlightedSymbolName: String? {
        didSet {
            refreshImage()
        }
    }
    
    open var pointSize: CGFloat = 17.0 {
        didSet {
            refreshImage()
            invalidateIntrinsicContentSize()
        }
    }
    
    open var symbolColor: UIColor = .contentPrimary {
        didSet {
            refreshImage()
        }
    }
    
    open var highlightedSymbolColor: UIColor? {
        didSet {
            refreshImage()
        }
    }
    
    open var activeColor: UIColor = .transparent {
        didSet {
            refreshImage()
        }
    }
    
    open var highlightedActiveColor: UIColor? {
        didSet {
            refreshImage()
        }
    }
    
    // MARK: - UIView
    
    open override var intrinsicContentSize: CGSize {
        .init(width: pointSize, height: pointSize)
    }
    
    // MARK: - Private
    
    private let imageView = UIImageView()
    
    private var symbolConfiguration: UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(pointSize: pointSize)
    }
    
    private var image: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        let image = UIImage(systemName: symbolName, withConfiguration: config)
        return image!
    }
    
    private var highlightedImage: UIImage {
        if let symbolName = highlightedSymbolName {
            let config = UIImage.SymbolConfiguration(pointSize: pointSize)
            let image = UIImage(systemName: symbolName, withConfiguration: config)
            return image!
        }
        return image
    }
    
    private func setUp() {
        imageView.backgroundColor = .transparent
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
        refreshImage()
    }
    
    private func refreshImage() {
        imageView.preferredSymbolConfiguration = symbolConfiguration
        if isHighlighted {
            backgroundColor = activeColor
            imageView.tintColor = symbolColor
            imageView.image = highlightedImage
        } else {
            backgroundColor = highlightedActiveColor ?? activeColor
            imageView.tintColor = highlightedSymbolColor ?? .controlDisabled
            imageView.image = image
        }
    }
}
