() =>
{
    [
        get_current_time =
            [
                definition =
                    [
                        type = "function",
                        name = "get_current_time",
                        description = "Get the current date and time.",
                        parameters =
                            [
                                type = "object",
                                properties = [],
                                required = {}
                            ]
                    ],

                function =
                    (arguments as record) =>
                        DateTimeZone.ToText(
                            DateTimeZone.FixedUtcNow(),
                            "yyyy-MM-ddTHH:mm:sszzz"
                        )
            ]
    ],

    [
        calculate_dot_product =
            [
                definition =
                    [
                        type = "function",
                        name = "PT_LA_Dot",
                        description = "Calculate the dot product of two numeric vectors.",
                        parameters =
                            [
                                type = "object",
                                properties =
                                    [
                                        u =
                                            [
                                                type = "array",
                                                description = "The first numeric vector."
                                            ],
                                        v =
                                            [
                                                type = "array",
                                                description = "The second numeric vector."
                                            ]
                                ],
                                required =
                                    {"u", "v"}
                            ]
                    ],

                function =
                    (arguments as record) =>
                        let
                            U = arguments[u],
                            V = arguments[v],
                            
                            Result =
                                PT_LA_Dot(
                                    U,
                                    V
                                )
                        in
                            Text.FromBinary(
                                Json.FromValue(
                                    [
                                        u = U,
                                        v = V,
                                        dot_product = Result
                                    ]
                                )
                            )
            ]
    ],

    [
        calculate =
            [
                definition =
                    [
                        type = "function",
                        name = "calculate",
                        description = "Calculate a mathematical expression using two numbers and an operator.",
                        parameters =
                            [
                                type = "object",
                                properties =
                                    [
                                        a =
                                            [
                                                type = "number",
                                                description = "The first number."
                                            ],

                                        b =
                                            [
                                                type = "number",
                                                description = "The second number."
                                            ],

                                        operator =
                                            [
                                                type = "string",
                                                description = "The mathematical operator: add, subtract, multiply, or divide."
                                            ]
                                    ],
                                required =
                                    {"a", "b", "operator"}
                            ]
                    ],

                function =
                    (arguments as record) =>
                        let
                            A =
                                arguments[a],

                            B =
                                arguments[b],

                            Operator =
                                arguments[operator],

                            Value =
                                if Operator = "add" then
                                    A + B
                                else if Operator = "subtract" then
                                    A - B
                                else if Operator = "multiply" then
                                    A * B
                                else if Operator = "divide" then
                                    if B = 0 then
                                        error "Cannot divide by zero."
                                    else
                                        A / B
                                else
                                    error
                                        "Unknown operator: "
                                        & Operator,

                            Result =
                                Text.FromBinary(
                                    Json.FromValue(
                                        [
                                            a = A,
                                            b = B,
                                            operator = Operator,
                                            result = Value
                                        ]
                                    )
                                )
                        in
                            Result
            ]
    ]
}
