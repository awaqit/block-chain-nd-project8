// migrating the appropriate contracts
var PharmacyRole = artifacts.require("./PharmacyRole.sol");
var DistributorRole = artifacts.require("./DistributorRole.sol");
var WarehouseRole = artifacts.require("./WarehouseRole.sol");
var ConsumerRole = artifacts.require("./ConsumerRole.sol");
var SupplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(PharmacyRole);
  deployer.deploy(DistributorRole);
  deployer.deploy(WarehouseRole);
  deployer.deploy(ConsumerRole);
  deployer.deploy(SupplyChain);
};
