import Foundation
import PlaygroundSupport

let wordHelper = WordHelper()
let guesserAlgorithm = GuesserAlgorithm(wordHelper: wordHelper)
let fiveLetterWords = wordHelper.getWords()
let runMockWordles = true

if runMockWordles {
    MockGuesser(wordHelper: wordHelper, guesserAlgorithm: guesserAlgorithm).runMockWordles(with: fiveLetterWords)
} else {
    PlaygroundPage.current.setLiveView(GuessInterface(guesserAlgorithm: guesserAlgorithm, wordHelper: wordHelper))
}

PlaygroundPage.current.needsIndefiniteExecution = true
