//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var isHomeGame: Bool
    var team: String
    var id: Int
    var date: Date
    var opponent: String
    var scoreOp: Int
    var scoreUNC: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                HStack {
                    Text(item.team + " vs " + item.opponent).font(.headline)
                    Spacer(minLength: 0)
                }
                HStack {
                    Text("\(item.date)")
                    Spacer()
                    Text(item.isHomeGame ? "Home" : "Away")
                }
            }
        }
        .navigationTitle("UNC Basketball")
        .task {
            await loadData()
        }
    }
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print( "Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(Response.self, from: data) {
                self.results = decodedData.results
            }
        } catch {
            print("Invalid data")
        }
    }
}
    

#Preview {
    ContentView()
}
