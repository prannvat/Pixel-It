//
//  ContentView.swift
//  PIXEL-IT
//
//  Created by Prannvat Singh on 15/02/2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var pixelationLevel: Double = 0
    @State private var showingFullScreenImage = false
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack {
                
                Text("PIXEL-IT")
                    .foregroundStyle(.red)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.rounded)
                    
                HStack {
                    Slider(value: $pixelationLevel, in: 0...100, step: 1)
                        .tint(.red)
                    .padding()
                    Text("\(Int(pixelationLevel))")
                        .foregroundStyle(.red)
                        
                }
                        
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFit()
                }
                
                if let processedImage = processedImage {
                    Image(uiImage: processedImage)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            showingFullScreenImage.toggle()
                        }
                }
                
                Spacer()
                HStack {
                    Button{
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue)
                    }
                    .padding()
                   
                    Spacer()
                    
                    Button{
                        guard let inputImage = inputImage else { return }
                        processedImage = pixelateImage(inputImage)
                    } label: {
                        Rectangle()
                            .foregroundStyle(.blue)
                            .frame(width: UIScreen.main.bounds.width*0.4,height:UIScreen.main.bounds.width*0.1)
                            .cornerRadius(20)
                            .overlay{
                                Text("Pixelate")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .fontDesign(.rounded)
                                    
                            }
                    }
                    Spacer()
                    
                    Button {
                        guard let processedImage = processedImage else { return }
                        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue)
                    }
                    .padding()
                }
                
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .fullScreenCover(isPresented: $showingFullScreenImage) {
                
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    if let processedImage = processedImage {
                        Image(uiImage: processedImage)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                showingFullScreenImage = false
                            }
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
    
    }
    
    func pixelateImage(_ image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let ciImage = CIImage(image: image),
              let filter = CIFilter(name: "CIPixellate") else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(pixelationLevel, forKey: kCIInputScaleKey)
        
        guard let outputCIImage = filter.outputImage,
              let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
#Preview {
    ContentView()
}
