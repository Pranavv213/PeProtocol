// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


//0x8b3244cc9B47A923Fdf72c0d06C1513d8BD0EA84

contract PeProtocol {
 
    uint256 public idCount;
    uint256 public senderId;

     constructor()  {      
        idCount=0;           
        senderId=0; 
     }
 

    mapping (uint256=>string) public  ip ;

    mapping (string=>uint256) public id;

    mapping (uint256=>address) public ipWalletAddress;

    mapping (uint256=>uint256) public stake;

    mapping (uint256=>uint256) public balance;

    mapping (uint256=>bool) public canClaim;

    mapping (uint256=>address) public payeeAddress;

    event Stake(address indexed sender, uint amount);

    event StakeWithdrawal(address indexed receiver, uint amount);

    event Pay(string upiId, string amount);

    function setSenderId(uint256 _id) public {

        senderId=_id;

    }
    function setIp(string calldata ipAddress) public  returns(uint256){

        ip[idCount]=ipAddress;
        id[ipAddress]=idCount;
        stake[idCount]=0;
        balance[idCount]=0;
        canClaim[idCount]=true;
        idCount=idCount+1;
       

       

        return idCount-1;
    }

    function setIpWalletAddress(uint256 _id,address walletAddress) public  returns(string memory){

        ipWalletAddress[_id]=walletAddress;

        return "set";
    }

    function stakeAmount(uint256 _id) public payable {

        require(msg.value > 0, "You need to send some Ether");

        stake[_id]=msg.value;
        
        emit Stake(msg.sender, msg.value);
       
    }

     function claimStake(uint256 _id) public {

        require(msg.sender == ipWalletAddress[_id], "Not authorized to claim your stakes");
        require(canClaim[_id] == true, "Cannot claim");

        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        // Transfer the balance to the authorized address
        payable(msg.sender).transfer(balance);

        stake[_id]=0;
        emit StakeWithdrawal(msg.sender, balance);
    }

     function sendAmount(string memory upiId,string memory amount) public payable  {

        require(msg.value > 0, "You need to send some Ether");

        balance[senderId]=msg.value;

        canClaim[senderId]=false;

        payeeAddress[senderId]=msg.sender;
        
        emit Pay(upiId, amount);
       

    }



    function paymentRecieved() public {

        require(payeeAddress[senderId]== msg.sender , "Not Authorised");

        canClaim[senderId]=true;


    }


  

    function getIp(uint256 id) public view returns(string memory){
        return ip[id];
    }

    function getId(string calldata ipAddress) public view returns(uint256){
        return id[ipAddress];
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

 
}