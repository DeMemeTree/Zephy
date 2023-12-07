//
//  ReceiveViewModel.swift
//  Zephy
//
//
import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

class ReceiveViewModel: ObservableObject {
    @Published var selectedAddress: String = ""
    @Published var addresses: [(String, String)] = []
    @Published var qrCodeImage: UIImage? = nil
    
    func load() {
        addresses = WalletService.allAddresses()
        if let first = addresses.first {
            selectedAddress = first.0
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
//        let newAddress = "NewlyGeneratedAddress"
//        //self.addresses.append(newAddress)
//        self.selectedAddress = newAddress
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
