import UIKit

public class PortableTextRenderer {
    let portableText: [PortableText]
    let fontMap: [String: UIFont]
    let normalFont: UIFont
    let quoteFont: UIFont
    let linkColor: UIColor
    let codeBackgroundColor: UIColor
    let underlineLinks: Bool

    public init(
        portableText: [PortableText],
        fontMap: [String: UIFont] = [
            "h1": UIFont.systemFont(ofSize: 24, weight: .bold),
            "h2": UIFont.systemFont(ofSize: 22, weight: .semibold),
            "h3": UIFont.systemFont(ofSize: 20, weight: .medium),
            "h4": UIFont.systemFont(ofSize: 18, weight: .medium),
            "h5": UIFont.systemFont(ofSize: 16, weight: .medium),
            "h6": UIFont.systemFont(ofSize: 14, weight: .regular),
            "blockquote": UIFont.italicSystemFont(ofSize: 14)
        ],
        normalFont: UIFont = UIFont.systemFont(ofSize: 14),
        quoteFont: UIFont = UIFont.italicSystemFont(ofSize: 14),
        linkColor: UIColor = UIColor(red: 0.024, green: 0.271, blue: 0.678, alpha: 1),
        codeBackgroundColor: UIColor = .lightGray,
        underlineLinks: Bool = true
    ) {
        self.portableText = portableText
        self.fontMap = fontMap
        self.normalFont = normalFont
        self.quoteFont = quoteFont
        self.linkColor = linkColor
        self.codeBackgroundColor = codeBackgroundColor
        self.underlineLinks = underlineLinks
    }

    public func renderAsNSAttributedString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        for block in portableText {
            let blockString = NSMutableAttributedString()
            let font = fontMap[block.style] ?? normalFont
            for child in block.children {
                let attributed = applyStyles(to: child, markDefs: block.markDefs, baseFont: font)
                blockString.append(attributed)
            }
            result.append(blockString)
            result.append(NSAttributedString(string: "\n"))
        }
        return result
    }

    private func applyStyles(to child: PortableTextChild, markDefs: [MarkDef], baseFont: UIFont) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: baseFont
        ]

        var hasLink = false
        var linkURL: URL?

        child.marks?.forEach { mark in
            if mark == "em" {
                attributes[.font] = UIFont.italicSystemFont(ofSize: baseFont.pointSize)
            } else if mark == "strong" {
                attributes[.font] = UIFont.boldSystemFont(ofSize: baseFont.pointSize)
            } else if mark == "underline" {
                attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            } else if mark == "code" {
                attributes[.backgroundColor] = codeBackgroundColor
                attributes[.font] = UIFont(name: "Menlo", size: baseFont.pointSize) ?? baseFont
            } else if let def = markDefs.first(where: { $0.key == mark }), def.type == "link", let href = def.href, let url = URL(string: href) {
                hasLink = true
                linkURL = url
                attributes[.foregroundColor] = linkColor
                if underlineLinks {
                    attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                }
                attributes[.link] = url
            }
        }

        return NSAttributedString(string: child.text ?? "", attributes: attributes)
    }
}
