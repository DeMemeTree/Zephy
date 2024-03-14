////
////  SendView.swift
////  Zephy
////
////
//import SwiftUI
//
//struct SendView: View {
//    @EnvironmentObject var router: Router
//    @StateObject var viewModel = SendViewModel()
//    @State private var showingQRCodeScanner = false
//    @State private var showingPreviewAlert = false
//    @State var isSelfSendEnabled = false
//
//    init() {
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            if let error = viewModel.error {
//                Text(error)
//                    .font(.footnote)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            HStack {
//                Text("Asset")
//                    .foregroundColor(.gray)
//                Spacer()
//                Picker("Asset", selection: $viewModel.selectedAsset) {
//                    ForEach(viewModel.assets, id: \.self) { asset in
//                        Text(asset).tag(asset)
//                    }
//                }
//                .tint(.white)
//                .pickerStyle(MenuPickerStyle())
//                .background(Color.gray.opacity(0.2))
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding()
//            
//            VStack(alignment: .leading) {
//                Text("Available \(viewModel.availableAmount)")
//                    .font(.footnote)
//                    .foregroundColor(.gray)
//                
//                HStack {
//                    TextField("", text: $viewModel.amount)
//                        .frame(height: 50)
//                        .placeholder(when: viewModel.amount.isEmpty) {
//                                Text("Enter amount")
//                                .foregroundColor(Color(uiColor: UIColor.lightGray))
//                        }
//                        .keyboardType(.decimalPad)
//                        .foregroundColor(.white)
//                    
//                    Button("MAX") {
//                        viewModel.useMaxAmount()
//                    }
//                    .foregroundColor(.white)
//                }
//            }
//            .padding()
//            
//            VStack {
//                recipientView()
//                
//                Toggle(isOn: $isSelfSendEnabled) {
//                    Text("Self Send")
//                        .foregroundColor(.gray)
//                }
//                .padding(.horizontal)
//                .onChange(of: isSelfSendEnabled) { newVal in
//                    guard newVal else { return }
//                    SendWrapper.pipe.send(1)
//                }
//            }
//            
//            Divider().background(Color.gray)
//                .padding()
//            
//            Spacer()
//            
//            HStack {
//                Text("Transfer Asset")
//                    .foregroundColor(.gray)
//                Spacer()
//                AssetLogo(assetLogo: viewModel.selectedAsset)
//                Text(viewModel.selectedAsset)
//                    .foregroundColor(.white)
//            }
//            .padding()
//            .padding(.vertical, 0)
//            
//            VStack(alignment: .leading) {
//                Text("Recipient Address")
//                
//                if viewModel.recipientAddress.isEmpty == false {
//                    ScrollView(.horizontal,
//                               showsIndicators: false) {
//                        HStack {
//                            Text(viewModel.recipientAddress)
//                                .lineLimit(1)
//                                .fixedSize(horizontal: false, vertical: true)
//                                .foregroundColor(.white)
//                            
//                            Rectangle()
//                                .frame(width: 15, height: 40)
//                                .foregroundColor(.clear)
//                        }
//                    }
//                    
//                    Text("Scroll horizontally to see more")
//                        .font(.footnote)
//                } else {
//                    Rectangle()
//                        .frame(height: 1)
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(.clear)
//                }
//            }
//            .foregroundColor(.gray)
//            .padding([.leading, .vertical])
//            .padding(.vertical, 0)
//            
//            HStack {
//                Text("Amount")
//                    .foregroundColor(.gray)
//                Spacer()
//                Text(viewModel.amount)
//                    .foregroundColor(.white)
//            }
//            .padding()
//            .padding(.vertical, 0)
//            
//            if let fee = viewModel.currentFeeEstimate {
//                HStack {
//                    Text("Fee Estimate")
//                        .foregroundColor(.gray)
//                    Spacer()
//                    Text(fee.formatHuman())
//                        .foregroundColor(.white)
//                    Text(viewModel.selectedAsset)
//                        .foregroundColor(.white)
//                }
//                .padding()
//                .padding(.vertical, 0)
//            }
//            
//            HStack {
//                Text("Unlock Time")
//                    .foregroundColor(.gray)
//                Spacer()
//                Text("~20m")
//                    .foregroundColor(.white)
//            }
//            .padding()
//            .padding(.vertical, 0)
//
//            
//            Button(action: {
//                closeKeyboard()
//                if viewModel.currentFeeEstimate == nil {
//                    viewModel.makeTransaction()
//                } else {
//                    withAnimation {
//                        showingPreviewAlert = true
//                    }
//                }
//            }) {
//                Text(viewModel.currentFeeEstimate == nil ? "Estimate Fee" : "Confirm")
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.white, lineWidth: 2)
//                    )
//            }
//            .padding()
//        }
//        .keyboardCloseButton()
//        .onAppear {
//            viewModel.updateAvailableAmount()
//        }
//        .onChange(of: viewModel.selectedAsset) { newValue in
//            viewModel.updateAvailableAmount()
//        }
//        .background(Color.zephyPurp)
//        .alert(isPresented: $showingPreviewAlert) {
//            Alert(
//                title: Text("Confirm"),
//                message: Text("Are you sure you transfer \(viewModel.amount) \(viewModel.selectedAsset) to \(viewModel.recipientAddress)? This process is irreversible."),
//                primaryButton: .destructive(Text("Yes"), action: {
//                    viewModel.commitTransaction(router: router)
//                }),
//                secondaryButton: .cancel()
//            )
//        }
//    }
//    
//    private func closeKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//    
//    private func recipientView() -> some View {
//        HStack {
//            TextField("", text: $viewModel.recipientAddress)
//                .frame(height: 50)
//                .placeholder(when: viewModel.recipientAddress.isEmpty) {
//                    Text("Enter recipient address")
//                        .foregroundColor(Color(uiColor: UIColor.lightGray))
//                }
//                .padding(.horizontal, 3)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.white, lineWidth: 1)
//                )
//                .foregroundColor(.white)
//                .padding(.trailing, 4)
//            
//            Button(action: {
//                self.showingQRCodeScanner = true
//            }) {
//                Image(systemName: "qrcode.viewfinder")
//                    .foregroundColor(.white)
//            }
//            .sheet(isPresented: $showingQRCodeScanner) {
//                ZStack {
//                    QRCodeScannerView { result in
//                        switch result {
//                        case .success(let code):
//                            viewModel.recipientAddress = code
//                        case .failure(let error):
//                            print("Scanning failed: \(error.localizedDescription)")
//                        }
//                        showingQRCodeScanner = false
//                    }
//                    
//                    VStack {
//                        HStack {
//                            Button {
//                                showingQRCodeScanner = false
//                            } label: {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                            }
//                            .padding()
//
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                }
//                .edgesIgnoringSafeArea(.bottom)
//            }
//
//        }
//        .padding()
//    }
//}
import SwiftUI

