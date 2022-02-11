import Foundation

public enum GuessResult: Hashable {
    case notInWord
    
    /// If `true` word is in correct position
    case inWord(Bool)
    
    case none
    
    public var emojiValue: String {
        switch self {
        case .notInWord:
            return "⬜️"
        case .inWord(let inCorrectPosition):
            return inCorrectPosition ? "🟩" : "🟨"
        case .none:
            return "⏹"
        }
    }
    
    public mutating func increase() {
        switch self {
        case .notInWord:
            self = .inWord(false)
        case .inWord(let inCorrectSpot):
            if inCorrectSpot {
                self = .notInWord
            } else {
                self = .inWord(true)
            }
        case .none:
            self = .notInWord
        }
    }
}

public struct Guess {
    public let value: String
    public let results: [(String.Element, GuessResult)]
    public var isCorrect: Bool {
        var isCorrect = true
        
        results.forEach {
            if case .notInWord = $0.1 {
                isCorrect = false
            } else if case .inWord(let isInCorrectPosition) = $0.1, !isInCorrectPosition {
                isCorrect = false
            }
        }
        
        return isCorrect
    }
    
    public func stringResult() -> String {
        var string = ""
        
        for result in results {
            string.append(result.1.emojiValue)
        }
        
        return string + " \(value)"
    }
}
