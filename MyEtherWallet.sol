pragma solidity ^0.8.0;

contract MyEtherWallet {
    // Address for owner
    address public owner;
    
    event EtherReceived(address indexed sender, uint amount);
    event EtherWithdrawn(address indexed owner, uint amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    // Init owner
    constructor() {
        owner = msg.sender;
    }
    
    // Just for Owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    receive() external payable {
        emit EtherReceived(msg.sender, msg.value);
    }
    
    // Balance-ETH
    function getBalanceInEth() public view returns (uint) {
        return address(this).balance / 1e18;
    }
    
    // Balance-Wei
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    // Withdraw-ETH
    function withdrawEth(uint amountInEth) public onlyOwner {
        uint amountInWei = amountInEth * 1e18;
        require(amountInWei <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amountInWei);
        emit EtherWithdrawn(owner, amountInWei);
    }
    
    // Withdraw-Wei
    function withdraw(uint amountInWei) public onlyOwner {
        require(amountInWei <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amountInWei);
        emit EtherWithdrawn(owner, amountInWei);
    }
    
    // Transfer to another one
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }
}