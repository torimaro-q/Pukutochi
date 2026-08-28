(message as text, api_key as text, model_name as text, system_prompt as text, optional interaction_id as nullable text) as record =>
let
    MaxSteps = 10,
    gyaru_prompt = system_prompt  & " in a gyaru-like style.",
    // ============================================================
    // debug
    // message        = "How is the weather in Tokyo today?",
    // api_key        = gemini_key,
    // model_name     = "gemini-3.5-flash",
    // system_prompt  = "", 
    // interaction_id = null,
    // ============================================================
    ExpTools    = PT_GA_ExpTools(),
    ToolRecords =
        Record.Combine(
            ExpTools
    ),
    Tools =
        List.Transform(
            Record.FieldValues(
                ToolRecords
            ),
            each _[definition]
        ),
    // ============================================================
    SendRequest =
        (
            input as any,
            optional previous_id as nullable text
        ) as record =>
        let
            BaseBody =
                [
                    model = model_name,
                    input = input,
                    system_instruction = gyaru_prompt,
                    tools = Tools
                ],
            Body =
                if previous_id <> null then
                    Record.AddField(
                        BaseBody,
                        "previous_interaction_id",
                        previous_id
                    )
                else
                    BaseBody,
            Raw = Web.Contents(
                    "https://generativelanguage.googleapis.com",
                    [
                        RelativePath = "v1beta/interactions",
                        Headers = [
                            #"x-goog-api-key" = api_key,
                            #"Content-Type" = "application/json"
                        ],
                        Content = Json.FromValue(Body)
                    ]
                ),
            Response = Json.Document(Raw)
        in
            Response,
    // ============================================================
    GetFunctionCall =
        (response as record) as nullable record =>
        let
            steps =
                Record.FieldOrDefault(
                    response,
                    "steps",
                    {}
                ),

            calls =
                List.Select(
                    steps,
                    each
                        Record.FieldOrDefault(
                            _,
                            "type",
                            null
                        ) = "function_call"
                ),

            call =
                if List.IsEmpty(calls) then
                    null
                else
                    List.First(calls)
        in
            call,
    // ============================================================
    ExecuteFunction =
        (call as record) as text =>
        let
            Tool =
                Record.FieldOrDefault(
                    ToolRecords,
                    call[name],
                    null
                ),

            Arguments =
                Record.FieldOrDefault(
                    call,
                    "arguments",
                    []
                ),

            result =
                if Tool = null then
                    error
                        "Unknown function: "
                        & call[name]
                else
                    Tool[function](Arguments)
        in
            result,
    // ============================================================
    SendFunctionResult =
        (
            response as record,
            call as record,
            function_result as text
        ) as record =>
        let
            input =
            {
                [
                    type = "function_result",
                    name = call[name],
                    call_id = call[id],
                    result =
                    {
                        [
                            type = "text",
                            text = function_result
                        ]
                    }
                ]
            },

            next_response =
                SendRequest(
                    input,
                    response[id]
                )
        in
            next_response,
    // ============================================================
    RunInteraction =
        (
            response as record,
            step as number
        ) as record =>
        let
            call =
                GetFunctionCall(response),

            result =
                if call = null then
                    [
                        Response = response,
                        #"no." = step + 1
                    ]

                else if step >= MaxSteps then
                    error
                        "Maximum function calling steps exceeded."

                else
                    let
                        function_result =
                            ExecuteFunction(call),

                        next_response =
                            SendFunctionResult(
                                response,
                                call,
                                function_result
                            )
                    in
                        @RunInteraction(
                            next_response,
                            step + 1
                        )
        in
            result,
    // ============================================================
    InitialResponse =
        SendRequest(
            message,
            interaction_id
        ),
    // check = InitialResponse[steps]{1},
    // ============================================================
    FinalResponse =
        RunInteraction(
            InitialResponse,
            0
        )

in
    FinalResponse
