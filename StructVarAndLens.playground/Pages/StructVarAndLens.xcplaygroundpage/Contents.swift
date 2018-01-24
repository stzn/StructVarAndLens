//: Playground - noun: a place where people can play

import Foundation

//--------------------------------------------------------------------------
public struct Lens<A, B> {
    public let get: (A) -> B
    public let set: (A, B) -> A
}

precedencegroup ComposePrecedence {
    associativity: left
}

infix operator >>> : ComposePrecedence

func >>> <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens(
        
        // get(A, B) => get(B, C) = get(A, C)
        // (1) get(A, B)でBが取得でき、
        // (2) get(B, C)でCが取得できるのでget(A, C)が成り立つ
        
        //       (2)     (1)
        get: { rhs.get(lhs.get($0)) },
        
        // set(A, B) => set(B, C) = set(A, C)
        // (1) get(A, B)でBが取得でき、
        // (2) set(B, C)でBが取得でき、
        // (3) set(A, B)でAが取得できるのでset(A, C)が成り立つ
        
        //              (3)         (2)      (1)
        set: { return lhs.set($0, rhs.set(lhs.get($0), $1)) }
    )
}
//-----------------------------------------------------------------------------

enum Position {
    case director
    case manager
    case engineer
    case officeWorker
}

struct Address {
    let postCode: String
    let prefecture: Prefecture
    
    static let postCode_ = Lens<Address, String>(
        get: { $0.postCode },
        set: { Address(postCode: $1, prefecture: $0.prefecture)}
    )

    static let prefecture_ = Lens<Address, Prefecture>(
        get: { $0.prefecture },
        set: { Address(postCode: $0.postCode, prefecture: $1)}
    )
}

struct Prefecture {
    let name: String

        static let name_ = Lens<Prefecture, String>(
            get: { $0.name },
            set: { Prefecture(name: $1)}
        )
}

struct Staff {
    let name: String
    let position: Position
    let monthlySalary: Int
    let address: Address
    
        static let address_ = Lens<Staff, Address>(
            get: { $0.address },
            set: { Staff(name: $0.name, position: $0.position, monthlySalary: $0.monthlySalary, address: $1 )}
        )

        static let name_ = Lens<Staff, String>(
            get: { $0.name },
            set: { Staff(name: $1, position: $0.position, monthlySalary: $0.monthlySalary, address: $0.address)}
        )
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

let address2 = Address.postCode_.set(address, "222-2222")
let newStaff = Staff.address_.set(staff, address2)

print(newStaff)

let lens = Staff.address_ >>> Address.prefecture_ >>> Prefecture.name_

let newPrefectureName = lens.set(staff, "aaaaaa")

print(newPrefectureName)
