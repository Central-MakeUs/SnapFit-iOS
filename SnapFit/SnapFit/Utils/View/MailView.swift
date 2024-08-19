//
//  MailView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentationMode: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentationMode: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentationMode = presentationMode
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                presentationMode.dismiss()
            }
            if let error = error {
                print("신고하기 error \(error)")
                self.result = .failure(error)
                
            } else {
                print("신고하기 성공 \(result)")
                self.result = .success(result)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["snapfit.snapshot@gmail.com"])
        vc.setSubject("신고하기")
        vc.setMessageBody("신고 내용을 작성해주세요.", isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}
}
