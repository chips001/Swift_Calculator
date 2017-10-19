//
//  ViewController.swift
//  Swift_Calculator
//
//  Created by 一木　英希 on 2017/10/16.
//  Copyright © 2017年 一木　英希. All rights reserved.
//

import UIKit
import Expression

class ViewController: UIViewController {

    @IBOutlet weak var mFormulaLbl: UILabel!
    @IBOutlet weak var mAnswerLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mFormulaLbl.text = ""
        mAnswerLbl.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 「C」「=」以外のButton押下時の処理
    ///
    /// - Parameter sender: UIButtonのインスタンス
    @IBAction func mInputFormulaAction(_ sender: UIButton) {
        //nilチェック
        guard let formulaText = mFormulaLbl.text else {
            //nilだったらreturn
            return
        }
        guard let senderedText = sender.titleLabel?.text else {
            //「sender.titleLabel?.text」:Buttonのタイトルを取得する
            //nilだったらreturn
            return
        }
        
        mFormulaLbl.text = formulaText + senderedText
        print("formulaText:\(formulaText)  senderedText:\(senderedText)")
        
    }

    /// 「C」Button押下時の処理
    ///
    /// - Parameter sender: UIButtonの処理
    @IBAction func mClearFormulaAction(_ sender: UIButton) {
        mFormulaLbl.text = ""
        mAnswerLbl.text = ""
    }
    
    /// 「=」Bitton押下時の処理
    ///
    /// - Parameter sender: UIButtonの処理
    @IBAction func mCalculateAnswerAction(_ sender: UIButton) {
        //nilチェック
        guard let formulaText = mFormulaLbl.text else {
            //nilだったらreturn
            return
        }
        
        //入力された値の判定
        let formula:String = formulaFormat(formulaText)
        //判定結果より計算した答えを表示orMsgの表示
        mAnswerLbl.text = evalFormula(formula)
        
    }
    
    /// 入力された整数に「.0」を追加して少数として追加する
    /// また、「÷」を「/」へ、「×」を「*」へ変換する
    ///
    /// - Parameter formulaText: 入力された値
    /// - Returns: フォーマット後の値
    private func formulaFormat (_ formulaText:String) -> String{
        
        //replacingOccurrences:文字列の置換
        let formattedFormula: String = formulaText.replacingOccurrences(
            of: "(?<=^|[÷×\\+\\-\\(])([0-9]+)(?=[÷×\\+\\-\\)]|$)",
            with: "$1.0",
            options: NSString.CompareOptions.regularExpression,
            range: nil
        ).replacingOccurrences(of: "÷", with: "/").replacingOccurrences(of: "×", with: "*")
        
        print("正規表現変換後:\(formattedFormula)")
        return formattedFormula
    }
    
    /// Expressionフレームワークで文字列の計算式を評価して答えを求める
    ///
    /// - Parameter formula:入力された式
    /// - Returns: 計算の答えor不当な式であった場合のMsg
    private func evalFormula(_ formula:String) -> String{
        //do でスコープを作成
        do{
            let expression = Expression(formula)
            //try で処理
            let answer = try expression.evaluate()
            let formattedAnswer = formatAnswer(String(answer))
            
            print("式評価後:\(formattedAnswer)")
            return formattedAnswer
        
        //catch節で投げられるであろうエラーをハンドリング
        }catch{
            //計算式が不当だった場合
            return "Sorry...Please formula!!"
        }
    }
    
    /// 答えの小数点以下が「.0」だった場合は、「.0」を削除して答えを整数で表示する
    ///
    /// - Parameter answer: 実際に計算される式
    /// - Returns: 計算の答え
    private func formatAnswer(_ answer:String) -> String{
        let formattedeAnswer:String = answer.replacingOccurrences(
            of: "\\.0$",
            with: "",
            options: NSString.CompareOptions.regularExpression,
            range: nil)
        
        print("小数点以下判定後:\(formattedeAnswer)")
        return formattedeAnswer
    }
}

