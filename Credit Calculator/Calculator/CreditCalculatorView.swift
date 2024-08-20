import SwiftUI

struct CreditCalculatorView: View {
    
    @State var creditSumma = 20000.0
    
    @State var stavka = ""
    @State var stavkaDouble = 0.0
    
    @State var durationOfCreditString = ""
    @State var durationOfCredit = 0
    
    @State var goToResult = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Кредитный\nкалькулятор")
                    .font(.custom("PragmaticaExtended-Bold", size: 48))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 20))
                
                VStack(alignment: .leading) {
                    Text("Сума займа")
                        .font(.custom("PragmaticaExtended-Bold", size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .leading])
                    Text("\(formattedValue(creditSumma)) ₽")
                        .font(.custom("PragmaticaExtended-Bold", size: 34))
                        .foregroundColor(Color(red: 239/255, green: 49/255, blue: 35/255))
                        .multilineTextAlignment(.leading)
                        .padding([.leading])
                    
                    Slider(value: $creditSumma, in: 5000...75000, step: 100)
                        .accentColor(.red)
                        .padding([.horizontal])
                    HStack {
                        Text("5000 ₽")
                            .font(.custom("PragmaticaExtended-Bold", size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .padding([.leading])
                        Spacer()
                        Text("75000 ₽")
                            .font(.custom("PragmaticaExtended-Bold", size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .padding([.leading])
                    }
                    
                    Text("Ставка")
                        .font(.custom("PragmaticaExtended-Bold", size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                    
                    TextField("21.9/год", text: $stavka, onCommit: {
                        if let value = Double(stavka) {
                            stavkaDouble = value
                        } else {
                            stavka = ""
                            stavkaDouble = 0.0
                        }
                    })
                    .foregroundColor(Color.init(red: 165/255, green: 165/255, blue: 165/255))
                    .keyboardType(.decimalPad) // Show the decimal keyboard
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                    )
                    
                    Text("Срок займа")
                        .font(.custom("PragmaticaExtended-Bold", size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                    
                    TextField("365 дней", text: $durationOfCreditString, onCommit: {
                        if let value = Int(durationOfCreditString) {
                            durationOfCredit = value
                        } else {
                            durationOfCreditString = ""
                            durationOfCredit = 0
                        }
                    })
                    .foregroundColor(Color.init(red: 165/255, green: 165/255, blue: 165/255))
                    .keyboardType(.decimalPad) // Show the decimal keyboard
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                    )
                    
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                if let value = Double(stavka) {
                                    stavkaDouble = value
                                }
                                if let value = Int(durationOfCreditString) {
                                    durationOfCredit = value
                                }
                                if !stavka.isEmpty && !durationOfCreditString.isEmpty {
                                    goToResult = true
                                }
                            } label: {
                                Image("calculate_btn")
                            }
                            
                            Text("Кредитный калькулятор не предоставляет\nвозможность получить кредит")
                                .font(.custom("PragmaticaExtended-Bold", size: 10))
                                .foregroundColor(Color.init(red: 214/255, green: 214/255, blue: 214/255))
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                    .padding(.top)
        
                    if goToResult {
                        NavigationLink(destination: CalculatorResultView(credit: creditSumma, stavka: stavkaDouble, duration: durationOfCredit)
                            .navigationBarBackButtonHidden(true), isActive: $goToResult) {
                        }
                    }
                    
                    Spacer()
                }
                .offset(y: 0)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 52.0, style: .continuous)
                        .fill(.white)
                        .frame(minWidth: UIScreen.main.bounds.width,
                               minHeight: UIScreen.main.bounds.height)
                        .offset(y: 135)
                )
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 239/255, green: 49/255, blue: 35/255), Color(red: 181/255, green: 25/255, blue: 13/255)]), startPoint: .top, endPoint: .bottom)
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

func formattedValue(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
}

#Preview {
    CreditCalculatorView()
}
