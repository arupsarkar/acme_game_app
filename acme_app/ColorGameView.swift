//
//  ColorGameView.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/10/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI

struct ColorGameView: View {
    @ObservedObject var game = GameModel()
    
    var body: some View {
        ScrollView {
            VStack (spacing: 5) {
                ZStack {
                    HStack(spacing: 5) {
                        BlinkingStar()
                        Spacer()
                        BlinkingStar()
                    }
                    Text("Color Matcher")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing)
                                .mask(
                                    Text("Color Matcher")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                )
                        )
                    HStack(spacing: 5) {
                        BlinkingStar()
                        Spacer()
                        BlinkingStar()
                    }
                    
                }
                

                GroupBox(
                    label: Text("Match this color")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                ) {
                    ColorView(color: game.targetColor)
                }
                GroupBox(
                    label: Text("Your guess")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                ) {
                    ColorView(color: game.guessColor)
                }
                

                ColorSlidersGroupBox(game: game)

                Button(action: {
                    game.newRound()
                }) {
                    Text("New Round")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .padding(.horizontal)
                }

                Text("Score: \(game.score)")
                    .font(.headline)
                
                WeatherWidget()
            }
        }
    }
}

struct ColorSlidersGroupBox: View {
    @ObservedObject var game: GameModel

    var body: some View {
        GroupBox(label: Label("Color Sliders", systemImage: "paintpalette").font(.headline)) {
            VStack {
                SliderView(value: $game.redValue, color: .red, text: "Red")
                SliderView(value: $game.greenValue, color: .green, text: "Green")
                SliderView(value: $game.blueValue, color: .blue, text: "Blue")
            }
        }
//        .padding()
    }

}

struct SliderView: View {
    @Binding var value: Double
    var color: Color
    var text: String

    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(color)
            Slider(value: $value, in: 0...1)
                .accentColor(color)
        }
    }
}

struct ColorView: View {
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(color)
            .frame(width: 100, height: 100)
    }
}

struct WeatherWidget: View {
    // Mockup data - replace with real data from a weather API
    let temperature = "21°C"
    let weatherDescription = "Partly Cloudy"
    let icon = "cloud.sun.fill" // SF Symbol for partly cloudy weather

    var body: some View {
        GroupBox(
                    label: Text("Today's Weather")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 5)
            ) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow)

                VStack(alignment: .leading) {
                    Text(temperature)
                        .font(.largeTitle)
                        .bold()
                    Text(weatherDescription)
                }

                Spacer()
            }
            .padding()
        }
        .groupBoxStyle(WidgetGroupBoxStyle())
    }
}

struct WidgetGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.1)))
            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
    }
}

struct BlinkingStar: View {
    @State private var isBlinking = false

    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 10, height: 10)
            .foregroundColor(.yellow)
            .opacity(isBlinking ? 1.0 : 0.0)
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(Double.random(in: 0...1)), value: isBlinking)
            .onAppear() {
                isBlinking.toggle()
            }
    }
}


