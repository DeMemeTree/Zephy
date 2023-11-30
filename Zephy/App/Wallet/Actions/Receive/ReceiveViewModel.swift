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
    @Published var addresses: [String] = []
    
    @Published var qrCodeImage: UIImage? = nil
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    init() {
        loadAddresses()
    }
    
    func loadAddresses() {
        self.addresses = ["Example Address 1", "Example Address 2"]
        self.selectedAddress = addresses.first ?? ""
    }
    
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
