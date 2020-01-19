# Pascoletti Sarafini scalarization

*ps_solver.m*: This is a matlab implementation of the pascoletti sarafini scalarization.

Given a multiobjective optimisation problem (MOP):

(MOP) `min C·x
s.t.`

`A·x ≦ b`

`x≧0`

`x∊ℝ^n, C∊ℝ^{nxQ}, A∊ℝ^{mxn}, b∊ℝ^m`

We can use the Pascoletti Serafini (PS(a,r)), to iteratively find out all weakly non-dominated points:

(PS(a,r)) `min t`

`s.t. a + t·r - f(x) ∊ ℝ^Q_≧`

`x∊S, a∊ℝ^Q, r∊ℝ^Q`

- choose r∊ℝ^Q_> to always attain a solution
- choose a∊ℝ^Q to be all points on hyperplane with negative gradient intersecting the Ideal point of (MOP)
  - limit the hyperplane at the lexmins
