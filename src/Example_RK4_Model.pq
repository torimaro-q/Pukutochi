let
    // ============================================================
    // 1. Define the Lorenz system
    //
    //     dx/dt = sigma * (y - x)
    //     dy/dt = x * (rho - z) - y
    //     dz/dt = x * y - beta * z
    //
    // This is a classic nonlinear dynamical system.
    // The Lorenz system is known for its chaotic behavior.
    // ============================================================

    Lorenz =
        (x as list) as list =>
        let
            sigma = 10.0,
            rho   = 28.0,
            beta  = 8.0 / 3.0,

            dx =
                sigma
                * (x{1} - x{0}),

            dy =
                x{0}
                * (rho - x{2})
                - x{1},

            dz =
                x{0}
                * x{1}
                - beta * x{2}
        in
            {
                dx,
                dy,
                dz
            },

    // ============================================================
    // 2. Set the differential equation
    //
    // PT_ODE_RK4Solve expects a function of the form:
    //
    //     f(x) -> dx/dt
    //
    // Here:
    //
    //     x = {x, y, z}
    //
    // and the function returns:
    //
    //     {dx/dt, dy/dt, dz/dt}
    // ============================================================

    f =
        Lorenz,

    // ============================================================
    // 3. Solve the ODE using fourth-order Runge-Kutta (RK4)
    //
    // Step size:
    //     h = 0.05
    //
    // Number of steps:
    //     1000
    //
    // Initial condition:
    //     {1, 1, 1}
    //
    // The solver returns a sequence containing:
    //
    //     step
    //     t
    //     x
    //
    // for every time step.
    // ============================================================

    solution =
        PT_ODE_RK4Solve(
            f,
            0.05,
            1000,
            {1, 1, 1}
        ),

    // ============================================================
    // 4. Convert the RK4 sequence into a table
    //
    // The state vector:
    //
    //     {x, y, z}
    //
    // is expanded into separate columns:
    //
    //     x1, x2, x3
    //
    // together with:
    //
    //     step
    //     t
    //
    // This makes the result convenient for Power BI
    // visualization and further analysis.
    // ============================================================

    result =
        PT_ODE_RK4ToTable(
            solution
        )

in
    result
