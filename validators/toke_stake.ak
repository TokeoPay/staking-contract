use aiken/collection/list
use cardano/transaction.{Transaction, OutputReference}
use aiken/crypto.{Blake2b_224, Hash, VerificationKey}

pub type Datum {
  owner: Hash<Blake2b_224, VerificationKey>,
}

validator staking {
  spend(
    datum: Option<Datum>,
    _: Void,
    _own_ref: OutputReference,
    self: Transaction,
  ) {
    
    expect Some(Datum { owner }) = datum
    
    list.has(self.extra_signatories, owner)?
  }
}


test basic_staking_you_cannot_spend_this() fail {
  let datum =
    Datum { owner: #"00000000000000000000000000000000000000000000000000000001" }
 
 
  let placeholder_utxo = OutputReference { transaction_id: "", output_index: 0 }
  let txn = Transaction {
    ..transaction.placeholder,
    extra_signatories: [#"00000000000000000000000000000000000000000000000000000000"]
  }
  
  staking.spend(
    Some(datum),
    Void,
    placeholder_utxo,
    txn,
  )
}

test basic_staking() {
  let datum =
    Datum { owner: #"00000000000000000000000000000000000000000000000000000000" }
 
 
  let placeholder_utxo = OutputReference { transaction_id: "", output_index: 0 }
  let txn = Transaction {
    ..transaction.placeholder,
    extra_signatories: [#"00000000000000000000000000000000000000000000000000000000"]
  }
  
  staking.spend(
    Some(datum),
    Void,
    placeholder_utxo,
    txn,
  )
}