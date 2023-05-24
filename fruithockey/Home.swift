//
//  PlayView.swift
//  mathquiz
//
//  Created by Aang Muammar Zein on 19/05/23.
//

import SwiftUI



struct Home: View {
    
    
    
    var arrGift:[giftModel] = [
        giftModel(icon:"🍇",score:1),
        giftModel(icon:"🍈",score:2),
        giftModel(icon:"🍉",score:3),
        giftModel(icon:"🍊",score:4),
        giftModel(icon:"🍋",score:5),
        giftModel(icon:"🍌",score:6),
        giftModel(icon:"🍍",score:7),
        giftModel(icon:"🍎",score:8),
        giftModel(icon:"🍏",score:9),
        giftModel(icon:"🍐",score:10),
        giftModel(icon:"🍑",score:11),
        giftModel(icon:"🍒",score:12),
    ]
    
    struct giftModel:Identifiable{
        var id = UUID()
        var name:String = ""
        var icon:String = ""
        var score:Int = 0
        var status:Bool = false
    }
    
    
    @State var screenWidth = UIScreen.main.bounds.size.width-40
    @State var screenHeight = UIScreen.main.bounds.size.height
    
    let columnsGift = [
        GridItem(.flexible(),spacing:15),
        GridItem(.flexible(),spacing:15),
        GridItem(.flexible(),spacing:15),
        GridItem(.flexible(),spacing:15),
        GridItem(.flexible(),spacing:15),
        GridItem(.flexible(),spacing:15),
    ]
    @State private var mode: Int = 1
    
    func play(){
        
    }
    
    struct modelMode:Identifiable{
        var id = UUID()
        var name:String = ""
        var icon:String = ""
        var config:[Int] = []
        var status:Bool = false
    }
    
    @State var is1Player:Bool = false
    @State var is2Player:Bool = false
    
    var body: some View {
        if(is1Player==true){
            Play(mode:$mode)
        }else if(is2Player==true){
            Play(mode:$mode)
        }else{
            ZStack(){
                VStack(){
                    ScrollView(showsIndicators: false){
                        Text("Fruit Hockey").font(.largeTitle) .fontDesign(.monospaced).fontWeight(.bold).foregroundColor(Color.white).padding(.top,20)
                        
                        HStack(){
                            Button(action:{
                                is1Player = true
                                mode = 1
                            }){
                                Text("1 Player").fontDesign(.monospaced).foregroundColor(Color.black)
                                    .font(.system(size: 20,weight:.regular ,design: .rounded)).padding(10)
                                
                            }.buttonStyle(.borderedProminent)
                            
                                .buttonBorderShape(.capsule).compositingGroup().tint(Color.white).shadow(color:Color.blue.opacity(0.5),radius: 0,x:1,y:5).padding(.bottom,20)
                            Button(action:{
                                is2Player = true
                                mode = 2
                            }){
                                Text("2 Player").fontDesign(.monospaced).foregroundColor(Color.black)
                                    .font(.system(size: 20,weight:.regular ,design: .rounded)).padding(10)
                                
                            }.buttonStyle(.borderedProminent)
                            
                                .buttonBorderShape(.capsule).compositingGroup().tint(Color.white).shadow(color:Color.blue.opacity(0.5),radius: 0,x:1,y:5).padding(.bottom,20)
                        }
                        
                        
                        Text("Extra Points").font(.largeTitle).fontDesign(.monospaced).fontWeight(.bold).padding(.bottom,15).foregroundColor(Color.white)
                        LazyVGrid(columns: columnsGift, spacing: 20) {
                            ForEach((0..<arrGift.count)) { index in
                                ZStack(alignment:.center){
                                    
                                    ZStack(alignment:.center){
                                        Image( "default").resizable().scaledToFit().frame(width:.infinity).cornerRadius(20)
                                        Image( "modeDefault").resizable().scaledToFit().frame(width:.infinity).cornerRadius(20).opacity(0.8).shadow(color:Color.blue.opacity(0.5),radius: 0,x:1,y:5)
                                        VStack(alignment:.center){
                                            Text(arrGift[index].icon).font(.system(size:screenWidth*0.06)).fontDesign(.rounded).opacity(1.0).shadow(color:Color.blue.opacity(0.5),radius: 0,x:1,y:5)
                                            Text("+"+String(arrGift[index].score)).font(.callout).fontDesign(.monospaced).frame(alignment:.center)
                                        }
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }.padding(.bottom,10)
                        
                        
                        
                    }
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)).background(Color.black).frame(maxWidth: .infinity,maxHeight:.infinity)
                
            }.onAppear{
                play()
                
                
            }
        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
