import Foundation

public class GuesserAlgorithm {
    var wordHelper: WordHelper
    
    public func filterPossibleWords(basedOn guesses: [Guess], possibleWords: inout [String]) {
        var filteredPossibleWords = possibleWords
        for guess in guesses {
            filterPossibleWords(basedOn: guess, possibleWords: &filteredPossibleWords)
        }
        
        possibleWords = filteredPossibleWords
    }
    
    public func filterPossibleWords(basedOn guess: Guess, possibleWords: inout [String]) {
        var filteredPossibleWords = possibleWords
        
        for (index, result) in guess.results.enumerated() {
            switch result.1 {
            case .notInWord:
                // Remove all words that contain the letter.
                filteredPossibleWords = filteredPossibleWords.filter { !$0.contains(result.0) }
            case .inWord(let inCorrectPosition):
                if inCorrectPosition {
                    // Remove all words that do not have the letter in the correct spot.
                    filteredPossibleWords = filteredPossibleWords.filter {
                        $0.checkLetterIndexMatches(letter: result.0, letterParent: guess.value, index: index)
                    }
                } else {
                    // Remove all words that do not have the the letter or it's in a spot we know it's not.
                    filteredPossibleWords = filteredPossibleWords.filter {
                        $0.checkLetterIsNotAtIndex(letter: result.0, letterParent: guess.value, index: index)
                    }
                }
            default:
                break
            }
        }
        
        possibleWords = filteredPossibleWords
    }
    
    public func getGuessSuggestion(possibleWords: [String]) -> String {
        guard possibleWords.count > 0 else {
            return ""
        }
        
        var rankedWords = [String: Int]()
        let possibleWords = possibleWords.shuffled()
       
        for i in 0...min(5000, possibleWords.count - 1) {
            let word = possibleWords[i]
            var ranking = rankWord(word: word)
            if wordHelper.getMostCommonWords().contains(word) {
                ranking += 6
            }
            
            rankedWords[word] = ranking
        }
        
        let sortedArray = rankedWords.sorted { $0.value > $1.value }
        
        return sortedArray.first!.key
    }
    
    private func rankWord(word: String) -> Int {
        var rank: Double = 0
        let numberOfVowels = word.filter {
            $0 == "a" || $0 == "e" || $0 == "i" || $0 == "o" || $0 == "u" || $0 == "y"
        }
        
        let commonLetters = word.filter {
            $0 == "h" || $0 == "n" || $0 == "r" || $0 == "s" || $0 == "t"
        }
        
        let outlierLetters = word.filter {
            $0 == "x" || $0 == "z" || $0 == "1" || $0 == "j" || $0 == "v" || $0 == "k"
        }
        
        if word.hasDuplicateLetters() {
            rank -= Double(7)
        }
        
        rank += Double(numberOfVowels.count) * 1.5
        rank += Double(commonLetters.count + 2)
        rank -= Double(outlierLetters.count - 1)
        
        return Int(rank)
    }
    
    // MARK: - Init
    public init(wordHelper: WordHelper) {
        self.wordHelper = wordHelper
    }
}
