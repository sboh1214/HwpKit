import Foundation

/**
 데이터 레코드 구조

 논리적으로 연관된 데이터들을 헤더 정보와 함께 저장하는 방식을 데이터 레코드라고 한다.
 레코드 구조를 가지는 스트림은 연속된 여러 개의 레코드로 구성된다. 데이터 레코드는 헤더와 데이터로 구성되며 각 헤더 정보를 활용하여 전체 논리적 구조를 생성하게 된다.
 레코드의 헤더에는 데이터 확장에 대비한 정보를 가지고 있다.
 따라서 이후에 한글의 기능이 확장되어 레코드에 데이터가 추가되는 경우에도 하위 버전의 한글이 상위 버전의 한글 문서를 읽을 수 있도록 하위 호환성이 보장된다.
 */
class HwpRecord {
    /**
     레코드가 나타내는 데이터의 종류를 나타내는 태그이다. Tag ID에는 10 비트가 사용되므 로 0x000 - 0x3FF까지 가능하다.
     - 0x000 - 0x00F = 일반 레코드 태그가 아닌 특별한 용도로 사용한다.
     - 0x010 - 0x1FF = 한글에 의해 내부용으로 예약된 영역(HWPTAG_BEGIN = 0x010)
     - 0x200 - 0x3FF = 외부 어플리케이션이 사용할 수 있는 영역
     */
    let tagId: UInt32
    /**
     연관된 레코드의 논리적인 묶음을 표현하기 위한 정보

     대부분 하나의 오브젝트는 여러 개의 레코드로 구성되는 것이 일반적이기 때문에
     하나의 레코드가 아닌 "논리적으로 연관된 연속된 레코드"라는 개념이 필요하다.
     스트림을 구성하는 모든 레코드는 계층 구조로 표현할 수 있는데, 레벨은 바로 이 계층 구조에서의 depth를 나타낸다.
     */
    let level: UInt32
    let payload: Data
    var children: [HwpRecord]

    init(tagId: UInt32, level: UInt32, payload: Data) {
        self.tagId = tagId
        self.level = level
        self.payload = payload
        children = [HwpRecord]()
    }
}

func parseTreeRecord(data: Data) -> HwpRecord {
    var reader = DataReader(data)
    let root = HwpRecord(tagId: 0, level: 0, payload: Data())

    while !reader.isEOF {
        let value = reader.read(UInt32.self)
        let tagId = value & 0x3FF
        let level = (value >> 10) & 0x3FF
        var size = (value >> 20) & 0xFFF
        if size == 0xFFF {
            size = reader.read(UInt32.self)
        }
        let payload = reader.readBytes(size)

        var parent = root

        for _ in 0 ..< level {
            parent = parent.children.last!
        }
        parent.children.append(HwpRecord(tagId: tagId, level: level, payload: payload))
    }

    return root
}
