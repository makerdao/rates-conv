// SPDX-FileCopyrightText: 2025 Dai Foundation <www.daifoundation.org>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "./Conv.sol";
import "./mock/RatesMapping.sol";

contract ConvTest is Test {
    Conv public conv;
    RatesMapping public ratesMapping;
    uint256 public maxBps;

    function setUp() public {
        conv = new Conv();
        ratesMapping = new RatesMapping();
        maxBps = conv.MAX();
    }

    function testBtor() public view {
        for (uint256 bps = 0; bps <= maxBps; bps++) {
            uint256 mappingRate = ratesMapping.rates(bps);
            uint256 bytesRate = conv.btor(bps);

            assertEq(bytesRate, mappingRate, string.concat("Rate mismatch at bps=", vm.toString(bps)));
        }
    }

    function testRevert_Btor_WhenInvalidBps() public {
        vm.expectRevert("Conv/bps-too-high");
        conv.btor(maxBps + 1);

    }

    function testFuzz_Btor(uint256 bps) public view {
        try conv.btor(bps) returns (uint256 result) {
            assertTrue(bps <= maxBps, "Bps must be less than or equal to maxBps");
            assertEq(result, ratesMapping.rates(bps), "Result must match mapping rate");
            assertEq(bps, conv.rtob(result));
        } catch {
            assertTrue(bps > maxBps, "Bps must be greater than maxBps");
        }
    }

    function testRtob() public view {
        for (uint256 bps = 0; bps <= 10000; bps++) {
            uint256 mappingRate = ratesMapping.rates(bps);
            uint256 bpsResult = conv.rtob(mappingRate);

            assertEq(bpsResult, bps, "rtob result must match bps");
        }
    }

    function testRevert_Rtob_RayTooLow() public {
        vm.expectRevert("Conv/ray-too-low");
        conv.rtob(0);
    }    
}
