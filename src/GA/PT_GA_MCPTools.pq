(endpoint as text, optional headers as nullable record) =>
let
    Headers =
        if headers = null then
            []
        else
            headers,

    // ------------------------------------------------------------
    // MCP request
    // ------------------------------------------------------------
    MCPRequest =
        (
            method as text,
            params as nullable record,
            optional previousSessionId as nullable text
        ) as record =>
        let
            RequestBody =
                [
                    jsonrpc = "2.0",
                    id = 1,
                    method = method,
                    params =
                        if params = null then
                            []
                        else
                            params
                ],

            ResponseBinary =
                Web.Contents(
                    endpoint,
                    [
                        Headers =
                            Record.Combine(
                                {
                                    [
                                        #"Content-Type" = "application/json",
                                        Accept = "application/json, text/event-stream"
                                    ],
                                    Headers
                                }
                            ),
                        Content =
                            Json.FromValue(RequestBody)
                    ]
                ),

            Response =
                Json.Document(ResponseBinary)
        in
            Response,

    // ------------------------------------------------------------
    // MCP initialize
    // ------------------------------------------------------------
    InitializeResponse =
        MCPRequest(
            "initialize",
            [
                protocolVersion = "2025-06-18",
                capabilities = [],
                clientInfo =
                    [
                        name = "PowerQuery-MCP-Client",
                        version = "1.0.0"
                    ]
            ]
        ),

    // ------------------------------------------------------------
    // MCP tools/list
    // ------------------------------------------------------------
    ToolsResponse =
        MCPRequest(
            "tools/list",
            []
        ),

    MCPTools =
        ToolsResponse[result][tools],

    // ------------------------------------------------------------
    // MCP tool call
    // ------------------------------------------------------------
    CallTool =
        (
            toolName as text,
            arguments as record
        ) as text =>
        let
            Response =
                MCPRequest(
                    "tools/call",
                    [
                        name = toolName,
                        arguments = arguments
                    ]
                ),

            Result =
                Response[result],

            TextResult =
                Text.FromBinary(
                    Json.FromValue(Result)
                )
        in
            TextResult,

    // ------------------------------------------------------------
    // Convert MCP tool ¨ existing ToolRecord format
    // ------------------------------------------------------------
    ConvertedTools =
        List.Transform(
            MCPTools,
            (tool as record) =>
                let
                    Name =
                        tool[name],

                    Description =
                        Record.FieldOrDefault(
                            tool,
                            "description",
                            ""
                        ),

                    InputSchema =
                        Record.FieldOrDefault(
                            tool,
                            "inputSchema",
                            [
                                type = "object",
                                properties = [],
                                required = {}
                            ]
                        ),

                    ToolRecord =
                        Record.FromList(
                            {
                                [
                                    definition =
                                        [
                                            type = "function",
                                            name = Name,
                                            description = Description,
                                            parameters = InputSchema
                                        ],

                                    function =
                                        (arguments as record) =>
                                            CallTool(
                                                Name,
                                                arguments
                                            )
                                ]
                            },
                            {Name}
                        )
                in
                    ToolRecord
        )
in
    ConvertedTools
