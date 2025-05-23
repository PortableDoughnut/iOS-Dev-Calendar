//
//  DateIdentifiable.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import Foundation

extension Date: @retroactive Identifiable {
    public var id: Int {
        Int(timeIntervalSince1970)
    }
}
