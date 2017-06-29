//
//  ViewController.swift
//  Game2048
//
//  Created by Minh Tuan on 6/28/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var score: UILabel!
    var lose : Bool = false
    var b = Array(repeating: Array(repeating: 0,count: 4), count: 4)
    override func viewDidLoad()
    {
        super.viewDidLoad()
        randomNum(type: -1)
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions
        {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(gesture:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        
           }
    func GetScore(value: Int){
        score.text = String(Int(score.text!)! + value)
    }
    // kiểm tra ô còn trống
    func checkRandom() -> Bool
    {
        for i in 0 ... 3
        {
            for j in 0 ... 3
            {
                if(b[i][j] == 0)
                {
                    return true
                }
            }
        }
        return false
    }
    // Kiểm tra điều kiện thua cuộc
    func checkLose() -> Bool
        
    {
        for i in 0 ..< 3
        {
            for j in 0 ..< 3
            {
                if (b[i][j] == b[i+1][j] || b[i][j] == b[i][j+1] )
                {
                    return false
                }
            }
        }
        // xét lại trường hợp xung quanh biên
        if b[3][0] == b[3][1]
        {
            return false
        }
        if b[3][1] == b[3][2]
        {
            return false
        }
        if b[3][2] == b[3][3]
        {
            return false
        }
        if b[0][3] == b[1][3]
        {
            return false
        }
        if b[1][3] == b[2][3]
        {
            return false
        }
        if b[2][3] == b[3][3]
        {
            return false
        }
        
        return true
    }
    

    func randomNum(type: Int)
    {
        if (!self.lose)
        {
            switch type
            {
            case 0 : left()
            case 1 : right()
            case 2 : up()
            case 3 : down()
            default:
                break
            }
        }
        if checkRandom()
        {
            
            var rnlabelX = arc4random_uniform(4)
            var rnlabelY = arc4random_uniform(4)
            let rdNum = arc4random_uniform(2) == 0 ? 2 : 4
            
            while(b[Int(rnlabelX)][Int(rnlabelY)] != 0)
            {
                rnlabelX = arc4random_uniform(4)
                rnlabelY = arc4random_uniform(4)
                
            }
            
            b[Int(rnlabelX)][Int(rnlabelY)] = rdNum
            let labelNumber = Int(100 + 4 * rnlabelX + rnlabelY)
            self.ConverNumLabe(numlabel: labelNumber, value: String(rdNum))
            self.transfer()
        }
        else
        {
            if checkLose()
            {
                self.lose = true
                let alert = UIAlertController(title: "GameOver", message: "You Lose", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    // truyền vào số tag của các ô vừa đặt tag
    func ConverNumLabe(numlabel: Int, value: String)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    // thay đổi màu của label theo tag của nó
    func chaneBackColor(numlabel: Int, color: UIColor)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }
    func transfer()
    {
        for i in 0 ..< 4
        {
            for j in 0 ..< 4
            {
                let numlabel = 100 + (i * 4) + j;
                ConverNumLabe(numlabel: numlabel, value: String(b[i][j]));
                switch(b[i][j])
                {
                case 2,4:chaneBackColor(numlabel: numlabel, color: UIColor.cyan)
                case 8,16:chaneBackColor(numlabel: numlabel, color: UIColor.green)
                case 16,32:chaneBackColor(numlabel: numlabel, color: UIColor.orange)
                case 64:chaneBackColor(numlabel: numlabel, color: UIColor.red)
                case 128,256,512:chaneBackColor(numlabel: numlabel, color: UIColor.yellow)
                case 1024,2048:chaneBackColor(numlabel: numlabel, color: UIColor.purple)
                default: chaneBackColor(numlabel: numlabel, color: UIColor.brown)
                }
            }
        }
    }

    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer)
    {
        if let swipeGesture = gesture as?
            UISwipeGestureRecognizer{
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.left:
                randomNum(type: 0)
            case UISwipeGestureRecognizerDirection.right:
                randomNum(type: 1)
            case UISwipeGestureRecognizerDirection.up:
                randomNum(type: 2)
            case UISwipeGestureRecognizerDirection.down:
                randomNum(type: 3)
            default:
                break
            }
        }
    }
    func up()
    { // từ dưới lên trên
        for col in 0 ..< 4
        {
            var check = false
            for row in 1 ..< 4
            {
            var tx = row
                if (b[row] [col] == 0)
                {
                    continue
                }
                for rowc in (0 ... row-1).reversed()
                {
                    if (b[rowc][col] != 0 && b[rowc][col] != b[row][col] || check)
                    {
                        break
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if(b[row][col] == b[tx][col])
                {
                    check = true
                    b[tx][col] *= 2
                    GetScore(value: b[tx][col])
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    func down() // từ trên xuống dưới
    {
        for col in 0 ..< 4
        {
            var check = false
            for row in 0 ..< 4
            {
                var tx = row
                
                if (b[row][col] == 0)
                {
                    continue
                }
                for rowc in row + 1 ..< 4
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break;
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[tx][col] == b[row][col])
                {
                    check = true
                    b[tx][col] *= 2
                    GetScore(value: b[tx][col])
                    
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func left() // từ trái qua phải
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in 1 ..< 4
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in ((-1 + 1)...col - 1).reversed()
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(value: b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty]=b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }
    func right() // từ phải qua trái
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in ((-1 + 1)...3).reversed()
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in col + 1 ..< 4
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(value: b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }

    @IBAction func Reset(_ sender: Any)
    {
        for i in 0 ..< 4
        {
            for j in 0 ..< 4
            {
                
            b[i][j] = 0
            }
        }
        self.transfer()
        self.lose = false
        self.randomNum(type: -1)
    }
}

