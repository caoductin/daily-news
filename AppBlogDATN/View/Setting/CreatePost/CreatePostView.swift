import Foundation
import FirebaseStorage
import SwiftUI
import PhotosUI

struct PostRequest: Encodable {
    let title: String
    let content: String
    let image: String
    let category: String
}

@Observable
@MainActor
class PostCreateViewModel {
    var title = ""
    var content = ""
    var category = "sports"
    var selectedImage: UIImage?
    var uploadedImageURL: URL?
    var isUploading = false
        
    func uploadImage(completion: @escaping (Bool) -> Void) {
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }
        
        isUploading = true
        let fileName = "\(UUID().uuidString).jpg"
        let ref = Storage.storage().reference().child("images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("❌ Upload error: \(error.localizedDescription)")
                self.isUploading = false
                completion(false)
                return
            }
            
            ref.downloadURL { url, error in
                DispatchQueue.main.async {
                    self.isUploading = false
                    if let url = url {
                        self.uploadedImageURL = url
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func createPost() async {
        guard let imageURL = uploadedImageURL else {
            print("⚠️ No image URL")
            return
        }
        
        let post = PostRequest(
            title: title,
            content: content,
            image: imageURL.absoluteString,
            category: category
        )
        do {
            let _ = try await APIServices.shared.sendRequest(from: APIEndpoint.createPost.path, type: EmptyResponse.self, method: .POST, body: post)
            clearData()
        } catch(let error) {
            print("this is error \(error)")
        }
    }
    
    func clearData() {
        title = ""
        content = ""
        selectedImage = nil
        uploadedImageURL = nil
    }
}

import SwiftUI
import PhotosUI

struct PostCreateView: View {
    @State var vm = PostCreateViewModel()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Group {
                    Text("Title")
                        .font(.headline)
                    TextField("Enter the article title", text: $vm.title)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                
                Group {
                    Text("Content")
                        .font(.headline)
                    TextEditor(text: $vm.content)
                        .frame(height: 180)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                Group {
                    Text("Category")
                        .font(.headline)
                    Menu {
                        ForEach(Category.allCases, id: \.self) { category in
                            Button {
                                vm.category = category.rawValue
                            } label: {
                                Text(category.title)
                            }
                        }
                    } label: {
                        HStack {
                            Text(vm.category)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                }

                Group {
                    Text("Illustrative image")
                        .font(.headline)

                    if let image = vm.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .cornerRadius(12)
                            .clipped()
                    }

                    PhotosPicker("📸 Select an image from the library.", selection: $pickerItem, matching: .images)
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 5)
                        .onChange(of: pickerItem) { item in
                            Task {
                                if let data = try? await item?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    vm.selectedImage = image
                                }
                            }
                        }
                }

                if vm.isUploading {
                    ProgressView("Uploading images...")
                        .padding(.vertical)
                }

                Button(action: {
                    vm.uploadImage { success in
                        if success {
                            Task {
                                await vm.createPost()
                            }
                        }
                    }
                }) {
                    Text("Create a post")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.title.isEmpty || vm.content.isEmpty || vm.selectedImage == nil ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(vm.title.isEmpty || vm.content.isEmpty || vm.selectedImage == nil)
            }
            .padding()
        }
        .navigationTitle("Create a new post")
    }
}


#Preview {
    PostCreateView()
}
