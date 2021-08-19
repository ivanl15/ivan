import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';
import { ask, yesno, done } from '@reach-sh/stdlib/ask.mjs';
const stdlib = loadStdlib(process.env);

(async () => {
  const isAlice = await ask(
    `Are you Alice?`,
    yesno
  );
  const who = isAlice ? 'Alice' : 'Bob';

  console.log(`Starting as ${who}`);

  let acc = null;
  const createAcc = await ask(
    `Would you like to create an account? (only possible on devnet)`,
    yesno
  );
  if (createAcc) {
    acc = await stdlib.newTestAccount(stdlib.parseCurrency(1000));
  } else {
    const secret = await ask(
      `What is your account secret?`,
      (x => x)
    );
    acc = await stdlib.newAccountFromSecret(secret);
  }

  let ctc = null;
  const deployCtc = await ask(
    `Do you want to deploy the contract? (y/n)`,
    yesno
  );
  if (deployCtc) {
    ctc = acc.deploy(backend);
    const info = await ctc.getInfo();
    console.log(`The contract is deployed as = ${JSON.stringify(info)}`);
  } else {
    const info = await ask(
      `Please paste the contract information:`,
      JSON.parse
    );
    ctc = acc.attach(backend, info);
  }

  const fmt = (x) => stdlib.formatCurrency(x, 4);
  const getBalance = async () => fmt(await stdlib.balanceOf(acc));

  const before = await getBalance();
  console.log(`Your balance is ${before}`);

  const interact = { ...stdlib.hasRandom };

  interact.informTimeout = () => {
    console.log(`There was a timeout.`);
    process.exit(1);
  };



  interact.getwords = async (now) => {
    const msg = await ask(`What do you want to say?`, (x) => {
      const word = x;
      console.log(`You've said ${word}`);
      return now+word;
    });
    return msg;
  };

  interact.check = async (t) => {
    console.log(`${t}`);
    const tnew = await ctc.getViews().LCT.lct();
    console.log(`${tnew[1]}`);
    //return t == tnew ? true : false;
    return true;
  };

  
  interact.show = async (msg) => {
    console.log(`The dialog is: ${msg}`);
    //const tnew = await ctc.getViews().LCT.lct();
    //console.log(`${tnew}`);
  };

  const part = backend.Alice;
  await part(ctc, interact);

  const after = await getBalance();
  console.log(`Your balance is now ${after}`);

  done();
})();
