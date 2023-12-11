//
//  RestoreSeedView.swift
//  Zephy
//
//
import Combine
import SwiftUI

struct RestoreSeedView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = RestoreSeedViewModel()
    @State private var searchText: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    @State var searchFocus: Bool = false
    
    @State var hideElements = false
    @State private var scrollToIndex: Int?
    
    var body: some View {
        VStack {
            Text("Enter your 25 word seed phrase...")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top)
            
            if viewModel.error.isEmpty == false {
                Text(viewModel.error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding()
            }
            
            VStack {
                TextField("Search", text: $searchText)
                    .frame(height: 50)
                    .focused($isTextFieldFocused)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.searchDebounce.send(newValue)
                    }

                HStack {
                    Text("Tap a word to select")
                        .font(.footnote)
                        .padding()
                    Spacer()
                }

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.filteredWords, id: \.self) { word in
                            Text(word)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .listRowBackground(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.addWord(word)
                                    searchText = ""
                                }
                        }
                    }
                }
                .padding()

                Divider()

                HStack {
                    VStack(spacing: 0) {
                        Text("Seed phrase word count: (\(viewModel.selectedWords.count))")
                            .font(.footnote)
                            .padding(.horizontal)
                        
                        Text("Tap word to remove from list")
                            .font(.footnote)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }

                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<viewModel.selectedWords.count, id: \.self) { index in
                                Text("\(index + 1). \(viewModel.selectedWords[index])")
                                    .id(index)
                                    .onTapGesture {
                                        viewModel.removeWord(index)
                                    }
                            }
                        }
                    }
                    .onChange(of: viewModel.selectedWords.count) { _, newCount in
                        if newCount > 0 {
                            scrollToIndex = newCount - 1
                        }
                    }
                    .onChange(of: scrollToIndex) { _, newIndex in
                        if let index = newIndex {
                            withAnimation {
                                scrollViewProxy.scrollTo(index, anchor: .trailing)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            if hideElements == false {
                restoreHeight()
                passwordView()
                
                restoreButton()
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        closeKeyboard()
                    }
                }
            }
        }
        .onChange(of: isTextFieldFocused) { _, focused in
            hideElements = focused
        }
    }
    
    private func restoreButton() -> some View {
        Button(action: {
            viewModel.restoreWallet(router: router)
        }) {
            Text("Restore")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .padding()
    }
    
    @ViewBuilder
    private func restoreHeight() -> some View {
        Text("Restore Height (Optional)")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
        
        TextField("", text: Binding(
            get: { self.viewModel.restoreHeight },
            set: { newValue in
                if let _ = UInt(newValue) {
                    self.viewModel.restoreHeight = newValue
                } else if newValue.isEmpty {
                    self.viewModel.restoreHeight = ""
                } else {
                    self.viewModel.restoreHeight = String(self.viewModel.restoreHeight.filter { "0123456789".contains($0) })
                }
            }
        ))
        .foregroundColor(.white)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
    
    private func passwordView() -> some View {
        HStack {
            if viewModel.showPassword {
                TextField("Wallet Password", text: $viewModel.walletPassword)
                    .foregroundColor(.white)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                SecureField("Wallet Password", text: $viewModel.walletPassword)
                    .foregroundColor(.white)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button(viewModel.showPassword ? "HIDE" : "SHOW", action: { viewModel.showPassword.toggle() })
                .padding(.trailing, 10)
        }
    }
    
    private func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
