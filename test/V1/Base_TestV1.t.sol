// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.20;

import {HorseStore} from "../../src/V1/HorseStore.sol";
import {Test, console2} from "forge-std/Test.sol";

abstract contract Base_TestV1 is Test {
    HorseStore public horseStore;

    function setUp() public virtual {
        horseStore = new HorseStore();
    }

    function testReadValue() public view {
        uint256 initialValue = horseStore.readNumberOfHorses();
        assert(initialValue == 0);
    }

    function testWriteValue(uint256 numberOfHorses) public {
        horseStore.updateHorseNumber(numberOfHorses);
        assertEq(horseStore.readNumberOfHorses(), numberOfHorses);
    }
}
