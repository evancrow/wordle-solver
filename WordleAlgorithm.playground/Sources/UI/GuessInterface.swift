import SwiftUI

public struct GuessInterface: View {
    var numberOfLetters = 5
    
   
    @ObservedObject var model: GuessModel
    
    var subtitle: String {
        if model.isComplete {
            return "Today's Wordle:"
        } else if model.needsReset {
            return "start/reset to begin"
        } else {
            return "Suggested Guess"
        }
    }
   
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(subtitle)
                    .font(.headline)
                
                HStack {
                    if model.isEditingCustomGuess {
                        VStack(spacing: 0) {
                            TextField(text: $model.suggestedGuess, prompt: Text("guess")) {
                                Text(model.suggestedGuess)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }.textCase(.lowercase)
                            
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.secondary)
                        }.padding(.vertical, 8)
                    } else {
                        Text(model.suggestedGuess)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Button {
                        model.suggestedGuess = model.suggestedGuess.lowercased()
                        model.isEditingCustomGuess.toggle()
                    } label: {
                        Image(systemName: model.isEditingCustomGuess ? "checkmark" : "pencil")
                            .font(.body)
                    }.disabled(model.isComplete || model.needsReset)
                }
            }.padding(.vertical)
            
            ForEach(0..<6, id:\.self) { row in
                HStack(spacing: 12) {
                    ForEach(0..<numberOfLetters, id: \.self) { column in
                        LetterSquare(result: (model.guessMatrix[row]?[column]) ?? .none)
                            .onTapGesture {
                                model.guessMatrix[row]?[column]?.increase()
                                model.updateCanContinue()
                            }
                            .disabled(row != model.currentRow)
                    }
                }
            }
            
            Button {
                model.onContinue()
            } label: {
                Text(model.isComplete || model.needsReset ? "Reset" : "Next Suggestion")
                    .font(.subheadline)
                    .padding(.top)
            }.disabled(!model.canContinue && !model.isComplete && !model.needsReset)
            
            Button {
                model.updatedSuggestedGuess()
            } label: {
                Text("Refresh Suggestion")
                    .font(.subheadline)
                    .padding(.bottom)
            }.disabled(model.isComplete || model.needsReset)
        }
        .padding()
        .onAppear {
            model.updatedSuggestedGuess()
        }
    }
    
    public init(numberOfLetters: Int = 5, guesserAlgorithm: GuesserAlgorithm, wordHelper: WordHelper) {
        self.model = GuessModel(guesserAlgorithm: guesserAlgorithm, wordHelper: wordHelper)
        self.model.buildMatrix(numberOfLetters: numberOfLetters)
    }
}

