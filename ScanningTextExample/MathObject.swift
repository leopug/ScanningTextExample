struct MathObject {
    private let firstInput: Int
    private let secondInput: Int
    private let operand: Operand
    
    var result: Int {
        switch operand {
        case .addition:
            return firstInput + secondInput
        case .subtraction:
            return firstInput - secondInput
        case .multiplication:
            return firstInput * secondInput
        case .division:
            return firstInput / secondInput
        }
    }
    
    init?(inputData: String) {
        let splitted = inputData.filter { !$0.isWhitespace }.map { String($0) }
        guard splitted.count == 3,
              let firstInput = Int(splitted[0]),
              let secondInput = Int(splitted[2]),
              let operand = Operand(rawValue: splitted[1]) else
        { return nil }
        
        self.firstInput = firstInput
        self.secondInput = secondInput
        self.operand = operand
    }
    
    private enum Operand: String {
        case addition = "+"
        case subtraction = "-"
        case multiplication = "*"
        case division = "÷"
    }
}
