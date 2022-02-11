import Foundation

extension String {
    func checkLetterIndexMatches(letter: String.Element, letterParent: String, index: Int) -> Bool {
        return self[String.Index(utf16Offset: index, in: letterParent)] == letter
    }
    
    func checkLetterIsNotAtIndex(letter: String.Element, letterParent: String, index: Int) -> Bool {
        guard self.contains(letter) else {
            return false
        }
        
        return !checkLetterIndexMatches(letter: letter, letterParent: letterParent, index: index)
    }
    
    func hasDuplicateLetters() -> Bool {
        var letters = [String.Element]()
        
        for letter in self {
            if letters.contains(letter) {
                return true
            } else {
                letters.append(letter)
            }
        }
        
        return false
    }
}
