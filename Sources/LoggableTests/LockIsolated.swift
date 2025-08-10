//
//  LockIsolated.swift
//  Loggable
//
//  Created by Aaron Rennow on 2025-04-02.
//

import Foundation

final class LockIsolated<Value>: @unchecked Sendable {
	private var _value: Value
	private let lock = NSLock()

	init(_ value: Value) {
		self._value = value
	}

	func access<R>(_ operation: @Sendable (inout Value) throws -> R) rethrows -> R {
		try self.lock.withLock {
			try operation(&self._value)
		}
	}
}
