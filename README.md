# Note
This is only for educational purposes, all credits go towards the authors of the book

## Currently Included Content:
- Formation of LP of form Ax?b with objective function vector and equality constraints (? can denote =, >=, or <=)
- Canonical form computation for given LP and proposed basis
- Simplex computation for given LP
- Two-phase Simplex computation for given LP
- Duality transformation for given LP

## Need to add:
- complementary slack conditions
- other algorithms included in the textbook (?)

## Example Usage:
formulating an LP simple case
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
formulating an LP with basis and initial $z$ value
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
optimal solution exists for raw Simplex
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
