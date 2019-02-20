pragma solidity ^0.4.25;
//@title record token contract
//@author dub-sizzle
//@dev building an erc720 tied to the value of vinyl records
contract record_token {
  mapping (uint => address) getRecordOwner;
  mapping (address => uint) ownerRecordCount;
  mapping (address => uint) userVotes;
  struct Record {
    string title;
    string artist;
    uint256 value;
    uint256 votes;
    uint256 id;
  }

  Record[] public records;

  function addVotes (address _user) internal {
    userVotes[_user]++;
  }

  function registerRecord(string _title, string _artist, uint256 _value) public {
    records.push(Record(_title, _artist, _value, 0, (100 + records.length)));
    addVotes(msg.sender);
  }

  function upVote (uint256 _id) public {
    require (userVotes[msg.sender] > 0);
    for(uint i = 0; i < records.length; i++){
      if(records[i].id == _id){
        records[i].votes++;
      }
    }
  }

  function getScore (uint256 _id) public view returns(uint256) {
    for(uint i = 0; i < records.length; i++){
      if(records[i].id == _id){
        return records[i].votes;
      }
    }
  }




}
