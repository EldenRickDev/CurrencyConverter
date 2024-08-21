//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Ricardo Andrés Gatica Collarte on 21-08-24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                Text("Currency Converter")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                TextField("Amount", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack(spacing: 10) {
                    // Picker para la divisa de origen
                    Picker("From", selection: $viewModel.fromCurrency) {
                        ForEach(viewModel.allCurrencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)  // Ajuste de ancho fijo para el Picker
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Botón de intercambio
                    Button(action: {
                        // Intercambia las divisas seleccionadas
                        let temp = viewModel.fromCurrency
                        viewModel.fromCurrency = viewModel.toCurrency
                        viewModel.toCurrency = temp
                    }) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.title2)
                            .padding()
                            .background(Color(.systemGray4))
                            .cornerRadius(10)
                    }
                    
                    // Picker para la divisa de destino
                    Picker("To", selection: $viewModel.toCurrency) {
                        ForEach(viewModel.allCurrencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)  // Ajuste de ancho fijo para el Picker
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.convertCurrency()
                }) {
                    Text("Convert")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                Text("Converted Value: \(viewModel.convertedValue)")
                    .font(.title2)
                    .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("ConvertWise 🧠")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


