(expression as text) as any =>
let
    Environment = PT_Expression_Registry,
    Result =
        Expression.Evaluate(
            expression,
            Environment
        )
in
    Result
