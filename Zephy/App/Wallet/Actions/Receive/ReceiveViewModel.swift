//
//  ReceiveViewModel.swift
//  Zephy
//
//
import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins
import ZephySDK

class ReceiveViewModel: ObservableObject {
    @Published var selectedAddress: String = ""
    @Published var addresses: [(String, String)] = []
    @Published var qrCodeImage: UIImage? = nil
    
    let walletCountKey = "walletCountKey"
    
    init() {
        DispatchQueue.global(qos: .background).async {
            self.load()
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            self.addresses = WalletService.allAddresses()
            
            let found = UserDefaults.standard.integer(forKey: self.walletCountKey)
            if self.addresses.count < found {
                let amount = found - self.addresses.count
                (0..<amount).forEach { _ in
                    self.createNewAddress(save: false)
                }
            }

            if let last = self.addresses.last {
                self.selectedAddress = last.0
            }
        }
    }
    
    func address(label: String) -> String? {
        var retval: String? = nil
        for item in addresses {
            if item.0 == label {
                retval = item.1
            }
        }
        return retval
    }
    
    func createNewAddress(save: Bool = true) {
        WalletService.createSubaddress()
        if save {
            UserDefaults.standard.setValue(subaddrress_size(),
                                           forKey: walletCountKey)
        }
        load()
        if let last = self.addresses.last {
            self.selectedAddress = last.0
        }
    }
    
    func generateQRCode() {
        guard let foundAccount = address(label: selectedAddress) else { return }
        let data = Data(foundAccount.utf8)
        DispatchQueue.global(qos: .background).async {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            filter.setValue(data, forKey: "inputMessage")

            if let qrCodeCIImage = filter.outputImage {
                if let qrCodeCGImage = context.createCGImage(qrCodeCIImage, from: qrCodeCIImage.extent) {
                    DispatchQueue.main.async {
                        self.qrCodeImage = UIImage(cgImage: qrCodeCGImage)
                    }
                }
            }
        }
    }
    
    func copyAddressToClipboard() {
        UIPasteboard.general.string = address(label: selectedAddress)
    }
}
