@testable import HwpKit
import XCTest

final class BlankTests: XCTestCase {
    func openHwp() throws -> HwpFile {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("blank.hwp")
        return try HwpFile(filePath: url.path)
    }

    func testOpen() throws {
        let hwp = try openHwp()
        XCTAssertNotNil(hwp.fileHeader)
    }

    func testSignature() throws {
        let hwp = try openHwp()
        dump(hwp.fileHeader.signature)
        XCTAssertEqual(hwp.fileHeader.signature, "HWP Document File\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0")
    }

    func testHwpVersion() throws {
        let hwp = try openHwp()
        XCTAssertEqual(hwp.fileHeader.version.major, 5)
        XCTAssertEqual(hwp.fileHeader.version.minor, 0)
        XCTAssertEqual(hwp.fileHeader.version.build, 3)
        XCTAssertEqual(hwp.fileHeader.version.revision, 4)
    }

    func testEncryptVersion() throws {
        let hwp = try openHwp()
        XCTAssertEqual(hwp.fileHeader.encryptVersion, 4)
    }

    static var allTests = [
        ("testOpen", testOpen),
        ("testSignature", testSignature),
        ("testHwpVersion", testHwpVersion),
        ("testEncryptVersion", testEncryptVersion),
    ]
}