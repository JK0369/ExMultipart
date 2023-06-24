//
//  ViewController.swift
//  ExUploadDownload
//
//  Created by 김종권 on 2023/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func uploadImageUsingURLSession(imageData: Data, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://example.com/upload")

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let uniqString = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(uniqString)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        /// 폼 데이터 생성
        var body = Data()
        
        /// 멀티 파트 데이터의 구분자(boundary)
        body.append("--\(uniqString)\r\n".data(using: .utf8)!)
        
        /// 멀티 파트 데이터의 파트에 대한 헤더를 추가: name 파라미터를 "image"로 설정하고, 업로드된 파일의 원래 이름을 "image.jpg"로 설정
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        
        /// 업로드된 파일의 MIME 타입을 명시
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        
        /// 실제 이미지 바이너리 데이터를 담고있는 값 추가
        body.append(imageData)
        
        ///  각 파트 사이에 빈 줄을 추가하여 파트를 구분하며 멀티파트 데이터의 각 파트를 구분하는 구분자 역할
        body.append("\r\n".data(using: .utf8)!)
        
        /// 멀티파트 데이터의 끝을 나타내는 경계값을 추가하며 멀티파트 데이터의 마지막을 나타내고 파트들을 닫는 역할
        body.append("--\(uniqString)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: body) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                // 응답 처리
                
                completion(nil)
            }
        }
        
        task.resume()
    }

}

extension ViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("progress = ", Double(bytesSent) / Double(totalBytesSent))
    }
}
