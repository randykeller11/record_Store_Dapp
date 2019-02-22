pragma solidity ^0.4.25;
import"./ERC720.sol";
import "./Owbable.sol";
//@title record token contract
//@author randyKeller
//@dev */this game involves both ERC720 and ERC20 tokens to create a decentralized exchange for a new kind of crypto asset
//the erc721 token is representative of the mint condintion value of a real world vinyl recording. I am defining this variable
//as the highest sale value for the record using the discogs api and web3.js. A record cannot be repeated once uploaded to the block chain which
//I believe will create a strong value incentive for the ERC20 token used to barter on the exchange. Extra functionality I plan to add is speculators 
//market that will reward players with ERC20 if the ERC720 sells for the value they guessed.
//

//@dev inherits from erc 720 standard and Ownable contract
contract record_token is ERC721 {
//@dev structs are used for storing important variables
  mapping (uint => address) getRecordOwner;
  mapping (address => uint) ownerRecordCount;
  mapping (uint => address) recordApprovals;

//@dev defining record object and array of all registered records to be written to the block chain
  struct Record {
    string title;
    string artist;
    uint256 value;
    uint256 votes;
    uint256 id;
  }

  Record[] public records;


//@notice registerRecord() instantiates the record object and stores it in the records array
//@param it requires the author, artist and discogs price (eventually want to add string _discogsID)
//@dev also increases users erc20 count
  function registerRecord(string _title, string _artist, uint256 _value) public {
    uint256 _id = 100 + records.length;
    getRecordOwner[_id] = msg.sender;
    records.push(Record(_title, _artist, _value, 0, _id));
  }

  //@dev erc720 compliant rules for generating a non fungible crypto asset
  function balanceOf(address _owner) external view returns (uint256) {
      return ownerRecordCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address){
      return getRecordOwner[_tokenId];
  }


  function transferFrom(address _from, address _to, uint256 _tokenId) external payable onlyOwner {
      require (getRecordOwner[_tokenId] == msg.sender || recordApprovals[_tokenId] == msg.sender);
      ownerRecordCount[_to]++;
      ownerRecordCount[_from]--;
      getRecordOwner[_tokenId] = _to;
      emit Transfer(_from, _to, _tokenId);

  }

  function approve(address _approved, uint256 _tokenId) external payable {
    recordApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }


}
