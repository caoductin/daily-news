//
//  OnBoardingView.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/14/26.
//
import SwiftUI

struct OnboardingView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @AppStorage("hasSeenOnboarding")
    var hasSeenOnboarding = false
    
    let welcomeLabel = [
        "Welcome go To Do List App",
        "Organize your tasks with ease",
        "Let's get started!",
    ]

    let imageNames = (1...6).map { String($0) }
    let imageNames1 = (7...13).map { String($0) }
    let imageNames2 = (14...20).map { String($0) }
    let imageNames3 = (20...26).map { String($0) }

    @State private var indexLabel = 0
    @State private var timer = Timer
        .publish(every: 3, on: .current, in: .default)
        .autoconnect()

    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            VStack {
                InfiniteCarouseView(imageNames: imageNames, 0.3)
                InfiniteCarouseView(imageNames: imageNames1, -0.8)
                InfiniteCarouseView(imageNames: imageNames2, 0.3)
                InfiniteCarouseView(imageNames: imageNames3, -1)
                Spacer()
            }
            .rotationEffect(.degrees(-10))

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .primary.opacity(0.4), location: 0.4),
                    .init(color: .primary.opacity(0.7), location: 0.7),
                    .init(color: .primary, location: 1),
                ], startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Text(welcomeLabel[indexLabel])
                    .font(.system(.largeTitle, design: .default, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.aiPink, .roboticBlue, .futuristicViolet],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .contentTransition(.numericText())
                    .onReceive(timer) { _ in
                        withAnimation {
                            if indexLabel >= 2 {
                                indexLabel = 0
                            } else {
                                indexLabel = indexLabel + 1
                            }
                        }
                    }

                Button("Get Started") {
                    hasSeenOnboarding = true
                }
                .font(.title2)
                .fontWeight(.bold)
                .buttonStyle(FillButton())
                .modifier(PressedScale(scale: 2))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
        }
    }
}

struct AnimatedBackground: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    .purple,
                    .blue,
                ],
                startPoint: startAnimation ? .topLeading : .bottomLeading,
                endPoint: startAnimation ? .bottomTrailing : .topTrailing
            )
            .opacity(0.3)
        }
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever()) {
                startAnimation.toggle()
            }
        }
    }
}

struct FillButton: ButtonStyle {
    var normalColor: Color = .blue
    var pressedColor: Color = .green

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? pressedColor : normalColor)
    }
}

struct OutlineButton: ButtonStyle {
    var strokeColor: Color = .green
    var fillColorPressed: Color = .secondary
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .stroke(strokeColor, lineWidth: 3)
                    .fill(configuration.isPressed ? fillColorPressed : .clear)
            )
    }
}

struct PressedScale: ViewModifier {
    var scale: CGFloat
    var backgroundColor: Color = .green
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }
}
