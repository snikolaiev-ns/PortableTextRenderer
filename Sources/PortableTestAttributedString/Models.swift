import Foundation

public struct PortableText: Codable {
    let style: String
    let markDefs: [MarkDef]
    let children: [PortableTextChild]
    let key: String
    let type: String
    let level: Int?
    let listItem: String?

    public enum CodingKeys: String, CodingKey {
        case style
        case markDefs
        case children
        case key = "_key"
        case type = "_type"
        case level
        case listItem
    }
}

public struct PortableTextChild: Codable {
    let type: String?
    let key: String?
    let text: String?
    let marks: [String]?

    public enum CodingKeys: String, CodingKey {
        case type
        case key
        case text
        case marks
    }
}

public struct MarkDef: Codable {
    let type: String
    let key: String
    let href: String?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case key = "_key"
        case href
    }
}
