//
//  SwapView.swift
//  Zephy
//
//

import SwiftUI

struct SwapView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = SwapViewModel()
    @State private var showingPreviewAlert = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if let zeph = Color.zephyPurp.cgColor {
            UINavigationBar.appearance().backgroundColor = UIColor(cgColor: zeph)
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("From Asset", selection: $viewModel.fromAsset) {
                        ForEach(viewModel.assets, id: \.self) { asset in
                            Text(asset).tag(asset)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    VStack(alignment: .leading) {
                        Text("Available \(viewModel.availableAmount)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        HStack {
                            TextField("Enter amount", text: $viewModel.fromAmount)
                                .keyboardType(.decimalPad)
                            
                            Button("MAX") {
                                viewModel.useMaxAmount()
                            }
                        }
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    Picker("To Asset", selection: $viewModel.toAsset) {
                        ForEach(viewModel.assets, id: \.self) { asset in
                            Text(asset).tag(asset)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Enter amount", text: $viewModel.toAmount)
                        .keyboardType(.decimalPad)
                }
                .listRowBackground(Color.clear)
                
//                Section {
//                    Picker("To Address", selection: $viewModel.recipientAddress) {
//                        ForEach(viewModel.addresses, id: \.self) { address in
//                            Text(address)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//                .listRowBackground(Color.clear)
                
//                Section {
//                    TextField("Swap to another address", text: $viewModel.recipientAddress)
//                }
//                .listRowBackground(Color.clear)
                
                Section {
                    HStack {
                        Text("Conversion Rate (Moving Average)")
                        Spacer()
                        Text(viewModel.conversionRate)
                    }
                    
                    HStack {
                        Text("Converting From")
                        Spacer()
                        Text(viewModel.fromAsset)
                    }
                    
                    HStack {
                        Text("Converting To")
                        Spacer()
                        Text(viewModel.toAsset)
                    }
                    
                    HStack {
                        Text("Conversion Fee")
                        Spacer()
                        Text("ZSD") // Replace with actual fee logic
                    }
                    
                    HStack {
                        Text("Unlock Time")
                        Spacer()
                        Text(viewModel.unlockTime)
                    }
                }
                .listRowBackground(Color.clear)

                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    withAnimation {
//                        showingPreviewAlert = true
//                    }
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .padding()
                .listRowBackground(Color.clear)
            }
            .tint(.white)
            .listStyle(PlainListStyle())
            .background(Color.zephyPurp)
            .navigationTitle("Swap Asset")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: {
                router.changeRoot(to: .wallet)
            }))
        }
    }
}
