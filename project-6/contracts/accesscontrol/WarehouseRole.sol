pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'WarehouseRole' to manage this role - add, remove, check
contract WarehouseRole {
  using Roles for Roles.Role;
  // Define 2 events, one for Adding, and other for Removing
    event WarehouseAdded(address indexed account);
    event WarehouseRemoved(address indexed account);
  // Define a struct 'warehouses' by inheriting from 'Roles' library, struct Role
  Roles.Role private warehouses;
  // In the constructor make the address that deploys this contract the 1st Warehouse
  constructor() public {
    _addWarehouse(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyWarehouse() {
    require(isWarehouse(msg.sender), 'only Warehouse can Access!');
    _;
  }

  // Define a function 'isWarehouse' to check this role
  function isWarehouse(address account) public view returns (bool) {
     return warehouses.has(account);
  }

  // Define a function 'addWarehouse' that adds this role
  function addWarehouse(address account) public onlyWarehouse {
    _addWarehouse(account);
  }

  // Define a function 'renounceWarehouse' to renounce this role
  function renounceWarehouse() public {
    _removeWarehouse(msg.sender);
  }

  // Define an internal function '_addWarehouse' to add this role, called by 'addWarehouse'
  function _addWarehouse(address account) internal {
    warehouses.add(account);
    emit WarehouseAdded(account);
  }

  // Define an internal function '_removeWarehouse' to remove this role, called by 'removeWarehouse'
  function _removeWarehouse(address account) internal {
    warehouses.remove(account);
    emit WarehouseRemoved(account);
  }
}