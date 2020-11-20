pragma solidity >=0.7.0;


contract Game {
    uint _pull;
   
    uint[] public pulls ;
    uint Fivestar;
    uint Fourstar;
    uint Threestar;

    function Start(uint pull) public {   
       if (pull == 1 || pull == 10){
           _pull = pull;
           PullCharacter();
       }
    }

    function Randompull(uint i) public returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, i))) % 200;
        return randomnumber;
    }

    function PullCharacter() public {
        for(uint i =0; i< _pull; i++){
        pulls.push(Randompull(i));
        }
    }
    
    function characterLoop() public {
        for (uint i = 0; i<pulls.length; i++) {
           if( pulls[i] == 0){
               Fivestar++;
           } else if (pulls[i] > 0 && pulls[i] < 10){
               Fourstar++;
           } else {
               Threestar++;
           }
        }
    }
}