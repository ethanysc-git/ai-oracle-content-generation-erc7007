# AIGC Metadata

```
{
    "title": "AIGC Metadata",
    "type": "object",
    "properties": {
        "name": {
            "type": "string",
            "description": "Identifies the asset to which this NFT represents"
        },
        "description": {
            "type": "string",
            "description": "Describes the asset to which this NFT represents"
        },
        "image": {
            "type": "string",
            "description": "A URI pointing to a resource with mime type image/* representing the asset to which this NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive."
        },

        "prompt": {
            "type": "string",
            "description": "Identifies the prompt from which this AIGC NFT generated"
        },
        "seed": {
            "type": "uint256",
            "description": "Identifies the seed from which this AIGC NFT generated"
        },
        "aigc_type": {
            "type": "string",
            "description": "image/video/audio..."
        },
        "aigc_data": {
            "type": "string",
            "description": "A URI pointing to a resource with mime type image/* representing the asset to which this AIGC NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive."
        }
    }
}

```
