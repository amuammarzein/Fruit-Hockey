//
//  ContentView.swift
//  GlowAirHockey
//
//  Created by Aang Muammar Zein on 22/05/23.
//

import SwiftUI
import SpriteKit

struct Play: View {
    @Binding var mode:Int
    var scene1 = GameScene()
    var scene2 = GameScene2()
    var size = UIScreen.main.bounds.size
    
    @State var isHome:Bool = false
    
    var body: some View {
        if(isHome==false){
            ZStack(alignment:.top){
                if(mode==1){
                    SpriteView(scene: scene1).ignoresSafeArea()
                }else{
                    SpriteView(scene: scene2).ignoresSafeArea()
                }
                ZStack(){
                    Circle().frame(height:40)
                    Image(systemName: "house.fill").resizable().scaledToFit().frame(height: 20).foregroundColor(Color.white)
                }.offset(y:30)
                    .onTapGesture {
                        isHome = true
                    }
            }.padding(0).frame(maxWidth: size.width, maxHeight: size.height).background(Color.red)
        }else{
            Home()
        }
    }
}
