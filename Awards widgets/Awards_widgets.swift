//
//  Awards_widgets.swift
//  Awards widgets
//
//  Created by Mihnea on 6/29/22.
//

import WidgetKit
import SwiftUI
import Intents

struct AwardEntry : TimelineEntry {
    let date = Date()
    let configuration : ConfigurationIntent
    var awards : [Award]
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> AwardEntry {
        return AwardEntry(configuration: ConfigurationIntent(), awards: [])
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AwardEntry) -> ()) {
        return completion(AwardEntry(configuration: configuration, awards: [Award(name: "", image: (UIImage(named: "longMoveStreak")?.pngData())!, count: 47), Award(name: "", image: (UIImage(named: "newMoveRecord")?.pngData())!, count: 8), Award(name: "", image: (UIImage(named: "perfectWeekAllActivity")?.pngData())!, count: 23), Award(name: "", image: (UIImage(named: "moveGoal200")?.pngData())!, count: 3)]))
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var savedAwards = [Award]()
        do {
            let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.awards.saved")
            guard savedData != nil else { return}
            let decoder = JSONDecoder()
            savedAwards = try decoder.decode([Award].self, from: savedData!)
        } catch {
            print("lasa")
        }
        let entry = AwardEntry(configuration: configuration, awards: savedAwards)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct Awards_widgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    @ViewBuilder var body: some View {
        switch widgetFamily {
        case .systemSmall:
            VStack{
                ZStack{
                    Rectangle()
                        .fill(Color(UIColor(named: "WidgetBackgroundColor")!))
                    HStack {
                        if entry.awards.isEmpty {
                            Image("awardMissing")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding()
                        }
                        if entry.awards.count == 1 {
                            Image(uiImage: UIImage(data: entry.awards[0].image)!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding()
                        }
                        
                        if(entry.awards.count == 2){
                            Image(uiImage: UIImage(data: entry.awards[0].image)!)
                                .resizable()
                                .frame(width: 55, height: 55)
                                .padding([.top, .leading, .trailing])
                            Spacer(minLength: -10)
                            Image(uiImage: UIImage(data: entry.awards[1].image)!)
                                .resizable()
                                .frame(width: 55, height: 55, alignment: .center)
                                .padding([.top, .leading, .trailing])
                        }
                    }
                    
                    if entry.awards.count == 3 {
                        VStack{
                            HStack{
                                Image(uiImage: UIImage(data: entry.awards[0].image)!)
                                    .resizable()
                                    .frame(width: 55, height: 55)
                                    .padding([.top, .leading, .trailing])
                                Spacer(minLength: -10)
                                Image(uiImage: UIImage(data: entry.awards[1].image)!)
                                    .resizable()
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .padding([.top, .leading, .trailing])
                            }
                            Spacer(minLength: -10)
                            Image(uiImage: UIImage(data: entry.awards[2].image)!)
                                .resizable()
                                .frame(width: 55, height: 55, alignment: .center)
                                .padding([.bottom, .leading, .trailing])
                        }
                    }
                    if entry.awards.count >= 4 {
                        VStack{
                            HStack{
                                Image(uiImage: UIImage(data: entry.awards[0].image)!)
                                    .resizable()
                                    .frame(width: 55, height: 55)
                                    .padding([.top, .leading, .trailing])
                                Spacer(minLength: -10)
                                Image(uiImage: UIImage(data: entry.awards[1].image)!)
                                    .resizable()
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .padding([.top, .leading, .trailing])
                            }
                            Spacer(minLength: -10)
                            HStack{
                                Image(uiImage: UIImage(data: entry.awards[2].image)!)
                                    .resizable()
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .padding([.bottom, .leading, .trailing])
                                Spacer(minLength: -10)
                                Image(uiImage: UIImage(data: entry.awards[3].image)!)
                                    .resizable()
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .padding([.bottom, .leading, .trailing])
                            }
                        }
                    }
                }
            }
            .background(Color(UIColor(named: "WidgetBackgroundColor")!))
        case .systemMedium:
            ZStack{
                Rectangle()
                    .fill(Color(UIColor(named: "WidgetBackgroundColor")!))
                HStack{
                    if entry.awards.isEmpty {
                        Image("awardsMissing")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .padding()
                    }
                    if entry.awards.count == 1 {
                        VStack {
                            Image(uiImage: (entry.awards.count >= 1 ? UIImage(data: entry.awards[0].image)! : UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding([.leading, .bottom, .trailing])
                            Text("x" + "\(entry.awards[0].count)")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30, alignment: .center)
                                .background(Color(UIColor(named: "countBackgroundColor")!))
                                .cornerRadius(15)
                        }
                    }
                    
                    if entry.awards.count == 2 {
                        VStack {
                            Image(uiImage: (entry.awards.count >= 1 ? UIImage(data: entry.awards[0].image)! : UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding([.leading, .bottom, .trailing])
                            Text("x" + "\(entry.awards[0].count)")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30, alignment: .center)
                                .background(Color(UIColor(named: "countBackgroundColor")!))
                                .cornerRadius(15)
                        }
                        VStack {
                            Image(uiImage: (entry.awards.count >= 1 ? UIImage(data: entry.awards[1].image)! : UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding([.leading, .bottom, .trailing])
                            Text("x" + "\(entry.awards[1].count)")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30, alignment: .center)
                                .background(Color(UIColor(named: "countBackgroundColor")!))
                                .cornerRadius(15)
                        }
                    }
                    
                    if entry.awards.count >= 3 {
                        VStack {
                            Image(uiImage: (entry.awards.count >= 1 ? UIImage(data: entry.awards[0].image)! : UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding([.leading, .bottom, .trailing])
                            Text("x" + "\(entry.awards[0].count)")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30, alignment: .center)
                                .background(Color(UIColor(named: "countBackgroundColor")!))
                                .cornerRadius(15)
                        }
                        VStack {
                            Image(uiImage: (entry.awards.count >= 1 ? UIImage(data: entry.awards[1].image)! : UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding([.leading, .bottom, .trailing])
                            Text("x" + "\(entry.awards[1].count)")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30, alignment: .center)
                                .background(Color(UIColor(named: "countBackgroundColor")!))
                                .cornerRadius(15)
                        }
                        VStack {
                            Image(uiImage: (entry.awards.count >= 1 ? UIImage(data: entry.awards[2].image)! : UIImage(named: "awardMissing"))!)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .padding([.leading, .bottom, .trailing])
                            Text("x" + "\(entry.awards[2].count)")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30, alignment: .center)
                                .background(Color(UIColor(named: "countBackgroundColor")!))
                                .cornerRadius(15)
                        }
                    }
                }
            }
        default:
            Text("hello")
        }
    }
}

@main
struct Awards_widgets: Widget {
    let kind: String = "Awards_widgets"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Awards_widgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Awards")
        .supportedFamilies([.systemSmall, .systemMedium])
        .description("Have up to 4 awards at a glance")
    }
}

struct Previews_Awards_widgets_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
