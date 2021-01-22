pragma solidity >= 0.6;
pragma experimental ABIEncoderV2;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "gachav.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract GachaTest {
    Game gacha;
 
     struct Unit{
        string naam;
        uint8 Rating;
    }
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // Here should instantiate tested contract
        gacha = new Game();
    }
     function testOnepull()  public  {
        gacha.Start(1);
        uint result =  gacha.getPullResultList().length;
        Assert.equal(result,1,"pulled 1 time");
    }
      
    function testTenPull()  public  {
        gacha.Start(10);
        uint result =  gacha.getPullResultList().length;
        Assert.equal(result,10,"pulled 10 times");
    }
     
    function testFivestar() public{
         gacha.setCharachter(0);
         uint result =  uint8(gacha.getPullLastResult());
        Assert.equal(result, 5, "pulled 5 star");
    }
     function testFourstar() public{
         gacha.setCharachter(6);
         uint result =  uint8(gacha.getPullLastResult());
        Assert.equal(result, 4, "pulled 4 star");
    }
     function testThreestar() public{
         gacha.setCharachter(15);
         uint result =  uint8(gacha.getPullLastResult());
        Assert.equal(result, 3, "pulled 3 star");
    }
    
}
