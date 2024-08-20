import SwiftUI

struct ContentView: View {
    
    @State var selection = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                FirstDataView(selection: $selection)
                    .tabItem {
                        if selection == 0 {
                            Image("rubl_active")
                        } else {
                            Image("rubl")
                        }
                    }
                    .tag(0)
                CreditCalculatorView()
                    .tabItem {
                        if selection == 1 {
                            Image("calculator_active")
                        } else {
                            Image("calculator")
                        }
                    }
                    .tag(1)
                CreditsListView(selection: $selection)
                    .tabItem {
                        if selection == 2 {
                            Image("list_active")
                        } else {
                            Image("list")
                        }
                    }
                    .tag(2)
            }
        }
    }
}

#Preview {
    ContentView()
}
