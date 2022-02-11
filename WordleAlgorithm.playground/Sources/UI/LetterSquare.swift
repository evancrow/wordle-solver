import SwiftUI

struct LetterSquare: View {
    var result: GuessResult
    
    var body: some View {
        Text(result.emojiValue)
            .font(.headline)
    }
}

