import "owned";

contract ClientReceipt {
  event AnonymousDeposit(address indexed _from, uint _value);
  event Deposit(address indexed _from, hash _id, uint _value);
  function() {
    AnonymousDeposit(msg.sender, msg.value);
  }
  function deposit(hash _id) {
    Deposit(msg.sender, _id, msg.value);
  }
}

