//
//  SettingsView.swift
//  Awards
//
//  Created by Mihnea on 7/7/22.
//

import SwiftUI
import OneSignal
import WidgetKit

struct SettingsView: View {
    @State private var userPrefs = UserPrefs()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("notifications")) {
                    Toggle("Limited Edition Challenges", isOn: $userPrefs.limitedEditToggle).onChange(of: userPrefs.limitedEditToggle) { newValue in
                        saveUserPrefs()
                        if newValue == false {
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            
                        } else {
                            OneSignal.disablePush(false)
                        }
                        
                    }
                }
                Section(header: Text("support")) {
                    Button("Contact") {
                        if let url = URL(string: "mailto:mihnea.bondor@gmail.com") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                print("Cannot open URL")
                            }
                        }
                    }.foregroundColor(.white)
                    Button("Website") {
                        if let url = URL(string: "https://mihneabondor.github.io/awardsapp") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                print("Cannot open URL")
                            }
                        }
                    }.foregroundColor(.white)
                    Button("Request award") {
                        if let url = URL(string: "mailto:mihnea.bondor@gmail.com") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                print("Cannot open URL")
                            }
                        }
                    }.foregroundColor(.white)
                }
                Button("Remove data") {
                    do {
                        let awards = [Award]()
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(awards)
                        UserDefaults.init(suiteName: "group.mihnea.Awards")!.set(data, forKey: "mihnea.awards.saved")
                    } catch {
                        print("\(LocalizedError.self)")
                    }
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "mihnea.awards.reloadData"), object: nil, userInfo: nil)
                    self.presentationMode.wrappedValue.dismiss()
                    WidgetCenter.shared.reloadAllTimelines()
                }.foregroundColor(.red)
                
                Section(header: Text("Support the app"), footer: Text("For Awards to continue to be free of charge, it continously relies on your support to fund its development. If you find it useful, please consider supporting the app.")) {
                    Button("Buy me a coffee ☕️") {
                        if let url = URL(string: "https://www.buymeacoffee.com/mihneabondor") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                print("Cannot open URL")
                            }
                        }
                    }.foregroundColor(.white)
                }
            }
            
            .listStyle(.grouped)
            Text("Awards • V1.0.B12").font(.footnote).foregroundColor(.secondary)
            Text("All awards are copyrighted Apple Inc. property").font(.footnote).foregroundColor(.secondary).padding(.bottom)
        }.padding(.top)
            .onAppear() {
                do {
                    if let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.users.preferences") {
                        let decoder = JSONDecoder()
                        userPrefs = try decoder.decode(UserPrefs.self, from: savedData)
                    }
                }
                catch {print("lasa")}
            }
    }
    
    func saveUserPrefs() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userPrefs)
            UserDefaults.init(suiteName: "group.mihnea.Awards")!.set(data, forKey: "mihnea.users.preferences")
        } catch {
            print("\(LocalizedError.self)")
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
