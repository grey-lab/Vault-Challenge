'reach 0.1';

/*
Problem analysis
*/
const COUNTDOWN = 10;

const Common = {
  showTime: Fun([UInt], Null),
}
export const main = Reach.App(() => {
  const A = Participant('Alice', {
    ...Common,
    inheritance: UInt,
    continueHold: Fun([], Bool),
  });
  const B = Participant('Bob', {
    ...Common,
    acceptTerms: Fun([UInt],Bool),
  });
  init();
  // The first one to publish deploys the contract
  A.only(() => {
    const value = declassify(interact.inheritance);
  })
  A.publish(value)
    .pay(value);
  commit();
  // The second one to publish always attaches
  B.only(() => {
    const decision = declassify(interact.acceptTerms(value));
  })
  B.publish(decision);
  commit();
  // write your program here
  each([A,B], () => {
    interact.showTime(COUNTDOWN);
  });

  A.only(() => {
    const isHere = declassify(interact.continueHold());
  })
  A.publish(isHere);

  if(isHere){
    transfer(value).to(A);
  } else {
    transfer(value).to(B);
  }
  commit();
  exit();
});
