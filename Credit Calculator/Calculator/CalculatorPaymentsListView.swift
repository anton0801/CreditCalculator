import SwiftUI

struct CalculatorPaymentsListView: View {
    
    @Environment(\.presentationMode) var backmode
    
    var montlyPayment: Double
    var montlyPayments: [MonthlyPayment]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    backmode.wrappedValue.dismiss()
                } label: {
                    Image("back")
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Ежемесячный платеж:")
                .font(.custom("PragmaticaExtended-Bold", size: 22))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 20))
            Text(String(format: "%.2f% ₽", montlyPayment))
                .font(.custom("PragmaticaExtended-Bold", size: 32))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            VStack {
                ScrollView {
                    ForEach(montlyPayments.indices, id: \.self) { index in
                        let payment = montlyPayments[index]
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(red: 229/255, green: 45/255, blue: 31/255))
                                    .frame(width: 50, height: 50)
                                Text("\(index + 1)")
                                    .font(.custom("PragmaticaExtended-Bold", size: 20))
                                    .foregroundColor(.white)
                            }
                            VStack {
                                HStack {
                                    Text(String(format: "%.0f% ₽", payment.amountPaid))
                                        .font(.custom("PragmaticaExtended-Book", size: 15))
                                        .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.0f% ₽", payment.remainingBalance))
                                        .font(.custom("PragmaticaExtended-Book", size: 15))
                                        .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                }
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                        .fill(Color.init(red: 216/255, green: 216/255, blue: 216/255))
                                        .frame(height: 5)
                                    
                                    RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                        .fill(Color(red: 229/255, green: 45/255, blue: 31/255))
                                        .frame(width: 230 * (payment.amountPaid / payment.remainingBalance), height: 5)
                                }
                            }
                            .padding(.horizontal, 2)
                            Spacer()
                        }
                        .frame(width: 300, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                                .frame(width: 300, height: 50)
                        )
                    }
                }
                
                Spacer()
            }
            .offset(y: 30)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 52.0, style: .continuous)
                    .fill(.white)
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .offset(y: 140)
            )
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 239/255, green: 49/255, blue: 35/255), Color(red: 181/255, green: 25/255, blue: 13/255)]), startPoint: .top, endPoint: .bottom)
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
            .ignoresSafeArea()
        )
    }
}

#Preview {
    CalculatorPaymentsListView(montlyPayment: 2421, montlyPayments: [MonthlyPayment(amountPaid: 5324, remainingBalance: 24554)])
}
