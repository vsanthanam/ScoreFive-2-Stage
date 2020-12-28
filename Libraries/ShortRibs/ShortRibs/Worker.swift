
//
//  Worker.swift
//  ShortRibs
//
//  Created by Varun Santhanam on 12/6/20.
//

import Foundation
import Combine

/// A protocol that defines the interface of a scope that a worker can be bound to.
///
/// @mockable
public protocol WorkerScope: AnyObject {
    
    /// Whether or not the scope is active
    var isActive: Bool { get }
    
    /// A publisher  of the `isActive` state
    var isActiveStream: AnyPublisher<Bool, Never> { get }
}

/// A protocol defining the public interface of a `Worker` accessible to `Interactor`s
///
/// @mockable
public protocol Working: AnyObject {
    
    /// Start the worker on a given scope
    /// - Parameter scope: A scope to bind the worker to
    func start(on scope: WorkerScope)
    
    /// Stop the worker
    func stop()
    
    /// Whether or not the worker has been started
    var isStarted: Bool { get }
    
    /// A publisher of the `isActive` state
    var isStartedStream: AnyPublisher<Bool, Never> { get }
    
}

/// A worker is an object that starts and stops based on some provided scope
open class Worker: Working {
    
    // MARK: - Initializer
    
    /// Initialize a `Worker`
    public init() {}
    
    // MARK: - Abstract Methods
    
    /// An abstract method, invoked just after the worker starts
    /// - Parameter scope: The scope that the worker is bound to
    open func didStart(on scope: WorkerScope) {}
    
    /// An abbstract method, invoked ust bef
    open func didStop() {}
    
    // MARK: - Working
    
    public func start(on scope: WorkerScope) {
        guard !isStarted else {
            return
        }
        
        stop()
        
        shouldStart = true
        bind(to: AnyWeakScope(scope))
    }
    
    public func stop() {
        guard shouldStart else {
            return
        }
        
        shouldStart = false
        performStop()
    }
    
    public final var isStarted: Bool {
        isStartedSubject.value
    }
    
    public final var isStartedStream: AnyPublisher<Bool, Never> {
        isStartedSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    @AutoCancel
    private var scopeBinding: Cancellable?
    
    private var shouldStart: Bool = false
    
    private var storage: Set<AnyCancellable>?
    
    private var isStartedSubject = CurrentValueSubject<Bool, Never>(false)
    
    private func bind(to scope: WorkerScope) {
        scopeBinding = scope.isActiveStream
            .removeDuplicates()
            .sink { [weak self] isActive in
                if isActive {
                    if let self = self, self.isStarted {
                        self.performStart(scope)
                    }
                } else {
                    self?.performStop()
                }
            }
    }
    
    private func performStart(_ scope: WorkerScope) {
        storage = Set<AnyCancellable>()
        isStartedSubject.send(true)
        didStart(on: scope)
    }
    
    private func performStop() {
        guard let storage = storage else {
            return
        }
        storage.forEach { stream in stream.cancel() }
        isStartedSubject.send(false)
        didStop()
    }
    
    fileprivate func store(cancellable: Cancellable) -> Bool {
        guard storage != nil else {
            return false
        }
        cancellable.store(in: &storage!)
        return true
    }
    
    private final class AnyWeakScope: WorkerScope {
        
        init(_ scope: WorkerScope) {
            self.scope = scope
        }
        
        var isActive: Bool {
            scope?.isActive ?? false
        }
        
        var isActiveStream: AnyPublisher<Bool, Never> {
            scope?.isActiveStream ?? Just<Bool>(false).eraseToAnyPublisher()
        }
        
        private weak var scope: WorkerScope?
    }
    
    // MARK: - Deinit
    
    deinit {
        stop()
    }
}

extension Publisher where Failure == Never {
    
    public func confine(to worker: Working) -> AnyPublisher<Output, Failure> {
        combineLatest(worker.isStartedStream) { element, isStarted in
            (element, isStarted)
        }
        .filter { element, isStarted in
            isStarted
        }
        .map { element, isActive in
            element
        }
        .eraseToAnyPublisher()
    }
    
}

extension Cancellable {
    
    @discardableResult
    public func cancelOnStop(worker: Worker) -> Cancellable {
        if !worker.store(cancellable: self) {
            cancel()
        }
        return self
    }
    
}
