import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .foregroundStyle(i <= rating ? .yellow : .secondary)
                    .font(.title3)
                    .onTapGesture {
                        rating = (rating == i) ? 0 : i
                    }
            }
        }
    }
}
