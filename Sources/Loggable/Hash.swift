//
//  Hash.swift
//  Loggable
//
//  Created by Aaron Rennow on 2025-03-04.
//

#if DEBUG
	public func hash(_ val: some CustomStringConvertible) -> String {
		val.description
	}

	public func hash(_ val: Optional<some CustomStringConvertible>, revealingNil: Bool) -> String {
		val?.description ?? "nil"
	}
#else
	public func hash(_ val: some CustomStringConvertible) -> String {
		val.description.hashValue.description
	}

	public func hash(_ val: Optional<some CustomStringConvertible>, revealingNil: Bool) -> String {
		if let val {
			val.description.hashValue.description
		} else {
			if revealingNil {
				"nil"
			} else {
				hash("nil")
			}
		}
	}
#endif
