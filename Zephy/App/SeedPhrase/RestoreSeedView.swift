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
    
    @State var selectedView: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    router.changeRoot(to: .splash)
                } label: {
                    Text("Back")
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Picker("Select Asset", selection: $selectedView) {
                Text("Word selection").tag(0)
                Text("Raw Text").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: selectedView) { _ in
                viewModel.selectedWords.removeAll()
                viewModel.rawText = ""
            }
            
            if viewModel.error.isEmpty == false {
                Text(viewModel.error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if selectedView == 0 {
                wordSelection()
            } else {
                rawText()
            }
            
            if hideElements == false {
                VStack(alignment: .leading) {
                    restoreHeight()
                }
                .padding()
                
                passwordView()
                
                Spacer()
                
                restoreButton()
            }
        }
        .keyboardCloseButton()
        .onChange(of: isTextFieldFocused) { focused in
            withAnimation {
                hideElements = focused
            }
        }
    }
    
    @ViewBuilder
    private func rawText() -> some View {
        HStack {
            Text("Seedphrase (words seperated by space)")
                .font(.footnote)
                .padding(.horizontal)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.top)
        
        TextEditor(text: $viewModel.rawText)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private func wordSelection() -> some View {
        VStack(alignment: .leading) {
            Text("Use the search bar below to filter the phrase words")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top)
                .padding(.horizontal)
            
            TextField("", text: $searchText)
                .frame(height: 50)
                .focused($isTextFieldFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .onChange(of: searchText) { newValue in
                    viewModel.searchDebounce.send(newValue)
                }
                .padding(.horizontal)

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select your 25 word seed phrase")
                        .font(.footnote)
                    Text("Tap a word to select")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
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
            .padding(.leading)

            Divider()
                .padding()

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
                .onChange(of: viewModel.selectedWords.count) { newCount in
                    if newCount > 0 {
                        scrollToIndex = newCount - 1
                    }
                }
                .onChange(of: scrollToIndex) { newIndex in
                    if let index = newIndex {
                        withAnimation {
                            scrollViewProxy.scrollTo(index, anchor: .trailing)
                        }
                    }
                }
                .padding()
            }
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
        Text("Restore Height (Should be set to block height 1 block before first wallet use)")
            .font(.footnote)
            .foregroundColor(.gray)
        
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
        .keyboardType(.numberPad)
        .foregroundColor(.white)
        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                .padding(.trailing)
        }
    }
}
