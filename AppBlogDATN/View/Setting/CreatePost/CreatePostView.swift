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
    var category = "Thể thao"
    var selectedImage: UIImage?
    var uploadedImageURL: URL?
    var isUploading = false
    
    let categoryOptions = ["Thể thao", "Công nghệ", "Giải trí", "SwiftUI"]
    
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
            let response = try await APIServices.shared.sendRequest(from: APIEndpoint.createPost.path, type: EmptyResponse.self, method: .POST, body: post)
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
                    Text("Tiêu đề")
                        .font(.headline)
                    TextField("Nhập tiêu đề bài viết", text: $vm.title)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                
                Group {
                    Text("Nội dung")
                        .font(.headline)
                    TextEditor(text: $vm.content)
                        .frame(height: 180)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                Group {
                    Text("Danh mục")
                        .font(.headline)
                    Menu {
                        ForEach(vm.categoryOptions, id: \.self) { category in
                            Button {
                                vm.category = category
                            } label: {
                                Text(category)
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
                    Text("Ảnh minh họa")
                        .font(.headline)

                    if let image = vm.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .cornerRadius(12)
                            .clipped()
                    }

                    PhotosPicker("📸 Chọn ảnh từ thư viện", selection: $pickerItem, matching: .images)
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
                    ProgressView("Đang tải ảnh lên...")
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
                    Text("Tạo bài viết")
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
        .navigationTitle("Tạo bài viết mới")
    }
}


#Preview {
    PostCreateView()
}
