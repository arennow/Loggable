//
//  OSLogHandler.swift
//  Loggable
//
//  Created by Aaron Rennow on 2025-03-04.
//

#if canImport(os)
	import Logging
	import os

	struct OSLogHandler: LogHandler {
		var metadata: Logging.Logger.Metadata = [:]
		var logLevel: Logging.Logger.Level = .info
		let label: String

		subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
			get { self.metadata[key] }
			set { self.metadata[key] = newValue }
		}

		init(label: String) {
			self.label = label
		}

		func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: Logging.Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
			let category = self.metadata.category ?? "unspecified"
			let osl = os.Logger(subsystem: self.label, category: category)
			osl.log(level: .from(loggerLevel: level), "\(message.description, privacy: .public)")
		}
	}

	private extension OSLogType {
		static func from(loggerLevel: Logging.Logger.Level) -> Self {
			switch loggerLevel {
				case .trace: .debug
				case .debug: .debug
				case .info: .info
				case .notice: .info
				case .warning: .info
				case .error: .error
				case .critical: .fault
			}
		}
	}
#endif
