pragma solidity >=0.7.0;


contract Game {
    uint _pull;
    string _Banner;
    uint[] public pulls ;
    uint Fivestar;
    uint Fourstar;
    uint Threestar;

    constructor(uint pull, string memory Banner) public {   
        require(pull != 1 || pull != 10, "amount of pulls not valid");
        _pull = pull;
    }

    function randompull() private returns (uint) {
    uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp , msg.sender))) % 200;
    return randomnumber;
    }

    function PullCharacter() public {
        for(uint i =0; i< _pull; i++){
        pulls.push(randompull());
        }
    }
    
    function characterLoop() public {
        
        // WARN: This unbounded for loop is an anti-pattern
        
        for (uint i=0; i<pulls.length; i++) {
           if( pulls[i]== 0){
               Fivestar++;
           } else if (pulls[i]>0 && 0<10){
               Fourstar++;
           }else {
               Threestar++;
           }
        }
    }
}