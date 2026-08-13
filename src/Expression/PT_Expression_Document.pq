() as table =>
let
    Registry =
        PT_Expression_Registry,

    Names =
        List.Sort(
            Record.FieldNames(Registry)
        ),

    Rows =
        List.Combine(
            List.Transform(
                Names,

                (name) =>
                    let
                        Function =
                            Record.Field(
                                Registry,
                                name
                            ),

                        FunctionType =
                            Value.Type(
                                Function
                            ),

                        Parameters =
                            Type.FunctionParameters(
                                FunctionType
                            ),

                        ParameterNames =
                            Record.FieldNames(
                                Parameters
                            ),

                        ReturnType =
                            Type.FunctionReturn(
                                FunctionType
                            ),

                        ReturnTypeText = PT_Expression_TypeName(ReturnType)
                        
                    in
                        if List.IsEmpty(ParameterNames) then
                            {
                                [
                                    Name = name,
                                    Parameter = null,
                                    ParameterType = null,
                                    ReturnType = ReturnTypeText
                                ]
                            }
                        else
                            List.Transform(
                                ParameterNames,

                                (parameterName) =>
                                    [
                                        Name = name,

                                        Parameter =
                                            parameterName,

                                        ParameterType =
                                            PT_Expression_TypeName(
                                                Record.Field(
                                                    Parameters,
                                                    parameterName
                                                )
                                            ),

                                        ReturnType =
                                            ReturnTypeText
                                    ]
                            )
            )
        ),

    Result =
        Table.FromRecords(
            Rows
        ),

    Typed =
        Table.TransformColumnTypes(
            Result,
            {
                {"Name", type text},
                {"Parameter", type text},
                {"ParameterType", type text},
                {"ReturnType", type text}
            }
        )
in
    Typed
