pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

// this is an interface where our ZombieFeeding contract can interact with other contracts in the blockchain
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
);
}

// ZombieFeeding inherits from ZombieFactory
contract ZombieFeeding is ZombieFactory {
    // address of the cryptokitties contract
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // ZombieFeeding can now use the functions from the KittyInterface since it has access to the contract using the address
    // KittyInterface kittyContract = KittyInterface(ckAddress);
    KittyInterface kittyContract;

    // calls the onlyOwner function from the Ownable contract before executing the code
    function setKittyContractAddress(address _address) external onlyOwner {
      kittyContract = KittyInterface(_address);
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        // make sure the owner is the same as the zombie owner
        require(msg.sender == zombieToOwner[_zombieId]);
        // put into the blockchain memory
        Zombie storage myZombie = zombies[_zombieId];
        // limit the DNA strand to 16 digits
        _targetDna = _targetDna % dnaModulus;
        // get the average of the dna of the zombie and newly infected
        uint newDna = (myZombie.dna + _targetDna) / 2;
        // add the newly infected to the zombie array
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
          // make the last two digits 99
          newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    // uint = uint256
    uint kittyDna;
    // getKitty returns multiple values
    // use commas to return the ones desired
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}