indirect enum Expression: Equatable {
    case label(String)
    case seq([Expression])
}
