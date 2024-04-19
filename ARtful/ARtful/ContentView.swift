//
//  ContentView.swift
//  ARtful
//
//  Created by Zerowave on 4/13/24.
//

import SwiftUI

let customFontName = "OpenSansCondensed-SemiBold"

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    @State private var currentPage: Int = 0
    @State private var heartAmount: Int = 3
    @State private var wordToGuess: String = ""
    @State private var isWin: Bool = false;
    
    var body: some View {
        switch currentPage {
        case 1:
            HomeScreen(changePage: $currentPage)
            
        case 2:
            PromptScreen(changePage: $currentPage, wordToGuess: $wordToGuess,
                         colors: [
                                    [255, 32, 78],      // Light Red
                                    [160, 21, 62],      // Darker Red
                                    [93, 14, 65],       // Dark Red
                                    [0, 34, 77]         // Blueish
                                ],
                         team: "Sketcher", task: "",  nextView: 3)
            
        case 3:
            PromptScreen(changePage: $currentPage, wordToGuess: $wordToGuess,
                         colors: [
                                    [82, 211, 216],     // Light Blue
                                    [56, 135, 190],     // Darker Blue
                                    [56, 65, 157],      // Dark Blue
                                    [32, 14, 58]        // Purple
                                ],
                         team: "Guesser", task: "Guess the chosen word. Make sure the sketcher is ready, align your phone, and hit 'Next' to start. You have 60 seconds—go!", nextView: 4)
            
        case 4:
            GameScreen(changePage: $currentPage, heartAmount: $heartAmount, wordToGuess: $wordToGuess, isWin: $isWin)
            
        case 5:
            GameDoneScreen(changePage: $currentPage, isWin: $isWin)
                .onAppear(){
                    wordToGuess = ""
                }
            
        case 6:
            SettingsScreen(changePage: $currentPage, heartAmount: $heartAmount)
            
        case 7:
            HelpScreen(changePage: $currentPage)
            
        default:
            OpeningScreen(changePage: $currentPage)
        }
    }
}

func getRandomWord(from wordPool: [[String]], forMode mode: Int) -> String {
    guard mode >= 0, mode < wordPool.count else {
        return "Invalid mode"
    }

    let wordsForMode = wordPool[mode]
    return wordsForMode.randomElement() ?? "No word found"
}

struct OpeningScreen: View {
    @Binding var changePage: Int

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Image("ZEROWAVED")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    changePage = 1
                }
            }
        }
    }
}

struct OpeningScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpeningScreen(changePage: .constant(0))
    }
}

struct HomeScreen: View {
    @Binding var changePage: Int
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Image("Background_MainMenu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack{
                
                HStack {
                    Button(action: {changePage = 7})
                    {Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(22.5)
                            .padding(20)
                    }
                    
                    Spacer()
                    
                    Button(action: {changePage = 6})
                    {Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .frame(width: 45, height: 45)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(22.5)
                            .padding(20)
                    }
                }
                
                VStack(spacing: 30) {
                 
                 Text("ARtful")
                 .font(.custom(customFontName, size: 100))
                 .multilineTextAlignment(.center)
                 .frame(width: 300, height: 250)
                 .foregroundStyle(
                 LinearGradient(
                 gradient: Gradient(colors: [Color.blue, Color.red, Color.purple]),
                 startPoint: .leading,
                 endPoint: .trailing)
                 )
                 .opacity(textOpacity)
                     .animation(.easeInOut(duration: 2), value: textOpacity)
                     .onAppear {
                         textOpacity = 1
                     }
                     .padding(.horizontal, 20)

                Spacer()
                    
                Button(action: {
                    changePage = 2
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 100))
                            .cornerRadius(100)
                            
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(changePage: .constant(0))
    }
}

struct PromptScreen: View {
    @Binding var changePage: Int
    @Binding var wordToGuess: String
    
    @State private var randomWords: [String] = []
    @State private var fontSize: CGFloat = 1.0
    @State private var textColor: Color = .white
    @State private var rotationAngle: Double = -0.4
    
    var wordPool: [[String]] = [
        ["Apple", "Heart", "Bowtie", "Fish", "Golf", "Moon", "Star", "Face"],
        ["Flower", "Banana", "Hexagon", "Ice Cream", "Mug"],
        ["Eye", "Lamp", "Glasses", "Initials"]
    ]
    
    var colors: [[Int]]
    var team: String
    var task: String
    var nextView: Int
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: colors.map { Color(red: Double($0[0]) / 255.0, green: Double($0[1]) / 255.0, blue: Double($0[2]) / 255.0) }),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                Text("You are the \(team)")
                    .font(.custom(customFontName, size: 40))
                    .foregroundColor(.white)
                    .padding()
                
