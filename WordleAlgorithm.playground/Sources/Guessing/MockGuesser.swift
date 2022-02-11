import Foundation

public class MockGuesser {
    var wordHelper: WordHelper
    var guesserAlgorithm: GuesserAlgorithm
    
    public func runMockWordles(with words: [String], numberOfRuns: Int = 25) {
        // Run through the mock algorithim
        var numberOfGuesses = [Int]()

        for _ in 0..<numberOfRuns {
            numberOfGuesses.append(guessesToFind(word: words.shuffled()[0]))
        }

        // Display results in a historgram
        var histogram = [Int: Int]()

        for number in numberOfGuesses {
            if histogram[number] == nil {
                histogram[number] = numberOfGuesses.filter { $0 == number }.count
            }
        }

        // Printing
        print("\n\nHere's a historgram of the results:")
        
        for key in histogram.keys.sorted() {
            var string = "\(key): "
            for _ in 0..<(histogram[key] ?? 0) {
                string.append("🟧")
            }
            
            string += " \(histogram[key] ?? 0)"
            
            print(string)
        }
    }
    
    private func guessesToFind(word: String) -> Int {
        var possibleWords = WordHelper().getWords().shuffled()
        var pastGuesses = [Guess]()
        
        while true {
            let guess = createGuess(for: guesserAlgorithm.getGuessSuggestion(possibleWords: possibleWords), word: word)
            pastGuesses.append(guess)
            
            // If guess was correct, exit the loop.
            if guess.isCorrect {
                print("\nCorrect guess found in \(pastGuesses.count). The correct word was \(word)!")
                print("Here's the WORDLE chart:")
                
                for guess in pastGuesses {
                    print(guess.stringResult())
                }
                
                break
            }
        
            guesserAlgorithm.filterPossibleWords(basedOn: guess, possibleWords: &possibleWords)
        }
        
        return pastGuesses.count
    }
    
    private func createGuess(for guess: String, word: String) -> Guess {
        var results = [(String.Element, GuessResult)]()
        
        for (index, letter) in guess.enumerated() {
            if word.contains(letter) {
                results.append((letter, .inWord(word.checkLetterIndexMatches(letter: letter, letterParent: guess, index: index))))
            } else {
                results.append((letter, .notInWord))
            }
        }
        
        return Guess(value: guess, results: results)
    }
    
    // MARK: - init
    public init(wordHelper: WordHelper, guesserAlgorithm: GuesserAlgorithm) {
        self.wordHelper = wordHelper
        self.guesserAlgorithm = guesserAlgorithm
    }
}
