'reach 0.1';

const Player = {
  getwords: Fun([UInt], UInt),
  show: Fun([UInt], Null),
};

export const main = Reach.App(() => {
  const Alice = Participant('Alice', {
    ...Player,
  });
  const Bob   = Participant('Bob', {
    ...Player,
  });
  deploy();
  Bob.only(() => {
    const original2 = 0; });

  Bob.publish(original2);
  commit();
  Alice.only(() => {
    const original1 = 0; });


  Alice.publish(original1);



  const [ index, dialog ] =
  parallelReduce([original1, original1])
  .invariant(balance() == 0)
  .while(index < 10)
  .case(Alice, (() => ({
        msg: declassify(interact.getwords(dialog))
     })),
    (newMsg) => {
      each([Alice, Bob], () => {
        interact.show(newMsg); });
      return [ index+1, newMsg ]; })
   .case(Bob, (() => ({
        msg: declassify(interact.getwords(dialog))
     })),
    (newMsg) => {
      each([Alice, Bob], () => {
        interact.show(newMsg); });
      return [ index+1, newMsg ]; });

    commit()

});
