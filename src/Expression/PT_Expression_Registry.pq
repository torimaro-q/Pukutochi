let
    Shared =
        #shared,

    Names =
        Record.FieldNames(
            Shared
        ),

    PublicNames =
        List.Select(
            Names,
            (name) =>
                Text.StartsWith(
                    name,
                    "PT_"
                )
                and name <> "PT_Expression_Registry"
                and name <> "PT_Expression_List"
                and Value.Is(
                    Record.Field(
                        Shared,
                        name
                    ),
                    type function
                )
        ),

    Environment =
        Record.SelectFields(
            Shared,
            PublicNames
        )
in
    Environment
