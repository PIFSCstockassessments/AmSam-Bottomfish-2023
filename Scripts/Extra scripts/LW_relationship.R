


f1 <- function(x) 0.0147*x^3.003
f2 <- function(x) 0.0241*x^2.89
f3 <- function(x) 0.0118*x^3.043

ggplot()+xlim(0,90)+geom_function(fun=f1,col="green")+geom_function(fun=f2,col="red")+geom_function(fun=f3,col="blue")

                                  