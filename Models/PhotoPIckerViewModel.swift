//
//  PhotoPickerViewModel.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 3/21/24.
//

import SwiftUI
import PhotosUI
@MainActor
final class PhotoPickerViewModal: ObservableObject {
    @State var blahImage = UIImage(named: "Loading.jpg")!
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    init() {
//        deleteOldImagesFolder(folderName: "userBackgroundImages")
        _ = loadImagesFromLocalStorage(folderName: "userBackgroundImages")
    }
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse) //write my own error
                }
                selectedImage = uiImage
            } catch {
                print(error)
            }
        }
        imageSelection = nil
    }
    
    private func setImages(from selections: [PhotosPickerItem]) {
        if selections.isEmpty  { print("nothing chosen"); return }

        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            selectedImages = images
            saveImagesLocally(folderName: "userBackgroundImages")
        }
                imageSelections.removeAll(keepingCapacity: true)
    }
    
    func appendDefaultImages(isPokemonMode: Bool = false){
        if isPokemonMode {
            for index in 1...13 {
                selectedImages.append(UIImage(named: "PokemonImage\(index).jpg")!)
            }
        }else {
            for index in 1...13 {
                selectedImages.append(UIImage(named: "DefaultImage\(index).jpg")!)
            }
        }
    
    }
    func loadImagesFromLocalStorage(folderName: String = "UserImageFolder") -> Int{
        //Load images until reaches a non-existing file.
        //Return number of images loaded from file
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var startPoint = 1
        var name = "UserImage\(startPoint).jpg"
        var imagePath = path
            .appendingPathComponent(folderName)
            .appendingPathComponent(name)
        
        while FileManager.default.fileExists(atPath: imagePath.path){
            logManager.shared.logMessage("Image loaded \(imagePath.absoluteString)", .debug)
            
            if let blahImage = UIImage(contentsOfFile: imagePath.path) {
                selectedImages.append(blahImage)
            } else {
                logManager.shared.logMessage("File doesn't exist: \(imagePath.absoluteString), exiting with loadedImageCount \(selectedImages.count)", .warning)
                break
            }
            
            startPoint += 1
            name = "UserImage\(startPoint).jpg"
            imagePath = path
                .appendingPathComponent("userBackgroundImages")
                .appendingPathComponent(name)
        }
        logManager.shared.logMessage("Found \(startPoint-1) images in local storage", .debug)
        logManager.shared.logMessage("selectedImages size \(selectedImages.count)", .debug)
        return startPoint
    }
    
    private func saveImagesLocally(folderName: String = "userBackgroundImages") {
        if selectedImages.isEmpty {
            logManager.shared.logMessage("\(#line) No images to store", .warning)
            return
        }
        //Delete old images
        deleteOldImagesFolder(folderName: folderName)
        
            //convert backgroundImages to Data
            let dir_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(folderName, isDirectory: true)
        
            if !FileManager.default.fileExists(atPath: dir_path.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dir_path.path, withIntermediateDirectories: true, attributes: nil)
    
                    logManager.shared.logMessage("Created Directory: \(dir_path.absoluteString)", .debug)
    
                }
                catch{
                    logManager.shared.logMessage("Error creating user directory \(error.localizedDescription)", .warning)
                }
            }
            
            var startPoint = 1
            var name = "UserImage\(startPoint).jpg"
            for userImage in selectedImages {
                let img_dir = dir_path.appendingPathComponent(name)
                logManager.shared.logMessage("Saving file to path: \(img_dir.absoluteString)", .debug)
                do {
                    try userImage.jpegData(compressionQuality: 50)?.write(to: img_dir)
                }
                catch {
                    logManager.shared.logMessage("Failed to save image err:"+error.localizedDescription, .warning)
                }
                startPoint+=1
                name = "UserImage\(startPoint).jpg"
            }
    }
    
    private func deleteOldImagesFile(oldFileIndex: Int = 0, folderName: String) {
        let fileNameToDelete = "UserImage\(oldFileIndex).jpg"
        var filePath = folderName

        // Fine documents directory on device
         let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)

        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + folderName + "/" + fileNameToDelete)

            print("Local path = \(filePath)")
         
        } else {
            print("Could not find local directory to store file")
            return
        }


        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        
    }
    private func deleteOldImagesFolder(folderName: String)  {
        var filePath = folderName

        // Fine documents directory on device
         let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)

        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + folderName )

            print("Deleting Local path = \(filePath)")
         
        } else {
            print("Could not find local directory to store file")
            return
        }


        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}
