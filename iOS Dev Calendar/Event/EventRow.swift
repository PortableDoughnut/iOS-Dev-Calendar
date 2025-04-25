//
//  EventRow.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI
import Foundation

struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 3)
                .fill(event.color)
                .frame(width: 6, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                Text(event.range)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }
}
