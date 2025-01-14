// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract HorseStoreYul {
    uint256 s_numberOfHorses;

    function updateHorseNumber(uint256 newHorseNumber) external {
        //s_numberOfHorses = newHorseNumber;
        assembly {
            sstore(s_numberOfHorses.slot, newHorseNumber)
        }
    }

    function readNumberOfHorses() external view returns (uint256) {
        //return s_numberOfHorses;
        assembly {
            let num := sload(s_numberOfHorses.slot)
            mstore(0, num)
            return(0, 0x20)
        }
    }
}
