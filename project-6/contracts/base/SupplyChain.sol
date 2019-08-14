pragma solidity >=0.4.24;

contract SupplyChain {

  address owner;
  uint  upc;
  uint  sku;

  mapping (uint => Item) private items;

  mapping (uint => string[]) itemsHistory;

  enum State
  {
    New,
    ForSale,
    Sold,
    Shipped,
    Received
    }

  State constant defaultState = State.ForSale;

  struct Item {
    uint    sku;
    uint    upc;
    address ownerID;
    uint    productID;
    string  productNotes;
    uint    productPrice;
    State   itemState;
    address distributorID;
    address pharmacyID;
    address consumerID;
  }

  event New(uint upc);
  event ForSale(uint upc);
  event Sold(uint upc);
  event Shipped(uint upc);
  event Received(uint upc);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier verifyCaller (address _address) {
    require(msg.sender == _address); 
    _;
  }

  modifier paidEnough(uint _price) {
    require(msg.value >= _price); 
    _;
  }

  modifier checkValue(uint _upc) {
    _;
    uint _price = items[_upc].productPrice;
    uint amountToReturn = msg.value - _price;
    items[_upc].consumerID.transfer(amountToReturn);
  }
  modifier readyToSale(uint _upc) {
    require(items[_upc].itemState == State.New);
    _;
  }

  modifier forSale(uint _upc) {
    require(items[_upc].itemState == State.ForSale);
    _;
  }
  modifier sold(uint _upc) {
    require(items[_upc].itemState == State.Sold);
    _;
  }
  modifier shipped(uint _upc) {
    require(items[_upc].itemState == State.Shipped);
    _;
  }
  modifier received(uint _upc) {
    require(items[_upc].itemState == State.Received);
    _;
  }

  constructor() public payable {
    owner = msg.sender;
    sku = 1;
    upc = 1;
  }

  function kill() public {
    if (msg.sender == owner) {
      selfdestruct(owner);
    }
  }

  function addItem(uint _upc, string memory _productNotes, uint _productPrice, address _distributorID, address _pharmacyID, address _consumerID) public
  {
    items[sku] = Item({
            sku: sku,
            upc: _upc,
            ownerID: msg.sender,
            productID: (sku + _upc),
            productNotes: _productNotes,
            productPrice: _productPrice,
            itemState: State.New,
            distributorID: _distributorID,
            pharmacyID: _pharmacyID,
            consumerID: _consumerID});

    emit New(sku);
    sku = sku + 1;
  }


  function sellItem(uint _upc, uint _price) public
  readyToSale(_upc)
  onlyOwner
  {
    items[_upc].itemState = State.ForSale;
    emit ForSale(_upc);
  }

  function buyItem(uint _upc) public payable
    forSale(_upc)
    paidEnough(_upc)
    checkValue(_upc)
    {
    items[_upc].itemState = State.Sold;
    emit Sold(_upc);
  }

  function shipItem(uint _upc) public
    sold(_upc)
    onlyOwner
    {
    items[_upc].itemState = State.Shipped;
    emit Shipped(_upc);
  }


  function receiveItem(uint _upc) public
    shipped(_upc)
    {
    items[_upc].itemState = State.Received;
    emit Received(_upc);
  }

  function fetchItemBufferOne(uint _upc) public view returns
  (
  uint    itemSKU,
  uint    itemUPC,
  address ownerID
  ) 
  {

  itemSKU = items[_upc].sku;
  itemUPC = items[_upc].upc;
  ownerID = items[_upc].ownerID;
  }

  function fetchItemBufferTwo(uint _upc) public view returns
  (
  uint    itemSKU,
  uint    itemUPC,
  uint    productID,
  string  memory productNotes,
  uint    productPrice,
  State    itemState,
  address distributorID,
  address pharmacyID,
  address consumerID
  )
  {
    itemSKU = items[_upc].sku;
    itemUPC = items[_upc].upc;
    productID = items[_upc].productID;
    productNotes = items[_upc].productNotes;
    productPrice = items[_upc].productPrice;
    itemState = items[_upc].itemState;
    distributorID = items[_upc].distributorID;
    pharmacyID = items[_upc].pharmacyID;
    consumerID = items[_upc].consumerID;
  }
}
