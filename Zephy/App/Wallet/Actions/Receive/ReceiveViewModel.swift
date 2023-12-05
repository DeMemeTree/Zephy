//
//  ReceiveViewModel.swift
//  Zephy
//
//
import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

class ReceiveViewModel: ObservableObject {
    @Published var selectedAddress: String = "Example Address 1"
    @Published var addresses: [String] = ["Example Address 1", "Example Address 2"]
    
    @Published var qrCodeImage: UIImage? = nil
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func createNewAddress() {
        let newAddress = "NewlyGeneratedAddress"
        self.addresses.append(newAddress)
        self.selectedAddress = newAddress
    }
    
    func generateQRCode() {
        let data = Data(selectedAddress.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let qrCodeCIImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeCIImage, from: qrCodeCIImage.extent) {
                self.qrCodeImage = UIImage(cgImage: qrCodeCGImage)
            }
        }
    }
    
    func copyAddressToClipboard() {
        UIPasteboard.general.string = selectedAddress
    }
}
