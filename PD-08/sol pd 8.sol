pragma solidity > 0.6.1 < 0.7.0; 
pragma experimental ABIEncoderV2;

import "https://raw.githubusercontent.com/provable-things/ethereum-api/master/provableAPI_0.6.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/math/SafeMath.sol";


contract Game is usingProvable{
    
    using SafeMath for uint256;
    
    uint PullAmount;
   
    string[] Fivestar = ["Diluc", "Keqing", "Qiqi", "Venti", "Jean"];
    string[] Fourstar = ["Beidou", "Xiangling", "Diona", "Fischl", "Barbara", "Razor"];
    string[] Threestar = ["Sword", "Bow", "Shield", "Great sword", "Mace", "Katana", "Saber"];
    
    uint168 constant pullCost = 5000000000000000;

    
    Unit[] public PullResult;
    
    mapping(address => uint) balance;

    
     event WantGachaPull(
            string CharName,
            uint8 Rating
        );
        
    struct Unit{
        string naam;
        uint8 Rating;
    }
    
    constructor()public payable{
        provable_setProof(proofType_Ledger);
    }
    
   
     modifier requireEnoughDeposit {
        require(msg.value >= 5000000000000000, "0.005 Ether is the minimum requirement");
        _;
    } 
    
    function getPullresult() view public returns (Unit[] memory){
        return PullResult;
    }
    
    function Start(uint pull) requireEnoughDeposit payable public { 
        require(pull == 1 || pull ==10, "only 1 pulls and 10 pulls are available!!");
        require(msg.value / pullCost >= pull, "You do not have enough funds to pull!");
        require(msg.value / pullCost <= 10, "You are not allowed to pull more than 10 times in a single turn");        
        PullAmount = pull;
        PullCharacter();
    }
      
    function __callback(bytes32  _queryId,string memory _result,bytes memory _proof ) override public {
        require(msg.sender == provable_cbAddress());
        if (provable_randomDS_proofVerify__returnCode(_queryId,_result,_proof)== 0) {
            setName(uint256(keccak256(abi.encodePacked(_result))) % 200);
        }
    }

    function PullCharacter() private {
       for(uint i = 0; i < PullAmount; i++) {
            provable_newRandomDSQuery(0,1,200000);
        }
    } 
    
    function setName(uint256 RandomNumber) public {
       if ( RandomNumber == 0){
               PullResult.push( Unit(Fivestar[RandomGenerator(RandomNumber, Fivestar.length)], 5));
           } else if (RandomNumber> 0 && RandomNumber <= 10){
               PullResult.push(Unit( Fourstar[RandomGenerator(RandomNumber, Fourstar.length)], 4));
           } else {
               PullResult.push(Unit(Threestar[RandomGenerator(RandomNumber, Threestar.length)], 3));
           }
        emit WantGachaPull(PullResult[PullResult.length -1 ].naam, PullResult[PullResult.length -1 ].Rating);
    }
   
    function RandomGenerator(uint extra, uint divide) private view returns (uint8){
       return uint8(uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, extra))) % divide);
    }
}