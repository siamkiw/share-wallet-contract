// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ShareWallet {

    address owner;

    uint accountBalance;

    mapping(address => Allowance) public balanceReceived;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not owner.");
        _;
    }

    modifier onlyUser {
        require(msg.sender != owner, "You are not user.");
        _;
    }

    struct Allowance {
        uint balance;
        bool isAllow;
    }

    receive() external payable {
        accountBalance += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    event WithdrawMoney (
        address _from,
        address _to,
        uint _amount
    );

    function withdrawMoney(address payable _to, uint _amount) public onlyUser {

        require(balanceReceived[msg.sender].isAllow == true, "You account is not allow.");
        require(balanceReceived[msg.sender].balance >= _amount, "You account has not enough funds.");
        require(getBalance() >= _amount, "Contract has not enough funds.");

        balanceReceived[msg.sender].balance -= _amount;

        _to.transfer(_amount);

        emit WithdrawMoney(msg.sender ,_to, _amount);
    }

    event WithdrawMoneyOwner (
        address _from,
        address _to,
        uint _amount
    );

    function withdrawMoneyOwner(address payable _to, uint _amount) public onlyOwner {
        require(getBalance() >= _amount, "Contract has not enough funds.");

        _to.transfer(_amount);

        emit WithdrawMoneyOwner(msg.sender, _to, _amount);
    }

    event UpdateAllowance (
        address _from,
        address _to,
        uint _amount,
        bool _isAllow
    );

    function updateAllowance(address _to, uint _amount, bool _isAllow) public onlyOwner {
        require(getBalance() >= _amount, "Contract has not enough funds.");

        balanceReceived[_to].balance = _amount;
        balanceReceived[_to].isAllow = _isAllow;

        emit UpdateAllowance(msg.sender, _to, _amount, _isAllow);
    }


}