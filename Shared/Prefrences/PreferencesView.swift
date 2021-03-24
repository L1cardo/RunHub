//
//  PreferencesView.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import SwiftUI
import Defaults

struct PreferencesView: View {
    @Environment(\.presentationMode) var presentationMode
    @Default(.svgURL) var activitiesURL
    @Default(.svgIsAscending) var svgIsAscending
    
    @Default(.greenMax) var greenMax
    @Default(.blueMax) var blueMax
    @Default(.orangeMax) var orangeMax
    @Default(.colorStyle) var colorStyle
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("URL"),
                        footer: HStack {
                            Spacer()
                            Text("Raw URL of 'github.svg' file generated by running page.\nYou can find the file here '/assets/github.svg'.\n The URL may be look like 'https://raw.githubusercontent.com/L1cardo/running_page/master/assets/github.svg'.")
                                .multilineTextAlignment(.trailing)
                        }) {
                    Toggle(isOn: $svgIsAscending) {
                        Text("The year of your SVG file is ascending")
                    }
                    TextField("", text: $activitiesURL)
                        .keyboardType(.URL)
                }
                Section(header: Text("Color"),
                        footer: VStack {
                            HStack(spacing: 4) {
                                Text("BIG THANKS TO")
                                Button {
                                    UIApplication.shared.open(URL(string: "https://github.com/yihong0618")!)
                                } label: {
                                    Text("@yihong0618")
                                }
                                Text("AND")
                                Button {
                                    UIApplication.shared.open(URL(string: "https://github.com/yihong0618/running_page")!)
                                } label: {
                                    Text("running_page")
                                }
                            }
                            HStack(alignment: .center, spacing: 4) {
                                Spacer()
                                Text("MADE WITH")
                                Image("heart")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("BY LICARDO")
                                Spacer()
                            }
                            Text("VERSION \(Defaults[.versionNum])(\(Defaults[.buildNum]))")
                        }
                        .padding()
                ) {
                    Picker("", selection: $colorStyle) {
                        Text("Colorfull").tag(0)
                        Text("Green").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if colorStyle == 0 {
                        ColorRangeView(color: .green, min: $greenMax, max: $greenMax)
                        ColorRangeView(color: .blue, min: $greenMax, max: $blueMax)
                        ColorRangeView(color: .orange, min: $blueMax, max: $orangeMax)
                        ColorRangeView(color: .red, min: $orangeMax, max: $orangeMax)
                    } else {
                        ColorRangeView(color: Color("GreenLevel1"), min: $greenMax, max: $greenMax)
                        ColorRangeView(color: Color("GreenLevel2"), min: $greenMax, max: $blueMax)
                        ColorRangeView(color: Color("GreenLevel3"), min: $blueMax, max: $orangeMax)
                        ColorRangeView(color: Color("GreenLevel4"), min: $orangeMax, max: $orangeMax)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Preferences")
            .navigationBarItems(
                trailing: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            )
        }
        .onDisappear {
            NotificationCenter.default.post(Notification(name: Notification.Name("active")))
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
