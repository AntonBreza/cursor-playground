import SwiftUI

struct GridLinesView: View {
    let visibleRange: (xRange: Range<Int>, yRange: Range<Int>)
    let cellSize: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(visibleRange.yRange, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(visibleRange.xRange, id: \.self) { x in
                        Rectangle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
} 