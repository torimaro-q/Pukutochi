(message as text, api_key as text, model_name as text, system_prompt as text, optional interaction_id as nullable text) as record =>
let
    // ============================================================
    // debug
    // message        = "what time is it now ?",
    // api_key        = gemini_key,
    // model_name     = "gemini-3.5-flash-lite",
    // system_prompt  = "",
    // interaction_id = null,
    // ============================================================

    CoreResult =
        PT_GA_Core(
            message,
            api_key,
            model_name,
            system_prompt,
            interaction_id
        ),

    Response =
        CoreResult[Response],

    No =
        CoreResult[#"no."],
    // ============================================================
    Steps =
        Record.FieldOrDefault(
            Response,
            "steps",
            {}
        ),
    TextSteps =
        List.Select(
            Steps,
            each
                Record.FieldOrDefault(
                    _,
                    "type",
                    null
                ) = "model_output"
        ),
    LastContent =
        if List.IsEmpty(TextSteps) then
            {}
        else
            Record.FieldOrDefault(
                List.Last(TextSteps),
                "content",
                {}
            ),
    LastText =
        if List.IsEmpty(LastContent) then
            null
        else
            Record.FieldOrDefault(
                List.First(LastContent),
                "text",
                null
            ),
    // ============================================================
    Result =
        [
            #"no." = No,
            output = LastText,
            InteractionId =
                Record.FieldOrDefault(
                    Response,
                    "id",
                    null
                )
        ]
in
    Result
