//
//  ContentView.swift
//  BottomCardSwiftUI
//
//  Created by valentine on 09.11.2021.
//

import SwiftUI

struct ContentView: View {
    @State var cardShown = false
    @State var cardDismissal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Button(action: {
                    cardShown.toggle()
                    cardDismissal.toggle()
                }, label: {
                    Text("Show Card")
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                })
                
                BottomCard(cardShown: $cardShown,
                           cardDismissal: $cardDismissal,
                           height: UIScreen.main.bounds.height/2.2) {
                    CardContent()
                        .padding()
                }
                .animation(.default)
            }
        }
    }
}

struct CardContent: View {
    var body: some View {
        Text("Photo Collage")
            .bold()
            .font(.system(size: 30))
        
        Text("You can create awesome photo")
            .font(.system(size: 18))
            .multilineTextAlignment(.center)
        
        Image("image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            
    }
}

struct BottomCard<Content: View>: View {
    let content: Content
    @Binding var cardShown: Bool
    @Binding var cardDismissal: Bool
    let height: CGFloat
    
    init(cardShown: Binding<Bool>,
         cardDismissal: Binding<Bool>,
         height: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.height = height
        _cardShown = cardShown
        _cardDismissal = cardDismissal
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Dimmed
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.7))
            .opacity(cardShown ? 1 : 0.3)
            .animation(Animation.easeIn)
            .onTapGesture {
                // Dismiss
                cardDismissal.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                    cardShown.toggle()
                }
            }
            
            // Card
            VStack {
                Spacer()
                
                VStack{
                    content
                    Button(action: {
                        cardDismissal.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                            cardShown.toggle()
                        }
                    }, label: {
                        Text("Dismiss")
                            .foregroundColor(Color.white)
                            .frame(width: UIScreen.main.bounds.width/1.3,
                                   height: 50)
                            .background(Color.pink)
                            .cornerRadius(8)
                    })
                    
                }
                .background(Color.init(white: 1))
                .frame(height: height)
                .offset(y: cardDismissal &&  cardShown ? 0 : height)
                .animation(Animation.default.delay(0.2))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    func dismiss() {
        cardDismissal.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            cardShown.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
