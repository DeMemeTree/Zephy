//
//  SendView.swift
//  Zephy
//
//
import SwiftUI

struct SendView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = SendViewModel()
    @State private var showingQRCodeScanner = false
    @State private var showingPreviewAlert = false

    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Asset")
                        .foregroundColor(.gray)
                    Spacer()
                    Picker("Asset", selection: $viewModel.selectedAsset) {
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
                
                HStack {
                    TextField("", text: $viewModel.recipientAddress)
                        .placeholder(when: viewModel.recipientAddress.isEmpty) {
                                Text("Enter recipient address")
                                .foregroundColor(Color(uiColor: UIColor.lightGray))
                        }
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        self.showingQRCodeScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingQRCodeScanner) {
                        QRCodeScannerView { result in
                            switch result {
                            case .success(let code):
                                viewModel.recipientAddress = code
                            case .failure(let error):
                                print("Scanning failed: \(error.localizedDescription)")
                            }
                            showingQRCodeScanner = false
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }

                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Available \(viewModel.availableAmount)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("", text: $viewModel.amount)
                            .placeholder(when: viewModel.amount.isEmpty) {
                                    Text("Enter amount")
                                    .foregroundColor(Color(uiColor: UIColor.lightGray))
                            }
                            .keyboardType(.decimalPad)
                            .foregroundColor(.white)
                        
                        Button("MAX") {
                            viewModel.useMaxAmount()
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding()
                
                Divider().background(Color.gray)
                    .padding()
                
                Spacer()
                
                HStack {
                    Text("Transfer Asset")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.selectedAsset)
                        .foregroundColor(.white)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Recipient Address")
                        
                    ScrollView(.horizontal,
                               showsIndicators: false) {
                        HStack {
                            Text(viewModel.recipientAddress)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.white)
                            
                            Rectangle()
                                .frame(width: 15, height: 40)
                                .foregroundColor(.clear)
                        }
                    }
                    
                    Text("Scroll horizontally to see more")
                        .font(.footnote)
                }
                .foregroundColor(.gray)
                .padding([.leading, .vertical])
                
                HStack {
                    Text("Amount")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.amount)
                        .foregroundColor(.white)
                }
                .padding()
                
                HStack {
                    Text("Unlock Time")
                    Spacer()
                    Text("~20m")
                        .foregroundColor(.white)
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
            }
            .background(Color.zephyPurp)
            .navigationTitle("Transfer Asset")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: {
                router.changeRoot(to: .wallet)
            }))
            .alert(isPresented: $showingPreviewAlert) {
                Alert(
                    title: Text("Confirm"),
                    message: Text("Are you sure you transfer \(viewModel.amount) \(viewModel.selectedAsset) to \(viewModel.recipientAddress)? This process is irreversible."),
                    primaryButton: .destructive(Text("Yes"), action: {
                        viewModel.makeTransaction(router: router)
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
