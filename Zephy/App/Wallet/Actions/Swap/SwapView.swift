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
            VStack {
                if viewModel.error.isEmpty == false {
                    Text(viewModel.error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }
                
                HStack {
                    Text("From Asset")
                        .foregroundColor(.gray)
                    Spacer()
                    Picker("Asset", selection: $viewModel.fromAsset) {
                        ForEach(viewModel.assets, id: \.self) { asset in
                            Text(asset).tag(asset)
                        }
                    }
                    .tint(.white)
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Available \(viewModel.availableAmount)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("Enter amount", text: $viewModel.fromAmount)
                            .keyboardType(.decimalPad)
                        
//                        Button("MAX") {
//                            viewModel.useMaxAmount()
//                        }
                    }
                }
                .padding()
                
                HStack {
                    Text("To Asset")
                        .foregroundColor(.gray)
                    Spacer()
                    Picker("Asset", selection: $viewModel.toAsset) {
                        ForEach(viewModel.assets, id: \.self) { asset in
                            Text(asset).tag(asset)
                        }
                    }
                    .tint(.white)
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                
                Spacer()

                VStack {
//                    HStack {
//                        Text("Conversion Rate (Moving Average)")
//                        Spacer()
//                        Text(viewModel.conversionRate)
//                    }
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        Text(viewModel.fromAmount)
                    }
                    
                    HStack {
                        Text("Converting From")
                        Spacer()
                        AssetLogo(assetLogo: viewModel.fromAsset)
                        Text(viewModel.fromAsset)
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("Converting To")
                        Spacer()
                        AssetLogo(assetLogo: viewModel.toAsset)
                        Text(viewModel.toAsset)
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("Unlock Time")
                        Spacer()
                        Text("~20m")
                    }
                    .padding(.vertical, 10)
                }
                .padding()
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    withAnimation {
                        showingPreviewAlert = true
                    }
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
            .onChange(of: viewModel.toAsset) { _ in
                viewModel.recalcSwapAssets()
            }
            .onChange(of: viewModel.fromAsset) { _ in
                viewModel.recalcSwapAssets()
            }
            .tint(.white)
            .background(Color.zephyPurp)
            .navigationTitle("Swap Asset")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: {
                router.changeRoot(to: .wallet)
            }))
            .alert(isPresented: $showingPreviewAlert) {
                Alert(
                    title: Text("Confirm"),
                    message: Text("Are you sure you swap from \(viewModel.fromAmount) \(viewModel.fromAsset) to \(viewModel.toAsset)? This process is irreversible."),
                    primaryButton: .destructive(Text("Yes"), action: {
                        viewModel.makeSwap(router: router)
                    }),
                    secondaryButton: .cancel()
                )
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            }
        }
    }
}
