private import DateTestHelpers
import Foundation
@testable import Loggable
import Testing

fileprivate func entry(date: Date, text: String) -> Journal.Entry {
	.init(date: date,
		  loggerLabel: "ll",
		  level: .info,
		  message: text,
		  metadata: nil,
		  source: "mock",
		  file: "text",
		  function: "entry",
		  line: 666)
}

struct JournalTests {
	@Test func journalExportIsOrdered() async {
		let j = Journal()

		await j.insert(entry(date: Date.Builder(minute: 2).build(), text: "B"))
		await j.insert(entry(date: Date.Builder(minute: 3).build(), text: "C"))
		await j.insert(entry(date: Date.Builder(minute: 1).build(), text: "A"))

		let entries = await j.export()
		#expect(entries.map(\.message) == ["A", "B", "C"])
	}
}
