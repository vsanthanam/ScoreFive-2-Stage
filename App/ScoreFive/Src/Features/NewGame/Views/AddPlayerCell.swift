//
//  AddPlayerCell.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import FiveUI
import Foundation
import UIKit

final class AddPlayerCell: ListCellView<AddPlayerCell.ContentConfiguration, AddPlayerCell.ContentView> {

    final class ContentView: CellContentView<ContentConfiguration> {
        
        override init(configuration: ContentConfiguration) {
            super.init(configuration: configuration)
            setUp()
        }
        
        override func apply(configuration: ContentConfiguration) {
            titleLabel.text = configuration.title ?? "Add Player"
        }
        
        let titleLabel = UILabel(frame: .zero)
        
        private func setUp() {
            titleLabel.textAlignment = .center
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make
                    .center
                    .equalToSuperview()
                make
                    .height
                    .greaterThanOrEqualTo(28.0)
                make
                    .top
                    .bottom
                    .equalToSuperview().inset(8.0)
            }
        }
    }

    struct ContentConfiguration: CellContentConfiguration {
        
        var title: String?
        
        func makeContentView() -> UIView & UIContentView {
            ContentView(configuration: self)
        }
        
        func updated(for state: UIConfigurationState) -> ContentConfiguration {
            self
        }
    }
}
