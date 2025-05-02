//
//  Task.swift
//  ToDo
//
//  Created by Vandan Pochiraju on 02/05/25.
//


import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
}
