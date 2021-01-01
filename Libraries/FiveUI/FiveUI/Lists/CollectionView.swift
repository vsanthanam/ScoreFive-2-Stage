//
//  CollectionView.swift
//  FiveUI
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import UIKit

/// A protocol describing a cell content configuration that can be initialized without parameters. For every cell, create a struct that conforms to this type.
public protocol CellContentConfiguration: UIContentConfiguration {
    init()
}

/// The content view of a cell, specialized against its matching content configuration struct.
open class CellContentView<T>: UIView, UIContentView where T: CellContentConfiguration {

    // MARK: - Initializers

    public init(configuration: T) {
        self.specializedConfiguration = configuration
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Don't Use Interface Builder 😡")
    }

    // MARK: - API

    open private(set) var specializedConfiguration: T

    open func apply(configuration: T) {
        fatalError("Abstract Method Not Implemented 😡")
    }

    // MARK: - UIContentView

    public var configuration: UIContentConfiguration {
        get { specializedConfiguration }
        set {
            guard let config = newValue as? T else {
                assertionFailure("Invalid Config Type")
                return
            }
            specializedConfiguration = config
            apply(configuration: specializedConfiguration)
        }
    }
}

open class ListCell<ContentConfiguration, ContentView>: CollectionViewListCell where ContentConfiguration: CellContentConfiguration, ContentView: CellContentView<ContentConfiguration> {
    public class func newConfiguration() -> ContentConfiguration {
        .init()
    }
}

open class CollectionViewListCell: UICollectionViewListCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("Don't Use Interface Builder 😡")
    }
}

open class Cell<ContentConfiguration, ContentView>: CollectionViewCell where ContentConfiguration: CellContentConfiguration, ContentView: CellContentView<ContentConfiguration> {
    public class func newConfiguration() -> ContentConfiguration {
        .init()
    }
}

open class CollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("Don't Use Interface Builder 😡")
    }
}

open class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("Don't Use Interface Builder 😡")
    }
}

open class TableCell<ContentConfiguration, ContentView>: TableViewCell where ContentConfiguration: CellContentConfiguration, ContentView: CellContentView<ContentConfiguration> {
    
    public class func newConfiguration() -> ContentConfiguration {
        .init()
    }
    
}
