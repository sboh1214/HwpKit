import Foundation

struct HwpRecord {
    var children: [HwpRecord] = []
    let payload: Data
    let tagID: UInt32
    let size: UInt32
    let parentTagID: UInt32
}

func parseRecordTree(data: Data) throws -> HwpRecord {
    let root = HwpRecord(payload: Data(), tagID: 0, size: 0, parentTagID: 0)
    var reader = DataReader(data)
    while reader.offset < data.count {
        let value = reader.readUInt32()

        let tagId = value & 0x3FF
        let level = (value >> 10) & 0x3FF
        var size = (value >> 20) & 0xFFF
        if size == 0xFFF {
            size = reader.readUInt32()
        }

        var parent = root
        let payload = reader.readBytes(Int(size))

        for _ in 0 ..< level {
            parent = parent.children[-1]
        }
        let child = HwpRecord(payload: payload, tagID: tagId, size: size, parentTagID: parent.tagID)
        parent.children.append(child)
    }
    return root
}
