()=>{
    [
    get_current_time =
        [
            definition =
                [
                    type = "function",
                    name = "get_current_time",
                    description = "get_current_time",
                    parameters =
                        [
                            type = "object",
                            properties = [],
                            required = {}
                        ]
                ],

            function =
                () =>
                    DateTimeZone.ToText(
                        DateTimeZone.FixedUtcNow(),
                        "yyyy-MM-ddTHH:mm:sszzz"
                    )
        ]
    ]
}
