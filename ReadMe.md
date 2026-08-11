# Pukutochi

**Numerical computing and machine learning in Power Query (M).**

> **Power Query is a perfectly reasonable place for numerical computing.**

> 🇯🇵 **Power Queryは、数値計算を行うのに非常に適した環境です。**

Pukutochi（プクトーチ）は、Power Query / M language向けの数値計算・機械学習ライブラリです。

Pukutochi provides reusable building blocks for:

* Linear algebra
* Regression
* Ordinary differential equations
* Neural networks
* Numerical optimization and machine learning

すべてPower Query / Mで実装されています。

---

## PyTorch?

**No.**

Pukutochi is an independent open-source project and is not affiliated with, sponsored by, endorsed by, or otherwise associated with PyTorch or the PyTorch Foundation.

It is not a port, fork, wrapper, or reimplementation of PyTorch.

> 🇯🇵 PukutochiはPyTorchとは無関係の独立したOSSプロジェクトです。
>
> PyTorchの移植・フォーク・ラッパー・再実装ではありません。

The name is just the name.

> **Pukutochi is Pukutochi.**

---

## Features / 機能

### Linear Algebra / 線形代数

Basic vector and matrix operations:

```text id="g9yn7e"
PT_LA_Dot
PT_LA_MatOp
PT_LA_MatVec
PT_LA_MatVecT
PT_LA_OuterProduct
PT_LA_Scale
PT_LA_Cholesky
PT_LA_ForwardSub
PT_LA_BackSub
```

Includes Cholesky decomposition and triangular system solvers.

---

### Regression / 回帰

Linear regression using the normal equation and Cholesky decomposition.

```text id="ik2i7j"
PT_Regression_DesignMatrix
PT_Regression_NormalEquation
PT_Regression_LinearFit
PT_Regression_Predict
```

---

### ODE / 常微分方程式

Fourth-order Runge-Kutta (RK4) solver.

```text id="u9y5d5"
PT_ODE_RK4Step
PT_ODE_RK4Solve
PT_ODE_RK4ToTable
```

The included example demonstrates the Lorenz system.

---

### Neural Networks / ニューラルネットワーク

A lightweight neural network implementation in M.

Supported components include:

* Dense layers
* Forward propagation
* Backpropagation
* Gradient descent
* ReLU
* Tanh
* Softmax
* Mean Squared Error
* Cross Entropy
* Classification
* Regression

```text id="iq3b7e"
PT_NN_CreateLayer
PT_NN_Forward
PT_NN_Backward
PT_NN_TrainClassification
PT_NN_TrainRegression
```

---

## Quick Start / 使い方

### XOR Classification / XOR分類

A small neural network can learn the XOR function directly in Power Query.

```pq id="g9p5f3"
Dataset =
    {
        [x = {0.0, 0.0}, t = {1.0, 0.0}],
        [x = {0.0, 1.0}, t = {0.0, 1.0}],
        [x = {1.0, 0.0}, t = {0.0, 1.0}],
        [x = {1.0, 1.0}, t = {1.0, 0.0}]
    };

Network =
    {
        PT_NN_CreateLayer(
            2,
            4,
            PT_NN_Tanh,
            PT_NN_TanhPrime
        ),

        PT_NN_CreateLayer(
            4,
            2,
            PT_NN_Softmax,
            null
        )
    };

Training =
    PT_NN_TrainClassification(
        Network,
        Dataset,
        2000,
        0.1
    );
```

> **Power Query learns XOR.**
>
> 🇯🇵 **Power QueryがXORを学習します。**

---

## Nonlinear Regression / 非線形回帰

Neural networks can also be used for nonlinear regression.

Example:

```text id="8f4zh4"
y = sin(x)
```

Network:

```text id="iv0zlw"
Input
  │
  ▼
Dense(1 → 4) + Tanh
  │
  ▼
Dense(4 → 4) + Tanh
  │
  ▼
Dense(4 → 1) + Linear
```

All computations are performed in Power Query.

---

## Project Structure / プロジェクト構成

```text id="qf2g2h"
Pukutochi
│
├── PT_LA_*
│   └── Linear Algebra
│
├── PT_Regression_*
│   └── Regression
│
├── PT_ODE_*
│   └── ODE / RK4
│
└── PT_NN_*
    └── Neural Networks
```

`PT_` is the function prefix used by Pukutochi.

---

## Why Power Query? / なぜPower Query？

Power Query provides:

* A functional language
* Rich list and record operations
* Built-in data transformation
* Integration with Power BI and Excel
* A natural environment for data-oriented computation

Pukutochi extends this environment with numerical computing and machine learning primitives.

> 🇯🇵 Power Queryのデータ処理能力と数値計算・機械学習を組み合わせることで、データ取得からモデル計算までを同一環境で扱えます。

**It is a reasonable choice.**

---

## Limitations / 制限事項

Pukutochi is designed primarily for experimentation, education, and small-scale analytical workloads.

For large-scale numerical computing or machine learning, specialized frameworks may provide better performance and hardware acceleration.

Pukutochi currently focuses on:

* Readable M implementations
* Self-contained algorithms
* Power Query integration
* Experimentation and learning

---

## Status / ステータス

**Experimental / Early Stage**

The API and implementation may change as the project evolves.

---

## Contributing / コントリビュート

Issues, ideas, experiments, benchmarks, bug reports, and pull requests are welcome.

Contributions related to:

* Numerical algorithms
* Linear algebra
* Optimization
* Machine learning
* Performance
* M language
* Tests and examples

are especially welcome.

---

## License / ライセンス

See [LICENSE](LICENSE).

---

## Name / 名前

**Pukutochi（プクトーチ）**

Pukutochi is Pukutochi.

> 🇯🇵 プクトーチは、プクトーチです。
