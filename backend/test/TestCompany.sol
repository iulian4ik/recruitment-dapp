pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import 'truffle/DeployedAddresses.sol';
import '../contracts/Company.sol';
import '../contracts/CompanyFactory.sol';

contract TestCompany {
    // Truffle will send the TestCompany ten Ether after deploying the contract.
    uint public initialBalance = 3 ether;
    event LogGeneric(bytes32 _message);
    event LogAddress(address _a, address _b);
    event LogUInt(uint _x);

    function testOwnerDuringCompanyCreationIsNull() public {
        Company company = new Company();
        Assert.equal(company.getOwner(), 0x0, 'For a newly generated Company without CompanyFactory, the owner should be 0x0');
    }

    function testSettingAnOwnerOfDirectlyDeployedCompanyContract() public {
        Company company = Company(DeployedAddresses.Company());
        Assert.equal(company.getOwner(), 0x0, 'For a newly generated Company without CompanyFactory, the owner should be 0x0');
    }

    function testSettingAnOwnerOfDeployedContractThroughFactory() public {
        CompanyFactory cf = CompanyFactory(DeployedAddresses.CompanyFactory());

        Company deployedCompany = cf.createCompany("A", "B");
        Assert.equal(deployedCompany.getOwner(), address(this), 'An owner is different than a deployer');
    }

    function testGettingCompanyDetails() public {
        CompanyFactory cf = CompanyFactory(DeployedAddresses.CompanyFactory());

        Company deployedCompany = cf.createCompany("A", "B");

        (address _contract,
        string memory _name,
        string memory _ipfsHash,
        uint _nrOfOpenedOffers,
        uint _nrOfClosedOffers,
        address _owner) = deployedCompany.getCompanyDetails();
        Assert.equal(_contract, address(deployedCompany), "Created company should have correct address");
        Assert.equal(_name, "A", "Created company should have correct name");
        Assert.equal(_ipfsHash, "B", "Created company should have correct IPFS hash");
        Assert.equal(_nrOfOpenedOffers, uint(0), "Created company should not have any opened offers upon creation");
        Assert.equal(_nrOfClosedOffers, uint(0), "Created company should not have any closed offers upon creation");
        Assert.equal(_owner, address(this), "Created company should not have any offers upon creation");
    }

//    function testCreateJobOffer() public {
//        CompanyFactory cf = CompanyFactory(DeployedAddresses.CompanyFactory());
//
//        Company deployedCompany = cf.createCompany("A", "B");
//        require(address(deployedCompany).call.value(2 ether).gas(1000000)());
//
//        (,,, uint _nrOfOpenedOffers,,) = deployedCompany.getCompanyDetails();
//        Assert.equal(_nrOfOpenedOffers, uint(0), "Created company should not have any offers upon creation");
//        deployedCompany.createJobOffer(1000, 2000, 1000000000, CompanyHeader.Domains.IT, "Web Dev", "JD");
//
//        (,,, uint _newNrOfOpenedOffers,,) = deployedCompany.getCompanyDetails();
//        Assert.equal(_newNrOfOpenedOffers, uint(1), "Created offer should increase Nr of offers available");
//    }

    function () public {}
}
