// The Swift Programming Language
// https://docs.swift.org/swift-book

public import Logging

private let unspecifiedSubsystem = "unspecified"
let logCategoryMetadataKey = "log-category"

public protocol Loggable {
	static var loggerSubsystem: String { get }
	static var loggerCategory: String { get }
	static var logger: Logger { get }
}

public extension Loggable {
	static var loggerSubsystem: String {
		unspecifiedSubsystem
	}

	static var loggerCategory: String {
		String(describing: Self.self)
	}

	static var logger: Logger {
		var l = Logger(label: Self.loggerSubsystem)
		l[metadataKey: logCategoryMetadataKey] = .string(Self.loggerCategory)
		return l
	}
}

public enum LoggableSetup {
	public static func setUp(journal: Journal? = nil) {
		LoggingSystem.bootstrap { label in
			var handlers = Array<any LogHandler>()

			#if canImport(os) && DEBUG
				handlers.append(OSLogHandler(label: label))
			#else
				handlers.append(TextLogHandler(label: label))
			#endif

			if let journal {
				handlers.append(JournalLogHandler(label: label,
												  journal: journal))
			}

			var mlh = MultiplexLogHandler(handlers)
			mlh.logLevel = .trace
			return mlh
		}
	}
}

public extension Logger {
	func tryOrLog<R>(message: String, action: () throws -> R?) -> R? {
		do {
			return try action()
		} catch {
			self.error("\(message): \(error)")
			return nil
		}
	}

	func tryOrLog(isolation: isolated (any Actor)? = #isolation, message: String, action: () async throws -> Void) async {
		do {
			try await action()
		} catch {
			self.error("\(message): \(error)")
		}
	}
}
