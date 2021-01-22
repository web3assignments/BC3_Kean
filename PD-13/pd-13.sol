pragma solidity >=0.6;
pragma experimental ABIEncoderV2;


contract Game {
    uint _pull;
    //pull rate five star 0.5%
    //pull rate four star 5%
    //pull rate three star 94.5%
    string[] Fivestar = ["Diluc", "Keqing", "Qiqi", "Venti", "Jean"];
    string[] Fourstar = ["Beidou", "Xiangling", "Diona", "Fischl", "Barbara", "Razor"];
    string[] Threestar = ["Sword", "Bow", "Shield", "Great sword", "Mace", "Katana", "Saber"];
    Unit[]  PullResult;
    
    struct Unit{
        string naam;
        uint8 Rating;
    }
    
    function Start(uint pull) public {   
        require(pull == 1 || pull ==10, "only 1 pulls and 10 pulls are available!!");
        _pull = pull;
        PullCharacter();
    }
    
    function getPullResultList() public view returns( Unit[] memory){
        return PullResult;
    }
    
    function getPullLastResult() public view returns(uint){
        return PullResult[PullResult.length-1].Rating;
    }
    
    function PullCharacter() public {
        for(uint i =0; i< _pull; i++){
            uint8 RNG = RandomGenerator(i,200);
            setCharachter(RNG);
        }
    }
    
    function setCharachter(uint RNG) public {
          if ( RNG == 0){
               PullResult.push(Unit(Fivestar[RandomGenerator(RNG, Fivestar.length)], 5));
           } else if (RNG> 0 && RNG <= 10){
               PullResult.push( Unit( Fourstar[RandomGenerator(RNG, Fourstar.length)], 4));
           } else {
               PullResult.push(Unit(Threestar[RandomGenerator(RNG, Threestar.length)], 3));
        }
    }
    
    function RandomGenerator(uint extra, uint divide) public view returns (uint8){
       return uint8(uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, extra))) % divide);
    }
}
