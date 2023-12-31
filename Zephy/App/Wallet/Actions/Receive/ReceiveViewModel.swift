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
    
    init() {
        DispatchQueue.global(qos: .background).async {
            self.load()
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            self.addresses = WalletService.allAddresses()
            
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
    
    func createNewAddress() {
        WalletService.createSubaddress()
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
