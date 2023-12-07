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

                if viewModel.addresses.count > 0 {
                    Picker("Select or Create Address", selection: $viewModel.selectedAddress) {
                        ForEach(0..<viewModel.addresses.count,
                                id: \.self) { index in
                            Text(viewModel.addresses[index].0)
                                .tag(viewModel.addresses[index].0)
                        }
                    }
                    .tint(Color.white)
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                
                if let addy = viewModel.address(label: viewModel.selectedAddress) {
                    Text("Scroll horizontally to see more")
                        .font(.footnote)
                    
                    ScrollView(.horizontal,
                               showsIndicators: false) {
                        HStack {
                            Rectangle()
                                .frame(width: 25, height: 40)
                                .foregroundColor(.clear)
                            
                            Text(addy)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.white)
                            
                            Rectangle()
                                .frame(width: 25, height: 40)
                                .foregroundColor(.clear)
                        }
                    }
                }
                
                VStack(alignment: .center) {
                    if let qrCodeImage = viewModel.qrCodeImage {
                        Image(uiImage: qrCodeImage)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
//                            .contextMenu {
//                                Button(action: {
//                                    // Save or share the QR code
//                                }) {
//                                    Text("Save QR Code")
//                                    Image(systemName: "square.and.arrow.down")
//                                }
//                            }
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
            .onAppear {
                viewModel.load()
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
