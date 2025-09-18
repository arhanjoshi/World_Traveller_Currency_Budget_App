//
//  ContentView.swift
//  WorldTraveler
//
//  Created by Arhan Joshi on 9/12/25.
//

import SwiftUI


final class Budget: ObservableObject{
    @Published var totalUSD: Double = 0
    @Published var remainingUSD: Double = 0
    @Published var comingBack: Bool = false
    
    
    func start(amount: Double){
        totalUSD = amount
        remainingUSD = amount
        comingBack = false
        
    }
    
    func spendInEUR(_ eur: Double){
        
        remainingUSD -= eur/0.85
    }
    
    func spendInJPY (_ jpy: Double){
        
        remainingUSD -= jpy/110.0
    }
}
    

    enum Route: Hashable {
        case europe, japan
    }


struct ContentView: View{
    @StateObject var budget = Budget()
    @State var path: [Route] = []
    @State var usdText = ""
    
    var body: some View{
        NavigationStack(path: $path){
            VStack(spacing: 16){
                Text("You are in the USA").font(.largeTitle)
                Text("🇺🇸").font(.system(size:100))
                
                if budget.comingBack {
                    Text("Coming back from a foreign land").foregroundColor(.blue)
                }
                
                HStack{
                    
                    Text("Total Budget (USD): $")
                    TextField("USD", text: $usdText).textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
                }
                
                Button("Go to Europe"){
                    let amount = Double(usdText) ?? 0
                    budget.start(amount: amount)
                    path.append(.europe)
                }
                
                if budget.totalUSD > 0{
                    Text("Remaining funds: $\(budget.remainingUSD, specifier: "%.2f")")
                }
                
                
                
            }
            
            .padding()
            .navigationTitle("World Traveler").navigationBarTitleDisplayMode(.inline).navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Route.self){
                route in if route == .europe{
                    EuropeView(
                        budget: budget,
                        goToJapan: {
                            path.append(.japan)
                        },
                        
                        backToUSA: {
                            budget.comingBack = true
                            path = []
                        }
                    )
                }
                
                else if route == .japan {
                    JapanView(
                        budget: budget,
                        backToEurope: {
                            path.removeLast()
                        },
                        backToUSA: {
                            budget.comingBack = true
                            path = []
                        }
                    )
                        
                }
            }
            
            
        }
    }
}

struct EuropeView: View{
    @StateObject var budget: Budget
    var goToJapan: () -> Void
    var backToUSA: () -> Void
    
    @State var eurText = ""
    
    var body: some View{
        VStack(spacing: 12) {
            Text("You are in EUROPE").font(.largeTitle)
            Text("🇪🇺").font(.system(size: 100))
            Text("A bit more valuable here!").foregroundColor(.green)
            
            HStack{
                Text("Expenditure in euros: €")
                TextField("EUR", text: $eurText).textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
            }
            
            Button("Calculate") {
                let eur = Double(eurText) ?? 0
                budget.spendInEUR(eur)
                eurText = ""
            }
            
            Text("Remaining funds: $\(budget.remainingUSD, specifier: "%.2f")")
            
            HStack{
                Button ("Back to USA"){
                    backToUSA()
                }
                Spacer()
                Button("Next: Japan"){
                    goToJapan()
                }
            }
            .padding()
        }
    }
    
}

struct JapanView: View{
    @StateObject var budget: Budget
    var backToEurope: () -> Void
    var backToUSA: () -> Void
    @State var jpyText = ""
    
    var body: some View{
        VStack(spacing: 12){
            Text("You are in JAPAN").font(.largeTitle)
            Text("🇯🇵").font(.system(size: 100))
            Text("I feel rich!!").foregroundColor(.red)
            HStack{
                Text("Expenditure in yen: ¥")
                TextField("JPY", text: $jpyText).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
            }
            Button("Calculate"){
                let jpy = Double(jpyText) ?? 0
                budget.spendInJPY(jpy)
                jpyText = ""
            }
            
            Text("Remaining funds: $\(budget.remainingUSD, specifier: "%.2f")")
            
            HStack{
                Button("Back to Europe"){
                    backToEurope()
                }
                Spacer()
                Button ("Back to USA"){
                    backToUSA()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
