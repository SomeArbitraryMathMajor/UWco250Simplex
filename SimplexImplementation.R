####################################
# SIMPLEX ALGORITHM IMPLEMENTATION #
####################################

require(MASS)

##########################
# LP Formation
##########################
form.LP <- function(B=NULL, b, A, v, z=0, A.c=rep('=',length(b)), x.c=rep('>=0',length(v))) {
  ## returns an LP formulation of Ax=b of type list
  ##    note it is assumed the LP is a maximization problem
  ##    default Ax=b, x>=0
  ## B is basis, default no basis
  ## z is obj val, default 0
  ## v is obj fn vector
  LP <- list(B, b, A, v, z, A.c, x.c)
  names(LP) <- c('basis', 'b', 'A', 'obj', 'z', 'A.cnstr', 'x.cnstr')
  return(LP)
}

# form.LP(b=b, A=A, v=v) # run an instance of LP formation

##########################
# Canonical Form
##########################
canonical <- function(LP) {
  ## returns the CF of a given LP
  A <- LP$A
  B <- LP$basis
  b <- LP$b
  v <- LP$obj
  z <- LP$z
  A.c <- LP$A.cnstr
  x.c <- LP$x.cnstr
  AB <- A[,B]
  ABinv <- solve(AB)
  A.new <- ABinv %*% A
  b.new <- ABinv %*% b
  yT <- t(v[B]) %*% ABinv
  z.new <- z + yT %*% b
  v.new <- v - yT %*% A
  temp <- lapply(
    list(B, b.new, A.new, v.new, z.new),
    round, digits=10) # round off small values
  form.LP(temp[[1]], temp[[2]], temp[[3]], temp[[4]], temp[[5]], A.c, x.c)
}

# canonical(LP) # run an instance of CF on LP

##########################
# Simplex Iterations
##########################
simplex <- function(LP) {
  ## returns either
  ##    (1) list of iter count, solved status, optimal solution, last LP; or
  ##    (2) list of iter count, solved status, certificate of unboundedness
  ## use Bland's rule
  i = 0 # counter for iteration
  LP <- canonical(LP)
  while(T) {
    v <- LP$obj
    b <- LP$b
    basis <- LP$basis
    pos.idx <- which(v > 0)
    if (length(pos.idx) == 0) { # optimal soln
      xbar <- replace(rep(0, length(v)), basis, b)
      out <- list(i, T, fractions(xbar),
                  append(lapply(LP[1:5], fractions), LP[6:7]))
      names(out) <- c('iteration','solved','xbar','LP')
      return(out)
    }
    k <- pos.idx[1] # first k s.t. v[k] > 0 
    A <- LP$A
    if (all(A[,k] <= 0)) {
      s <- replace(rep(0, length(v)), basis, b)
      d <- -replace(rep(0, length(v)), basis, A[,k])
      d <- replace(d, pos.idx, rep(1,length(pos.idx)))
      out <- list(i, F, cbind(s,d))
      names(out) <- c('iteration','solved','certificate of unboundedness')
      return(out)
    }
    ratios <- b/A[,k]
    t <- min(ratios[ratios > 0])
    r <- which(ratios == t)[1]
    basis.new <- sort(c(basis[-r], k)) # B U {k}\{l}
    # recursive update on LP
    LP$basis <- basis.new
    LP <- canonical(LP)
    i = i + 1
  }
}

# simplex(LP) # run an instance of simplex on LP

##########################
# Two-phase Simplex
##########################
twophase <- function(LP) {
  ## returns same output as simplex
  ## phase I
  A <- LP$A
  b <- LP$b
  v <- LP$obj
  z <- LP$z
  A.c <- LP$A.cnstr
  x.c <- LP$x.cnstr
  v.aux <- replace(
    rep(0, length(v) + length(b)),
    (length(v) + 1):(length(v) + length(b)),
    rep(-1, length(b))
  )
  idx <- which(b < 0)
  b.aux <- abs(b)
  if (length(idx) != 0) {
    A[idx,] = -1*A[idx,]
  }
  A.aux <- cbind(A, diag(length(b)))
  B.aux <- which(v.aux < 0)
  LP.aux <- form.LP(B.aux, b.aux, A.aux, v.aux, z, A.c, x.c)
  BFS <- simplex(canonical(LP.aux)) # solve aux problem
  if (!BFS$solved) { # aux problem no optimal soln
    print('No basic feasible solution, stop at Phase I')
    return(BFS)
  }
  ## phase II
  basis <- BFS$LP$basis # new basis for original LP
  LP$basis <- basis
  simplex(canonical(LP))
}

# twophase(LP) # run an instance of two-phase simplex on LP

##########################
# Duality
##########################
dual <- function(LP, opt=1) {
  ## returns the dual of given LP
  ##    note opt=1 is max, 0 is min
  ##    cannot solve dual problems yet
  v.dual <- LP$b
  b.dual <- LP$obj
  A.c <- LP$A.cnstr
  x.c <- LP$x.cnstr
  A.dual <- t(LP$A)
  A.dual.c <- c()
  x.dual.c <- c()
  if (opt == 0) { # if min LP
    for (i in A.c) {
      if (i == '>=') {
        x.dual.c <- c(x.dual.c, '>=0')
      } else if (i == '=') {
        x.dual.c <- c(x.dual.c, 'free')
      } else {
        x.dual.c <- c(x.dual.c, '<=0')
      }
    }
    for (i in x.c) {
      if (i == '>=0') {
        A.dual.c <- c(A.dual.c, '<=')
      } else if (i == 'free') {
        A.dual.c <- c(A.dual.c, '=')
      } else {
        A.dual.c <- c(A.dual.c, '>=')
      }
    }
  } else { # otherwise LP is max
    for (i in A.c) {
      if (i == '<=') {
        x.dual.c <- c(x.dual.c, '>=0')
      } else if (i == '=') {
        x.dual.c <- c(x.dual.c, 'free')
      } else {
        x.dual.c <- c(x.dual.c, '<=0')
      }
    }
    for (i in x.c) {
      if (i == '>=0') {
        A.dual.c <- c(A.dual.c, '>=')
      } else if (i == 'free') {
        A.dual.c <- c(A.dual.c, '=')
      } else {
        A.dual.c <- c(A.dual.c, '<=')
      }
    }
  }
  form.LP(LP$basis, b.dual, A.dual, v.dual, LP$z, A.dual.c, x.dual.c)
}

# dual(LP, opt=0) # run an instance of dual on min LP



