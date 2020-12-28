

import Foundation
import NeedleFoundation
import ShortRibs
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent") { component in
        return MainDependency453d57de9749f65d685aProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent") { component in
        return FiveDependencye83935124bfdddb7b15dProvider(component: component)
    }
    
}

// MARK: - Providers

private class MainDependency453d57de9749f65d685aBaseProvider: MainDependency {


    init() {

    }
}
/// ^->RootComponent->MainComponent
private class MainDependency453d57de9749f65d685aProvider: MainDependency453d57de9749f65d685aBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class FiveDependencye83935124bfdddb7b15dBaseProvider: FiveDependency {
    var persistentContainer: PersistentContaining {
        return rootComponent.persistentContainer
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->MainComponent->FiveComponent
private class FiveDependencye83935124bfdddb7b15dProvider: FiveDependencye83935124bfdddb7b15dBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent.parent as! RootComponent)
    }
}
