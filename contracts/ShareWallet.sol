// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ShareWallet {

    address owner;

    uint accountBalance;

    mapping(address => uint) public allowance;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not owner.");
        _;
    }

    modifier ownerOrAllowance(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount,  "You are not allowance or you has not enough funds.");
        _;
    }

    event Receive (
        address sender,
        uint amount
    );

    receive() external payable {
        emit Receive(msg.sender, msg.value);
    }

    function isOwner() public view returns (bool){
        return msg.sender == owner;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    event WithdrawMoney (
        address _from,
        address _to,
        uint _amount
    );

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowance(_amount) {
        require(getBalance() >= _amount, "Contract has not enough funds.");

        if(!isOwner()){
            allowance[msg.sender] -= _amount;
        }

        emit WithdrawMoney(msg.sender ,_to, _amount);

        _to.transfer(_amount);
    }


    event UpdateAllowance (
        address _from,
        address _to,
        uint _amount
    );

    function updateAllowance(address _to, uint _amount) public onlyOwner {
        require(getBalance() >= _amount, "Contract has not enough funds.");

        emit UpdateAllowance(msg.sender, _to, _amount);

        allowance[_to] = _amount;

    }


}