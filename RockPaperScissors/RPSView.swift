//
//  RPSView.swift
//  RockPaperScissors
//
//  Created by Pranav Kasetti on 06/04/2021.
//

import SwiftUI

struct RPSView: View {

  let moves = ["Rock", "Paper", "Scissors"]

  @State var currentChoice = "Rock"
  @State var userMove = ""
  @State var shouldWin = false
  @State var showingAlert = false
  @State var userScore: Int

  func askMove() {
    currentChoice = moves[Int.random(in: 0..<3)]
    shouldWin = Bool.random()
  }

  func correctMove(_ move: String) -> String {
    guard let index = moves.firstIndex(of: currentChoice) else {
      return "INVALID"
    }
    if shouldWin {
      let next = moves.index(after: index) % moves.count
      return moves[next]
    } else {
      let previous = (moves.index(before: index) + moves.count) % moves.count
      return moves[previous]
    }
  }

  func choseCorrectMove(_ move: String) -> Bool {
    return move == correctMove(move)
  }

  private func createAlert(forMove move: String) -> Alert {
    let didWin = choseCorrectMove(move)
    let title = Text(didWin ? "Correct" : "Incorrect")
    let message = Text("The correct answer is: \(correctMove(move))")
    let dismissButton = Alert.Button.default(Text("Dismiss")) {
      showingAlert = false
      askMove()
    }
    return Alert(title: title, message: message, dismissButton: dismissButton)
  }

  var body: some View {
    LazyVStack {
      Text(currentChoice)
        .font(.largeTitle)
        .padding()
        .foregroundColor(.white)
      Spacer()
      Text(shouldWin ? "WIN" : "LOSE")
        .font(.largeTitle)
        .padding()
        .foregroundColor(.white)
      Spacer()
      LazyHStack {
        ForEach(moves, id: \.self) { move in
          Button.init(action: {
            let didWin = choseCorrectMove(move)
            userScore += didWin ? 1 : 0
            showingAlert = true
            userMove = move
          }, label: {
            Text(move)
              .font(.title)
              .padding()
          })
        }
        .alert(isPresented: $showingAlert, content: {
          return createAlert(forMove: userMove)
        })
      }
      .frame(maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
      .background(Color.white)
      .border(Color.black, width: 5)
      Spacer()
      Text("Your score: \(userScore)")
        .font(.title)
        .foregroundColor(.white)
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .edgesIgnoringSafeArea(.all)
    .background(RadialGradient(gradient: Gradient(colors: [Color.red, Color.blue, Color.green]), center: .center, startRadius: 5, endRadius: 500))
  }
}

struct RPSView_Previews: PreviewProvider {
  static var previews: some View {
    RPSView(userScore: 0).edgesIgnoringSafeArea(.all)
  }
}
