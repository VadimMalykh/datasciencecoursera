D <- function(N) {
  X = data.frame()
  for (i in 1:N) {
    X = rbind(X, c(runif(1, min=-1, max=1), runif(1, min=-1, max=1)))
  }
  names(X) = c("X1", "X2")
  return(X)
}

getLine <- function(x1, x2) {
  m = (x2[2] - x1[2]) / (x2[1] - x1[1])
  b = -m * x1[1] + x1[2]
  return(c(b, m))  
}

getClass <- function(x, line) {
  if (x[2] > line[2] * x[1] + line[1]) return(1)
  else return(-1)
}

linearD <- function(df, line) {
  # get random line
  x1 = runif(2, min=-1, max=1)
  x2 = runif(2, min=-1, max=1)
  
  if (is.null(line)) {
    # get line in form y = mx + b
    line = getLine(x1, x2)
  }
  
  # label points above line as 1 and below line as -1
  y = c()
  for (i in 1:nrow(df)) {
    x = df[i,]
    y[i] = getClass(x, line)
  }
  
  df = cbind(df, Y=y)
  return(df)
}

quadraticD <- function(df) {
  # get random point
  c = runif(2, -1, 1)
  # get random radius
  r = runif(1, 0.2, 0.8)
  
  y = c()
  for(i in 1:nrow(df)) {
    x = df[i,]
    if (((x[1]-c[1])^2 + (x[2]-c[2])^2) < r^2) {
      y[i] = 1
    }
    else {
      y[i] = -1
    }
  }
  
  df = cbind(df, Y=y)
  return(df)
}

sinusoidalD <- function(df) {
  # bet random basis point
  b = runif(2, -1, 1)
  # get random frequency
  f = runif(1, 2, 10)
  # get random amplitude
  a = runif(1, 0.1, 1)
  
  y = c()
  for(i in 1:nrow(df)) {
    x = df[i,]
    if (x[2] > (b + a * sin(x[1]*f))) {
      y[i] = 1
    }
    else {
      y[i] = -1
    }
  }
  
  df = cbind(df, Y=y)
  return(df)
}

generateDF <- function(dataType, size, noise) {
  if (dataType == "linear") {
    line <- getLine(runif(2, -1, 1), runif(2, -1, 1))
    df <- linearD(D(size), line)
  }
  else if (dataType == "quadratic") {
    df <- quadraticD(D(size))
  }
  else {
    df <- sinusoidalD(D(size))
  }
  if (noise > 0) {
    rows = sample(1:nrow(df), nrow(df)*noise)
    df$Y[rows] = -df$Y[rows]
  }
  return(df)
}

learnSVMModel <- function(df) {
  X1 = rep(seq(-0.98, 0.98, length.out=48), times=48)
  X2 = rep(seq(-0.98, 0.98, length.out=48), each=48)
  test = data.frame(X1, X2)
  model <- svm(df[, 1:2], df[, 3])
  Y <- predict(model, newdata=test)
  Y[Y<0] = -1
  Y[Y>=0] = 1
  return(list(cbind(test, Y), model$index))
}
