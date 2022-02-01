//
//  Home.swift
//  UI-444 (iOS)
//
//  Created by nyannyan0328 on 2022/02/01.
//

import SwiftUI

struct Home: View {
    @StateObject  var iconVM = IconViewModel()
    @Environment(\.self) var scehme
    var body: some View {
        VStack(spacing:20){
            
            
            
            if let image = iconVM.pickedImage{
                
                
                Group{
                    
                    
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipped()
                        .onTapGesture {
                            
                            iconVM.pickImage()
                        }
                    
                    
                    Button {
                        
                        iconVM.genelateIconSet()
                        
                    } label: {
                        
                        Text("Create Icon Set")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .background(.white,in: RoundedRectangle(cornerRadius: 7))
                    }

                }
                
                
                
            }
            else{
                
                
                ZStack{
                    
                    
                    
                    
                    Button {
                        
                        iconVM.pickImage()
                        
                   
                        
                    } label: {
                        
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                            .foregroundColor(scehme.colorScheme == .dark ? .black : .white)
                            .background(.white,in: RoundedRectangle(cornerRadius: 5))
                    }
                    
                    
                    Text("1024 * 1024 is Reccommanded")
                        .font(.title.weight(.semibold))
                        .foregroundColor(.gray)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom,20)
                    
                    

                }
            }
        }
        .frame(width: 500, height: 500)
        .buttonStyle(.plain)
        .alert(iconVM.alreMSG, isPresented: $iconVM.showAlert, actions: {
            
            
            
        })
        .overlay{
            
            
            ZStack{
                
                
                if iconVM.isGeneRating{
                    
                    Color.black.opacity(0.3)
                        
                    
                    ProgressView()
                        .padding()
                        .background(.white,in: RoundedRectangle(cornerRadius: 3))
                        .environment(\.colorScheme, .light)
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            
        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
