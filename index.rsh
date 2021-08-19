'reach 0.1';

const Player = {
  getwords: Fun([UInt], UInt),
  show: Fun([UInt], Null),
  check: Fun([UInt], Bool)
};

export const main = Reach.App(() => {
  const Alice = ParticipantClass('Alice', {
    ...Player,
  });
  const Bob   = Participant('Bob', {
    ...Player,
  });
  const vLCT = View('LCT', {
    lct: UInt });
  deploy();
  
  Alice.only(() => {
    const original1 = 0; });


  Alice.publish(original1);
  const CT = lastConsensusTime();

  const [ index, dialog, lastCT, isfirst ] =
  parallelReduce([original1, original1, CT, true])
  .invariant(balance() == 0)
  .while(index < 10)
  .case(Alice, (
    () => {
    return ({
        when: isfirst
     })
    }
  ),
    (_) => {
      vLCT.lct.set(lastCT);
      Alice.only(()=>{
          interact.show(index);}
      );
      return [ index, dialog, lastConsensusTime(),false ]; })
  .case(Alice, (
    () => {
    const t = lastConsensusTime();
    return ({
        when: declassify(interact.check(t)),
        msg: declassify(interact.getwords(dialog))
     })
    }
  ),
    (newMsg) => {
      //vLCT.lct.set(lastCT);
      each([Alice], () => {
        interact.show(newMsg); });
      return [ index+1, newMsg, lastConsensusTime(),false ]; })
    
.timeout(10000,()=>{
        Anybody.publish();
        return [ index, dialog, lastConsensusTime(), isfirst ];});

    commit()

});
