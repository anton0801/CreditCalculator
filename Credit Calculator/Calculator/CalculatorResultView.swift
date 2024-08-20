import SwiftUI
import Charts
import CoreData

struct MonthlyPayment {
    let amountPaid: Double
    let remainingBalance: Double
}

struct CalculatorResultView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var backmode
    
    var credit: Double
    var stavka: Double
    var duration: Int
    
    private var overpayment: Double {
        get {
            return calculateOverpayment()
        }
    }
    
    private var monltyPayment: Double {
        get {
            return calculateMonthlyPayment()
        }
    }
    
    private var montlyPayments: [MonthlyPayment] {
        get {
            return calculateMonthlyPayments()
        }
    }

    func calculateMonthlyPayment() -> Double {
        let annualInterestRate = stavka / 100
        let monthlyInterestRate = annualInterestRate / 12
        let durationInYears = Double(duration) / 365.0
        let numberOfPayments = Int(durationInYears * 12)  // Переводим годы в месяцы
        
        // Формула аннуитетного платежа
        let monthlyPayment = credit * (monthlyInterestRate * pow(1 + monthlyInterestRate, Double(numberOfPayments))) / (pow(1 + monthlyInterestRate, Double(numberOfPayments)) - 1)
        
        return monthlyPayment
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        backmode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(alignment: .center) {
                    Image("overpay")
                    Text("Переплата")
                        .font(.custom("PragmaticaExtended-Bold", size: 22))
                        .foregroundColor(.white)
                    Spacer()
                    Image("credit")
                    Text("Займ")
                        .font(.custom("PragmaticaExtended-Bold", size: 22))
                        .foregroundColor(.white)
                }
                .padding([.horizontal, .top])
                
                VStack {
                    ZStack {
                        Image("chart_bg")
                        DonutChart(total: credit + overpayment, credit: credit, overpayment: overpayment)
                                      .frame(width: 220, height: 220)
                                      .padding()
                        HStack {
                            Text(String(format: "%.1f%%", (overpayment / (credit + overpayment)) * 100))
                                .font(.custom("PragmaticaExtended-Bold", size: 18))
                                .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                            
                            Text(String(format: "%.1f%%", (credit / (credit + overpayment)) * 100))
                                .font(.custom("PragmaticaExtended-Bold", size: 18))
                                .foregroundColor(Color(red: 229/255, green: 45/255, blue: 31/255))
                        }
                    }
                    
                    HStack {
                        Text("Ежемесячный платеж:")
                            .font(.custom("PragmaticaExtended-Book", size: 16))
                            .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                        Spacer()
                        Text(String(format: "%.2f% ₽", monltyPayment))
                            .font(.custom("PragmaticaExtended-Bold", size: 18))
                            .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                    }
                    .padding([.horizontal, .top])
                    
                    HStack {
                        Text("Переплата по кредиту:")
                            .font(.custom("PragmaticaExtended-Book", size: 16))
                            .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                        Spacer()
                        Text(String(format: "%.2f% ₽", overpayment))
                            .font(.custom("PragmaticaExtended-Bold", size: 18))
                            .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                    }
                    .padding([.horizontal, .top])
                    
                    HStack {
                        Text("Общая выплата:")
                            .font(.custom("PragmaticaExtended-Book", size: 16))
                            .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                        Spacer()
                        Text(String(format: "%.2f% ₽", credit + overpayment))
                            .font(.custom("PragmaticaExtended-Bold", size: 18))
                            .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                    }
                    .padding([.horizontal, .top])
                    
                    NavigationLink(destination: CalculatorPaymentsListView(montlyPayment: monltyPayment, montlyPayments: montlyPayments)
                        .navigationBarBackButtonHidden(true)) {
                        Image("calendar_payments")
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .offset(y: 40)
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
        .onAppear {
            saveData()
        }
    }
    
    func saveData() {
        let newRecord = CreditRecord(context: viewContext)
        newRecord.credit = credit
        newRecord.stavka = stavka
        newRecord.durationInDays = Int32(duration)
        newRecord.overpayment = overpayment
        newRecord.monthlyPayment = monltyPayment
        newRecord.date = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func calculateOverpayment() -> Double {
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
    
    func calculateMonthlyPayments() -> [MonthlyPayment] {
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
    
}

#Preview {
    CalculatorResultView(credit: 55000.0, stavka: 21.9, duration: 365)
}

struct Pie: View {
    @State var slices: [(Double, Color)]
    var body: some View {
        Canvas { context, size in
            // Add these lines to display as Donut
            //Start Donut
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            //End Donut
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            let gapSize = Angle(degrees: 5) // size of the gap between slices in degrees

            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle + Angle(degrees: 5) / 2, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


struct DonutChart: View {
    let total: Double
    let credit: Double
    let overpayment: Double
    
    @State var overpaymentAnimated = 0.0
    @State var creditAnimated = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let lineWidth: CGFloat = 20
            let inset: CGFloat = 4 / size
            
            ZStack {
                // Overpayment Segment
                Circle()
                    .trim(from: 0.0, to: CGFloat(overpaymentAnimated / total) - inset)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .foregroundColor(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .rotationEffect(Angle(degrees: -140))
                
                // Credit Segment
                Circle()
                    .trim(from: CGFloat(overpaymentAnimated / total) + inset, to: 0.98 - inset)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .foregroundColor(Color(red: 229/255, green: 45/255, blue: 31/255))
                    .rotationEffect(Angle(degrees: -140))
            }
        }
        .onAppear() {
            withAnimation {
                overpaymentAnimated = overpayment
                creditAnimated = credit
            }
        }
    }
}
