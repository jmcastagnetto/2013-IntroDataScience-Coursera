
train <- 
  read.table("/home/jesus/devel/bitbucket/introdatascience/peer_review-kaggle_titanic/train.csv",
   header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
library(relimp, pos=4)
showData(train, placement='-20+200', font=getRcmdr('logFont'), maxwidth=80, 
  maxheight=30, suppress.X11.warnings=FALSE)
save("train", 
  file="/home/jesus/devel/bitbucket/introdatascience/peer_review-kaggle_titanic/train.RData")
scatterplotMatrix(~age+fare+parch+pclass+sibsp+survived | sex, reg.line=lm, 
  smooth=TRUE, spread=TRUE, span=0.5, diagonal= 'boxplot', by.groups=TRUE, 
  data=train)
library(lattice, pos=4)
xyplot(survived ~ age + fare + parch + pclass + sibsp |  embarked + sex,
 
  outer=TRUE, layout=c( 8 * 5 , 1 ) , between=list(x=c( 0,0,0,0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 ), y=1), pch=16,
 
  auto.key=list(border=TRUE), par.settings = simpleTheme(pch=16), 
  scales=list(x=list(relation='same'), y=list(relation='same')),
 data=train)
library(ggplot2, pos=4)
GLM.1 <- glm(survived ~ age + embarked + fare + parch + pclass + sex + 
  sibsp, family=binomial(logit), data=train)
summary(GLM.1)
GLM.2 <- glm(survived ~ age + pclass + sex + 
  sibsp, family=binomial(logit), data=train)
summary(GLM.2)
Confint(GLM.1, level=0.95, type="LR")
oldpar <- par(oma=c(0,0,3,0), mfrow=c(2,2))
plot(GLM.1)
par(oldpar)
outlierTest(GLM.2)
Confint(GLM.2, level=0.95, type="LR")
anova(GLM.1, GLM.2, test="Chisq")
oldpar <- par(oma=c(0,0,3,0), mfrow=c(2,2))
plot(GLM.2)
par(oldpar)
stepwise(GLM.2, direction='backward/forward', criterion='BIC')
summary(train)
stepwise(GLM.2, direction='forward', criterion='AIC')
influencePlot(GLM.2)
library(effects, pos=4)
trellis.device(theme="col.whitebg")
plot(allEffects(GLM.2), ask=FALSE)
vif(GLM.2)
library(aplpack, pos=4)
.Table <- table(train$embarked)
.Table  # counts for embarked
round(100*.Table/sum(.Table), 2)  # percentages for embarked
.Table <- table(train$sex)
.Table  # counts for sex
round(100*.Table/sum(.Table), 2)  # percentages for sex
remove(.Table)
sapply(train, function(x)(sum(is.na(x)))) # NA counts
library(Hmisc, pos=4)
rcorr.adjust(train[,c("age","fare","parch","pclass","sibsp","survived")], type="pearson")
GLM.3 <- glm(survived ~ age + parch + 
  sibsp, family=binomial(logit), data=train)
summary(GLM.3)
anova(GLM.3, GLM.2, test="Chisq")
train$fitted.GLM.2 <- fitted(GLM.2)
train$residuals.GLM.2 <- residuals(GLM.2)
train$rstudent.GLM.2 <- rstudent(GLM.2)
train$hatvalues.GLM.2 <- hatvalues(GLM.2)
train$cooks.distance.GLM.2 <- cooks.distance(GLM.2)
train$obsNumber <- 1:nrow(train)
showData(train, placement='-20+200', font=getRcmdr('logFont'), maxwidth=80, maxheight=30, 
  suppress.X11.warnings=FALSE)
trellis.device(theme="col.whitebg")
plot(allEffects(GLM.2), ask=FALSE)
trellis.device(theme="col.whitebg")
plot(allEffects(GLM.3), ask=FALSE)
names(train)
fix(train)
load("/home/jesus/devel/bitbucket/introdatascience/peer_review-kaggle_titanic/train.RData")
showData(train, placement='-20+200', font=getRcmdr('logFont'), maxwidth=80, maxheight=30, 
  suppress.X11.warnings=FALSE)
train$lived <- factor(train$survived, labels=c('no','yes'))
MLM.3 <- multinom(lived ~ parch + pclass + age + embarked + fare + sex + sibsp, data=train, 
  trace=FALSE)
summary(MLM.3, cor=FALSE, Wald=TRUE)
trellis.device(theme="col.whitebg")
plot(allEffects(MLM.3), ask=FALSE)
GLM.5 <- glm(lived ~ age + pclass + sex + sibsp, 
  family=binomial(logit), data=train)
summary(GLM.5)
trellis.device(theme="col.whitebg")
plot(allEffects(GLM.5), ask=FALSE)
boxplot(fare~lived, ylab="fare", xlab="lived", data=train)
tapply(train$fare, list(lived=train$lived), mean, na.rm=TRUE)
library(abind, pos=4)
library(e1071, pos=4)
numSummary(train[,"fare"], groups=train$lived, statistics=c("mean", "sd", "quantiles", "cv"), 
  quantiles=c(0,.25,.5,.75,1))
train$farelvl <- with(train, fare < 100
)
GLM.6 <- glm(lived ~ age + pclass + sex + sibsp + farelvl, 
  family=binomial(logit), data=train)
summary(GLM.6)
boxplot(fare~sex, ylab="fare", xlab="sex", data=train)
Hist(train$fare, scale="frequency", breaks="Sturges", col="darkgray")
matplot(train$fare, train[, c("pclass")], type="b", lty=1, ylab="pclass", pch=1)
scatterplot(pclass~fare | lived, reg.line=lm, smooth=TRUE, spread=TRUE, boxplots='xy', 
  span=0.5, jitter=list(x=1, y=1), by.groups=TRUE, data=train)
scatterplot(pclass~fare | lived, reg.line=FALSE, smooth=FALSE, spread=TRUE, boxplots='xy', 
  span=0.5, jitter=list(x=1, y=1), by.groups=FALSE, data=train)
scatterplot(age~fare | lived, reg.line=FALSE, smooth=FALSE, spread=TRUE, boxplots='xy', 
  span=0.5, jitter=list(x=1, y=1), by.groups=FALSE, data=train)
scatterplotMatrix(~age+fare+parch+pclass+sibsp | lived, reg.line=lm, smooth=TRUE, 
  spread=FALSE, span=0.5, diagonal= 'boxplot', by.groups=TRUE, data=train)
showData(train, placement='-20+200', font=getRcmdr('logFont'), maxwidth=80, maxheight=30, 
  suppress.X11.warnings=FALSE)