                if(changePage == 3) {
                    Text(task)
                        .font(.custom(customFontName, size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
    
                }
                
                if(changePage == 2){
                    Text("Select a Word to Illustrate:")
                        .font(.custom(customFontName, size: 25))
                        .foregroundColor(.white)
                    ForEach(randomWords, id: \.self) { randomWord in
                        Button(action: {
                            wordToGuess = randomWord
                            changePage += 1

                        }) {
                        Text(randomWord)
                            .padding(35)
                            .font(.custom(customFontName, size: 30 * fontSize))
                            .foregroundColor(textColor)
                            .rotationEffect(.degrees(rotationAngle))
                            .onAppear {
                                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                                    fontSize = 1.1
                                }
                                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                                    textColor = .teal
                                }
                                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                                    rotationAngle = 0.8
                                }
                            }
                        }
                            
                    }
                }
                if(changePage == 3){
                    Button(action: {
                        changePage = nextView
                    }) {
                        Text("Next")
                            .font(.custom(customFontName, size: 30))
                            .frame(width: 160, height: 60)
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(Color(red: Double(colors[3][0]) / 255.0, green: Double(colors[3][1]) / 255.0, blue: Double(colors[3][2]) / 255.0))
                    }
                }
                
                Spacer()
                
            }
        }
        .onAppear {
            if randomWords.isEmpty {
                randomWords = wordPool.compactMap { $0.randomElement() }
            }
        }
        .onDisappear(){
            randomWords = []
        }
    }
}



struct GameScreen: View {
    @Binding var changePage: Int
    @Binding var heartAmount: Int
    @Binding var wordToGuess: String
    @Binding var isWin: Bool

    @State private var remainingHearts: Int
    @State private var guessWordArray: [Character]
    @State private var currentGuess: String = ""
    @State private var timeRemaining = 60
    @State private var timer: Timer?

    init(changePage: Binding<Int>, heartAmount: Binding<Int>, wordToGuess: Binding<String>, isWin: Binding<Bool>) {
        self._changePage = changePage
        self._heartAmount = heartAmount
        self._wordToGuess = wordToGuess
        self._isWin = isWin
        _remainingHearts = State(initialValue: heartAmount.wrappedValue)
        _guessWordArray = State(initialValue: Array(repeating: "_", count: wordToGuess.wrappedValue.count))
    }

    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<remainingHearts, id: \.self) { _ in
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .padding(5)
                }
                
                Spacer()
                
                Text("\(timeString(from: timeRemaining))")
                    .padding(5)
                    .font(.custom(customFontName, size: 20))
    
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
                }
            }
            
            Text(guessWordArray.map { String($0) }.joined(separator: "   "))
                .font(.custom(customFontName, size: 35))
                .padding()
            
            ARViewContainer()
            
            Spacer()
            
            TextField("Enter your guess", text: $currentGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .font(.custom(customFontName, size: 15))
                .autocapitalization(.none)
                .onChange(of: currentGuess) {
                    if currentGuess.count > wordToGuess.count {
                        currentGuess = String(currentGuess.prefix(wordToGuess.count))
                    }
                }

            Button(action: {
                if currentGuess.count != wordToGuess.count {
                    return
                }

                if currentGuess.lowercased() == wordToGuess.lowercased() {
                    isWin = true;
                    changePage += 1
                } else {
                    remainingHearts -= 1
                    if remainingHearts == 0 {
                        isWin = false
                        changePage += 1
                    }
                }
                currentGuess = ""
                UIApplication.shared.endEditing()
            }) {
                Text("Guess")
                    .font(.custom(customFontName, size: 25))
            }
        }
        .padding()
    }
    
    func timeString(from totalSeconds: Int) -> String {
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }

        func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    isWin = false
                    stopTimer()
                    changePage += 1
                }
                if timeRemaining == 30 {
                    displayLetter(wordToGuess: wordToGuess)
                }
                if timeRemaining == 15 {
                    displayLetter(wordToGuess: wordToGuess)
                }
            }
        }

        func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
        
    func displayLetter(wordToGuess: String) {
        let wordCount = wordToGuess.count
        guard wordCount > 0 else { return }

        var randomIndex = Int.random(in: 0..<wordCount)

        let wordArray = Array(wordToGuess)

        while guessWordArray[randomIndex] != "_" {
            randomIndex = Int.random(in: 0..<wordCount)
        }
        guessWordArray[randomIndex] = wordArray[randomIndex]
    }
}

struct GameDoneScreen: View {
    @Binding var changePage: Int
    @Binding var isWin: Bool
    
