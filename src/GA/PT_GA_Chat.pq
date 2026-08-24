(message as text, api_key as text, model_name as text, systemPrompt as text, optional interactionId as nullable text) =>
let
    GyaruPrompt =
        systemPrompt  & " in a gyaru-like style.",

    Body =
        if interactionId = null then
            [
                model = model_name,
                input = message,
                system_instruction = GyaruPrompt
            ]
        else
            [
                model = model_name,
                input = message,
                previous_interaction_id = interactionId
            ],

    Raw =
        Web.Contents(
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

    Json =
        Json.Document(Raw),

    NewInteractionId =
        Json[id],

    Steps =
        Json[steps],

    ModelOutput =
        List.First(
            List.Select(
                Steps,
                each [type] = "model_output"
            )
        ),

    Content =
        ModelOutput[content],

    TextContent =
        List.First(
            List.Select(
                Content,
                each [type] = "text"
            )
        ),

    Answer =
        TextContent[text]
in
    [
        Answer = Answer,
        InteractionId = NewInteractionId
    ]
