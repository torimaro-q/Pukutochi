(ApiKey as text,Model as text,SystemPrompt as text,InputTableName as text, OutputTableName as text) =>
let    
    cleanTable = (tb) => Table.SelectRows(tb,each
                not List.IsEmpty(
                    List.RemoveMatchingItems(
                        Record.FieldValues(_),
                        {"", null}
                    )
                )
        ),
    // ============================================================
    UserTable = 
        try 
            Excel.CurrentWorkbook(){[Name = InputTableName]}[Content] 
        otherwise 
            #table(
                {"input"},
                {}
            ),
    RemovedU = cleanTable(UserTable),
    // ============================================================
    ResponseTable =
        try
            Excel.CurrentWorkbook(){[Name = OutputTableName]}[Content]
        otherwise
            #table(
                {"no.", "output", "InteractionId"},
                {}
            ),
    RemovedR = cleanTable(ResponseTable),
    // ============================================================
    UserCount     = Table.RowCount(RemovedU),
    ResponseCount = Table.RowCount(RemovedR),
    HasPending    = UserCount > ResponseCount,
    // ============================================================
    LatestUserMessage =
        if HasPending then
            RemovedU[input]{UserCount - 1}
        else
            null,
    // ============================================================
    PreviousInteractionId =
        if ResponseCount > 0 then
            RemovedR[InteractionId]{ResponseCount - 1}
        else
            null,
    // ============================================================
    Gemini =
        if HasPending then
            PT_GA_Chat(
                LatestUserMessage,
                ApiKey,
                Model,
                SystemPrompt,
                PreviousInteractionId
            )
        else
            null,
    // ============================================================
    NewResponse =
        if not HasPending then
            #table(
                {"no.", "output", "InteractionId"},
                {}
            )
        else
            #table(
                {"no.", "output", "InteractionId"},
                {
                    {
                        UserCount,
                        Gemini[Answer],
                        Gemini[InteractionId]
                    }
                }
            ),
    // ============================================================
    Result =
        if ResponseCount = 0 then
            NewResponse
        else
            Table.Combine(
                {
                    ResponseTable,
                    NewResponse
                }
            )
in
    Result
