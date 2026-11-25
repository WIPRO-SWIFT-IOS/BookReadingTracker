//
//  BookCoverView.swift
//  BookReadingTracker
//
//  Generated book cover (no image files needed): a coloured gradient with the
//  title and author, plus a matching narrow "spine" used on the shelf view.
//

import SwiftUI

/// Deterministic colour choice so every book always keeps the same cover colour.
enum CoverPalette {

    private static let pairs: [(UInt32, UInt32)] = [
        (0x4B2A8A, 0x8B5CF6),   // violet
        (0x6B1F6B, 0xC026D3),   // plum
        (0x1E3A8A, 0x6366F1),   // indigo
        (0x0F5E63, 0x14B8A6),   // teal
        (0x7F1D3A, 0xE11D74),   // berry
        (0x14532D, 0x22A06B),   // forest
        (0x1E293B, 0x64748B),   // slate
        (0x7C2D12, 0xD97706)    // amber brown
    ]

    static func index(for text: String) -> Int {
        let hash = text.unicodeScalars.reduce(0) { ($0 &* 31 &+ Int($1.value)) % 9973 }
        return hash % pairs.count
    }

    static func gradient(for text: String) -> LinearGradient {
        let pair = pairs[index(for: text)]
        return LinearGradient(
            colors: [Color(UIColor(hex: pair.0)), Color(UIColor(hex: pair.1))],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}

struct BookCoverView: View {
    let book: Book
    var width: CGFloat = 70

    private var height: CGFloat { width * 1.5 }

    var body: some View {
        ZStack(alignment: .topLeading) {
            CoverPalette.gradient(for: book.title)

            VStack(alignment: .leading, spacing: 3) {
                Image(systemName: book.genre.iconName)
                    .font(.system(size: width * 0.18))
                    .opacity(0.85)
                Spacer(minLength: 0)
                Text(book.title)
                    .font(.system(size: width * 0.15, weight: .bold, design: .serif))
                    .lineLimit(4)
                    .minimumScaleFactor(0.6)
                Text(book.author)
                    .font(.system(size: width * 0.1))
                    .lineLimit(1)
                    .opacity(0.85)
            }
            .foregroundStyle(Color.white)
            .padding(width * 0.1)
            .padding(.leading, width * 0.04)

            // Spine highlight on the left edge
            Rectangle()
                .fill(Color.black.opacity(0.18))
                .frame(width: max(width * 0.05, 3))
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: width * 0.07, style: .continuous))
        .shadow(color: Theme.Colors.shadow, radius: 4, x: 0, y: 3)
        .accessibilityHidden(true)
    }
}

struct BookSpineView: View {
    let book: Book

    private var width: CGFloat {
        min(max(CGFloat(book.totalPages) / 14, 30), 48)
    }

    private var height: CGFloat {
        CGFloat(120 + (CoverPalette.index(for: book.author) % 4) * 10)
    }

    var body: some View {
        ZStack {
            CoverPalette.gradient(for: book.title)

            Text(book.title)
                .font(.system(size: 11, weight: .bold, design: .serif))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(width: height - 16, height: width)
                .rotationEffect(.degrees(-90))
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        .shadow(color: Theme.Colors.shadow, radius: 2, x: 1, y: 1)
        .accessibilityLabel("\(book.title) by \(book.author)")
    }
}
