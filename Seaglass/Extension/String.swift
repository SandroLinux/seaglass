//
// Seaglass, a native macOS Matrix client
// Copyright © 2018, Neil Alexander
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import AppKit

extension String {
    func toAttributedStringFromHTML(justify: NSTextAlignment) -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let str: NSMutableAttributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                                     .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            let range = NSRange(location: 0, length: str.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = justify
            
            str.beginEditing()
            str.removeAttribute(.paragraphStyle, range: range)
            
            str.enumerateAttributes(in: range, options: [], using: { attr, attrRange, _ in
                if let font = attr[.font] as? NSFont {
                    if font.familyName == "Times" {
                        let newFont = NSFontManager.shared.convert(font, toFamily: NSFont.systemFont(ofSize: NSFont.systemFontSize).familyName!)
                        str.addAttribute(.font, value: newFont, range: attrRange)
                    }
                }
            })
            
            str.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            str.endEditing()
            
            return str
        } catch {
            return NSAttributedString()
        }
    }
}