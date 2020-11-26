pragma solidity >=0.7.0;

contract Game {
    uint _pull;
    uint[] public pulls ;
    //pull rate five star 0.5%
    //pull rate four star 5%
    //pull rate three star 94.5%
    string[] Fivestar = ["Diluc", "Keqing", "Qiqi", "Venti", "Jean"];
    string[] Fourstar = ["Beidou", "Xiangling", "Diona", "Fischl", "Barbara", "Razor"];
    string[] Threestar = ["Sword", "Bow", "Shield", "Great sword", "Mace", "Katana", "Saber"];
    mapping(uint => Profit) public ProfitMap;
    
    event WantGachaPull(
            string CharName,
            string Rating
        );
    
    struct Profit{
        string naam;
        string Rating;
    }
    
    function Start(uint pull) public {   
        require(pull == 1 || pull ==10, "only 1 pulls and 10 pulls are available!!");
        _pull = pull;
        PullCharacter();
    }
    
    function PullCharacter() private {
        for(uint i =0; i< _pull; i++){
        pulls.push(RandomGenerator(i,200));
        }
        characterLoop();
    }
    
    function characterLoop() private {
        for (uint i = 0; i<pulls.length; i++) {
           if ( pulls[i] == 0){
               ProfitMap[i]= Profit( Fivestar[RandomGenerator(i, Fivestar.length)], "Five star");
               emit WantGachaPull(Fivestar[RandomGenerator(i, Fivestar.length)], "Five star");
           } else if (pulls[i] > 0 && pulls[i] <= 10){
               ProfitMap[i]= Profit( Fourstar[RandomGenerator(i, Fourstar.length)], "Four star");
               emit WantGachaPull( Fourstar[RandomGenerator(i, Fourstar.length)], "Four star");
           } else {
               ProfitMap[i]= Profit(Threestar[RandomGenerator(i, Threestar.length)], "Three star");
               emit WantGachaPull(Threestar[RandomGenerator(i, Threestar.length)], "Three star");
           }
        }
    }
    
    function RandomGenerator(uint extra, uint divide) private view returns (uint){
       return uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, extra))) % divide;
    }
}