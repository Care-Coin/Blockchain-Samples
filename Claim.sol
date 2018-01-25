pragma solidity ^0.4.18;
// We have to specify what version of compiler this code will compile with

// Simple blockchain implementation of the claim lifecycle.
// Includes status changes and location changes.
// Allows for patients and providers to access information, and allows only CCX to 
// update status and location. 
contract Claim {
  // All possible statuses of a claim.
  string[4] statuses = ["Processing", "Partially Rejected", "Rejected", "Accepted"];
  
  // The index into "statuses"
  uint public status;

  // The amount of times this claim's status has been updated.
  uint numStatusChanges;
  
  address provider;
  address patient;
  address ccx;

  string location;

  /* This is the constructor which will be called once when you
  deploy the contract to the blockchain. Simply initializes all of 
  the states and information of the claim.
  */
  function Claim(
    address _provider, 
    address _patient, 
    string _location, 
    uint _status) public 
  {
    ccx = msg.sender;
    provider = _provider;
    patient = _patient;
    location = _location;
    status = _status;
  }

  modifier condition(bool _condition) {
      require(_condition);
      _;
  }

  modifier onlyProvider() {
      require(msg.sender == provider);
      _;
  }

  modifier onlyPatient() {
      require(msg.sender == patient);
      _;
  }

  modifier onlyCCX() {
      require(msg.sender == ccx);
      _;
  }

  modifier inStatus(uint _status) {
      require(status == _status);
      _;
  }

  // Returns the current location of the claim in the cycle
  function getCurrentLocation() view public returns (string) {
    return location;
  }

  // Returns the current status of the claim
  function getCurrentStatus() view public returns (string) {
    return statuses[status];
  }

  // Returns patient address associated with this claim
  // only CCX or the provider for this claim can call this
  function getPatient()
    view
    public
    onlyProvider
    returns (address)
  {
    return patient;
  }

  // This function updates the location of the claim, only
  // CCX can call this function.
  function updateLocation(string newLocation) 
    public
    onlyCCX 
  {
    location = newLocation;
  }

  // This function updates the status of the claim, only
  // CCX can call this function.
  function updateStatus(uint newStatus) 
    public
    onlyCCX 
  {
    numStatusChanges += 1;
    status = newStatus;
  }
}
