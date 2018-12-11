//
//  RxActivity.swift
//  Uniview
//
//  Created by Krunoslav Zaher on 10/18/15.
//  Borrowed and revised by David James
//  Original source found in the open source project RxSwift.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/*
 Example:
 
 let signingIn = ActivityTracker()
 
 self.signingIn = signingIn.asDriver()
 
 let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
 
 signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
 .flatMapLatest { (username, password) in
 return API.signup(username, password: password)
 .trackActivity(signingIn)
 .asDriver(onErrorJustReturn: false)
 etc
 }
 // See: https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Examples/GitHubSignup/UsingDriver/GithubSignupViewModel2.swift#L91
 */

public extension ObservableConvertibleType {
    /// Track the activity of the current observable.
    public func trackActivity(_ activityTracker: ActivityTracker) -> Observable<E> {
        return activityTracker.trackActivityOfObservable(self)
    }
}

/**
 Enables monitoring of sequence computation.
 
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityTracker : SharedSequenceConvertibleType {
    
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let lock = NSRecursiveLock()
    
    private let counter = Variable(0)
    private let activityOverride = PublishSubject<Int>()
    private let loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        self.loading = Driver
            .of(
                counter.asDriver(),
                activityOverride.asDriver(onErrorJustReturn: 0)
            )
            .merge()
            .map { counter in counter > 0 }
            .distinctUntilChanged()
    }
    
    /// Keep activity tracking alive.
    /// Use this in cases of dependent chained observables
    /// so that the "waiting" state continues until the
    /// last observable completes. Usually call this in
    /// a "do.onNext" between observables.
    public func keepAlive() {
        lock.lock()
        activityOverride.onNext(1)
        lock.unlock()
        
    }
    
    /// For each observable track activity by initially incrementing
    /// (activity started) and storing a token which when the observable
    /// completes will decrement (activity ended).
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        
        // Examples of "using", ties the lifetime of the observable sequence
        // to an external resource which when disposed can take some further
        // action (in this case decrement and stop the activity)
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { token in
            return token.asObservable()
        }
    }
    
    /// Increment/start activity
    private func increment() {
        lock.lock()
        counter.value = counter.value + 1
        lock.unlock()
    }
    
    /// Decrement/stop activity
    private func decrement() {
        lock.lock()
        counter.value = counter.value - 1
        lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return loading
    }
}

/// The resource that is kept until the source observable finishes
/// at which time it disposes and calls the dispose action
/// which in this case is to decrement the activity tracker.
fileprivate struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}
