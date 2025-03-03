//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [GameResult]
}

struct GameResult: Codable, Identifiable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [GameResult]()
    
    var body: some View {
        NavigationStack {
            List(results, id: \.id) { item in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(item.team) vs \(item.opponent)")
                            .font(.headline)
                        Spacer()
                        Text("\(item.score.unc) - \(item.score.opponent)")
                    }
                    .font(.headline)
                    HStack {
                        Text("\(item.date)")
                        Spacer()
                        Text(item.isHomeGame ? "Home" : "Away")
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedData.results
            } else if let decoded = try? JSONDecoder().decode([GameResult].self, from: data) {
                results = decoded
            }
        } catch {
            print("Invalid data")
        }
    }
}
    
#Preview {
    ContentView()
}
