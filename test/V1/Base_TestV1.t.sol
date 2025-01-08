// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.20;

import {HorseStore} from "../../src/V1/HorseStore.sol";
import {Test, console2} from "forge-std/Test.sol";

abstract contract Base_TestV1 is Test {
    HorseStore public horseStore;

    function setUp() public virtual {
        horseStore = new HorseStore();
    }

    function testReadValue() public {
        uint256 initialValue = horseStore.readNumberOfHorses();
        assert(initialValue == 0);
    }
}
