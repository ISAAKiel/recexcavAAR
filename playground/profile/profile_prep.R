#Script for profile preparation -> distances/size stay the same, but the absolute position of the
#profile is changed

library(dplyr)

# input is a
# 0: normal profile (N-S, E-W), 1: diagonal profile (NE-SW, etc.),
diagswitch <- 1


#### load data ####
input <- read.table(
  "playground/profile/Profile_NW3.dat",
  stringsAsFactors = FALSE
)
M1 <- input[,c(4,6,8,2)]

rgl::plot3d(M1$V4, M1$V6, M1$V8)

M <- input[,c(4,6)]





#### rotation - if necessary ####
#Concept: http://stackoverflow.com/questions/15463462/rotate-graph-by-angle

#calculate rotation angle
alpha <- -atan(
  (M[1,2]-tail(M,1)[,2]) /
    (M[1,1]-tail(M,1)[,1])
)

#rotation matrix
rotm <- matrix(c(
  cos(alpha),
  sin(alpha),
  -sin(alpha),
  cos(alpha)),
  ncol=2
)

#shift, rotate, shift back
#shift points, so that turning point is (0,0)
M2.1 <- t(t(M)-c(M[1,1],M[1,2]))
plot(M2.1,col="blue")
#rotate
M2.2 <- t(rotm %*% (t(M2.1)))
points(M2.2,col="green")
# #shift back
# M2.3 <- t(t(M2.2)+c(M[1,1],M[1,2]))
# plot(M2.3,col="red")

#build export file
finalM <- data.frame(X = M2.2[,1], Y = M2.2[,2], Z = M1[,3], Code = M1[,4])
#plot(finalM$X, finalM$Y)
#plot(finalM$X, finalM$Z)
rgl::plot3d(finalM)




#### Transformation ####

# diagonal decision
if (diagswitch == 1) {
  M2 <- finalM
} else if (diagswitch == 0) {
  M2 <- data.frame(X = M1[,1]-min(M1[,1]), Y = M1[,2]-min(M1[,2]), Z = M1[,3], Code = M1[,4])
}
rgl::plot3d(M2)


#check position and orientation of the profile with the measurements of KS-U and KS-X
#set up a perfectly prepared data.frame for each case (including mirroring of the profile if necessary)
if (diff(c(min(M2$X),max(M2$X))) < diff(c(min(M2$Y),max(M2$Y)))) {
  print("Profile: |")
  if (filter(M2, Code == "1-KS-U")$Y < filter(M2, Code == "1-KS-X")$Y) {
    print("The profile is S-N-oriented - West Profile")
    M3 <- data.frame(Code = M2$Code, X = M2$Y, Y = M2$Z, Deviation = M2$X)
  } else {
    print("The profile is N-S-oriented - East Profile")
    M3 <- data.frame(Code = M2$Code, X = abs(M2$Y-max(M2$Y)), Y = M2$Z, Deviation = M2$X)
  }
} else {
  print("Profile: --")
  if (filter(M2, Code == "1-KS-U")$X < filter(M2, Code == "1-KS-X")$X) {
    print("The profile is W-E-oriented - North Profile")
    M3 <- data.frame(Code = M2$Code, X = M2$X, Y = M2$Z, Deviation = M2$Y)
  } else {
    print("The profile is E-W-oriented - South Profile")
    M3 <- data.frame(Code = M2$Code, X = abs(M2$X-max(M2$X)), Y = M2$Z, Deviation = M2$Y)
  }
}

#add point numbers again
M4 <- data.frame(M3, Number = input$V1)

#format data.frame and write into file system
M5 <- format(M4, nsmall=3)
# write.table(
#   M5,
#   file = "playground/profile/Profile_NW3_prep.txt",
#   sep="\t",
#   row.names = FALSE,
#   quote = FALSE
#   )
