@testable import Loggable
import Logging
import Testing
private import DateTestHelpers
import Foundation

struct TextLogHandlerTests {
	@Test func lineFormat() {
		let lines = LockIsolated(Array<String>())
		let tlh = TextLogHandler(label: "TLHLabel") {
			Date.Builder.baseDate
		} outputHandle: { line in
			lines.access { lines in
				lines.append(line)
			}
		}

		tlh.log(level: .critical,
				message: "thing happened",
				metadata: nil,
				source: "TextLogHandlerTests",
				file: #file,
				function: #function,
				line: #line)

		#expect(lines.access(\.self) == [
			"2005-05-01T00:00:00Z [critical] TLHLabel: thing happened",
		])
	}
}
