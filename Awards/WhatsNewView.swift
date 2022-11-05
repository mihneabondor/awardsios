//
//  WhatsNewView.swift
//  Awards
//
//  Created by Mihnea on 7/3/22.
//

import SwiftUI

struct WhatsNewView: View {
    @Environment(\.presentationMode) private var presentationMode
    var body : some View {
        VStack{
            Text(" ")
            Text("Welcome to")
                .font(.title)
                .bold()
                .padding(.top)
            Text("Awards")
                .font(.title)
                .bold()
                .foregroundColor(.green)
            Spacer()
            HStack {
                Image(systemName: "rectangle.portrait.topleft.inset.filled")
                    .foregroundColor(.accentColor)
                    .font(.title)
                    .padding()
                VStack{
                    Text("Widgets")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Showcase your awards right on the home screen.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding()
            
            HStack {
                Image(systemName: "cloud")
                    .font(.title)
                    .foregroundStyle(.green)
                    .padding()
                VStack{
                    Text("New awards added automatically")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("All awards are added to a database, so new ones come in automatically.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding()
            
            HStack {
                Image(systemName: "app.badge")
                    .symbolRenderingMode(.palette)
                    .font(.title)
                    .foregroundStyle(Color.red, Color.green)
                    .padding()
                VStack{
                    Text("Notifications")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Get notified when a limited edition award is available.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding()
            Spacer()
            Button() {
                UserDefaults.standard.set(true, forKey: "mihnea.firstRun.v1.0.b12")
                presentationMode.self.wrappedValue.dismiss()
            } label: {
                Text("Continue")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width/1.1, height: 50, alignment: .center)
            .background(Color.accentColor)
            .cornerRadius(15)
            Spacer()
        }
    }
    
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
