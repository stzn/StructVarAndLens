//: [Previous](@previous)

import Foundation

// These are kind of "Swift" lenses. We don't need to generate a lot of code this way and can just use Swift `var`.
protocol Mutable {
}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) -> ()) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) throws -> ()) rethrows -> Self {
        var newSelf = self
        try transform(&newSelf)
        return newSelf
    }
}

enum Position {
    case director
    case manager
    case engineer
    case officeWorker
}

struct Staff {
    var name: String
    var position: Position
    var monthlySalary: Int
    var address: Address
}

struct Address {
    var postCode: String
    var prefecture: Prefecture
}

struct Prefecture {
    var name: String
}

extension Staff: Mutable {}


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

let newStaff = staff.mutateOne { $0.address.postCode = "222-2222" }

print(newStaff)

let newStaff2 = staff.mutate {
    $0.address.postCode = "333-3333"
    $0.address.prefecture.name = "aaaaaaa"
}

print(newStaff2)
