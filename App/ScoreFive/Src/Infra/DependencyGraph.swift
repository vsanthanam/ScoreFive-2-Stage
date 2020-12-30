

import Foundation
import NeedleFoundation
import ShortRibs
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent->HomeComponent") { component in
        return HomeDependency6719eb94b72d94a36f34Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent->GameComponent->NewRoundComponent") { component in
        return NewRoundDependency7cd092c3b5cbba3d7ac0Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent->GameComponent") { component in
        return GameDependency81e44729f3f6e44c959bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent->HomeComponent->NewGameComponent") { component in
        return NewGameDependencya0c15d095925b8e7801cProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent") { component in
        return MainDependency453d57de9749f65d685aProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent->GameComponent->ScoreCardComponent") { component in
        return ScoreCardDependencyfe55e6e48ba925e19d0aProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MainComponent->FiveComponent") { component in
        return FiveDependencye83935124bfdddb7b15dProvider(component: component)
    }
    
}

// MARK: - Providers

private class HomeDependency6719eb94b72d94a36f34BaseProvider: HomeDependency {
    var gameStorageManager: GameStorageManaging {
        return fiveComponent.gameStorageManager
    }
    private let fiveComponent: FiveComponent
    init(fiveComponent: FiveComponent) {
        self.fiveComponent = fiveComponent
    }
}
/// ^->RootComponent->MainComponent->FiveComponent->HomeComponent
private class HomeDependency6719eb94b72d94a36f34Provider: HomeDependency6719eb94b72d94a36f34BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(fiveComponent: component.parent as! FiveComponent)
    }
}
private class NewRoundDependency7cd092c3b5cbba3d7ac0BaseProvider: NewRoundDependency {


    init() {

    }
}
/// ^->RootComponent->MainComponent->FiveComponent->GameComponent->NewRoundComponent
private class NewRoundDependency7cd092c3b5cbba3d7ac0Provider: NewRoundDependency7cd092c3b5cbba3d7ac0BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class GameDependency81e44729f3f6e44c959bBaseProvider: GameDependency {


    init() {

    }
}
/// ^->RootComponent->MainComponent->FiveComponent->GameComponent
private class GameDependency81e44729f3f6e44c959bProvider: GameDependency81e44729f3f6e44c959bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class NewGameDependencya0c15d095925b8e7801cBaseProvider: NewGameDependency {


    init() {

    }
}
/// ^->RootComponent->MainComponent->FiveComponent->HomeComponent->NewGameComponent
private class NewGameDependencya0c15d095925b8e7801cProvider: NewGameDependencya0c15d095925b8e7801cBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
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
private class ScoreCardDependencyfe55e6e48ba925e19d0aBaseProvider: ScoreCardDependency {
    var gameStorageProvider: GameStorageProviding {
        return fiveComponent.gameStorageProvider
    }
    var activeGameStream: ActiveGameStreaming {
        return fiveComponent.activeGameStream
    }
    private let fiveComponent: FiveComponent
    init(fiveComponent: FiveComponent) {
        self.fiveComponent = fiveComponent
    }
}
/// ^->RootComponent->MainComponent->FiveComponent->GameComponent->ScoreCardComponent
private class ScoreCardDependencyfe55e6e48ba925e19d0aProvider: ScoreCardDependencyfe55e6e48ba925e19d0aBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(fiveComponent: component.parent.parent as! FiveComponent)
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
