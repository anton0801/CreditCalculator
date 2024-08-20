import SwiftUI

struct CreditsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selection: Int
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \CreditRecord.credit, ascending: true)],
            animation: .linear
        ) private var creditRecords: FetchedResults<CreditRecord>
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Список займов")
                        .font(.custom("PragmaticaExtended-Bold", size: 32))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 20))
                    
                    VStack() {
                        ScrollView(showsIndicators: false) {
                            ForEach(creditRecords) { record in
                                NavigationLink(destination: CalculatorPaymentsListView(montlyPayment: record.monthlyPayment, montlyPayments: calculateMonthlyPayments(stavka: record.stavka, duration: Int(record.durationInDays), credit: record.credit))) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Сумма займа:")
                                                .font(.custom("PragmaticaExtended-Book", size: 14))
                                                .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                            Spacer()
                                            Text(String(format: "%.2f% ₽", record.credit))
                                                .font(.custom("PragmaticaExtended-Bold", size: 18))
                                                .foregroundColor(Color(red: 229/255, green: 45/255, blue: 31/255))
                                        }
                                        .padding([.horizontal, .top])
                                        HStack {
                                            Text("Стоимость займа:")
                                                .font(.custom("PragmaticaExtended-Book", size: 14))
                                                .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                            Spacer()
                                            Text(String(format: "%.2f% ₽", record.overpayment))
                                                .font(.custom("PragmaticaExtended-Bold", size: 18))
                                                .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                        }
                                        .padding([.horizontal, .top])
                                        HStack {
                                            Text("Процентная\nставка:")
                                                .font(.custom("PragmaticaExtended-Book", size: 14))
                                                .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Text(String(format: "%.2f%%/год", record.stavka))
                                                .font(.custom("PragmaticaExtended-Bold", size: 18))
                                                .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                        }
                                        .padding([.horizontal, .top])
                                        
                                        HStack {
                                            VStack {
                                                Text("Займ от:")
                                                    .font(.custom("PragmaticaExtended-Book", size: 14))
                                                    .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                                    .multilineTextAlignment(.leading)
                                                Text(formatDate(record.date ?? Date()))
                                                    .font(.custom("PragmaticaExtended-Bold", size: 19))
                                                    .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Дата возврата:")
                                                    .font(.custom("PragmaticaExtended-Book", size: 14))
                                                    .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                                    .multilineTextAlignment(.leading)
                                                Text(addDaysToDate(record.date ?? Date(), days: Int(record.durationInDays)))
                                                    .font(.custom("PragmaticaExtended-Bold", size: 19))
                                                    .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                                            }
                                        }
                                        .padding([.horizontal, .top])
                                    }
                                    .frame(width: 320, height: 235)
                                    .background(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                                            
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .stroke(Color.init(red: 226/255, green: 226/255, blue: 226/255), lineWidth: 1)
                                        }
                                    )
                                }
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
                            .offset(y: 135)
                    )
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            selection = 1
                        } label: {
                            Image("fab")
                        }
                    }
                    .padding(.horizontal)
                }
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
    
    func calculateMonthlyPayments(stavka: Double, duration: Int, credit: Double) -> [MonthlyPayment] {
        let overpayment = calculateOverpayment(stavka, duration, credit)
        
        let annualInterestRate = stavka / 100
        let monthlyInterestRate = annualInterestRate / 12
        let durationInYears = Double(duration) / 365.0
        let numberOfPayments = Int(durationInYears * 12)  // Переводим годы в месяцы
        
        let monthlyPayment = credit * (monthlyInterestRate * pow(1 + monthlyInterestRate, Double(numberOfPayments))) / (pow(1 + monthlyInterestRate, Double(numberOfPayments)) - 1)
        
        var payments: [MonthlyPayment] = []
        var totalPaid = 0.0
        
        for _ in 0..<numberOfPayments {
            totalPaid += monthlyPayment
            payments.append(MonthlyPayment(amountPaid: totalPaid, remainingBalance: credit + overpayment))
        }
        
        return payments
    }
    
    func calculateOverpayment(_ stavka: Double, _ duration: Int, _ credit: Double) -> Double {
        let annualInterestRate = stavka / 100
        let monthlyInterestRate = annualInterestRate / 12
        let durationInYears = Double(duration) / 365.0
        let numberOfPayments = Int(durationInYears * 12)  // Переводим годы в месяцы
        
        // Аннуитетный платеж
        let monthlyPayment = credit * (monthlyInterestRate * pow(1 + monthlyInterestRate, Double(numberOfPayments))) / (pow(1 + monthlyInterestRate, Double(numberOfPayments)) - 1)
        
        // Общая сумма всех платежей за весь срок кредита
        let totalPayment = monthlyPayment * Double(numberOfPayments)
        
        // Переплата за весь период кредита
        let overpayment = totalPayment - credit
        
        return overpayment
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

    func addDaysToDate(_ date: Date, days: Int) -> String {
        var dateComponent = DateComponents()
        dateComponent.day = days
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: dateComponent, to: date) {
            return formatDate(newDate)
        }
        return "Ошибка"
    }
    
}

#Preview {
    CreditsListView(selection: .constant(1))
}
