import Foundation

public class GuessModel: ObservableObject {
    @Published var guessMatrix = [Int: [Int: GuessResult]]()
    @Published var currentRow = 0 {
        didSet {
            updateCanContinue()
        }
    }
    @Published var canContinue = false
    @Published var needsReset: Bool = false
    
    @Published var isEditingCustomGuess = false
    @Published var suggestedGuess = "" {
        didSet {
            if isEditingCustomGuess {
                updateCanContinue()
            } else if suggestedGuess == "" {
                needsReset = true
            }
        }
    }
    @Published var possibleWords = [String]()
    
    private var wordHelper: WordHelper
    private var guesserAlgorithm: GuesserAlgorithm
    private var numberOfLetters = 5

    var isComplete: Bool {
        currentRow == 7
    }
    
    // MARK: - Rows
    public func buildMatrix(numberOfLetters: Int) {
        self.numberOfLetters = numberOfLetters
        
        for i in 0...5 {
            var columns = [Int: GuessResult]()
            for ii in 0...(numberOfLetters - 1) {
                columns[ii] = GuessResult.none
            }
            
            guessMatrix[i] = columns
        }
    }
    
    public func updateCanContinue() {
        if suggestedGuess.count != numberOfLetters {
            canContinue = false
            return
        }
            
        if currentRow == 6 {
            needsReset = true
            canContinue = false
        }
        
        canContinue = !getGuessesForCurrentRow().contains(.none)
    }
    
    // MARK: - Guesses
    public func createGuessForCurrentRow(suggestedGuess: String) -> Guess {
        var results = [(String.Element, GuessResult)]()
        for (index, result) in getGuessesForCurrentRow().enumerated() {
            results.append((suggestedGuess[String.Index(utf16Offset: index, in: suggestedGuess)], result))
        }
        
        return Guess(value: suggestedGuess.lowercased(), results: results)
    }
    
    private func getGuessesForCurrentRow() -> [GuessResult] {
        var guessResults = [GuessResult]()
        
        if !isComplete {
            let columns = guessMatrix[currentRow]!
            for i in 0...(numberOfLetters - 1) {
                guessResults.append(columns[i]!)
            }
        } else {
            for _ in 0...(numberOfLetters - 1) {
                guessResults.append(.inWord(true))
            }
        }
        
        return guessResults
    }
    
    // MARK: - UI
    public func updatedSuggestedGuess() {
        suggestedGuess = guesserAlgorithm.getGuessSuggestion(possibleWords: possibleWords)
    }
    
    public func reset() {
        currentRow = 0
        needsReset = false
        
        buildMatrix(numberOfLetters: numberOfLetters)
        possibleWords = wordHelper.getWords(with: numberOfLetters)
        updatedSuggestedGuess()
    }
    
    public func onContinue() {
        if isComplete || needsReset {
            reset()
        } else {
            let guess = createGuessForCurrentRow(suggestedGuess: suggestedGuess)
            guard !guess.isCorrect else {
                currentRow = 7
                suggestedGuess = suggestedGuess + "!"
                
                return
            }
            
            currentRow += 1
            guesserAlgorithm.filterPossibleWords(basedOn: guess, possibleWords: &possibleWords)
            updatedSuggestedGuess()
        }
    }

    // MARK: - init
    public init(guesserAlgorithm: GuesserAlgorithm, wordHelper: WordHelper) {
        self.guesserAlgorithm = guesserAlgorithm
        self.wordHelper = wordHelper
        self.possibleWords = wordHelper.getWords(with: numberOfLetters)
    }
}
