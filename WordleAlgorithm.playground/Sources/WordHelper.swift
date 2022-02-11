import Foundation

public class WordHelper {
    private var words: [String] = []
    private var mostCommonWords: [String] = []
    
    // MARK: - Public Methods
    public func getWords(with numberOfLetters: Int = 5) -> [String] {
        return words.filter { $0.count == numberOfLetters}
    }
    
    public func getMostCommonWords(with numberOfLetters: Int = 5) -> [String] {
        return mostCommonWords.filter { $0.count == numberOfLetters}
    }
   
    // MARK: - Data
    private func loadWords() {
        // Clear the previous list
        words.removeAll()
        
        // Find the list of words file
        guard let filePath = Bundle.main.path(forResource: "words_dictionary", ofType: "json") else {
            return
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        // Unwrap the file data
        if let data = try? Data(contentsOf: fileURL) {
            // Parse to dictionary
            guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            
            for word in dictionary {
                words.append(word.key)
            }
        }
    }
    
    private func loadMostCommonWords() {
        mostCommonWords.removeAll()
        
        // Find the list of words file
        guard let filePath = Bundle.main.path(forResource: "most_common_words", ofType: "txt") else {
            return
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        // Unwrap the file data
        if let data = try? String.init(contentsOf: fileURL) {
            for word in data.split(separator: "\n") {
                mostCommonWords.append(String(word))
            }
        }
    }
    
    // MARK: - Init
    public init() {
        loadWords()
        loadMostCommonWords()
    }
}
