//
//  TextLogHandler.swift
//  Loggable
//
//  Created by Aaron Rennow on 2025-04-02.
//

import Foundation
import Logging

struct TextLogHandler: LogHandler {
	var metadata: Logger.Metadata = [:]
	var logLevel: Logger.Level = .info
	let label: String
	var dateGetter: @Sendable () -> Date = Date.init
	var outputHandle: @Sendable (String) -> Void = { print($0) }

	subscript(metadataKey key: String) -> Logger.Metadata.Value? {
		get { self.metadata[key] }
		set { self.metadata[key] = newValue }
	}

	func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
		var line = self.dateGetter().formatted(Date.ISO8601FormatStyle())
		line += " [\(level)]"
		line += " \(self.label):"
		line += " \(message)"

		self.outputHandle(line)
	}
}
