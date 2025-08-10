import Foundation
import Logging

public actor Journal {
	public struct Entry: Comparable, Sendable, Identifiable {
		public static func < (lhs: Self, rhs: Self) -> Bool { lhs.date < rhs.date }

		public let id = UUID()
		public let date: Date

		public let loggerLabel: String

		public let level: Logger.Level
		public let message: String
		public let metadata: Logger.Metadata?
		public let source: String
		public let file: String
		public let function: String
		public let line: UInt
	}

	private var entries = Array<Entry>()

	public init() {}

	func insert(_ entry: Entry) {
		self.entries.append(entry)
	}

	public func export() -> Array<Entry> {
		// Presumably fast-ish since it's _nearly_ in order
		self.entries.sort()
		return self.entries
	}
}

public extension Journal.Entry {
	static func mock(level: Logger.Level,
					 subsystem: String = "Subsystem",
					 category: String = "Category",
					 message: String) -> Self
	{
		.init(date: .now,
			  loggerLabel: subsystem,
			  level: level,
			  message: message,
			  metadata: [logCategoryMetadataKey: .string(category)],
			  source: "The App",
			  file: #file,
			  function: #function,
			  line: #line)
	}
}

struct JournalLogHandler: LogHandler {
	var metadata: Logger.Metadata = [:]
	var logLevel: Logger.Level = .info
	let label: String
	let journal: Journal

	subscript(metadataKey key: String) -> Logger.Metadata.Value? {
		get { self.metadata[key] }
		set { self.metadata[key] = newValue }
	}

	func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
		let resolvedMetadata = if let metadata {
			self.metadata.merging(metadata, uniquingKeysWith: { $1 })
		} else {
			self.metadata
		}

		let entry = Journal.Entry(date: Date(),
								  loggerLabel: self.label,
								  level: level,
								  message: message.description,
								  metadata: resolvedMetadata,
								  source: source,
								  file: file,
								  function: function,
								  line: line)

		Task {
			await self.journal.insert(entry)
		}
	}
}

public extension Logger.Metadata {
	var category: String? {
		guard case .string(let value) = self[logCategoryMetadataKey] else { return nil }
		return value
	}
}
