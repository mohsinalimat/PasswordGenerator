//
//  SettingsView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI
import KeychainSwift

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsViewModel
    @State var biometricType: SettingsViewModel.BiometricType
    let keychain = KeychainSwift()
    @State private var removePasswordAlert = false
    @State private var bgColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sécurité")) {
                        
                        if settings.biometricType() != .none {
                            Toggle(isOn: $settings.faceIdToggle, label: {
                                Label(
                                    title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("") },
                                    icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "") }
                                )
                            }).toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                            
                            .onChange(of: settings.faceIdToggle, perform: { _ in
                                
                                if settings.faceIdToggle {
                                    settings.addBiometricAuthentication()
                                    print("Waiting for auth")
                                }
                                
                                if !settings.faceIdToggle {
                                    settings.turnOffBiometricAuthentication()
                                }
                                
                            })
                        }
                    }
                    Section(header: Text("Personalisation")) {
                        Picker(selection: $settings.accentColorIndex, label: Label(
                            title: { Text("Couleur principale") },
                            icon: { Image(systemName: "eyedropper.halffull") }
                        )             , content: {
                            
                            List {
                                Label(
                                    title: { Text("Vert") },
                                    icon: { Image(systemName: "circle.fill")
                                        .foregroundColor(settings.colors[0])
                                        
                                    }).tag(0)
                                
                                Label(
                                    title: { Text("Bleu") },
                                    icon: { Image(systemName: "circle.fill")
                                        .foregroundColor(settings.colors[1])
                                        
                                    }).tag(1)
                                
                                Label(
                                    title: { Text("Rouge") },
                                    icon: { Image(systemName: "circle.fill")
                                        .foregroundColor(settings.colors[2])
                                        
                                    }).tag(2)
                                
                                Label(
                                    title: { Text("Rose") },
                                    icon: { Image(systemName: "circle.fill")
                                        .foregroundColor(settings.colors[3])
                                        
                                    }).tag(3)
                                
                                Label(
                                    title: { Text("Violet") },
                                    icon: { Image(systemName: "circle.fill")
                                        .foregroundColor(settings.colors[4])
                                        
                                    }).tag(4)
                                
                                Label(
                                    title: { Text("Jaune") },
                                    icon: { Image(systemName: "circle.fill")
                                        .foregroundColor(settings.colors[5])
                                        
                                    }).tag(5)
                            }
                            
                        })
                        
                        Picker(selection: settings.$appAppearance, label: Label(
                            title: { HStack {
                                Text("Mode nuit")
                                
                            } },
                                icon: {
                                    
                                    if settings.appAppearance == "Auto" {
                                        Image(systemName: "moon.circle")
                                    }
                                    if settings.appAppearance == "Nuit" {
                                        Image(systemName: "moon.fill")
                                    }
                                    if settings.appAppearance == "Jour" {
                                    Image(systemName: "sun.min")
                                    }
                                    
                                }
                        ), content: {
                            Text("Automatique").tag("Auto")
                            Text("Nuit").tag("Nuit")
                            Text("Jour").tag("Jour")
                        }).pickerStyle(MenuPickerStyle()).onChange(of: settings.appAppearance, perform: { value in
                            if settings.appAppearance == "Nuit" {
                                settings.appAppearanceToggle = true
                            } else if settings.appAppearance == "Jour" {
                                settings.appAppearanceToggle = false
                            }
                        })
                        
                    }
                    Label(
                        title: { Text("Noter l'application") },
                        icon: { Image(systemName: "star.fill") })
                    
                    Section(header: Text("Section 3")) {
                        Button(action: { removePasswordAlert.toggle() }, label: {
                            Text("Effacer tous les mots de passes").foregroundColor(.red)
                        }).buttonStyle(PlainButtonStyle())
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0 beta 1").foregroundColor(.gray)
                    }
                }
                
            }
            
            .alert(isPresented: $removePasswordAlert, content: {
                Alert(title: Text("Effacer TOUS les mots de passes"), message: Text("Vos mots de passes seront supprimés de manière définitive. Cette action est irreversible."), primaryButton: .cancel(), secondaryButton: .destructive(Text("TOUT supprimer"), action: {
                    keychain.clear()
                }))
            })
            
            .onAppear(perform: {
                //set biometric type for device
                biometricType = settings.biometricType()
            })
            
            
            
            .navigationBarTitle("Préférences")
        }.accentColor(settings.colors[settings.accentColorIndex])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face)
    }
}
