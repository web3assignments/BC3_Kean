pragma solidity >= 0.6 < 0.7; 

import "./ProvableAPI_0.6.sol";
import "./Initializable.sol";

contract GachaV2 is usingProvable, Initializable {    
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

    uint168 constant pullCost = 5000000000000000;
    Unit[] PullResultList;

    function initialize() public payable initializer{
        provable_setProof(proofType_Ledger);
        _pull = 0;
        PullResult[1] = Unit("bla",1);
        PullResultList;
        Fivestar = ["Diluc", "Keqing", "Qiqi", "Venti", "Jean"];
        Fourstar = ["Beidou", "Xiangling", "Diona", "Fischl", "Barbara", "Razor"];
        Threestar = ["Sword", "Bow", "Shield", "Great sword", "Mace", "Katana", "Saber"];
    }
    
    modifier requireEnoughDeposit {
        require(msg.value >= 5000000000000000, "0.005 Ether is the minimum requirement");
        _;
    } 
    
    /// @param pull with either 1 or 10 to determine the amount of pulls
    /// @notice start with pulling the characters 
    function Start(uint pull) requireEnoughDeposit payable public { 
        require(pull == 1 || pull ==10, "only 1 pulls and 10 pulls are available!!");
        require(msg.value / pullCost >= pull, "You do not have enough funds to pull!");
        require(msg.value / pullCost <= 10, "You are not allowed to pull more than 10 times in a single turn");        
        _pull  = pull;
        PullCharacter();
    }
     
    function __callback(bytes32  _queryId,string memory _result,bytes memory _proof ) override public {
        require(msg.sender == provable_cbAddress());
        if (provable_randomDS_proofVerify__returnCode(_queryId,_result,_proof)== 0) {
            setName(uint256(keccak256(abi.encodePacked(_result))) % 200);
        }
    }

    /// @notice start looping and calling the _calback
    function PullCharacter() private {
       for(uint i = 0; i < _pull; i++) {
            provable_newRandomDSQuery(0,1,200000);
        }
    } 
    
    /// @notice set the name and the rating of the character
    /// @param RandomNumber to determine the rarity
    function setName(uint256 RandomNumber) private {
       if ( RandomNumber == 0){
               PullResultList.push( Unit(Fivestar[RandomGenerator(RandomNumber, Fivestar.length)], 5));
           } else if (RandomNumber> 0 && RandomNumber <= 10){
               PullResultList.push(Unit( Fourstar[RandomGenerator(RandomNumber, Fourstar.length)], 4));
           } else {
               PullResultList.push(Unit(Threestar[RandomGenerator(RandomNumber, Threestar.length)], 3));
           }
        emit WantGachaPull(PullResultList[PullResultList.length -1 ].naam, PullResultList[PullResultList.length -1 ].Rating);
    }
   
    /// @notice random number generator
    /// @param extra is a number to for randomness in the generator
    /// @param divide is a number to determine the range of the number
    /// @return get a random number
    function RandomGenerator(uint extra, uint divide) private view returns (uint8){
       return uint8(uint(keccak256(abi.encodePacked(block.timestamp , msg.sender, extra))) % divide);
    }
    
    // function close() public {
    //   selfdestruct(msg.sender);
    // }
}