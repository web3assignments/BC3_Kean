pragma solidity >= 0.6 < 0.7; 

import "./ProvableAPI_0.6.sol";
import "./Initializable.sol";

contract Gacha is usingProvable, Initializable  {
    uint _pull;
    //pull rate five star 0.5%
    //pull rate four star 5%
    //pull rate three star 94.5%
    string[] Fivestar;
    string[] Fourstar;
    string[] Threestar;
    mapping(uint => Unit) public PullResult;
    
    event WantGachaPull(
        string CharName,
        uint8 Rating
    );
    
    struct Unit{
        string naam;
        uint8 Rating;
    }
    
    function initialize() public payable initializer {
        Fivestar = ["Diluc", "Keqing", "Qiqi", "Venti", "Jean"];
        Fourstar = ["Beidou", "Xiangling", "Diona", "Fischl", "Barbara", "Razor"];
        Threestar = ["Sword", "Bow", "Shield", "Great sword", "Mace", "Katana", "Saber"];
    }
    function Start(uint pull) public {   
        require(pull == 1 || pull ==10, "only 1 pulls and 10 pulls are available!!");
        _pull = pull;
        PullCharacter();
    }
    
    function PullCharacter() private {
        for(uint i =0; i< _pull; i++){
        uint8 RNG = RandomGenerator(i,200);
          if ( RNG == 0){
               PullResult[i]= Unit(Fivestar[RandomGenerator(i, Fivestar.length)], 5);
           } else if (RNG> 0 && RNG <= 10){
               PullResult[i]= Unit( Fourstar[RandomGenerator(i, Fourstar.length)], 4);
           } else {
               PullResult[i]= Unit(Threestar[RandomGenerator(i, Threestar.length)], 3);
           }
            emit WantGachaPull(PullResult[i].naam, PullResult[i].Rating);
        }
    }
    
    function RandomGenerator(uint extra, uint divide) private view returns (uint8){
       return uint8(uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, extra))) % divide);
    }
}