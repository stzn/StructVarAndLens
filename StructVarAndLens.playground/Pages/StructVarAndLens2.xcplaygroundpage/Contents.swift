//: [Previous](@previous)

import Foundation

enum Position {
    case director
    case manager
    case engineer
    case officeWorker
}

struct Address {
    var postCode: String
    var prefecture: Prefecture
}

struct Prefecture {
    var name: String
}

struct Staff {
    var name: String
    var position: Position
    var monthlySalary: Int
    var address: Address
}

let prefecture = Prefecture(
    name: "XX県"
)

let address = Address(
    postCode: "111-1111",
    prefecture: prefecture
)

let staff = Staff(
    name: "スタッフ",
    position: .engineer,
    monthlySalary: 300000,
    address: address
)

print(staff)

var newStaff = staff

newStaff.address.postCode = "222-2222"

newStaff.address.prefecture.name = "aaaaaa"

print(newStaff)

print(staff)
