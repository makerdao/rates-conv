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

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Conv} from "src/Conv.sol";

contract GasMeteringScript is Script {
    function run() external {
        Conv conv;
        
        uint256 gasBefore = gasleft();
        conv = new Conv();
        console.log("Deploy: ", gasBefore - gasleft());

        for (uint256 i; i <= 5_000; i += 123) {
            gasBefore = gasleft();
            conv.btor(i);
            console.log("Turn bps", i, ":", gasBefore - gasleft());
        }
    }
}
