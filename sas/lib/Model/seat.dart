import 'dart:math';

class  Seat {


  foamOptions foamOption;
  double foamThickness;
  int fabricNeeded;
  planeTypes planeType;
  planeModels planeModel;
  designOptions designOption;

  Seat(this.foamOption,this.foamThickness,this.planeType,this.planeModel,this.designOption);

}

enum foamOptions {
  thin,
  thick,
  medium,
}

//orderReceived
//orderPOIncomplete
//orderInProgress
//orderFinished
//orderShipped



enum planeTypes {
  cessna,
  superCub,
  piper,
}

enum planeModels {
  pa18,
  cherokee,
  warrior,
  arrow,
  archer,
  c150,
  c152,
  c170,
  c172,
  c180,
  c182,
  c185,
}

enum designOptions {
  singleColor,
  dualColor,
  LeatherSingleColor,
  LeatherDualColor,
}