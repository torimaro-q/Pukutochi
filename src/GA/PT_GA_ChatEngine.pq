(ApiKey as text, Model as text, SystemPrompt as text, InputTableName as text, OutputTableName as text) =>
let
    // ============================================================
    // ApiKey          = gemini_key,
    // Model           = "gemini-3.5-flash",
    // SystemPrompt    = "",
    // InputTableName  = "Input",
    // OutputTableName = "Example_GA_Chat",
    // ============================================================
    cleanTable =
        (tb) =>
            Table.SelectRows(
                tb,
                each
                    not List.IsEmpty(
                        List.RemoveMatchingItems(
                            Record.FieldValues(_),
                            {"", null}
                        )
                    )
            ),

    // ============================================================
    // User
    // ============================================================
    UserTable =
        try
            Excel.CurrentWorkbook(){[Name = InputTableName]}[Content]
        otherwise
            #table(
                {"input"},
                {}
            ),

    RemovedU =
        cleanTable(UserTable),

    // ============================================================
    // Response
    // ============================================================
    ResponseTable =
        try
            Excel.CurrentWorkbook(){[Name = OutputTableName]}[Content]
        otherwise
            #table(
                {"no.", "output", "InteractionId"},
                {}
            ),

    RemovedR =
        cleanTable(ResponseTable),

    // ============================================================
    // State
    // ============================================================
    UserCount =
        Table.RowCount(RemovedU),

    ResponseCount =
        Table.RowCount(RemovedR),

    HasPending =
        UserCount > ResponseCount,

    // ============================================================
    // Latest User Message
    // ============================================================
    LatestUserMessage =
        if HasPending then
            RemovedU[input]{UserCount - 1}
        else
            null,

    // ============================================================
    // Previous Interaction
    // ============================================================
    PreviousInteractionId =
        if ResponseCount > 0 then
            RemovedR[InteractionId]{ResponseCount - 1}
        else
            null,

    // ============================================================
    // Gemini
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
    // New Response
    // ============================================================
    NewResponse =
        if not HasPending then
            #table(
                {"no.", "output", "InteractionId"},
                {}
            )
        else
            Table.FromRecords(
                {Gemini}
            ),

    // ============================================================
    // Result
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
