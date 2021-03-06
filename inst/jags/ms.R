sink("inst/jags/ms.jags")
cat("
    model {
    
    # -------------------------------------------------
    # Parameters:
    # phiA: survival probability at site A
    # phiB: survival probability at site B
    # psiAB: movement probability from site A to site B
    # psiBA: movement probability from site B to site A
    # pA: recapture probability at site A
    # pB: recapture probability at site B
    # -------------------------------------------------
    # States (S):
    # 1 alive at A
    # 2 alive at B
    # 3 dead
    # Observations (O):  
    # 1 seen at A 
    # 2 seen at B
    # 3 not seen
    # -------------------------------------------------
    
    # Priors and constraints
    phiA ~ dunif(0, 1)
    phiB ~ dunif(0, 1)
    psiAB ~ dunif(0, 1)
    psiBA ~ dunif(0, 1)
    pA ~ dunif(0, 1)
    pB ~ dunif(0, 1)

    
    # Define state-transition and observation matrices
    # Define probabilities of state S(t+1) given S(t)
    ps[1,1] <- phiA * (1-psiAB)
    ps[1,2] <- phiA * psiAB
    ps[1,3] <- 1-phiA
    ps[2,1] <- phiB * psiBA
    ps[2,2] <- phiB * (1-psiBA)
    ps[2,3] <- 1-phiB
    ps[3,1] <- 0
    ps[3,2] <- 0
    ps[3,3] <- 1
    
    # Define probabilities of O(t) given S(t)
    po[1,1] <- pA
    po[1,2] <- 0
    po[1,3] <- 1-pA
    po[2,1] <- 0
    po[2,2] <- pB
    po[2,3] <- 1-pB
    po[3,1] <- 0
    po[3,2] <- 0
    po[3,3] <- 1

    # Likelihood 
    for (i in 1:nInd){
    # Define latent state at first capture
    z[i,f[i]] <- y[i,f[i]]
    for (t in (f[i]+1):nOcc){
    # State process: draw S(t) given S(t-1)
    z[i,t] ~ dcat(ps[z[i,t-1],])
    # Observation process: draw O(t) given S(t)
    y[i,t] ~ dcat(po[z[i,t],])
    } #t
    } #i
    }
    ",fill = TRUE)
sink()