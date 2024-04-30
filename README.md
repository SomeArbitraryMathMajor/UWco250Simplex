# Note
This is only for educational purposes, all credits go towards the authors of the book

## Currently Included Content
- Formation of LP of form $Ax\text{ ?} b$ with objective function vector and equality constraints (? can denote $=$, $\geq$, or $\leq$)
- Canonical form computation for given LP and proposed basis
- Simplex computation for given LP
- Two-phase Simplex computation for given LP
- Duality transformation for given LP

## Need to add
- complementary slack conditions
- other algorithms included in the textbook (?)

## Example Usage
formulating an LP simple case:

$$\max\left\\{z(x)=v^{\top} x:Ax=b,x\geq 0 \right\\}$$

where

$$A=\begin{pmatrix}
1&1&-3&1&2\\
0&1&-2&2&-2\\
-2&-1&4&1&0
\end{pmatrix},\quad b=\begin{pmatrix}
7\\
-2\\
-3
\end{pmatrix},\quad v=\begin{pmatrix}
-1\\
0\\
3\\
7\\
-1
\end{pmatrix}$$

```
A <- rbind(
  c(1,1,-3,1,2),
  c(0,1,-2,2,-2),
  c(-2,-1,4,1,0)
)
b <- c(7,-2,-3)
v <- c(-1,0,3,7,-1)
LP <- form.LP(b=b, A=A, v=v)
```
formulating an LP with basis $B=\\{1,4\\}$ and initial $z$ value of $3$:

$$\begin{aligned}
    &\text{max}\qquad 3 + \begin{pmatrix}0 & -1 & -2 & 0 & -3\end{pmatrix}x\\
    \text{s.t.}\qquad&\\
    &\begin{pmatrix}
    1 & -2 & 1 & 0 & 2\\
    0 & 1 & -1 & 1 & 3
\end{pmatrix}x=\begin{pmatrix}
    2\\
    4
\end{pmatrix}\\
&\quad x \geq 0
\end{aligned}$$

```
B <- c(1,4)
A <- rbind(
  c(1,-2,1,0,2),
  c(0,1,-1,1,3)
)
b <- c(2,4)
v <- c(0,-1,-2,0,-3)
z <- 3
LP <- form.LP(B, b, A, v, z)
```
optimal solution exists for raw Simplex with given basis $B=\\{3,5\\}$:

$$\begin{aligned}
    &\text{max}\qquad \begin{pmatrix}-1 & 3 & -5 & 9 & 3\end{pmatrix}x\\
    \text{s.t.}\qquad&\\
    &\begin{pmatrix}
    4 & 1& 3 & -1 & -2\\
    3 & 1 & 2 & 0 & -1
\end{pmatrix}x=\begin{pmatrix}
    2\\
    3
\end{pmatrix}\\
&\quad x \geq 0
\end{aligned}$$

```
B <- c(3,5)
A <- rbind(
  c(4,1,3,-1,-2),
  c(3,1,2,0,-1)
)
b <- c(2,3)
v <- c(-1,3,-5,9,3)
LP <- form.LP(B, b, A, v)
simplex(LP)
```
unbounded LP under raw Simplex with basis $B=\\{2,3,5,6\\}$:

$$\begin{aligned}
    &\text{max}\qquad \begin{pmatrix}0 & 7 & -8 & -2 & -4 & -6\end{pmatrix}x\\
    \text{s.t.}\qquad&\\
    &\begin{pmatrix}
0 & -2 & 2 & 1 & 1 & 1 \\
2 & -3 & 3 & 0 & 2 & 4 \\
4 & -2 & 4 & -2 & 1 & 2 \\
3 & 4 & -3 & -4 & -2 & -1
\end{pmatrix}x=\begin{pmatrix}
    1\\
    9\\
    6\\
    2
\end{pmatrix}\\
&\quad x \geq 0
\end{aligned}$$

```
B <- c(2,3,5,6)
A <- rbind(
  c(0,-2,2,1,1,1),
  c(2,-3,3,0,2,4),
  c(4,-2,4,-2,1,2),
  c(3,4,-3,-4,-2,-1)
)
b <- c(1,9,6,2)
v <- c(0,7,-8,-2,-4,-6)
LP <- form.LP(B, b, A, v)
simplex(LP)
```
optimal solution exists under two-phase Simplex:

$$\begin{aligned}
    &\text{max}\qquad \begin{pmatrix}2 & -1 & 2\end{pmatrix}x\\
    \text{s.t.}\qquad&\\
    &\begin{pmatrix}
-1 & -2 & 1 \\
1 & -1 & 1
\end{pmatrix}x=\begin{pmatrix}
    -1\\
    3
\end{pmatrix}\\
&\quad x \geq 0
\end{aligned}$$

```
A <- rbind(
  c(-1,-2,1),
  c(1,-1,1)
)
b <- c(-1,3)
v <- c(2,-1,2)
LP <- form.LP(b=b, A=A, v=v)
twophase(LP)
```
finding dual of given LP simple case:

$$\begin{aligned}
    &\text{max}\qquad \begin{pmatrix}28 & -7 & 20\end{pmatrix}x\\
    \text{s.t.}\qquad&\\
    &\begin{pmatrix}
6 & -2 & 1 \\
-1 & 1 & 2 \\
4 & -1 & 3
\end{pmatrix}x\leq\begin{pmatrix}
    3\\
    3\\
    3
\end{pmatrix}\\
&\quad x \geq 0
\end{aligned}$$

```
A <- rbind(
  c(6,-2,1),
  c(-1,1,2),
  c(4,-1,3)
)
b <- c(3,3,3)
v <- c(28,-7,20)
LP <- form.LP(b=b, A=A, v=v, A.c=rep('<=',3))
dual(LP)
```
finding dual of given LP complex case:

$$\begin{aligned}
    &\text{max}\qquad \begin{pmatrix}53 & 52 & 51 & 54 & 55\end{pmatrix}x\\
    \text{s.t.}\qquad&\\
    &\begin{pmatrix}
    1 & 2 & 3 & 4 & 5 \\
    6 & 7 & 8 & 9 & 10 \\
    11 & 12 & 13 & 14 & 15
\end{pmatrix}x\text{ }\begin{matrix}
    =\\
    \geq\\
    \geq
\end{matrix}\begin{pmatrix}
    9\\
    15\\
    29
\end{pmatrix}\\
&\\
&\quad x_1\geq0,x_2\geq0,x_3\leq0,x_4\leq0,x_5\text{ free}
\end{aligned}$$

```
A <- matrix(1:15, ncol=5, nrow=3, byrow=T)
b <- c(9, 15, 29)
v <- c(53, 52, 51, 54, 55)
LP <- form.LP(b=b, A=A, v=v, A.c=c('=','>=','>='), x.c=c('>=0','>=0','<=0','<=0','free'))
dual(LP, opt=0)
```
