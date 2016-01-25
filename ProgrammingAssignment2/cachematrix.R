## when there is repetitive use of Mtrix inversion computation
## caching can be helpful

## function which creates a matrix which can be cached

makeCacheMatrix <- function(x = matrix()) {
      inverse1 <- NULL
    set <- function(y) {
      x <<- y
      inverse1 <<- NULL
    }
    get <- function() x
    setInverse <- function(inverse) inverse1 <<- inverse
    getInverse <- function() inverse1
    list(set = set,
         get = get,
         setInverse = setInverse,
         getInverse = getInverse)
  
}


## inverse computation

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  inverse1 <- x$getInverse()
  if (!is.null(inverse1)) {
    message("getting cached data")
    return(inverse1)
  }
  mat <- x$get()
  inv <- solve(mat, ...)
  x$setInverse(invverse1)
  inverse1
  
}
