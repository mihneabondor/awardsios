//
//  addNewAwardsView.swift
//  Awards
//
//  Created by Mihnea on 6/27/22.
//

import SwiftUI
import UIKit
import Foundation
import WidgetKit


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

var award = [Award]()
var model = ViewModel()
struct addNewAwardsView: View {
    @State private var stepperCount : Int = 1
    @FocusState private var isTextFieldFocused: Bool
    @State private var awardSelection : String = "Select"
    @State private var awardImage : Data = (UIImage(named: "awardMissing")?.pngData())!
    
    @State private var awards = [Award]()
    
    @State private var fetched : Bool = false
    
    @Environment(\.presentationMode) private var presentationMode
    
    var example : [Int] = [1,2,3,4,5]
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ZStack{
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4, alignment: .center)
                        .cornerRadius(20)
                        .padding()
                    VStack{
                        if UIScreen.main.bounds.width <= 380 {
                            Image(uiImage: (UIImage(data: awardImage) ?? UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.height/6, alignment: .center)
                                .fixedSize()
                        } else {
                            Image(uiImage: (UIImage(data: awardImage) ?? UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width/2.8, height: UIScreen.main.bounds.height/6, alignment: .center)
                                .fixedSize()
                        }
                        
                        ZStack{
                            Rectangle()
                                .fill(Color(UIColor.systemGray2))
                                .frame(width: 75, height: 25, alignment: .center)
                                .cornerRadius(30)
                            Text("x\(stepperCount)").bold()
                        }
                    }
                }.padding(.top)
                
                HStack{
                    Text(" ")
                    Text("Count:")
                    TextField("Count", value: $stepperCount, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                        .focused($isTextFieldFocused)
                    Spacer()
                    Stepper("", value: $stepperCount, in: 1...1000)
                        .disabled(isTextFieldFocused)
                    Text(" ")
                }
                
                HStack {
                    Text(" ")
                    Text("Select an award")
                    Spacer()
                    if dbMonthly.isEmpty || dbCompetitions.isEmpty || dbLimited.isEmpty || dbClose.isEmpty {
                        ProgressView().padding([.trailing, .leading])
                    }
                    else {
                        Menu(awardImage.count > 20 ? awardSelection : "Select") {
                            Menu("Close Your Rings") {
                                ForEach(dbClose, id:\.self) {item in
                                    if item.collection == "closeYourRings" {
                                        Button(item.name) {
                                            awardSelection = item.name
                                            awardImage = item.image
                                        }
                                    }
                                }
                                
                                Menu("Move Goals") {
                                    ForEach(dbClose, id:\.self) {item in
                                        if item.collection == "moveGoals" {
                                            Button(item.name) {
                                                awardSelection = item.name
                                                awardImage = item.image
                                            }
                                        }
                                    }
                                }
                                
                                Menu("Perfect Week") {
                                    ForEach(dbClose, id:\.self) {item in
                                        if item.collection == "perfectWeek" {
                                            Button(item.name) {
                                                awardSelection = item.name
                                                awardImage = item.image
                                            }
                                        }
                                    }
                                }
                                
                                
                            }
                            Menu("Limited Edition Awards") {
                                ForEach(dbLimited, id:\.self) {item in
                                    if item.collection == "limited" {
                                        Button(item.name) {
                                            awardSelection = item.name
                                            awardImage = item.image
                                        }
                                    }
                                }
                            }
                            Menu("Monthly Challenges") {
                                Menu("2022"){
                                    ForEach(dbMonthly, id: \.self) {item in
                                        if item.collection == "monthly" && item.orderNo <= 8 {
                                            Button(item.name) {
                                                awardSelection = item.name
                                                awardImage = item.image
                                            }
                                        }
                                    }
                                    Menu("More") {
                                        ForEach(dbMonthly, id: \.self) {item in
                                            if item.collection == "monthly" && item.orderNo > 8 {
                                                Button(item.name) {
                                                    awardSelection = item.name
                                                    awardImage = item.image
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Menu("Competitions") {
                                ForEach(dbCompetitions, id:\.self) {item in
                                    if item.collection == "competitions" {
                                        Button(item.name) {
                                            awardSelection = item.name
                                            awardImage = item.image
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text(" ")
                }
                Button("Submit"){
                    do {
                        let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.awards.saved")
                        if savedData != nil {
                            let decoder = JSONDecoder()
                            award = try decoder.decode([Award].self, from: savedData!)
                        }
                    } catch {
                        print("lasa")
                    }
                    
                    if(award.contains(where: {$0.image == awardImage})) {
                        do {
                            award[award.firstIndex(where: {$0.image == awardImage})!].count += stepperCount
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(award)
                            UserDefaults.init(suiteName: "group.mihnea.Awards")!.set(data, forKey: "mihnea.awards.saved")
                        } catch {
                            print("lasama")
                        }
                    } else {
                        do {
                            award.append(Award(name: awardSelection, image: awardImage, count: stepperCount))
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(award)
                            UserDefaults.init(suiteName: "group.mihnea.Awards")!.set(data, forKey: "mihnea.awards.saved")
                        } catch {
                            print("lasama")
                        }
                    }
                    print(award.count)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mihnea.awards.reloadData"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mihnea.awards.noAwards"), object: nil)
                    
                    self.presentationMode.wrappedValue.dismiss()
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .disabled(awardSelection == "Select" || awardImage.count < 20)
                .buttonStyle(.borderedProminent)
                Spacer()
                    .onAppear() {
                        print(dbMonthly.count)
                        print(dbCompetitions.count)
                        print(dbLimited.count)
                        print(dbClose.count)
                        
                        dbCompetitions.sort(by: {$0.orderNo > $1.orderNo})
                        dbMonthly.sort(by: {$0.orderNo > $1.orderNo})
                        dbLimited.sort(by: {$0.orderNo > $1.orderNo})
                        dbClose.sort(by: {$0.orderNo > $1.orderNo})
                        
                        do {
                            let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.awards.saved")
                            guard savedData != nil else { return}
                            let decoder = JSONDecoder()
                            awards = try decoder.decode([Award].self, from: savedData!)
                        } catch {
                            print("lasa")
                        }
                        print(awards.count)
                    }
            }
        }
    }
}
