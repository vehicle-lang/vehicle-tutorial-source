--------------------------------------------------------------------------------
-- Doggos

numberOfDogs = 20
type Dog = Index numberOfDogs

unknownDog     = 0

greatDane      = 1
germanShepherd = 2

chihuahua  = 11
pekinese   = 12

smallDogs : List Dog
smallDogs = [chihuahua, pekinese]

bigDogs : List Dog
bigDogs = [greatDane, germanShepherd]

--------------------------------------------------------------------------------
-- Network

type Image = Tensor Rat [28, 28]
type Score = Rat

network score : Image -> Vector Score numberOfDogs

getScore : Image -> Dog -> Score
getScore x dog = score x ! dog

--------------------------------------------------------------------------------
-- Predicates

isFirstChoice : Image -> Dog -> Bool
isFirstChoice x dog1 =
  let scores = score x in
  forall d . d != dog1 => scores ! dog1 > scores ! d

isSecondChoice : Image -> Dog -> Bool
isSecondChoice x dog2 =
  let scores = score x in
  exists dog1 .
    isFirstChoice dog1 and
    forall d . d != dog1 and d != dog2 => scores ! dog2 > scores ! d

noConfusionWith : Image -> List Dog -> List Dog -> Bool
noConfusionWith x dogs1 dogs2 =
  forall dog1 in dogs1 .
    forall dog2 in dogs2 .
      not (isFirstChoice x dog1 and isSecondChoice x dog2)

--------------------------------------------------------------------------------
-- Properties chihuahua

@property
doesNotConfuseBigAndSmall : Bool
doesNotConfuseBigAndSmall =
  forall x . validImage x => noConfusionWith x bigDogs smallDogs