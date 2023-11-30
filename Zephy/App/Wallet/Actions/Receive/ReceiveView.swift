//
//  ReceiveView.swift
//  Zephy
//
//
import SwiftUI

struct ReceiveView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = ReceiveViewModel()
    @State private var showToastMessage: String? = nil

    var body: some View {
        NavigationStack {
            VStack {
                Text("Receive")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Picker("Select or Create Address", selection: $viewModel.selectedAddress) {
                    ForEach(viewModel.addresses, id: \.self) { address in
                        Text(address).tag(address)
                    }
                }
                .tint(Color.white)
                .pickerStyle(MenuPickerStyle())
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
                VStack(alignment: .center) {
                    Text("Address (\(viewModel.selectedAddress))")
                        .foregroundColor(.white)
                        .lineLimit(8)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                    
                    if let qrCodeImage = viewModel.qrCodeImage {
                        Image(uiImage: qrCodeImage)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .contextMenu {
                                Button(action: {
                                    // Save or share the QR code
                                }) {
                                    Text("Save QR Code")
                                    Image(systemName: "square.and.arrow.down")
                                }
                            }
                    }
                    
                    Spacer()
                    
                    if let toastMessage = showToastMessage {
                        Toast(message: toastMessage)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .zIndex(1)
                    }

                    HStack {
                        Button {
                            viewModel.generateQRCode()
                        } label: {
                            Text("Show QR")
                                .foregroundColor(.white)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.copyAddressToClipboard()
                            withAnimation {
                                showToastMessage = "Address copied!"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showToastMessage = nil
                                }
                            }
                        } label: {
                            Text("Copy")
                                .foregroundColor(.white)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(Color.zephyPurp.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.createNewAddress()
                        withAnimation {
                            showToastMessage = "Created new address!"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showToastMessage = nil
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }

                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        router.changeRoot(to: .wallet)
                    }
                }
            }
        }
    }
}
