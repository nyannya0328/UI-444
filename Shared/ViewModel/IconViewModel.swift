//
//  IconViewModel.swift
//  UI-444 (iOS)
//
//  Created by nyannyan0328 on 2022/02/01.
//

import SwiftUI

class IconViewModel: ObservableObject {
    @Published var pickedImage : NSImage?
    
    @Published var isGeneRating : Bool = false
    @Published var alreMSG : String = ""
    @Published var showAlert : Bool = false
    
    @Published var iconSizes: [Int] = [
    
        20,60,58,87,80,120,180,40,29,76,152
        ,167,1024,16,32,64,128,256,512,1024
    ]
    
    func pickImage(){
        
        let pannel = NSOpenPanel()
        pannel.title = "Choose a Pannel"
        pannel.showsResizeIndicator = true
        pannel.showsHiddenFiles = false
        pannel.allowsMultipleSelection = false
        pannel.canChooseDirectories = false
        pannel.allowedContentTypes = [.image,.png,.jpeg]
        
        
        if pannel.runModal() == .OK{
            
            
            if let result = pannel.url?.path{
                
                let image = NSImage(contentsOf: URL(fileURLWithPath: result))
                
                self.pickedImage = image
                
                
            }
            
            
        }
        else{
            
            
            
        }
        
        
    }
    
    func genelateIconSet(){
        
        
        folderSelector { folderURL in
            
            
            let modifiredURL = folderURL.appendingPathComponent("AppIcon.appiconset")
            
            
            self.isGeneRating = true
            
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                do{
                    
                    
                    let manager = FileManager.default
                    
                   try manager.createDirectory(at: modifiredURL, withIntermediateDirectories: true, attributes: [:])
                    
                    self.wirteContentsFiler(folderURL: modifiredURL.appendingPathComponent("Contents.json"))
                    
                    
                    if let pickedImages = self.pickedImage{
                        
                        
                        
                        self.iconSizes.forEach { size in
                            
                            
                            let imageSize = CGSize(width: CGFloat(size), height: CGFloat(size))
                            
                            let imageURL = modifiredURL.appendingPathComponent("\(size).png")
                            
                            pickedImages.resizedImage(size: imageSize)
                                .writeImage(to: imageURL)
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.isGeneRating = false
                            self.alreMSG = "Genereating SuccessFull"
                            self.showAlert.toggle()
                            
                        }
                        
                        
                    
                    }
                    
                    
                    
                    
                }
                catch{
                    
                    print(error.localizedDescription)
                    
                    DispatchQueue.main.async {
                        
                        self.isGeneRating = false
                    }
                }
                
                
                
            }
            
          
        }
        
        
        
        
    }
    
    
    func folderSelector(competition : @escaping(URL) ->()){
        
        let pannel = NSOpenPanel()
        pannel.title = "Chose a Folder"
        pannel.showsResizeIndicator = true
        pannel.showsHiddenFiles = false
        pannel.allowsMultipleSelection = false
        pannel.canChooseDirectories = true
        pannel.canChooseFiles = false
        pannel.canCreateDirectories = true
        pannel.allowedContentTypes = [.folder]
        
        
        if pannel.runModal() == .OK{
            
            
            if let result = pannel.url?.path{
                
                
                competition(URL(fileURLWithPath: result))
            }
            
            
            
            
        }
        
        else{
            
            
            
            
        }
        
        
        
        
    }
    
    
    func wirteContentsFiler(folderURL : URL){
        
        
        do{
            
            let bundle = Bundle.main.path(forResource: "Contents", ofType: "json") ?? ""
            
            let url = URL(fileURLWithPath: bundle)
            
            
            try Data(contentsOf: url).write(to: folderURL,options: .atomic)
            
            
        }
        catch{
            
            
            
        }
        
    }
    
    
}

extension NSImage{
    
    
    func resizedImage(size : CGSize) -> NSImage{
        
        
        let scale = NSScreen.main?.backingScaleFactor ?? 1
        
    
        
        let newSize = CGSize(width: size.width / scale, height: size.height / scale)
        
        let newImage = NSImage(size: newSize)
        
        newImage.lockFocus()
        
        
        
        self.draw(in: NSRect(origin: .zero, size: newSize))
        
        newImage.unlockFocus()
        
        return newImage
    }
    
    
    func writeImage(to : URL){
        
        
        guard let data = tiffRepresentation,let representaiton = NSBitmapImageRep(data: data),let pingData = representaiton.representation(using: .png, properties: [:])else{
            
            
            return
        }
        
        try? pingData.write(to: to,options: .atomic)
        
        
        
    }
    
}
