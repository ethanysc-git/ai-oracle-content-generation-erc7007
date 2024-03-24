// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./interfaces/IERC7007Updatable.sol";
import "./interfaces/IOpml.sol";

/**
 * @dev Implementation of the {IERC7007} interface.
 */
contract ERC7007Opml is ERC165, IERC7007Updatable, ERC721URIStorage {
    address public immutable opml = 0xF0794e464b0dAa63b84571D729CF42754b2Eb365;
    mapping(uint256 => uint256) public tokenIdToRequestId;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor() ERC721("Dragon Mint", "DM") {}

    /**
     * @dev See {IERC7007-mint}.
     */
    function mint(
        address to,
        bytes calldata prompt,
        bytes calldata aigcData,
        string calldata uri,
        bytes calldata proof
    ) public virtual override returns (uint256 tokenId) {
        tokenId = uint256(keccak256(prompt));
        _safeMint(to, tokenId);
        string memory tokenUri = string(
            abi.encodePacked(
                "{",
                uri,
                ', "prompt": "',
                string(prompt),
                '", "aigc_data": "',
                string(aigcData),
                '"}'
            )
        );
        _setTokenURI(tokenId, tokenUri);

        emit Mint(to, tokenId, prompt, aigcData, uri, proof);
    }

    /**
     * @dev See {IERC7007-mint}.
     */
    function mint2(
        address to,
        bytes memory prompt,
        bytes memory aigcData,
        uint256 requestId,
        string calldata uri,
        bytes memory proof
    ) public returns (uint256 tokenId) {
        tokenId = uint256(keccak256(prompt));
        if (tokenIdToRequestId[tokenId] == 0) {
            tokenIdToRequestId[tokenId] = requestId;
            _safeMint(to, tokenId);
        }
        string memory tokenUri = string(
            abi.encodePacked(
                "{",
                uri,
                ', "prompt": "',
                string(prompt),
                '", "aigc_data": "',
                string(aigcData),
                '"}'
            )
        );
        _setTokenURI(tokenId, tokenUri);

        emit Mint(to, tokenId, prompt, aigcData, uri, proof);
    }

    /**
     * @dev See {IERC7007-verify}.
     */
    function verify(
        bytes calldata prompt,
        bytes calldata aigcData,
        bytes calldata proofS
    ) public view virtual override returns (bool success) {
        uint256 tokenId = uint256(keccak256(prompt));
        bytes memory output = IOpml(opml).getOutput(tokenIdToRequestId[tokenId]);

        return
            IOpml(opml).isFinalized(tokenIdToRequestId[tokenId]) &&
            (keccak256(output) == keccak256(aigcData));
    }

    /**
     * @dev See {IERC7007Updatable-update}.
     */
    function update(
        bytes calldata prompt,
        bytes calldata aigcData,
        string calldata uri
    ) public virtual override {
        require(verify(prompt, aigcData, prompt), "ERC7007: invalid aigcData"); // proof argument is not used in verify() function for opML, so we can pass prompt as proof
        uint256 tokenId = uint256(keccak256(prompt));
        string memory tokenUri = string(
            abi.encodePacked(
                "{",
                uri,
                ', "prompt": "',
                string(prompt),
                '", "aigc_data": "',
                string(aigcData),
                '"}'
            )
        );
        require(
            keccak256(bytes(tokenUri)) != keccak256(bytes(tokenURI(tokenId))),
            "ERC7007: token uri is not changed"
        );

        emit Update(tokenId, prompt, aigcData, uri);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165, ERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
