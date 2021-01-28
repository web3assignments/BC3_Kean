pragma solidity >=0.6;
pragma experimental ABIEncoderV2;

import "./Initializable.sol";
import "./ProvableAPI_0.6.sol";

contract Gacha is Initializable, usingProvable{
    uint _pull;
    //pull rate five star 0.5%
    //pull rate four star 5%
    //pull rate three star 94.5%
    string[] Fivestar;
    string[] Fourstar;
    string[] Threestar;

    Unit[]  PullResult;
    Unit[]  AllPullResult;
    uint168 constant pullCost = 5000000000000000;
    
    struct Unit{
        string naam;
        uint8 Rating;
    }
    
    modifier requireEnoughDeposit {
        require(msg.value >= pullCost, "0.005 Ether is the minimum requirement");
        _;
    } 
    
    function initialize() public initializer {
        Fivestar = ["Diluc", "Keqing", "Qiqi", "Venti", "Jean"];
        Fourstar = ["Beidou", "Xiangling", "Diona", "Fischl", "Barbara", "Razor"];
        Threestar = ["Sword", "Bow", "Shield", "Great sword", "Mace", "Katana", "Saber"];
    }

    /// @param pull with either 1 or 10 to determine the amount of pulls
    /// @notice start with pulling the characters 
    function Start(uint pull) requireEnoughDeposit payable public {   
        require(pull == 1 || pull ==10, "only 1 pulls and 10 pulls are available!!");
        require(msg.value / pullCost >= pull, "You do not have enough funds to pull!");
        _pull = pull;
        delete PullResult;
        PullCharacter();
    }
    
    function getPullResultList() public view returns( Unit[] memory){
        return PullResult;
    }
    
    function getAllResult() public view returns(Unit[] memory){
        return AllPullResult;
    }
    
    function __callback(bytes32  _queryId,string memory _result,bytes memory _proof ) override public {
        require(msg.sender == provable_cbAddress());
        if (provable_randomDS_proofVerify__returnCode(_queryId,_result,_proof)== 0) {
            setCharachter(uint256(keccak256(abi.encodePacked(_result))) % 200);
        }
    }

    /// @notice start looping and calling the _calback
    function PullCharacter() private {
       for(uint i = 0; i < _pull; i++) {
            provable_newRandomDSQuery(0,1,200000);
        }
    } 

    /// @notice set the name and the rating of the character
    /// @param RNG to determine the rarity
    function setCharachter(uint RNG) public {
          if ( RNG == 0){
               Unit memory result =Unit(Fivestar[RandomGenerator(RNG, Fivestar.length)], 5);
               PullResult.push(result);
               AllPullResult.push(result);
           } else if (RNG> 0 && RNG <= 10){
               Unit memory result = Unit( Fourstar[RandomGenerator(RNG, Fourstar.length)], 4);
               PullResult.push(result);
               AllPullResult.push(result);
           } else {
               Unit memory result = Unit(Threestar[RandomGenerator(RNG, Threestar.length)], 3);
               PullResult.push(result);
               AllPullResult.push(result);
        }
    }
    
    /// @notice random number generator
    /// @param extra is a number to for randomness in the generator
    /// @param divide is a number to determine the range of the number
    /// @return get a random number
    function RandomGenerator(uint extra, uint divide) public view returns (uint8){
       return uint8(uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, extra))) % divide);
    }
    
    // function close() public {
    //   selfdestruct(msg.sender);ks
    // }
}