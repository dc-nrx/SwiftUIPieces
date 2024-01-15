//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import Foundation
import Combine

public extension Published<InputAsyncOperation<String>?>.Publisher {
    mutating func nullifyOnFinish(
        waitAfterSuccess: DispatchQueue.SchedulerTimeType.Stride? = .seconds(1.5)
    ) {
        compactMap { $0 }
            .flatMap(\.$state)
            .filter(\.isFinal)
            .debounce(for: waitAfterSuccess, scheduler: DispatchQueue.main) { $0.isSuccess }
            .map { _ in nil }
            .assign(to: &self)
    }
}

public extension Published<VoidAsyncOperation?>.Publisher {
    mutating func nullifyOnFinish(
        waitAfterSuccess: DispatchQueue.SchedulerTimeType.Stride? = nil
    ) {
        compactMap { $0 }
            .flatMap(\.$state)
            .filter(\.isFinal)
            .debounce(for: waitAfterSuccess, scheduler: DispatchQueue.main) { $0.isSuccess }
            .map { _ in nil }
            .assign(to: &self)
    }

}

private extension Publisher {
  func debounce<S>(
    for dueTime: S.SchedulerTimeType.Stride?,
    scheduler: S,
    options: S.SchedulerOptions? = nil,
    shouldDebounce: @escaping (Output) -> Bool
  ) -> AnyPublisher<Output, Failure> where S: Scheduler {
    map { output in
      if shouldDebounce(output), let dueTime {
          Just(output)
            .delay(for: dueTime, scheduler: scheduler)
            .eraseToAnyPublisher()
      } else {
          Just(output)
            .eraseToAnyPublisher()
      }
    }
    .switchToLatest()
    .eraseToAnyPublisher()
  }
}
