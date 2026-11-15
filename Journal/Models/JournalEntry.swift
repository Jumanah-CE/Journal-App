//
//  JournalEntry.swift
//  Journal
//
//  Created by JumanahAlqarni on 12/11/2026.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {

    var title: String
    var content: String
    var dateCreated: Date
    var isBookmarked: Bool

    init(
        title: String,
        content: String,
        dateCreated: Date = .now,
        isBookmarked: Bool = false
    ) {
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
        self.isBookmarked = isBookmarked
    }
}