struct SendView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = SendViewModel()
    @State private var showingQRCodeScanner = false
    @State private var showingPreviewAlert = false
    @State private var isSelfSendEnabled = false
    @State private var isConfirmViewVisible = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        VStack {
            if isConfirmViewVisible {
                confirmView
                    .transition(.move(edge: .trailing))
                    .zIndex(2)
            } else {
                mainContentView
                    .zIndex(isConfirmViewVisible ? 0 : 1)
            }
            Spacer()
        }
        .background(Color.zephyPurp)
        .onAppear {
            viewModel.updateAvailableAmount()
        }
        .onChange(of: viewModel.selectedAsset) { newValue in
            viewModel.updateAvailableAmount()
        }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        VStack(spacing: 0) {
            if let error = viewModel.error {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding()
            }
            
            assetPicker
            amountInput
            recipientInput
            selfSendToggle
            
            confirmButton
        }
    }
    
    @ViewBuilder
    private var confirmView: some View {
        VStack {
            HStack {
                Text("Transfer Asset")
                    .foregroundColor(.gray)
                Spacer()
                AssetLogo(assetLogo: viewModel.selectedAsset)
                Text(viewModel.selectedAsset)
                    .foregroundColor(.white)
            }
            .padding()
            
            recipientAddress
            amountDisplay
            feeEstimate
            unlockTime
            
            confirmTransactionButton
        }
    }
    
    @ViewBuilder
    private var assetPicker: some View {
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
    }
    
    @ViewBuilder
    private var amountInput: some View {
        VStack(alignment: .leading) {
            Text("Available \(viewModel.availableAmount)")
                .font(.footnote)
                .foregroundColor(.gray)
            
            HStack {
                TextField("", text: $viewModel.amount)
                    .frame(height: 50)
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
    }
    
    @ViewBuilder
    private var recipientInput: some View {
        recipientView()
    }
    
    @ViewBuilder
    private var selfSendToggle: some View {
        Toggle(isOn: $isSelfSendEnabled) {
            Text("Self Send")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .onChange(of: isSelfSendEnabled) { newVal in
            guard newVal else { return }
            SendWrapper.pipe.send(1)
        }
    }
    
    @ViewBuilder
    private var confirmButton: some View {
        Button(action: {
            guard viewModel.amount.isEmpty == false else { 
                viewModel.error = "Enter amount"
                return }
            
            closeKeyboard()
            
            if viewModel.currentFeeEstimate == nil {
                viewModel.makeTransaction()
            }
            withAnimation {
                isConfirmViewVisible = true
            }
        }) {
            Text("Estimate Fee")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .padding()
    }
    
    @ViewBuilder
    private var recipientAddress: some View {
        VStack(alignment: .leading) {
            Text("Recipient Address")
            
            if viewModel.recipientAddress.isEmpty == false {
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
            } else {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.clear)
            }
        }
        .foregroundColor(.gray)
        .padding([.leading, .vertical])
        .padding(.vertical, 0)
    }
    
    @ViewBuilder
    private var amountDisplay: some View {
        HStack {
            Text("Amount")
                .foregroundColor(.gray)
            Spacer()
            Text(viewModel.amount)
                .foregroundColor(.white)
        }
        .padding()
    }
    
    @ViewBuilder
    private var feeEstimate: some View {
        if let fee = viewModel.currentFeeEstimate {
            HStack {
                Text("Fee Estimate")
                    .foregroundColor(.gray)
                Spacer()
                Text(fee.formatHuman())
                    .foregroundColor(.white)
                Text(viewModel.selectedAsset)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var unlockTime: some View {
        HStack {
            Text("Unlock Time")
                .foregroundColor(.gray)
            Spacer()
            Text("~20m")
                .foregroundColor(.white)
        }
        .padding()
    }
    
    @ViewBuilder
    private var confirmTransactionButton: some View {
        Button(action: {
            viewModel.commitTransaction(router: router)
        }) {
            Text("Confirm Transaction")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .padding()
    }
    
    private func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    private func recipientView() -> some View {
        HStack {
            TextField("", text: $viewModel.recipientAddress)
                .frame(height: 50)
                .placeholder(when: viewModel.recipientAddress.isEmpty) {
                    Text("Enter recipient address")
                        .foregroundColor(Color(uiColor: UIColor.lightGray))
                }
                .padding(.horizontal, 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
                .padding(.trailing, 4)
            
            Button(action: {
                self.showingQRCodeScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                    .foregroundColor(.white)
            }
            .sheet(isPresented: $showingQRCodeScanner) {
                ZStack {
                    QRCodeScannerView { result in
                        switch result {
                        case .success(let code):
                            viewModel.recipientAddress = code
                        case .failure(let error):
                            print("Scanning failed: \(error.localizedDescription)")
                        }
                        showingQRCodeScanner = false
                    }
                    
                    VStack {
                        HStack {
                            Button {
                                showingQRCodeScanner = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .padding()

                            Spacer()
                        }
                        Spacer()
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }

        }
        .padding()
    }
}