    var body: some View {
        ZStack {
            gradient
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(isWin ? "You Won!" : "You Lost!")
                    .font(.custom(customFontName, size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                Button(action: {
                    changePage = 1
                }) {
                    Text("Home")
                        .font(.custom(customFontName, size: 25))
                        .frame(width: 160, height: 60)
                        .background(.white)
                        .cornerRadius(10)
                        .foregroundColor(Color(red: 19/255, green: 93/255, blue: 102/255))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(gradient) // You can also apply the gradient to this VStack if you prefer
        }
    }
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 227/255, green: 254/255, blue: 247/255),
                Color(red: 119/255, green: 176/255, blue: 170/255),
                Color(red: 19/255, green: 93/255, blue: 102/255),
                Color(red: 0/255, green: 60/255, blue: 67/255)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct HelpScreen: View {
    @Binding var changePage: Int
    @State private var boxopacity = 0.0
    @State private var textOpacity1 = 0.0
    @State private var textOpacity2 = 0.0
    @State private var textOpacity3 = 0.0
    @State private var textOpacity4 = 0.0

    var body: some View {

        ZStack(){
            Image("Background_MainMenu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            ZStack(){
                Rectangle()
                    .fill(Color.black.opacity(0.95))
                    .frame(width: 300, height: 600)
                    .cornerRadius(12)
                    .opacity(boxopacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            boxopacity = 0.95
                        }
                        withAnimation(.easeIn(duration: 0.8).delay(1.5)){
                            textOpacity1 = 1.0
                        }
                        withAnimation(.easeIn(duration: 1.5).delay(1.75)){
                            textOpacity2 = 1.0
                        }
                        withAnimation(.easeIn(duration: 1.75).delay(2.0)){
                            textOpacity3 = 1.0
                        }
                        withAnimation(.easeIn(duration: 2.0).delay(2.25)){
                            textOpacity4 = 1.0
                        }
                }
                VStack {
                    Text("How To Play")
                        .font(.custom(customFontName, size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(textOpacity1)
                        .padding(.top, 10)  // Adjust padding to position text from the top edge of the box
                        .frame(width: 300, alignment: .top) // Ensure text is aligned to the top of the box
                    Spacer() // Pushes the text to the top
                }
                .frame(width: 300, height: 600) // Match the dimensions of the rectangle for alignment

                VStack(alignment: .leading, spacing: 20) {
                    Text("1. Select a person to draw a random object.")
                        .font(.custom(customFontName, size: 30))
                        .foregroundColor(.white)
                        .opacity(textOpacity2)
                        .padding(.bottom, 10)

                    Text("2. Drawer select object they want to draw, hidden from guesser")
                        .font(.custom(customFontName, size: 30))
                        .foregroundColor(.white)
                        .opacity(textOpacity3)
                        .padding(.bottom, 10)

                    Text("3. Start drawing and guess the drawing")
                        .font(.custom(customFontName, size: 30))
                        .foregroundColor(.white)
                        .opacity(textOpacity4)
                }
                .frame(width: 280, height: 580)
                .padding(.top, 10)

                Button(action: {
                    changePage = 1
                }) {
                    ZStack {
                        Image(systemName: "arrow.left.circle.fill")
                            .position(x: 50, y: 50)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }

            }

        }
    }
}

struct SettingsScreen: View {
    @Binding var changePage: Int
    @Binding var heartAmount: Int
    @State private var boxOpacity = 0.0
    @State private var textOpacity = 0.0
    @State private var heartsOpacity = 0.0

    var body: some View {
        ZStack {
            Image("Background_MainMenu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                changePage = 1
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .position(x: 25, y: 10)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 50)
            .padding(.leading, 20)
            .alignmentGuide(.top) { d in d[.top] }
            .alignmentGuide(.leading) { d in d[.leading] }

            VStack {
                Spacer()

                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.95))
                        .frame(width: 300, height: 600)
                        .cornerRadius(12)
                        .opacity(boxOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.5)) {
                                boxOpacity = 0.95
                                textOpacity = 1.0
                                heartsOpacity = 1.0
                            }
                        }

                    VStack(spacing: 20) {
                        Text("Settings")
                            .font(.custom(customFontName, size: 40))
                            .foregroundColor(.white)
                            .opacity(textOpacity)
                            .padding(.top, 20)

                        HStack {
                            Text("Lives:")
                                .font(.custom(customFontName, size: 20))
                                .foregroundColor(.white)
                                .opacity(textOpacity)

                            HStack(spacing: 10) {
                                ForEach(0..<heartAmount, id: \.self) { _ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                        .opacity(heartsOpacity)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 10)

                        HStack {
                            Button(action: {
                                if heartAmount > 1 { heartAmount -= 1 }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }

                            Button(action: {
                                if heartAmount < 5 { heartAmount += 1 }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                        }
                        .opacity(textOpacity)

                        Spacer()
                    }
                    .frame(width: 280, height: 580)
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
