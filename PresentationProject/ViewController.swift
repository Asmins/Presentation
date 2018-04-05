//
//  ViewController.swift
//  PresentationProject
//
//  Created by Asmins on 04.04.2018.
//  Copyright © 2018 Asmins. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var NLPTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    private let textForTestLemma = "misfits rebels troublemakers reading"

    private var rangeText: NSRange {
        return NSRange(location: 0, length: NLPTextView.text.utf16.count)
    }

    private let tagger = NSLinguisticTagger(tagSchemes: [.language, .tokenType, .lemma, .nameType, .lexicalClass], options: 0)
    private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NLPTextView.isEditable = false
    }
    
    @IBAction func getDomainLanguage(_ sender: Any) {
        tagger.string = NLPTextView.text
        guard let language = tagger.dominantLanguage else { return }
        
        resultTextView.text = "Dominant language is \(language)"
    }
    
    @IBAction func getWords(_ sender: Any) {
        tagger.string = NLPTextView.text
        var result = ""
        tagger.enumerateTags(in: rangeText, unit: .word, scheme: .tokenType, options: options, using: { tag, tokenRagne, _ in
            let word = (NLPTextView.text as NSString).substring(with: tokenRagne)
            
            result.append("\(word)\n")
        })
        resultTextView.text = result
    }
    
    @IBAction func getNameTouched(_ sender: Any) {
        tagger.string = NLPTextView.text
        var result = ""
        let tags: [NSLinguisticTag] = [.organizationName, .personalName, .placeName]
        
        tagger.enumerateTags(in: rangeText, unit: .word, scheme: .nameType, options: options, using: { tag, tokenType, _ in
            guard let tag = tag, tags.contains(tag) else { return }
            let name = (NLPTextView.text as NSString).substring(with: tokenType)
            result.append("Name \(name): \(tag.rawValue)\n")
        })
        resultTextView.text = result
    }
    
    @IBAction func lemmaTouched(_ sender: Any) {
        tagger.string = textForTestLemma
        var result = ""
        tagger.enumerateTags(in: NSRange(location: 0, length: textForTestLemma.utf16.count), unit: .word, scheme: .lemma, options: options, using: { tag, tokenRange, _ in
            guard let lemma = tag?.rawValue else {
                debugPrint("Doesn't know this lemma")
                return
            }
            result.append("\(lemma)\n")
        })
        resultTextView.text = result
    }
    
    @IBAction func partsOfSpeech(_ sender: Any) {
        tagger.string = NLPTextView.text
        var result = ""
        tagger.enumerateTags(in: rangeText, unit: .word, scheme: .lexicalClass, options: options, using: { tag, tokenRange, _ in
            guard let tag = tag else { return }
            let word = (NLPTextView.text as NSString).substring(with: tokenRange)
            result.append("\(word): \(tag.rawValue)\n")
        })
        resultTextView.text = result
    }
}
