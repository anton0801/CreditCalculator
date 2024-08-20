import SwiftUI
import UIKit

struct FirstDataView: View {
    
    @Binding var selection: Int
    
    @State var creditSumma = 20000.0
    
    @State var name = ""
    @State var email = ""
    @State var phone = "+7"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Под 0%\nна карту")
                .font(.custom("PragmaticaExtended-Bold", size: 38))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 20))
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Сума займа")
                        .font(.custom("PragmaticaExtended-Bold", size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text("\(formattedValue(creditSumma)) ₽")
                        .font(.custom("PragmaticaExtended-Bold", size: 26))
                        .foregroundColor(Color(red: 239/255, green: 49/255, blue: 35/255))
                        .multilineTextAlignment(.leading)
                }
                .padding([.horizontal, .top])
                
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
                
                Text("Введите свое имя")
                    .font(.custom("PragmaticaExtended-Bold", size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                
                TextField("Введите свое имя", text: $name)
                .foregroundColor(Color.init(red: 165/255, green: 165/255, blue: 165/255))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                )
                
                Text("Введите свой email")
                    .font(.custom("PragmaticaExtended-Bold", size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                
                TextField("Введите свой email", text: $email)
                .foregroundColor(Color.init(red: 165/255, green: 165/255, blue: 165/255))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                )
                
                Text("Введите свой номер телефона")
                    .font(.custom("PragmaticaExtended-Bold", size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                
                PhoneNumberTextField(text: $phone)
                    .foregroundColor(Color.init(red: 165/255, green: 165/255, blue: 165/255))
                    .padding()
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                    )
                
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            if !name.isEmpty && !email.isEmpty && !phone.isEmpty {
                                selection = 1
                            }
                        } label: {
                            Image("calculate_btn")
                        }
                        
//                        Text("Кредитный калькулятор не предоставляет\nвозможность получить кредит")
//                            .font(.custom("PragmaticaExtended-Bold", size: 10))
//                            .foregroundColor(Color.init(red: 214/255, green: 214/255, blue: 214/255))
//                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                .padding(.top)
                
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
}

#Preview {
    FirstDataView(selection: .constant(1))
}


struct PhoneNumberTextField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            let formatter = PhoneNumberFormatter()
            if let formattedText = formatter.formatPhoneNumber(textField.text) {
                textField.text = formattedText
                text = formattedText
            }
        }
    }
}

class PhoneNumberFormatter {
    func formatPhoneNumber(_ phoneNumber: String?) -> String? {
        guard let phoneNumber = phoneNumber else { return nil }
        let digits = phoneNumber.filter { "0123456789".contains($0) }
        var result = ""

        let mask = "+# (###) ###-##-##"
        var index = digits.startIndex

        for ch in mask where index < digits.endIndex {
            if ch == "#" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
