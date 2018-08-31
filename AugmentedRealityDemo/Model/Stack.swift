//
//  Stack.swift
//  AugmentedRealityDemo
//
//  Created by MacBook Pro on 8/29/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import Foundation

class Node<T>
{
    let value: T
    let next: Node?
    
    init(value: T, next: Node) {
        self.value = value
        self.next = next
    }
    
    init(value: T) {
        self.value = value
        self.next = nil
    }
}

class Stack<T>
{
    var top: Node<T>?
    
    init() {
        top = nil
    }
    
    func push(value: T)
    {
        if top == nil
        {
            let node = Node(value: value)
            top = node
        }
        else if let top = top
        {
            let node = Node(value: value, next: top)
            self.top = node
        }
    }
    
    func pop()
    {
        if let top = top
        {
            self.top = top.next
        }
    }
    
    func peek() -> T?
    {
        if let top = top
        {
            return top.value
        }
        return nil
    }
    
}
