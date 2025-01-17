//
//  LoggingView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI

struct LoggingView: View {
    
    @State private var scale: CGFloat = 1
    @ObservedObject var viewModel: SettingsViewModel
    @State var biometricType: SettingsViewModel.BiometricType
    @ObservedObject var passwordViewModel: PasswordListViewModel
    var body: some View {
       
            VStack {
                VStack {
                Spacer().frame(maxHeight : 120)
                Image(systemName: "key.fill")
                    .foregroundColor(viewModel.colors[viewModel.accentColorIndex])
                    .font(.system(size: 100))
                    .scaleEffect(scale)
                    .animateForever(using: .easeInOut(duration: 1), autoreverses: true, { scale = 0.95 })
                }.padding()
                Spacer()
                Button(action: { if viewModel.biometricAuthentication() { passwordViewModel.getAllKeys() }}, label: {
                    Label(
                        title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Entrer le mot mot de passe") },
                        icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
                    )
                }).foregroundColor(.white).padding().background(viewModel.colors[viewModel.accentColorIndex]).cornerRadius(15)
                
                Spacer().frame(maxHeight : 30)
            
        } .onAppear(perform: {
            //set biometric type for device
            biometricType = viewModel.biometricType()
            })
    }
}

extension View {
    func animateForever(using animation: Animation = Animation.easeInOut(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}

struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView(viewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.touch, passwordViewModel: PasswordListViewModel())
    }
}
